`timescale 1 ns / 1 ns
module mult(a, b, res);
parameter width = 4; //default 1 bit
input [width:0] a;
output reg [2*width-1:0] res;
input [width-1:0] b;
always@(a) begin;
res = a * b;
end
endmodule


