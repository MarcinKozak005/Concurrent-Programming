-- kontroler_pak.adb
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk

with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Exceptions;
use Ada.Exceptions;
with GNAT.Sockets; use GNAT.Sockets;

package body Kontroler_Pak is

  task body Kontrol is
    Address  : Sock_Addr_Type;
    Server   : Socket_Type;
    Socket   : Socket_Type;
    Channel  : Stream_Access;
    Dane     : Integer := 0;
	Tab: array(1..3,1..3) of Integer;
  begin
    Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
    --Address.Addr := Addresses (Get_Host_By_Address(Inet_Addr("10.0.0.1")),1);
    --Address.Addr := Inet_Addr("10.0.0.1");
    --Address.Addr := Addresses (Get_Host_By_Name ("imac.local"), 1);
    --Address.Addr := Addresses (Get_Host_By_Name ("localhost"), 1);
    Address.Port := 5876;
    Put_Line("Host: "&Host_Name);
    Put_Line("Adres:port = ("&Image(Address)&")");

    Create_Socket (Server);
    Set_Socket_Option (Server, Socket_Level, (Reuse_Address, True));
    Bind_Socket (Server, Address);
    Listen_Socket (Server);
    Put_Line ( "Kontroler: czekam na Sensor ....");
    Accept_Socket (Server, Socket, Address);

    Channel := Stream (Socket);
    for I in 1..3 loop
		for J in 1..3 loop
		  Dane := Integer'Input (Channel);
		  Put_Line ("Kontroler: -> dane =" & Dane'Img);
		  Tab(I,J):=Dane;
		  --  Komunikat do: Sensor
		  String'Output (Channel, "OK: " & Dane'Img);
		end loop;
    end loop;
	Put_Line("Wyswietlam tablice");
	for I in 1..3 loop
		for J in 1..3 loop
		  Put(" "&Tab(I,J)'Img);
		end loop;
		Put_Line("");
    end loop;

  exception
    when E:others => Put_Line("Error: Zadanie Kontrol");
      Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
  end Kontrol;

end Kontroler_Pak;
