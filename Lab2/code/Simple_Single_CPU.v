// 0516244 TAY CHUN KEAT ???
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0]pc, pc_next, pc_back, pc_back_pre, instr_w, Rsdata, Rtdata, imm, MUX_ALUsrc_w, result, imm_after_shift;

wire [4:0] WriteReg1, WriteData, ReadReg1, ReadReg2;

wire [3:0] ALU_control;
wire [2:0] ALU_op;

wire RegDst;
wire RegWrite;
wire branch;
wire ALUSrc;
wire zero;

//Greate componentes
ProgramCounter PC(
            .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_back) ,   
	    .pc_out_o(pc) 
);
	
Adder Adder1(
            .src1_i(pc),     
	    .src2_i(32'd4),     
	    .sum_o(pc_next)    
);
	
Instr_Memory IM(
           .pc_addr_i(pc),  
	   .instr_o(instr_w)    
);

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_w[20:16]),
        .data1_i(instr_w[15:11]),
        .select_i(RegDst),
        .data_o(WriteReg1)
);	
		
Reg_File RF(
        .clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(instr_w[25:21]) ,  
        .RTaddr_i(instr_w[20:16]) ,  
        .RDaddr_i(WriteReg1) ,  
        .RDdata_i(result)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(Rsdata) ,  
        .RTdata_o(Rtdata)   
);
	
Decoder Decoder(
            .instr_op_i(instr_w[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
	    .Branch_o(branch)   
);

ALU_Ctrl AC(
        .funct_i(instr_w[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALU_control) 
);
	
Sign_Extend SE(
        .data_i(instr_w[15:0]),
        .data_o(imm)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(Rtdata),
        .data1_i(imm),
        .select_i(ALUSrc),
        .data_o(MUX_ALUsrc_w)
);	
		
ALU ALU1(
	.ALUctl(ALU_control),
	.A(Rsdata),
        .B(MUX_ALUsrc_w),
        .ALUOut(result),
	.Zero(zero)
);
		
Adder Adder2(
        .src1_i(imm_after_shift),
        .src2_i(pc_next),
        .sum_o(pc_back_pre)
);
		
Shift_Left_Two_32 Shifter(
        .data_i(imm),
        .data_o(imm_after_shift)
); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_next),
        .data1_i(pc_back_pre),
        .select_i(branch & zero),
        .data_o(pc_back)
);	

endmodule
		  