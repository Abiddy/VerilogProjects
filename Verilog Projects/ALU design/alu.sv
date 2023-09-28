`timescale 1ns/100ps 
module alu(clk, en, oe, opcode, a, b, alu_out, cf, of, sf, zf);

// cf - carry flag , of - overflow flag, sf - negative flag, zf - zero flag

parameter width=8;
output [width-1:0] alu_out;
output reg cf,of,sf,zf;
input [3:0] opcode;
input [width-1:0] a,b;
input clk, en, oe;
reg [width-1:0] temp; // temporary variable to store outputs

//if(oe)
//alu_out[width-1:0] =temp;
//else
//alu_out = 8'bz;
assign alu_out=oe?temp:8'bz; // output goes to high impedance mode if oe in not enabled
always@(posedge clk)
begin

case(opcode)
2: // A + B - opcode 4b'0010 
begin 
{cf,temp}=a+b; // concatenating the carry flag cf
if(temp==0) // if temp is 0 then zefo flag is set to 1 otherwise set to 0
zf=1;
else
zf=0;
if(temp[width-1]==1) // if temp[width-1] is 1 , we set negative flag to 1, otherwise 0
sf=1;
else
sf=0;
if(cf&&temp[width-1]) // overflow flag set when signed operation is too big for ALU
of=1;
else
of=0;
end

3: // A - B (same flag conditions as A + B ) - opcode 4'b0011 (and so on)
begin 
{cf,temp}=a-b; 
if(temp==0)
zf=1;
else
zf=0;
if(temp[width-1]==1)
sf=1;
else
sf=0;
if(cf&&temp[width-1])
of=1;
else
of=0;
end

4: // A AND B
begin temp=a&b; 
if(temp==0)
zf=1;
else
zf=0;
if(temp[width-1]==1)
sf=1;
else
sf=0;
end

5: // A OR B 
begin temp=a|b; 
if(alu_out==0)
zf=1;
else
zf=0;
if(temp[width-1]==1)
sf=1;
else
sf=0;
end

6: // A XOR B
begin temp=a^b; 
if(temp==0)
zf=1;
else
zf=0;
if(temp[width-1]==1)
sf=1;
else
sf=0;
end

7: // NOT A
begin temp=~a; 
if(temp==0)
zf=1;
else
zf=0;
if(temp[width-1]==1)
sf=1;
else
sf=0;
end

endcase
end
endmodule
