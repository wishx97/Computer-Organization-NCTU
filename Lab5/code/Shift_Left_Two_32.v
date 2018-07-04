// 0516244 TAY CHUN KEAT

module Shift_Left_Two_32(
    data_i,
    data_o
);

//I/O ports                    
input  [32-1:0] data_i;
output [32-1:0] data_o;

wire   [32-1:0] data_o;
//shift left 2
assign data_o = {data_i[29:0], 2'b00};     
endmodule
