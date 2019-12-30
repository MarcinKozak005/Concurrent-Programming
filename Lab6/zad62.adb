-- losd2

with Ada.Text_IO, Ada.Numerics.Float_Random, Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

procedure Losd2 is


type Kolory is (Czerwony, Zielony, Niebieski);
  package Los_Kolor is new Ada.Numerics.Discrete_Random(Kolory);
  
type Dni is (Poniedzialek, Wtorek, Sroda, Czwartek, Piatek, Sobota, Niedziela);
  package Los_Dzien is new Ada.Numerics.Discrete_Random(Dni);
  
type TabFloat is array (1..6) of Float;

-- 0.0 - 5.0 przez wejscie
-------------------------------------
  task Los is
    entry From0To5(X: in out Float);
  end Los;
  
  task body Los is
    use Ada.Numerics.Float_Random;
    G:Generator;
  begin
    accept From0To5(X: in out Float) do
      Reset(G);
      X := Random(G)*5.0;
    end From0To5;
  end Los;
-------------------------------------
  task Losujacy is
    entry From0To5(X: in out Float);
    entry Kolor(K: in out Kolory);
    entry Dzien(D: in out Dni);
    entry Tab(A: in out TabFloat);
    entry Koniec;
  end Losujacy;
  
  task body Losujacy is
    --use Ada.Numerics.Float_Random;
    GF:Ada.Numerics.Float_Random.Generator;
    --use Los_Kolor;
    GK:Los_Kolor.Generator;
    GD:Los_Dzien.Generator;
  begin
    loop
      select
        -- 0.0 - 5.0
        accept From0To5(X: in out Float) do
          Ada.Numerics.Float_Random.Reset(GF);
          X := Ada.Numerics.Float_Random.Random(GF)*5.0;
        end From0To5;
      or
        -- Kolory
        accept Kolor(K: in out Kolory) do
          Los_Kolor.Reset(GK);
          K := Los_Kolor.Random(GK);
        end Kolor;
      or
        -- Dni
        accept Dzien(D: in out Dni) do
          Los_Dzien.Reset(GD);
          D := Los_Dzien.Random(GD);
        end Dzien;
      or
        accept Tab(A: in out TabFloat) do
          Ada.Numerics.Float_Random.Reset(GF);
          for I in 1..6 loop
            A(I) := Ada.Numerics.Float_Random.Random(GF)*50.0;
          end loop;
        end Tab;
      or
        accept Koniec;
          exit;
      end select;
    end loop;
  end Losujacy;

-------------------------------------


Pudelko1: Float := 0.0;
Pudelko2: Kolory := Czerwony;
Pudelko3: Dni := Poniedzialek;
Pudelko4: TabFloat;

begin
  Los.From0To5(Pudelko1);
  Put_Line(Pudelko1'Img);
  
  Losujacy.Kolor(Pudelko2);
  Put_Line(Pudelko2'Img);
  
  Losujacy.Dzien(Pudelko3);
  Put_Line(Pudelko3'Img);
  
  Losujacy.Tab(Pudelko4);
  Put_Line("Tablica: ");
  for I in 1..6 loop
    Put_Line(Pudelko4(I)'Img);
  end loop;

  Losujacy.Koniec;
  
end Losd2;