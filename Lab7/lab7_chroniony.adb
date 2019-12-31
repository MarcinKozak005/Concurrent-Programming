with Ada.Text_IO;
use Ada.Text_IO;

procedure SemaforLiczbowy is
  
-- typ chroniony 
protected type SemaforLiczbowy(N: Integer) is
  entry Czekaj(NrZadania: in Integer);
  procedure Sygnalizuj(NrZadania: in Integer);
  private
    Capasity: Integer := N;
    Size: Integer := N;
end SemaforLiczbowy ;

protected body SemaforLiczbowy  is
  entry Czekaj(NrZadania: in Integer) when Size>0 is
  begin
    Size := Size-1;
    Put_Line(NrZadania'Img&" Czekaj -> Size: "&Size'Img);
  end Czekaj;
  procedure Sygnalizuj(NrZadania: in Integer) is
  begin
    if Size = Capasity then
      Size := Capasity;
    else
      Size := Size+1;
    end if;
    Put_Line(NrZadania'Img&" Sygnalizuj -> Size: "&Size'Img);
  end Sygnalizuj;
end SemaforLiczbowy;
  
Semafor1: SemaforLiczbowy(2);  


task type Zadanie(N: Integer := 1);
type WskZad is access Zadanie;

task body Zadanie is
begin
  Put_Line("Zadanie("&N'Img&") u¿ywa semafora:");
  Semafor1.Czekaj(N);
  --produkcja
  delay 0.5;
  --end produkcja
  Semafor1.Sygnalizuj(N);
  Put_Line("Koniec produkcji zadania "&N'Img);
end Zadanie;

Z1: Zadanie(1);
Z2: Zadanie(2);
Z3: Zadanie(3);
begin
  null;
end SemaforLiczbowy;
  