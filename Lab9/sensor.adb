-- sensor.adb
-- materiały dydaktyczne
-- 2016
-- (c) Jacek Piwowarczyk

with System;
with Sensor_Pak; pragma Unreferenced(Sensor_Pak);
with Ada.Text_IO;
use  Ada.Text_IO;

procedure Sensor is
  pragma Priority (System.Priority'First);
begin
  Put_Line("Sensor: początek");
  loop
    null;
  end loop;
end Sensor;
