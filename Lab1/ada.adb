-- lab1.adb
-- komentarz do koÅ?ca linii

-- wykorzystany pakiet 
with Ada.Text_IO;
use Ada.Text_IO;

-- procedura gÅ?Ã³wna - dowolna nazwa
procedure hello is

-- czÄ?Å?Ä? deklaracyjna  
  
  -- funkcja - forma peÅ?na
  function Max2(A1, A2 : in Float ) return Float is
  begin
    if A1 > A2 then return A1;
    else return A2; 
    end if;
  end Max2;    

  -- funkcja "wyraÅŸeniowa"  
  -- forma uproszczona funkcji
  -- jej treÅ?ciÄ? jest tylko wyraÅŸenie w nawiasie   
  
  function Add(A1, A2 : Float) return Float is
    (A1 + A2);
       
  function Max(A1, A2 : in Float ) return Float is
    (if A1 > A2 then A1 else A2);    
    
  -- Fibonacci      
  function Fibo(N : Natural) return Natural is   
    (if N = 0 then 1 elsif N in 1|2 then  1 else Fibo(N-1) + Fibo(N-2) );   
  
    -- procedura 
    -- zparametryzowany ciÄ?g instrukcji  
  procedure Print_Fibo(N: Integer) is
  begin
    if N <1 or N>46 then raise Constraint_Error;
    end if;
    Put_Line("CiÄ?g Fibonacciego dla N= " & N'Img);
    for I in 1..N loop
      Put( Fibo(I)'Img & " " );
    end loop;   
    New_Line;
  end Print_Fibo;
  
  -----------------------------------------------------------------------------------------
  
  function Srednia(A, B: Float) return Float is
    begin
        return (A+B)/2.0;
    end Srednia;
  
  function Silnia(N:Integer) return Integer is
    tmp: Integer:=1;
  begin
    if N>=0 then
      for x in 1..N loop
        tmp := tmp*x;
      end loop;
      return tmp;
    elsif N=0 then
      return 1;
    else
      return -1;
    end if;
  end Silnia;
  
  function FibboN(N: Natural) return Natural is
    a:Natural:=1;
    b:Natural:=1;
    res: Natural:=0;
  begin
    if N=0 then
      return raise Constraint_Error;
    elsif N in 1|2 then
      return a;
    else
      for x in 3..N loop
        res := a+b;
        a := b;
        b := res;
      end loop;
      return res;
    end if;
  end FibboN;
  
  
  
  -----------------------------------------------------------------------------------------
-- poniÅŸej treÅ?Ä? procesury gÅ?Ã³wnej   
begin
  Put_Line("Suma = " & Add(3.0, 4.0)'Img );
  Put_Line("Srednia = "& Srednia(3.0, 4.0)'Img);
  Put_Line( "Max =" & Max(6.7, 8.9)'Img);
  Put_Line( "Max2 =" & Max2(6.7, 8.9)'Img);
  Put_Line( "Silnia(5) = "& Silnia(5)'Img);
  Put_Line("Fibbo_Moje(12)"& FibboN(12)'Img);
  Print_Fibo(12);
  
  -- zabawa z pentla
  for x in 0..5 loop
    Put(x'Img);
    New_Line;
  end loop;
end hello;  