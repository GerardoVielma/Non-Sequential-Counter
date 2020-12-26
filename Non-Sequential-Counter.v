`timescale 1ns / 1ps
module Clk_Slow(CLK, Clk_Slow);
input CLK;
output Clk_Slow;
reg [31:0] counter_out;
reg Clk_Slow;
	initial begin
	counter_out<= 32'h00000000;
	Clk_Slow <=0;
	end	

always @(posedge CLK) begin
	counter_out<=    counter_out + 32'h00000001;		
	if (counter_out  > 32'h02F5E100) begin
		counter_out<= 32'h00000000;
		Clk_Slow <= !Clk_Slow;
		end
	end
endmodule 

module DFF(CLK,X,Q);
 input CLK;
 input X;
 output reg Q; 
 initial
 begin
 Q=0;
 end
 always @(posedge CLK)
  begin 
   Q=X;
  end 
endmodule

module counter(
 input CLK,
 input Start,
 output [3:0]LED,
 output [7:0]SSEG_AN,
 output reg [7:0]SSEG_CA);
 
 Clk_Slow SC(CLK, Clk_Slow);
 
 reg [3:0]NS;
 wire [3:0]P;
 
 always @(negedge Clk_Slow)
  begin
   if(Start)
    begin
        NS[3]<=(!P[3]&&!P[2])||(P[3]&&!P[1])||(!P[3]&&P[1]&&!P[0]);
        NS[2]<=(!P[2])||(!P[3]&&!P[1])||(P[3]&&P[0]);
        NS[1]<=(!P[3]&&P[0])||(P[3]&&P[2]);
        NS[0]<=(!P[3]&&P[2])||(!P[3]&&P[1]);
    end   
  end
 
 assign SSEG_AN=8'b11111110;
 
 DFF FF0(CLK,NS[0],P[0]);
 DFF FF1(CLK,NS[1],P[1]);
 DFF FF2(CLK,NS[2],P[2]);
 DFF FF3(CLK,NS[3],P[3]);
 
 always @(posedge Clk_Slow)
 begin
  case(P)
   4'b0000:SSEG_CA=8'b01000000;
   4'b0001:SSEG_CA=8'b01111001;
   4'b0010:SSEG_CA=8'b00100100;
   4'b0011:SSEG_CA=8'b00110000;
   4'b0100:SSEG_CA=8'b00011001;
   4'b0101:SSEG_CA=8'b00010010; 
   4'b0110:SSEG_CA=8'b00000010;
   4'b0111:SSEG_CA=8'b01111000;
   4'b1000:SSEG_CA=8'b00000000;
   4'b1001:SSEG_CA=8'b00011000;
   4'b1010:SSEG_CA=8'b00001000;
   4'b1011:SSEG_CA=8'b00000011;
   4'b1100:SSEG_CA=8'b01000110;
   4'b1101:SSEG_CA=8'b00100001;
   4'b1110:SSEG_CA=8'b00000110;
   4'b1111:SSEG_CA=8'b00001110;
   endcase
  end
 
 assign LED=P; 
 

 endmodule