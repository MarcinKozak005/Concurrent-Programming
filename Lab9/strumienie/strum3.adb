-- strum3.adb
--
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk
--
-- zapis i odczyt do/z pliku tekstowego jako strumienia
-- dodanie obsługi strumienia (Read/Write) dla nowego typu
-- 

with Ada;
use Ada;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Streams;
use Ada.Streams;
with Ada.Text_IO.Text_Streams;
use Ada.Text_IO.Text_Streams;
with Ada.Numerics.Discrete_Random;

procedure Strum3 is
  Plik         : File_Type;
  Nazwa        : String := "textrt.txt";
  Strumien     : Stream_Access;
  
  subtype Zakres is Integer range 0..1000;
  package Rand_Zakres is new Ada.Numerics.Discrete_Random(Zakres);
  use Rand_Zakres;
  G : Generator;
  
  -- obsługa tablicy
  --  
  type Nowa_Tablica is array(Integer range <>) of Integer;
   
  procedure Read (S : access Root_Stream_Type'Class; NTab : out Nowa_Tablica);
  procedure Write (S : access Root_Stream_Type'Class; NTab : in Nowa_Tablica);
  for Nowa_Tablica'Read use Read;
  for Nowa_Tablica'Write use Write;
   
  procedure Read (S : access Root_Stream_Type'Class; NTab : out Nowa_Tablica) is
  begin
    for E of NTab loop
      Integer'Read(S,E);
    end loop;
  end Read;  
  procedure Write (S : access Root_Stream_Type'Class; NTab : in Nowa_Tablica) is
  begin
    for E of NTab loop
      Integer'Write(S,E);
    end loop;    
  end Write; 
  
  function To_String(T: Nowa_Tablica; Str: String:=""; I: Integer:=1) return String is
    (if I>T'Last and Str'Length>0 then Str else 
      (if Str'Length=0 then To_String(T,Str&" ",T'First) 
       else To_String(T,Str&ASCII.LF&"["&I'Img&"]=>"&T(I)'Img,I+1)));
  
  -- obsługa rekordu
  --
  type Nowy_Rek is record
    Liczba_Int   : Integer := 5;
    Liczba_Float : Float   := 1.23;
    Znak         : Character := 'A';
  end record;
  
  procedure Read (S : access Root_Stream_Type'Class; Rek : out Nowy_Rek);
  procedure Write (S : access Root_Stream_Type'Class; Rek : in Nowy_Rek);
  for Nowy_Rek'Read use Read;
  for Nowy_Rek'Write use Write;
  
  procedure Read (S : access Root_Stream_Type'Class; Rek : out Nowy_Rek) is
  begin
    Integer'Read(S, Rek.Liczba_Int);
    Float'Read(S, Rek.Liczba_Float);
    Character'Read(S, Rek.Znak);
  end Read;  
  procedure Write (S : access Root_Stream_Type'Class; Rek : in Nowy_Rek) is
  begin
    Integer'Write(S, Rek.Liczba_Int);
    Float'Write(S, Rek.Liczba_Float);
    Character'Write(S, Rek.Znak);   
  end Write; 
  
  Tablica : Nowa_Tablica(-1..10):=(others => Random(G)); -- przed Resetem
  Rekord  : Nowy_Rek;
  
begin
  Reset(G);
  Tablica:=(others => Random(G));
  
  Put_Line("* Zapis do pliku -> " & Nazwa);
  Create(Plik, Out_File, Nazwa); 
  Strumien := Stream(Plik);
  Put_Line("* Zapisuje tablicę : " & To_String(Tablica) );
  Nowa_Tablica'Output(Strumien, Tablica);
  Put_Line("* Zapisuje rekord : (" & Rekord.Liczba_Int'Img&", "&
           Rekord.Liczba_Float'Img&", "&Rekord.Znak&")");
  Nowy_Rek'Output(Strumien, Rekord);
  Close(Plik);
  -- zerowanie
  Tablica := (others=>0);
  Rekord := (0, 0.0, ' ');
 
  Put_Line("* Odczyt z pliku <- " & Nazwa);
  Open(Plik, In_File, Nazwa);
  Strumien := Stream(Plik);
 
  Tablica := Nowa_Tablica'Input(Strumien);
  Put_Line("* Odczytałem tablicę : " & To_String(Tablica) );
  Rekord := Nowy_Rek'Input(Strumien);
  Put_Line("* Odczytałem rekord : (" & Rekord.Liczba_Int'Img&
          ", "&Rekord.Liczba_Float'Img&", "&Rekord.Znak&")");
   
  Close(Plik);
  Put_Line("* Koniec");
end Strum3;  
