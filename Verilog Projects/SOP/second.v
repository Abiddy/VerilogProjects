`timescale 1 ns / 1 ns
 
module second(CLK, RESET, data_in, reg1, c0, c1,adder_out); // port declaration

//port definition
parameter width = 4; // widths
input CLK, RESET; // register clock and reset
input [width:0] c0, c1; // multiplier inputs as shown in figure
input [width-1:0] data_in; // register input
output [width-1:0] reg1; // output of register 1
output [2*width:0] adder_out; // output of adder
wire [width-1:0] reg2; // output of register 2
wire [2*width-1:0] M1, M2; // mult outputs


// instantiate register - register(reset, CLK, D, Q);
register #(.width(width)) r1(reset, CLK, data_in, reg1);
register #(.width(width)) r2(reset, CLK, reg1, reg2);


// instantiate multiplier - mult(a, b, res);
mult #(.width(width)) mult1(c0, reg1, M1);
mult #(.width(width)) mult2(c1, reg2, M2);

// instantiate adder - adder(x,y,sum)
adder #(.width(2*width)) a1(M1,M2,adder_out);

endmodule




