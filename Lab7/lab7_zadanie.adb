with Ada.Text_IO;
use Ada.Text_IO;

procedure SemaforLiczbowy is
  
  task type Semafor(N: Integer) is
    entry Czekaj(NrZadania : Integer);
    entry Sygnalizuj(NrZadania : Integer);
  end Semafor;
  
  type WskZad is access Semafor;
  
  s1: Semafor(2);
  
  task body Semafor is
    Size: Integer := N;
    Capasity: Integer := N;
  begin
    loop
      select when Size > 0 =>
        accept Czekaj(NrZadania : Integer) do
          Size:=Size-1;
          Put_Line("Zadanie("&NrZadania'Img&") pobral->Size: "&Size'Img);
        end Czekaj;
      or --when Size < Capasity =>
        accept Sygnalizuj(NrZadania : Integer) do
          Size:=Size+1;
          Put_Line("Zadanie("&NrZadania'Img&") oddal->Size: "&Size'Img);
        end Sygnalizuj;
      end select;
    end loop;
  end Semafor;
  
task type zadanie(N:Integer);
task body zadanie is
begin
  Put_Line("Z("&N'Img&")");
  s1.Czekaj(N);
  --produkcja
  delay 0.5;
  --end produkcja
  s1.Sygnalizuj(N);
  Put_Line("Z("&N'Img&") zakonczylo sie");
end zadanie;

z1: zadanie(1);
z2: zadanie(2);
z3: zadanie(3);
z4: zadanie(4);


begin
  null;
end SemaforLiczbowy;
  