-- strum2.adb
--
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk
--
-- zapis i odczyt do/z pliku tekstowego jako strumienia

with Ada;
use Ada;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with Ada.Text_IO.Text_Streams;
use Ada.Text_IO.Text_Streams;

procedure Strum2 is
  Plik         : File_Type;
  Nazwa        : String := "text.txt";
  Strumien     : Stream_Access;
  Liczba_Int   : Integer := 5;
  Liczba_Float : Float   := 1.23;
  Znak         : Character := 'A';
  Tekst        : String    := "Ada2012";
begin
 Put_Line("* Zapis do pliku -> " & Nazwa);
 Create(Plik, Out_File, Nazwa); 
 Strumien := Stream(Plik);
 Put_Line("* Zapisuje liczbę : " & Liczba_Int'Img);
 Integer'Write(Strumien, Liczba_Int);
 Put_Line("* Zapisuje liczbę : " & Liczba_Float'Img);
 Float'Write(Strumien, Liczba_Float);
 Put_Line("* Zapisuje znak : " & Znak);
 Character'Write(Strumien, Znak);
 Put_Line("* Zapisuje tekst: " & Tekst);
 String'Output(Strumien, Tekst);
 Close(Plik);
 
 Put_Line("* Odczyt z pliku <- " & Nazwa);
 Open(Plik, In_File, Nazwa); 
 Strumien := Stream(Plik);
 Integer'Read(Strumien, Liczba_Int);
 Put_Line("* Odczytałem liczbę : " & Liczba_Int'Img);
 Float'Read(Strumien,Liczba_Float);
 Put_Line("* Odczytałem liczbę : " & Liczba_Float'Img);
 Character'Read(Strumien,Znak);
 Put_Line("* Odczytałem znak : " & Znak);  
 Put_Line("* Odczytałem tekst : " & String'Input(Strumien) ); 
 Close(Plik);
 Put_Line("* Koniec");
end Strum2;  
