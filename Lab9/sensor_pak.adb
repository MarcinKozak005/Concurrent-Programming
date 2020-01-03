-- sensor_pak.adb
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk

with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;
with Ada.Exceptions;
use Ada.Exceptions;
with GNAT.Sockets; use GNAT.Sockets;
with Ada.Calendar;
use Ada.Calendar;

package body Sensor_Pak is

  task body Sens is
    Nastepny : Time;
    Okres   : constant Duration := 1.2;
    G       : Generator;
    Address : Sock_Addr_Type;
    Socket  : Socket_Type;
    Channel : Stream_Access;
	Tab: array(1..3,1..3) of Integer;
  begin
	Tab := ((1,2,3),(4,5,6),(7,8,9));
    Reset(G);
    Nastepny := Clock;
    Address.Addr := Addresses (Get_Host_By_Name (Host_Name), 1);
    --Address.Addr := Addresses (Get_Host_By_Address(Inet_Addr("10.0.0.1")),1);
    --Address.Addr := Inet_Addr("10.0.0.1");
    --Address.Addr := Addresses (Get_Host_By_Name ("imac.local"), 1);
    --Address.Addr := Addresses (Get_Host_By_Name ("localhost"), 1);
    Address.Port := 5876;
    Put_Line("Host: "&Host_Name);
    Put_Line("Adres:port => ("&Image(Address)&")");
    Create_Socket (Socket);
    Set_Socket_Option (Socket, Socket_Level, (Reuse_Address, True));
    Connect_Socket (Socket, Address);
    for I in 1..3 loop
		for J in 1..3 loop
		  Put_Line("Sensor: czekam okres ...");
		  delay until Nastepny;
		  Channel := Stream (Socket);
		  --  Send message to kontroler
		  Put_Line("Sensor: -> wysyłam dane ...");
		  Integer'Output (Channel, Tab(I,J) );
		  --  Receive and print message from Kontroler
		  Put_Line ("Sensor: <-" & String'Input (Channel));
		  Nastepny := Nastepny + Okres;
		end loop;
    end loop;
  exception
    when E:others =>
      Close_Socket (Socket);
      Put_Line("Error: Zadanie Sensor");
      Put_Line(Exception_Name (E) & ": " & Exception_Message (E));
  end Sens;

end Sensor_Pak;
