-- semaforb.adb
-- semafr binarny 

with Ada.Text_IO;
use Ada.Text_IO;

procedure Buffor is
  
  type bufforTab is array(Integer range <>) of Character;
  
  --deklaracja?
  protected type buffor(N: Integer) is
    entry Wstaw(Ch: in Character);
    entry Pobierz(Ch: out Character);
  private
    B: bufforTab(1..N);
    Taken : Integer := 0;
    IndWstaw : Integer := 1;
    IndPob : Integer := 1;
  end buffor;
  
  protected body buffor is
    entry Wstaw(Ch: in Character) when Taken<N is
    begin
      B(IndWstaw) := Ch;
      Taken := Taken+1;
      --IndWstaw := (IndWstaw+1) mod (N+1);
      if IndWstaw = N then
        IndWstaw := 1;
      else
        IndWstaw:= IndWstaw+1;
      end if;
      
      Put("[Wstawione: "& Taken'Img &"/"&N'Img&"]");
      Put_Line("<- Wstawione");
      Put_Line("Taken("&Taken'Img&") IndWstaw("&IndWstaw'Img&") IndPob("&IndPob'Img&")");
      Put_Line("");
    end Wstaw;
    
    entry Pobierz(Ch: out Character) when Taken>0 is
    begin
      Ch := B(IndPob);
      Taken := Taken-1;
      --IndPob := (IndPob+1) mod (N+1);
      if IndPob = N then
        IndPob := 1;
      else
        IndPob:= IndPob+1;
      end if;
      
      Put("[Pobrane: "& Taken'Img &"/"&N'Img&"]");
      Put_Line("<- Zabrane");
      Put_Line("Taken("&Taken'Img&") IndWstaw("&IndWstaw'Img&") IndPob("&IndPob'Img&")");
      Put_Line("");
    end Pobierz;
  end buffor;

Buffor1 : buffor(10);

task Producent is
  entry Start;
end Producent;

task body Producent is
  X: Character := 'X';
begin
  accept Start;
  for I in 1..17 loop
    Put_Line("$ "&I'Img&" Producent wstawia: ");
    Buffor1.Wstaw(X);
  end loop;
end Producent;

task Konsument is
  entry Start;
end Konsument;

task body Konsument is
  X: Character := ' ';
begin
    accept Start;
    for I in 1..10 loop
      Put_Line("# "&I'Img&" Konsument zabiera: ");
      Buffor1.Pobierz(X);
    end loop;
end Konsument;

begin
  Producent.Start;
  delay 0.5;
  Konsument.Start;
  --Put_Line("@ jestem w procedurze glownej");
end Buffor;
  