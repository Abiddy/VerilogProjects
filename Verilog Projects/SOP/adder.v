`timescale 1 ns / 1 ns
module adder(x,y,sum);
parameter width = 1; // 1 bit is default
input signed [width-1:0] x, y;
output reg signed [width:0] sum;
always@(x, y) 
begin
sum = x + y;
end
endmodule

