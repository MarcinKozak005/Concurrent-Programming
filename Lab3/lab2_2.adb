with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Hello is

type Tree is record
    Data: Integer;
    Right: access Tree := Null;
    Left: access Tree := Null;
end record;

type Ptree is access all Tree;

procedure Insert(root: in out Ptree; N: Integer) is
    current: Ptree := root;
    Node: Ptree := new Tree;
begin
    Node.Data := N;
    if root = Null then
        root := Node;
    else 
        if current.Data > N then
            if current.Right = Null then
                current.Right := Node;
            else
                current := current.Right;
                Insert(current,N);
            end if;
        else
            if current.Left = Null then
                current.Left := Node;
            else
                current := current.Left;
                Insert(current,N);
            end if;
        end if;
    end if;
end Insert;

number : constant Integer := 5;

procedure PrintHelper(root:Ptree; spaces: in out Integer) is
begin
    if root = Null then
        null;
    else
        
        spaces := spaces+number;
        
        PrintHelper(root.Right,spaces);
        
        Put_Line("");
        for I in number..spaces loop
            Put(" ");
        end loop;
        Put_Line(root.Data'Img&"<");
        
        PrintHelper(root.Left,spaces);
        spaces := spaces-number;
        
        
    end if;
end PrintHelper;

procedure Print(root:Ptree) is
x:Integer:=0;
begin
    PrintHelper(root,x);
end Print;

package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer);
use Los_Liczby;

procedure addRandom(root: in out PTree; N,M:Integer) is
Gen: Generator;
Wart: Integer;
i:Integer:=0;
begin
    Reset(Gen);
    while i<N loop
        Wart:= Random(Gen) mod M;
        Insert(root,Wart);
        i:=i+1;
    end loop;
end addRandom;

function Search(root:PTree;N:Integer) return Boolean is
begin
    if root = Null then
        return False;
    else
        return (root.Data = N or Search(root.Right,N) = True or Search(root.Left,N) = True );
    end if;
end Search;

Drzewo1: PTree:= Null; 
Drzewo2: PTree:= Null; 
begin
    Insert(Drzewo1,15);
    Insert(Drzewo1,10);
    Insert(Drzewo1,20);
    Insert(Drzewo1,12);
    Insert(Drzewo1,17);
    Insert(Drzewo1,5);
    Insert(Drzewo1,30);
    Print(Drzewo1);
    
    Put_Line("---nowe drzewo---");
    addRandom(Drzewo2,8,20);
    Print(Drzewo2);

    Put_Line(Search(Drzewo1,17)'Img);
    
    
end Hello;