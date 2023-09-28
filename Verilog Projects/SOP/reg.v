`timescale 1 ns / 1 ns
module register(reset, CLK, D, Q);
input reset;
input CLK;
parameter width = 1; // Default size is 1 bit 
input [width-1:0] D;
output [width-1:0] Q;
reg [width-1:0] Q;
always @(posedge CLK)
begin
if (reset)
Q = 0;
else
Q = D;
end
endmodule 
