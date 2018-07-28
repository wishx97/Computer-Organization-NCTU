// 0516244 TAY CHUN KEAT

module ALU (ALUctl, A, B, ALUOut, Zero);
   input [4-1:0] ALUctl;
   input signed [32-1:0] A,B;
   output reg [32-1:0] ALUOut;
   output Zero;
   assign Zero = (ALUOut == 0);
   always @(ALUctl, A, B) begin
      case (ALUctl)
	0: ALUOut <= A & B;
	1: ALUOut <= A | B;
	2: ALUOut <= A + B;
	3: ALUOut <= A * B;
	6: ALUOut <= A - B;
	7: ALUOut <= A < B ? 1 : 0;
	12: ALUOut <= ~(A | B);
	default: ALUOut <= 0;
      endcase
    end
endmodule