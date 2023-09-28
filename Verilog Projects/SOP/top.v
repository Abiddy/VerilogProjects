`timescale 1 ns/ 1 ns
module top(CLK,RESET,c0,c1,c2,c3,data_in, final_out);
//set parameters
parameter width = 4;
input CLK, RESET;// register clock and reset;
input [width-1:0] data_in; //input to register
input [width:0] c0,c1,c2,c3; // inputs of multiplier as shown in figure
output [2*width+1:0] final_out; // final output
wire [width-1:0] reg2; // 
wire [2*width:0] adder1, adder2; // output of second level adders
wire rst; // using aasd reset

//instantiate aasd reset - aasd(clk, reset, out)
aasd r1(CLK, RESET, rst);

//instantiate second level - second(CLK, RESET, data_in, reg1, c0, c1,adder_out)
second #(.width(width)) s1(CLK, rst, data_in, reg2,c0,c1, adder1);
second #(.width(width)) s2(CLK, rst, reg2, ,c2,c3, adder2);

//instantiate final adder - adder(x,y,sum)
adder #(.width(2*width+1)) a1(adder1, adder2, final_out);

endmodule
