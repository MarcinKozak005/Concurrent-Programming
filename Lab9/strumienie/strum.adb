-- strum.adb
--
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk
--
-- zapis i odczyt do/z pliku jako strumienia

with Ada;
use Ada;
with Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with Ada.Streams.Stream_IO;

procedure Strum is
  Plik         : Stream_IO.File_Type;
  Nazwa        : String := "test.txt";
  Strumien     : Stream_IO.Stream_Access;
  Liczba_Int   : Integer := 5;
  Liczba_Float : Float   := 1.23;
  Znak         : Character := 'A';
  Tekst        : String    := "Ada2012";
begin
 Text_IO.Put_Line("* Zapis do pliku -> "&Nazwa);
 Stream_IO.Create(Plik, Stream_IO.Out_File, Nazwa); 
 Strumien := Stream_IO.Stream(Plik);
 Text_IO.Put_Line("* Zapisuje liczbę : " & Liczba_Int'Img);
 Integer'Write(Strumien, Liczba_Int);
 Text_IO.Put_Line("* Zapisuje liczbę : " & Liczba_Float'Img);
 Float'Write(Strumien, Liczba_Float);
 Text_IO.Put_Line("* Zapisuje znak : " & Znak);
 Character'Write(Strumien, Znak);
 Text_IO.Put_Line("* Zapisuje tekst: " & Tekst);
 String'Output(Strumien, Tekst);
 Stream_IO.Close(Plik);
 
 Text_IO.Put_Line("* Odczyt z pliku <- "&Nazwa);
 Stream_IO.Open(Plik, Stream_IO.In_File, Nazwa); 
 Strumien := Stream_IO.Stream(Plik);
 Integer'Read(Strumien, Liczba_Int);
 Text_IO.Put_Line("* Odczytałem liczbę : " & Liczba_Int'Img);
 Float'Read(Strumien,Liczba_Float);
 Text_IO.Put_Line("* Odczytałem liczbę : " & Liczba_Float'Img);
 Character'Read(Strumien,Znak);
 Text_IO.Put_Line("* Odczytałem znak : " & Znak);  
 
 Text_IO.Put_Line("* Odczytałem tekst : " & String'Input(Strumien) ); 
 Stream_IO.Close(Plik);
 Text_IO.Put_Line("* Koniec");
end Strum;  
