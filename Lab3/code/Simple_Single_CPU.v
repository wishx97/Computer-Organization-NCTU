// 0516244 TAY CHUN KEAT ???

module Simple_Single_CPU(
        clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0] alu_result, instr_o, writeData, ReadData1, ReadData2, pc_in_i, pc_out_o, signed_addr, after_extended, ALUin,
	    adder_out1, adder_out2, mux_jump_out, mux_jumpReg_out, MemRead_data;

wire [4:0] write_Reg_address;

wire [3:0] ALU_operation;

wire [2:0] ALUOp;

wire [1:0] RegDst, MemtoReg;

wire RegWrite, ALUSrc, Branch, Jump, MemRead, MemWrite, ALU_zero, jumpregister;

assign jumpregister = (instr_o[31:26] == 6'd0 && instr_o[5:0] == 6'd8)?1:0;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	.rst_i(rst_i),     
	.pc_in_i(pc_in_i),   
	.pc_out_o(pc_out_o) 
);

Adder Adder1(
        .src1_i(pc_out_o),     
	.src2_i(32'd4),
	.sum_o(adder_out1)    
);

Instr_Memory IM(
        .pc_addr_i(pc_out_o),  
	.instr_o(instr_o)    
);

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
	.data2_i(5'b11111),
        .select_i(RegDst),
        .data_o(write_Reg_address)
);	

Reg_File Registers(
        .clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]),  
        .RTaddr_i(instr_o[20:16]),  
        .RDaddr_i(write_Reg_address),  
        .RDdata_i(writeData), 
        .RegWrite_i(RegWrite & (~jumpregister)),
        .RSdata_o(ReadData1),  
        .RTdata_o(ReadData2)   
);
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	.RegWrite_o(RegWrite), 
	.ALUOp_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),
	.Branch_o(Branch),
	.Jump_o(Jump), 
	.MemRead_o(MemRead), 
	.MemWrite_o(MemWrite), 
	.MemtoReg_o(MemtoReg)
);

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALU_operation)
);
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(signed_addr)
);

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(ReadData2),
        .data1_i(signed_addr),
        .select_i(ALUSrc),
        .data_o(ALUin)
);	
		
ALU ALU(
	.A(ReadData1),
	.B(ALUin),
	.ALUctl(ALU_operation),
	.ALUOut(alu_result),
	.Zero(ALU_zero)
);

Data_Memory Data_Memory(
	.clk_i(clk_i), 
	.addr_i(alu_result), 
	.data_i(ReadData2), 
	.MemRead_i(MemRead), 
	.MemWrite_i(MemWrite), 
	.data_o(MemRead_data)
);		

Adder Adder2(
        .src1_i(adder_out1),     
	.src2_i(after_extended),
	.sum_o(adder_out2)    
);

Shift_Left_Two_32 Shifter_address(
    	.data_i(signed_addr),
    	.data_o(after_extended)
);

MUX_2to1 #(.size(32)) Mux_Branch(
        .data0_i(adder_out1),
        .data1_i(adder_out2),
        .select_i(Branch & ALU_zero),
        .data_o(mux_jump_out)
);	

MUX_2to1 #(.size(32)) Mux_Jump(
        .data0_i(mux_jump_out),
        .data1_i({adder_out1[31:28], instr_o[25:0], 2'b00}),
        .select_i(Jump),
        .data_o(mux_jumpReg_out)
);	

MUX_2to1 #(.size(32)) Mux_JumpReg(
        .data0_i(mux_jumpReg_out),
        .data1_i(ReadData1),
        .select_i(jumpregister),
        .data_o(pc_in_i)
);			

MUX_3to1 #(.size(32)) Mux_MemtoReg(
        .data0_i(alu_result),
        .data1_i(MemRead_data),
	.data2_i(adder_out1),
        .select_i(MemtoReg),
        .data_o(writeData)
);
endmodule
