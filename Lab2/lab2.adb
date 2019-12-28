with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

--czas
with Ada.Text_IO, Ada.Calendar;
use Ada.Text_IO, Ada.Calendar;


procedure Hello is
    type Wektor is array (Integer range <>) of Float;
    agregat: Wektor(1..10) := (1..5 => 12.0, others => 1.0);
    
-------------------------------------------------------------
    procedure WypiszWektor(vec:Wektor) is
    begin
        for x in vec'Range loop
            Put_Line(vec(x)'Img&" ");
        end loop;
    end WypiszWektor;
    
    --out bo przypisujemy
-------------------------------------------------------------
    procedure FillWithRandom(vec: out Wektor) is
        Gen: Generator;
    begin
        Reset(Gen);
        for i in vec'Range loop
            vec(i):=Random(Gen);
        end loop;
    end FillWithRandom;
    
-------------------------------------------------------------
    function IsSorted(vec:Wektor) return Boolean is
    begin
        return (for all i in vec'First..(vec'Last)-1 => vec(i)<vec(i+1));
    end IsSorted;
    
-------------------------------------------------------------
    procedure BubbleSort(vec: in out Wektor) is
        tmp: Float :=0.0;
    begin
        for i in vec'First..(vec'Last-1) loop
            for j in vec'First..(vec'Last-i) loop
                if vec(j)>vec(j+1) then
                    tmp:=vec(j+1);
                    vec(j+1):=vec(j);
                    vec(j):=tmp;
                else
                    null;
                end if;
            end loop;
        end loop;
    end BubbleSort;

-------------------------------------------------------------
    procedure InsertionSort(vec: in out Wektor) is
        tmp:Float:=0.0;
    begin
        for i in (vec'First+1)..vec'Last loop
            for j in reverse 2..i loop
                
                if vec(j-1)>vec(j) then
                    tmp:=vec(j-1);
                    vec(j-1):=vec(j);
                    vec(j):=tmp;
                else
                    exit;
                end if;
                
            end loop;
        end loop;
    end InsertionSort;
    
-------------------------------------------------------------
    procedure SelectionSort(vec: in out Wektor) is
        index:Integer:=0;
        tmp:Float:=0.0;
    begin
        for i in vec'First..vec'Last loop
            index:=i;
            for j in i+1..vec'Last loop
                if vec(j)<vec(index) then
                    index:=j;
                end if;
            end loop;
            tmp:=vec(i);
            vec(i):=vec(index);
            vec(index):=tmp;
        end loop;
    end SelectionSort;
    
-------------------------------------------------------------

    T1:Time;
    T2:Time;
    D: Duration;
begin
    FillWithRandom(agregat);
    
    T1:=Clock;
    InsertionSort(agregat);
    T2:=Clock;
    D:= T2-T1;
    
    Put_Line("Czas sortowania: "&D'Img&"[s]");
    WypiszWektor(agregat);
end Hello;