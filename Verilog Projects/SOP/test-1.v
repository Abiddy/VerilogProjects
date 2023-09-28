module test();
parameter width = 5;
reg [width-1:0] r_in; //register input
reg CLK, RESET;
reg [width:0] C0,C1,C2,C3;
wire [2*width+1:0] final_out; //top module output
reg [2*width+1:0] CHECK, NOT_EQUAL;
reg [width-1:0] i, j;

// instantiate top module 
top #(width) UUT(CLK, RESET, C0,C1,C2,C3,r_in, final_out);


initial begin
CLK = 1'b0;
forever #5 CLK = ~ CLK; // clock switches every 5 time units
end
initial
$monitor("%d DATA = %b | Program Output = %d | Actual Result = %d",$time, r_in, final_out, CHECK);
initial begin
$dumpfile("sum_of_product.vcd");
$dumpvars;
C0 = 4'h6; C1 = 4'h7; C2 = 4'hE; C3 = 4'hF; // mulitplier coefficent values
$display("");
$display("Test Cases");
$display("");
$display("TEST for Reset");
#100 RESET = 0; r_in = 5'b00100;
CHECK = (((r_in * C0) + (r_in * C1)) + (( r_in * C2) + (r_in * C3)));

$display("TEST for Changing values from C0 to C3");
#100 C0 = 4'hA; C1 = 4'hB; C2 = 4'hC; C3 = 4'hD;
CHECK = (((r_in * C0) + (r_in * C1)) + (( r_in * C2) + (r_in * C3)));
#10
$display("");
for (j = 0; j < 2; j = j + 1) begin
if(!j)
$display("Free of Errors");
else
$display("Forcing Errors");
RESET = 0; r_in = 0; C0 = 4'h6; C1 = 4'h7; C2 = 4'hE; C3 = 4'hF;
#10 RESET = 1;
for (i = 0; i < 5'b11111; i = i + 1) begin
#100 CHECK = (((r_in * C0) + (r_in * C1)) + (( r_in * C2) + (r_in * C3)));
if(j == 0 && i >= 5'b01111)
$monitoron;
else if(j == 1 && i < 5'b01111)
$monitoron; 
else
$monitoroff; // using monitor off for cases that are irrelevant
if (j == 1 && i == 5'b11001)
#100 force UUT.data_in = 5'b11111; // using force to get error value
NOT_EQUAL <= CHECK - final_out;
if (NOT_EQUAL)begin
$display("ERROR");
$stop; //end simulation
end
r_in = r_in + 1;
end
end
#100 $strobe("Finish");
$finish;
end
endmodule
