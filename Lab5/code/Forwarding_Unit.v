// 0516244 TAY CHUN KEAT
module Forwarding_Unit(
            regwrite_mem,
            regwrite_wb,
            idex_regs,
            idex_regt,
            exmem_regd,
            memwb_regd,
            forwarda,
            forwardb
);

input       regwrite_mem;
input       regwrite_wb;
input [4:0] idex_regs;
input [4:0] idex_regt;
input [4:0] exmem_regd;
input [4:0] memwb_regd;
output [1:0] forwarda;
output [1:0] forwardb;

reg [1:0] forwarda;
reg [1:0] forwardb;

always@(*) begin
    if(regwrite_mem == 1'b1 && idex_regs == exmem_regd && exmem_regd != 5'd0)
        forwarda <= 2'b01;
    else if(regwrite_wb == 1'b1 && idex_regs == memwb_regd && memwb_regd != 5'd0)
        forwarda <= 2'b10;
    else
        forwarda <= 2'b00;

    if(regwrite_mem == 1'b1 && idex_regt == exmem_regd && exmem_regd != 5'd0)
        forwardb <= 2'b01;
    else if(regwrite_wb == 1'b1 && idex_regt == memwb_regd && memwb_regd != 5'd0)
        forwardb <= 2'b10;
    else
        forwardb <= 2'b00;
end
endmodule
