`timescale 1 ns / 100 ps
module fifo
        // parameters
        #(
            parameter width = 8, // fifo data width
            parameter depth = 32, // fifo depth
            parameter addrWidth = $clog2(depth),
            parameter almostThreshold = 2
        )
        // input output port declaration
        (
            input [width-1:0] data_in,
            input clk,
            input rst_n,
            input wr_en,
            input rd_en,
            output [width-1:0] data_out,
            output [addrWidth+1:0] count,
            output empty,
            output almostEmpty,
            output full,
            output almostFull,
            output overflow,
            output underflow,
            output valid
        );
        
	// RAM Signals
	reg [width-1:0] memory [0:depth-1];
	reg [width-1:0] memoryOut1;
	
	// Integer for for loop
	integer i;
	
	// Counters to keep track of data location
	reg [addrWidth-1:0] writeCounterReg;
	reg [addrWidth-1:0] readCounterReg;
	
	// RAM Count Reg
	reg signed [addrWidth+1:0] countReg;
	
	// Flag Registers
	reg overflow1;
	reg underflow1;
	reg valid1;
	
	// RAM Reset Logic
	always @ (posedge clk)
        begin
            if (rst_n)
                begin
                    // Clear Memory
                    for (i = 0; i < depth ; i = i+1)
                        begin
                            memory[i] = 0; 
                        end
                        
                    writeCounterReg = 0; // Write Counter set to 0 (restarts)
                    
                    // Restart Read Counter
                    readCounterReg = 0; // Read Counter set to 0 (restarts)
                    
                    
                    countReg = 0; // reg counter set to 0 (restarts)
                    
                    //Restarting flags
                    overflow1 = 0;
                    underflow1 = 0;
		    valid1 = 0;
                end
        end
	
	always @ (posedge clk)
        begin
            if (wr_en)// If writing is asked/enabled
                begin
					// Increment Writer Counter and FIFO Counter
                    writeCounterReg = writeCounterReg+1;
                    countReg = countReg + 1;
					
                    if (countReg > depth)// If writing requires more memory than available
                        begin
							// Decrement the FIFO Counter and Writer Pointer
                            countReg = countReg - 1;
                            writeCounterReg = writeCounterReg - 1;
							
                            overflow1 = 1;// Assert the Overflow Flag
                        end
						
                    else// else, assume the there's enough memory to perform a write
                        begin
                            memory[writeCounterReg] = data_in;// Take in data and place it at the write counter's address
                            overflow1 = 0;// Deassert the Overflow Flag
                        end
                end
        end
        
    // Read Logic 
    always @ (posedge clk)
        begin
            if (rd_en)// If reading is asked/enabled
                begin
					// Increment Read Counter but decrement the FIFO Counter
                    readCounterReg = readCounterReg + 1;
                    countReg = countReg - 1;
					
                    if (countReg < 0)// If there is nothing to read
                        begin
                            countReg = countReg+1;// Increment the FIFO Counter
                            readCounterReg = readCounterReg-1;// Decrement the Read Counter
                            underflow1=1; // Assert the Underflow Flag
                            valid1=0; // Deassert the Overflow Flag
                        end
                    else// else, assume there's something in the memory
                        begin
                            memoryOut1 = memory[readCounterReg];// Output/take out the data at the read counter's address
                            underflow1=0;// deassert the underflow flag
                            valid1=1;// assert the valid flag
                        end
                end
        end
        
    // Assign Registers to Outputs
    assign data_out = memoryOut1;
    assign count = countReg;
    assign empty = (countReg == 0);// empty is asserted if the count is zero
    assign almostEmpty = (countReg <= almostThreshold) && !(countReg == 0);// almost empty is asserted only if the count is less than the threshold AND the empty flag is not asserted
    assign full = (countReg == depth);// full flag is asserted when the count is the same as the memory depth
    assign almostFull = (countReg >= (depth-2) ) && !(countReg == depth);// almostFull flag is asserted only when the count is greater than the depth-2 AND the full flag is not asserted.
    assign overflow = overflow1;
    assign underflow = underflow1;
    assign valid = valid1;
        
endmodule

