//behavior modelled AASD design

`timescale 1 ns / 1 ns
module aasd(clk, reset, out);
input clk, reset;
output reg out;
reg a1;
always @ (negedge reset or posedge clk)
if (!reset) 
begin 
a1 <= 0; 
out <= 0; 
end
else begin
a1 <= 1; 
out <= a1; 
end 
endmodule
