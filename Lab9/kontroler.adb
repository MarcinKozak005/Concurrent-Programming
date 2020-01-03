-- kontroler.adb
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk

with System;
with Kontroler_Pak; pragma Unreferenced(Kontroler_Pak);
with Ada.Text_IO;
use  Ada.Text_IO;

procedure Kontroler is
  pragma Priority (System.Priority'First);
begin
  Put_Line("Kontroler: początek");
  loop
    null;
  end loop;
end Kontroler;
