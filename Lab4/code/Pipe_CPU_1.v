// 0516244 TAY CHUN KEAT
`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire [32-1:0] pc, pc_out, instr, pc_out_added;
wire [32-1:0] pc_out_added_id, instr_id;

/**** ID stage ****/
wire [32-1:0] ReadData1, ReadData2, signed_addr;
wire RegDst, MemtoReg;
wire [3-1:0] ALUOp;
wire RegWrite, ALUSrc, Branch, MemRead, MemWrite;
//control signal
wire [32-1:0] ReadData1_ex, ReadData2_ex, signed_addr_ex, pc_out_added_ex;
wire [21-1:0] instr_ex;
wire RegDst_ex, MemtoReg_ex;
wire [3-1:0] ALUOp_ex;
wire RegWrite_ex, ALUSrc_ex, Branch_ex, MemRead_ex, MemWrite_ex;

/**** EX stage ****/
wire [32-1:0] addr_shifted, ALUin_2, alu_result, adder_out2;
wire [5-1:0] write_Reg_address;
wire [4-1:0] ALU_operation;
wire ALU_zero;
//control signal
wire [32-1:0] alu_result_mem, adder_out2_mem, ReadData2_mem;
wire [5-1:0] write_Reg_address_mem;
wire MemtoReg_mem;
wire RegWrite_mem, Branch_mem, MemRead_mem, MemWrite_mem, ALU_zero_mem;

/**** MEM stage ****/
wire [32-1:0] MemRead_data;
//control signal
wire [32-1:0] MemRead_data_wb, alu_result_wb;
wire [5-1:0] write_Reg_address_wb;
wire MemtoReg_wb;
wire RegWrite_wb;

/**** WB stage ****/
wire [32-1:0] writeData;
//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(pc_out_added),
        .data1_i(adder_out2_mem),
        .select_i(Branch_mem & ALU_zero_mem),
        .data_o(pc)
);

ProgramCounter PC(
	.clk_i(clk_i),      
	.rst_i(rst_i),     
	.pc_in_i(pc),   
	.pc_out_o(pc_out)
);

Instruction_Memory IM(
	.addr_i(pc_out),  
	.instr_o(instr)
);
			
Adder Add_pc(
	.src1_i(pc_out),     
	.src2_i(32'd4),
	.sum_o(pc_out_added)
);
		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	.clk_i(clk_i),
    	.rst_i(rst_i),
    	.data_i({pc_out_added, instr}),
    	.data_o({pc_out_added_id, instr_id})
);


//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),      
	.rst_i(rst_i) ,     
        .RSaddr_i(instr_id[25:21]),  
        .RTaddr_i(instr_id[20:16]),  
        .RDaddr_i(write_Reg_address_wb),  
        .RDdata_i(writeData), 
        .RegWrite_i(RegWrite_wb),
        .RSdata_o(ReadData1),  
        .RTdata_o(ReadData2)
);

Decoder Control(
	.instr_op_i(instr_id[31:26]), 
	.RegWrite_o(RegWrite), 
	.ALUOp_o(ALUOp),   
	.ALUSrc_o(ALUSrc),   
	.RegDst_o(RegDst),
	.Branch_o(Branch),
	.MemRead_o(MemRead), 
	.MemWrite_o(MemWrite), 
	.MemtoReg_o(MemtoReg)
);

Sign_Extend Sign_Extend(
	.data_i(instr_id[15:0]),
        .data_o(signed_addr)
);	

Pipe_Reg #(.size(159)) ID_EX(
	.clk_i(clk_i),
    	.rst_i(rst_i),
    	.data_i({ReadData1, ReadData2, instr_id[20:0], pc_out_added_id, RegWrite, 
		RegDst, ALUSrc, Branch, MemRead, MemWrite, MemtoReg, ALUOp, signed_addr}),
    	.data_o({ReadData1_ex, ReadData2_ex, instr_ex, pc_out_added_ex, RegWrite_ex, 
		RegDst_ex, ALUSrc_ex, Branch_ex, MemRead_ex, MemWrite_ex, MemtoReg_ex, ALUOp_ex, signed_addr_ex})
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
	.data_i(signed_addr_ex),
    	.data_o(addr_shifted)
);

ALU ALU(
	.A(ReadData1_ex),
	.B(ALUin_2),
	.ALUctl(ALU_operation),
	.ALUOut(alu_result),
	.Zero(ALU_zero)
);
		
ALU_Ctrl ALU_Control(
	.funct_i(instr_ex[5:0]),   
        .ALUOp_i(ALUOp_ex),   
        .ALUCtrl_o(ALU_operation)
);

MUX_2to1 #(.size(32)) Mux1(
	.data0_i(ReadData2_ex),
        .data1_i(signed_addr_ex),
        .select_i(ALUSrc_ex),
        .data_o(ALUin_2)
);
		
MUX_2to1 #(.size(5)) Mux2(
	.data0_i(instr_ex[20:16]),
        .data1_i(instr_ex[15:11]),
        .select_i(RegDst_ex),
        .data_o(write_Reg_address)
);

Adder Add_pc_branch(
	.src1_i(pc_out_added_ex),     
	.src2_i(addr_shifted),
	.sum_o(adder_out2)    
);

Pipe_Reg #(.size(107)) EX_MEM(
	.clk_i(clk_i),
    	.rst_i(rst_i),
    	.data_i({alu_result, adder_out2, write_Reg_address, ReadData2_ex, 
		 RegWrite_ex, Branch_ex, MemRead_ex, MemWrite_ex, MemtoReg_ex, ALU_zero}),
    	.data_o({alu_result_mem, adder_out2_mem, write_Reg_address_mem, ReadData2_mem, 
		 RegWrite_mem, Branch_mem, MemRead_mem, MemWrite_mem, MemtoReg_mem, ALU_zero_mem})
);


//Instantiate the components in MEM stage
Data_Memory DM(
	.clk_i(clk_i), 
	.addr_i(alu_result_mem), 
	.data_i(ReadData2_mem), 
	.MemRead_i(MemRead_mem), 
	.MemWrite_i(MemWrite_mem), 
	.data_o(MemRead_data)
);

Pipe_Reg #(.size(71)) MEM_WB(
	.clk_i(clk_i),
    	.rst_i(rst_i),
	.data_i({MemRead_data, alu_result_mem, write_Reg_address_mem, MemtoReg_mem, RegWrite_mem}),
    	.data_o({MemRead_data_wb, alu_result_wb, write_Reg_address_wb, MemtoReg_wb, RegWrite_wb})
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(alu_result_wb),
        .data1_i(MemRead_data_wb),
        .select_i(MemtoReg_wb),
        .data_o(writeData)
);

/****************************************
signal assignment
****************************************/

endmodule

