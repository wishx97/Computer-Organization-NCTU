// 0516244 TAY CHUN KEAT

module Sign_Extend(
    data_i,
    data_o
);
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg    [32-1:0] data_o;
integer k;

//Sign extended
always @(*)
begin
    data_o[15:0] <= data_i[15:0];
        for (k = 16; k < 32; k = k + 1)
            data_o[k] <= data_i[15];
end
endmodule      
