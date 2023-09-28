// defining values before hand
`define dataWidth 8
`define memoryDepth 32
`define addrWidth $clog2(`memoryDepth)
`define almostThreshold 2
`define CLK_PERIOD 10
`define seperator

`timescale 1 ns / 100 ps
module fifo_tb();

    // Read Inputs
    reg [`dataWidth-1:0] data_in;
    reg clk, rst_n, wr_en, rd_en;
    
    // Read Outputs
    wire [`dataWidth-1:0] data_out;
    wire signed [`addrWidth+1:0] count;
    wire empty, almostEmpty, full, almostFull, overflow, valid;
        
    fifo #(.dataWidth(`dataWidth), .memoryDepth(`memoryDepth), .almostThreshold(`almostThreshold) ) UUT(data_in, clk, rst_n, wr_en, rd_en, data_out,count, empty, almostEmpty, full, almostFull, overflow, underflow, valid);
        
    // Clock Generator
	initial 
        begin
        clk = 0;
            forever 
                begin
                    #( `CLK_PERIOD/2 ) clk = ~clk;
                end
    end

    // Counter
    initial 
        begin
        data_in = 0;
            forever 
                begin
                    #( `CLK_PERIOD) data_in = data_in+1;
                end
    end
        
  initial 
    begin
		$vcdpluson;
        $monitor("%0d: clk: %b, rst_n: %b, wr_en: %b, rd_en: %b, data_in: %0d, data_out: %0d, count: %0d, empty: %b, almostEmpty: %b, full: %b, almostFull: %b, overflow: %b, underflow: %b, valid: %b", $time, clk, rst_n, wr_en, rd_en, data_in, data_out, count, empty, almostEmpty, full, almostFull, overflow, underflow, valid);
    
        // Reset FIFO
        rst_n = 1'b1;
        wr_en = 1'b0;
        rd_en = 1'b0;
        
        #`CLK_PERIOD
        
        $display(`seperator);
        $display("Count is Behaving Correctly");
        $display("Write to all Memory Locations");
        // Write
        rst_n = 1'b0;
        wr_en = 1'b1;
        rd_en = 1'b0;
        
        // After 32 Writes
        #(`CLK_PERIOD*32)
        
        $display(`seperator);
        $display("Read to all Memory Locations");
        // Read
        rst_n = 1'b0;
        wr_en = 1'b0;
        rd_en = 1'b1;
        
        // After 32 Reads
        #(`CLK_PERIOD*32) 
        
        $display(`seperator);
        $display("Simultaneous Read and Write in the Middle.");
        $display("Write for next 16 Clock Cycles");
        // Write
        rst_n = 1'b0;
        wr_en = 1'b1;
        rd_en = 1'b0;
        
        // Write to FIFO 16 Times
        #(`CLK_PERIOD*16) 
        
        $display("Simulataneous Read and Write for next 16 Clock Cycles");
        // Simulataneous Read and Write
        rst_n = 1'b0;
        wr_en = 1'b1;
        rd_en = 1'b1;
        
        // Read from and write to FIFO 16 Times
        #(`CLK_PERIOD*16) 
        
        // Read
        rst_n = 1'b0;
        wr_en = 1'b0;
        rd_en = 1'b1;
        
        // Read for the next (LOOK_BELOW) clock cycles
        #(`CLK_PERIOD*(32-2-17)) 
        
        $display(`seperator);
        $display("Demonstrating All Flags");
        $display("almostEmpty Flag");
        
        #(`CLK_PERIOD*(2)) 
        $display("Empty Flag");
        
        #(`CLK_PERIOD*(1)) 
        
        $display("Underflow Flag and Valid Flag");
        #(`CLK_PERIOD*(1)) 
        
         $display("Writing to FIFO to setup almostFull, Full, and Overflow Flag");
        // Write
        rst_n = 1'b0;
        wr_en = 1'b1;
        rd_en = 1'b0;
        
        // Write to FIFO 30 Times
        #(`CLK_PERIOD*29) 
        $display("almostFul Flag");
        
        #(`CLK_PERIOD*(2)) 
        $display("Full Flag");
        
        #(`CLK_PERIOD*(1)) 
        $display("Overflow Flag");
        
        #(`CLK_PERIOD*(1)) 
        $finish;
    end
endmodule
