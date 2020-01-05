with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

with Ada.Numerics.Discrete_Random;

 
procedure lab2_1 is
 
type Element is record 
    Data : Integer := 0;
    Next : access Element := Null;
end record; 
 
type Elem_Ptr is access all Element;

-- bylo access Element zamiast Elem_Ptr
procedure Print(List : Elem_Ptr) is
    L : Elem_Ptr := List;
begin
  if List = Null then
    Put_Line("List EMPTY!");
  else
    Put_Line("List:"); 
  end if; 
  while L /= Null loop
    Put(L.Data, 4); -- z pakietu Ada.Integer_Text_IO
    New_Line;
    L := L.Next;
  end loop; 
end Print;
 
procedure Insert(List : in out Elem_Ptr; D : in Integer) is
  E : Elem_Ptr := new Element; 
begin
  E.Data := D;
  E.Next := List;
  -- lub E.all := (D, List);
  List := E;
end Insert;
 
-- wstawianie jako funkcja - wersja krótka
function Insert(List : access Element; D : in Integer) return access Element is 
  ( new Element'(D,List) ); 
 
-- brak kontroli Nulla na wejsciu 
procedure Insert_Sort(List : in out Elem_Ptr; D : in Integer) is 
    E: Elem_Ptr:= new Element;
    before: Elem_Ptr:=List;
    after: Elem_Ptr:=List;
begin
    --Put_Line("InsertSort ready to insert "&D'Img);
    
    E.Data := D;
    if List = Null then --lista pusta
        List:=Insert(List,D);
    else
        after:=List.Next;
        
        if after = Null then
            before.Next := E;
            E.Next:=Null;
        else
        
            if D<List.Data then -- nowy mniejszy
                E.Next:=List;
                List:=E;
            else
                while after.Data<D loop
                    before:=after;
                    after:= after.Next;
                    if after=Null then
                        exit;
                    end if;
                end loop;
            
                if after = Null then
                    before.Next := E;
                    E.Next:=Null;
                else
                    E.Next:=after;
                    before.Next:=E;
                end if;
            end if;
        end if;
        
        
    end if;
end Insert_Sort;


procedure InsertRandom(List: in out Elem_Ptr; N,M:in Integer) is
    package zakres is new Ada.Numerics.Discrete_Random(Integer);
    use zakres;
    Gen: Generator;
    Wart: Integer;
    i: Integer:=0;
begin
    --Put_Line("InsertRandom");
    Reset(Gen);
    while i<N loop
        --Print(List);
        Wart:= Random(Gen) mod M;
        Insert_Sort(List,Wart);
        i:=i+1;
    end loop;
end InsertRandom;


function Search(List: in out Elem_Ptr; N: Integer) return Boolean is
    indicator: Elem_Ptr := List;
begin
    while indicator /= Null loop
        if indicator.Data = N then
            return True;
        end if;
        indicator := indicator.Next;
    end loop;
    
    return False;
end Search;

procedure Delete(List: in out Elem_Ptr; N:Integer) is
current: Elem_Ptr := List;
previous: Elem_Ptr := List;
begin
    if current.Data = N then
        List := current.Next;
    else
        current := current.Next;
        while current /= Null loop
            if current.Data = N then
                previous.Next := current.Next;
                current:= Null;
                exit;
            else
                current := current.Next;
                previous := previous.Next;
            end if;
        end loop;
    end if;

end Delete;

-- procedure glowna***
Lista : Elem_Ptr := Null;
Lista2: Elem_Ptr := Null;
begin
  --Print(Lista);
  Lista := Insert(Lista, 21);
  --Print(Lista);
  Insert(Lista, 20); 
  --Print(Lista);
  for I in reverse 1..12 loop
  Insert(Lista, I);
  end loop;
  Insert_Sort(Lista,-2);
  --Print(Lista);
  
  --Print(Lista2);
  --InsertRandom(Lista2,10,100);
  Insert_Sort(Lista2,0);
  Insert_Sort(Lista2,10);
  Insert_Sort(Lista2,-20);
  Insert_Sort(Lista2,100);
  Insert_Sort(Lista2,50);
  Insert_Sort(Lista2,500);
  Insert_Sort(Lista2,-100);
  Print(Lista2);
  --Put_Line(Search(Lista2,220)'Img);
  Delete(Lista2,-100);
  Delete(Lista2,50);
  Delete(Lista2,500);
  Print(Lista2);
  
  
end lab2_1;