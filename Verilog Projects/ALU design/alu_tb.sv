module test();
reg [7:0] a,b;
reg [3:0] opcode;
wire [7:0] alu_out;
reg clk, en, oe;
wire cf,of,sf,zf;
integer i,j,k;
alu a1(clk, en, oe, opcode, a, b, alu_out, cf, of, sf, zf);
initial
begin
for(k=0;k<7;k=k+1) // opcode = k ; opcodes goes from 2(4'b0010) to 7(4'b0111)
begin
for(i=0;i<2;i=i+1)
begin
for(j=0;j<2;j=j+1)

begin
#2 a=i; b=j; opcode=k; oe=1; // all combinations with output enable as 1
end
end
end
for(k=2;k<8;k=k+1)
begin
for(i=0;i<2;i=i+1)
begin
for(j=0;j<2;j=j+1)
begin
#2 a=i;b=j; opcode=k;oe=0; // all combinations with output enable as 0
end
end
end
#4 a=1; b= 1 ; opcode = 4'b0111;
#50 $finish;
end
initial
begin
$dumpfile("alu_tb.vcd");
$dumpvars;
end
initial
$monitor("a=%b b=%b opcode=%b oe=%b alu_out=%b",a,b,opcode,oe,alu_out);
endmodule
