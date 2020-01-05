with Ada.Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

with Ada.Numerics.Elementary_Functions; -- od Sqrt

procedure zad6 is
	
function odleglosc(X1,Y1,X2,Y2: in Integer) return Float is
begin
  return Ada.Numerics.Elementary_Functions.Sqrt( Float( ((X1-X2)**2) + ((Y1-Y2)**2) ));
end odleglosc;

	
  package Los_Liczby is new Ada.Numerics.Discrete_Random(Integer); --do losowania
  use Los_Liczby; --do losowania
------------------------------------------	
task Generujacy is
  entry Generuj(N:Integer);  	
end Generujacy;

task Kalkulator is 
  entry Start;
  entry Koniec;
  entry Punkt(X,Y:Integer);
end Kalkulator;

------------------------------------------
task body Generujacy is
  X:Integer;
  Y:Integer;
  G:Generator;
begin
  Reset(G);
  accept Generuj(N:Integer) do	
    for K in 1..N loop
     -- Put(N'Img);
      X:= Random(G) rem 20;
      Y:= Random(G) rem 20;
  	  Kalkulator.Punkt(X,Y);
    end loop;
  end Generuj;
  
  Kalkulator.Koniec;
end Generujacy;

------------------------------------------
task body Kalkulator is
  PrevX: Integer := 0;
  PrevY: Integer := 0;
  
  OdlLast: Float := 0.0;
  Odl0: Float := 0.0;
begin
  accept Start;
  
  loop
    select 
      accept Punkt(X,Y: in Integer) do
        OdlLast := odleglosc(PrevX,PrevY,X,Y);
        Odl0 := odleglosc(X,Y,0,0);
        PrevX := X;
        PrevY := Y;
      end Punkt;
      Put_Line("--------------------------------------");
      Put_Line("Punkt ("& PrevX'Img &","& PrevY'Img &")");
      Put_Line("Odl od (0,0) = "&Odl0'Img);
      Put_Line("Odl od poprzedniego = "&OdlLast'Img);
    or 
	    accept Koniec;
 	    exit;
    end select;
  end loop;
  
  Put_Line("Koniec Kalkulator ");
end Kalkulator;


------------------------------------------
begin
  Kalkulator.Start;
  Generujacy.Generuj(10);
  
  Put_Line("Koniec_PG ");
end zad6;
	  	