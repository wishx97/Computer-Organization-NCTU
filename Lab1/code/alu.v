// 0516244
`timescale 1ns/1ps

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)		  
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             overflow;
reg		zero;
reg		cout;

wire   [32-1:0] carry_out; 	// for carry out through 1 bit ALU
wire   [32-1:0] result_tmp; 	// temporary store for result
wire		set; 	 	// check if slt is set

alu_top A0(
        .src1(src1[0]),
        .src2(src2[0]),
	.less(set),
	.A_invert(ALU_control[3]),
	.B_invert(ALU_control[2]),
	.cin(ALU_control[3] ^ ALU_control[2]),
        .operation(ALU_control[1:0]),
        .result(result_tmp[0]),
        .cout(carry_out[0])
       );           

generate
    genvar i;
    for(i = 1; i <= 31; i = i + 1) 
    begin 
        alu_top Ai(
        .src1(src1[i]),
        .src2(src2[i]),
	.less(1'b0),
	.A_invert(ALU_control[3]),
	.B_invert(ALU_control[2]),
	.cin(carry_out[i-1]),
        .operation(ALU_control[1:0]),
        .result(result_tmp[i]),
        .cout(carry_out[i])
       );           
    end
endgenerate

assign set = (src1[31] ^ (~src2[31]) ^ carry_out[30]); 

always@(*) 
begin
	if(rst_n) begin
	   cout = 0;
	   overflow = 0;
	   result = 0;
	   if(ALU_control[1:0] == 2'b10)begin
	   	cout = carry_out[31];
		overflow = ((src1[31]&(src2[31]^ALU_control[2])) ^ result_tmp[31]) & (ALU_control[2]^ALU_control[3]) & ~(src1[31]^src2[31]);
	   end
	   result = result_tmp;
	   if(result == 0)
	      zero = 1;
	   else
	      zero = 0;
	   
	end
	   
end
endmodule
