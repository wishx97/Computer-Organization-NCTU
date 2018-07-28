// 0516244 TAY CHUN KEAT ???
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
);
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter


//Select exact operation
always@(*) begin
    case (ALUOp_i)
        // R-type
        3'b100:
            case (funct_i)
                6'b100100: ALUCtrl_o <= 4'b0000;    // and 0000
                6'b100101: ALUCtrl_o <= 4'b0001;    // or  0001
                6'b100000: ALUCtrl_o <= 4'b0010;    // add 0010
                6'b100010: ALUCtrl_o <= 4'b0110;    // sub 0110
                6'b101010: ALUCtrl_o <= 4'b0111;    // slt 0111
                default:   ALUCtrl_o <= 4'bxxxx;
            endcase
        3'b000:  ALUCtrl_o <= 4'b0010;               // add in addi
        3'b001:  ALUCtrl_o <= 4'b0110;               // sub in beq
        3'b010:  ALUCtrl_o <= 4'b0111;               // slt in slti
        default: ALUCtrl_o <= 4'bxxxx;
    endcase
end
endmodule     





                    
                    