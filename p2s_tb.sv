`timescale 1ns/1ps

// Testbench module
module p2s_tb;
    logic clk = 0, rstn = 0;
    localparam CLK_PERIOD = 10;

    // Clock generation
    initial forever
        #(CLK_PERIOD/2) clk <= ~clk;

    // Parameters for the parallel to serial converter module
    parameter N = 8;

    // Signals for the parallel to serial converter module
    logic [N-1:0] par_data;
    logic par_valid = 0, par_ready, 
          ser_data, ser_valid, ser_ready;

    // Instantiate the parallel to serial converter module
    p2s #(.N(N)) dut (.*);

    // Initialize VCD dump file
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        // Reset sequence
        @(posedge clk); #1 rstn <= 0;
        @(posedge clk); #1 rstn <= 1;

        // Test scenarios
        @(posedge clk) #1 par_data <= 8'd7 ; par_valid <= 0; ser_ready <= 1; 
        #(CLK_PERIOD*3)
        @(posedge clk) #1 par_data <= 8'd62; par_valid <= 1;
        @(posedge clk) #1 par_valid <= 0;
        #(CLK_PERIOD*10)
        @(posedge clk) #1 par_data <= 8'd52; par_valid <= 1;
        @(posedge clk) #1 par_valid <= 0; 
        @(posedge clk) #1 ser_ready <= 0;
        #(CLK_PERIOD*3)
        @(posedge clk) #1 ser_ready <= 1;
        #(CLK_PERIOD*10)
        @(posedge clk) #1 ser_ready <= 0;

        // Finish simulation
        $finish();
    end
endmodule
