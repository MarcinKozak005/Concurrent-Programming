-- lab1.adb
-- komentarz do koñca linii

-- wykorzystany pakiet 
with Ada.Text_IO;
use Ada.Text_IO;

-- procedura g³ówna - dowolna nazwa
procedure Lab1 is

-- czêœæ deklaracyjna  
  
  -- funkcja - forma pe³na
  function Max2(A1, A2 : in Float ) return Float is
  begin
    if A1 > A2 then return A1;
    else return A2; 
    end if;
  end Max2;    

  -- funkcja "wyra¿eniowa"  
  -- forma uproszczona funkcji
  -- jej treœæ jest tylko wyra¿enie w nawiasie   
  
  function Add(A1, A2 : Float) return Float is
    (A1 + A2);
       
  function Max(A1, A2 : in Float ) return Float is
    (if A1 > A2 then A1 else A2);    
    
  -- Fibonacci      
  function Fibo(N : Natural) return Natural is   
    (if N = 0 then 1 elsif N in 1|2 then  1 else Fibo(N-1) + Fibo(N-2) );   
  
    -- procedura 
    -- zparametryzowany ci¹g instrukcji  
  procedure Print_Fibo(N: Integer) is
  begin
    if N <1 or N>46 then raise Constraint_Error;
    end if;
    Put_Line("Ci¹g Fibonacciego dla N= " & N'Img);
    for I in 1..N loop
      Put( Fibo(I)'Img & " " );
    end loop;   
    New_Line;
  end Print_Fibo;    
  
--moje

procedure Abc(a : Integer; b : Float) is
begin
    Put_Line("Integer: "& a'Img);
    Put_Line("Float: "&b'Img);
end Abc;

function druga(a: out Integer) return Integer is
begin
a := 1+2;
return a;
end druga;

function Mean(a, b : in Float) return Float is
    ((a+b)/2.0);
    
function Factorial(a : in Integer) return Integer is
begin
    if a<0 then raise Constraint_Error;
    elsif a in 0|1 then return 1;
    else
        return Factorial(a-1)*a;
    end if;
end Factorial;

procedure proc1(a:Integer) is
begin
    if a in 0..10 then Put_Line("Od 0 do 10");
    else Put_Line("Nie zlapalem");
    end if;
end proc1;

--end moje
x: Integer;
-- poni¿ej treœæ procesury g³ównej   
begin
  --Put_Line("Suma = " & Add(3.0, 4.0)'Img ); 
  --Put_Line( "Max =" & Max(6.7, 8.9)'Img);
  --Put_Line( "Max2 =" & Max2(6.7, 8.9)'Img);
  --Print_Fibo(12);
  --Put_Line("Silnia: "& Factorial(5)'Img);
  --Abc(1,2.0);
  Put_Line("druga:"& druga(x)'Img);
  proc1(-10);
end Lab1;  