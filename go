#! /c/iverilog/bin/vvp
:ivl_version "0.9.7 " "(v0_9_7)";
:vpi_time_precision + 0;
:vpi_module "system";
:vpi_module "v2005_math";
:vpi_module "va_math";
S_00AD3200 .scope module, "testMUX" "testMUX" 2 1;
 .timescale 0 0;
v00BE3E18_0 .var "InMux", 7 0;
v00BEE950_0 .var "InMux_2", 7 0;
v00BEE9A8_0 .net "OUTMux", 7 0, v00BE3DC0_0; 1 drivers
v00BEEA00_0 .var "select", 0 0;
S_00BE1670 .scope module, "MUX_module" "MUX" 2 7, 2 19, S_00AD3200;
 .timescale 0 0;
v00AD3288_0 .net "InMux_1", 7 0, v00BE3E18_0; 1 drivers
v00BE16F8_0 .net "InMux_2", 7 0, v00BEE950_0; 1 drivers
v00BE1750_0 .alias "OUTMux", 7 0, v00BEE9A8_0;
v00BE3D68_0 .net "muxselect", 0 0, v00BEEA00_0; 1 drivers
v00BE3DC0_0 .var "temp", 7 0;
E_00AD1B30 .event edge, v00BE16F8_0, v00AD3288_0, v00BE3DC0_0;
    .scope S_00BE1670;
T_0 ;
    %wait E_00AD1B30;
    %load/v 8, v00BE3D68_0, 1;
    %jmp/0xz  T_0.0, 8;
    %load/v 8, v00AD3288_0, 8;
    %set/v v00BE3DC0_0, 8, 8;
T_0.0 ;
    %load/v 8, v00BE3D68_0, 1;
    %cmpi/u 8, 0, 1;
    %jmp/0xz  T_0.2, 4;
    %load/v 8, v00BE16F8_0, 8;
    %set/v v00BE3DC0_0, 8, 8;
T_0.2 ;
    %end;
    .thread T_0;
    .scope S_00AD3200;
T_1 ;
    %movi 8, 161, 8;
    %set/v v00BE3E18_0, 8, 8;
    %movi 8, 15, 8;
    %set/v v00BEE950_0, 8, 8;
    %set/v v00BEEA00_0, 0, 1;
    %vpi_call 2 10 "$monitor", "OUTPUT : %b", v00BEE9A8_0;
    %end;
    .thread T_1;
    .scope S_00AD3200;
T_2 ;
    %delay 100, 0;
    %vpi_call 2 14 "$finish";
    %end;
    .thread T_2;
# The file index is used to find the file name in the following table.
:file_names 3;
    "N/A";
    "<interactive>";
    "mux.v";
