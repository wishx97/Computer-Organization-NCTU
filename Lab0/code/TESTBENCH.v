`timescale 1ns/10ps

`include "PATTERN.v"
`include "marquee.v"

module TESTBECH();

wire  CLK;
wire  RST;
wire  [2:0] INDATA_A;
wire  [2:0] INDATA_B;
wire  [5:0] OUTDATA;

PATTERN u_PATTERN(
  .clk(CLK),
  .rst(RST),
  .indataA(INDATA_A),
  .indataB(INDATA_B),
  .outdata(OUTDATA)
);

marquee u_marquee(
  .clk(CLK),
  .rst(RST),
  .indataA(INDATA_A),
  .indataB(INDATA_B),
  .outdata(OUTDATA)
);



endmodule