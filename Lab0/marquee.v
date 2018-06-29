`timescale 1ns/10ps
module marquee(
  clk,
  rst,
  indataA,
  indataB,
  outdata
  );

input clk;
input rst;  
input  [2:0] indataA;
input  [2:0] indataB;

output reg[5:0] outdata;


reg [1:0] counter_r, counter_n;


// To do:
// Please fulfill the code to make your output waveform the same as our specification

// To do:
// Please add sequential code here:
always@(posedge clk)begin
    if(rst)begin
	counter_r <= 2'b00;
    end
    else begin
	counter_r <= counter_r + 2'b01;
    end
end



// To do:
// please add combinational code here:
always@(*)begin
     if(counter_r == 0)begin
	outdata = indataA | indataB;
     end
     else if(counter_r == 1)begin
	outdata = indataA & indataB;
     end
     else if(counter_r == 2)begin
	outdata = indataA ^ indataB;
     end
     else if(counter_r == 3)begin
	outdata = {indataA , indataB};
     end
end

endmodule
