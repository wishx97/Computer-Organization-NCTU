// 0516244
`timescale 1ns/1ps

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout        //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg           cout;


//reg
reg           a_out; 
reg           b_out;


always@(*)
begin
	a_out = src1;
	if(A_invert)
	   a_out = ~src1;
  	b_out = src2;  
	if(B_invert)
	   b_out = ~src2;
	case(operation)
	   2'b00:
	   begin
	      result = (a_out & b_out);
	      cout = 0;
	   end
	   2'b01:
	   begin
	      result = (a_out | b_out);
	      cout = 0;
	   end
	   2'b10:
	   begin
	      {cout, result} = (a_out + b_out + cin);
	   end
	   2'b11:
	   begin
	      result = less;
	      cout = (a_out & b_out) | (a_out & cin) | (b_out & cin); 
	   end 
	endcase
end

endmodule
