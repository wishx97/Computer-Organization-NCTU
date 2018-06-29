`timescale 1ns/10ps
module PATTERN(
  clk,
  rst,
  indataA,
  indataB,
  outdata
);

//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION
//---------------------------------------------------------------------
output reg clk;
output reg rst;  
output reg [2:0] indataA;
output reg [2:0] indataB;

input [5:0] outdata;

//---------------------------------------------------------------------
// PARAMETER DECLARATION
//---------------------------------------------------------------------
real  CYCLE = 5.0; //5ns
parameter MAX_PATTERN_NUM = 1000;

parameter [1:0] OR  = 2'd0;
parameter [1:0] AND = 2'd1;
parameter [1:0] XOR = 2'd2;
parameter [1:0] MERGE  = 2'd3;
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION
//---------------------------------------------------------------------

integer i;
reg [1:0] counter;
reg [5:0] ANSWER;
//---------------------------------------------------------------------
//   CLOCK GENERATION
//---------------------------------------------------------------------

always #(CYCLE/2)begin
    clk = ~clk;
end

initial begin
  clk = 1'b0;
  rst = 1'b0;
  indataA = 3'd0;
  indataB = 3'd0;
  counter = 2'd0;
  
  //send reset signal 
  @(negedge clk);
  rst = 1'b1;
  @(negedge clk);
  rst = 1'b0;

  for(i=0; i<MAX_PATTERN_NUM; i=i+1)begin
    //set input data
    @(posedge clk);
    indataA = $random();
    indataB = $random();
    counter = counter + 2'd1;
    
    Calulate_Correct_Answer(indataA,indataB,ANSWER);
    @(negedge clk);
    if(ANSWER !== outdata)begin
      $display("=============================================");
      $display("===  ====  =====  ==          =====         =");
      $display("===  ===    ===  =======  =========  ========");
      $display("====  =  ==  =  ========  =========        ==");
      $display("=====   ====   =========  =========  ========");
      $display("====== ====== ==========  =========  ========");
      $display("Your answer is not correct");
      $display("Correct answer is %b, Your answer is %b",ANSWER,outdata);
      #(0.5*CYCLE);
      $stop();
    end
    else begin
      $display("pass pattern %d",i);
    end
  end
    $display("=============================================");
    $display("=============================================");
    $display("=============================================");
    $display("=============================================");
    $display("=============================================");
    $display("Congratulation.  You pass  TA's pattern  ");
    $display("=============================================");
    $display("=============================================");
    $display("=============================================");

    $stop();

end

task Calulate_Correct_Answer;
input [2:0] A;
input [2:0] B;
output [5:0] ANS;

begin

  
  ANS = 6'd0;
  case(counter)
    OR:
      ANS = A | B;
    AND:
      ANS = A & B;
    XOR:
      ANS = A ^ B;
    MERGE:
      ANS = {A,B};
  endcase
end
endtask


endmodule
