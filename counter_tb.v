`timescale 1ns / 1ps

module latch_counter_tb;

    // Testbench signals
    reg en;
    reg rst;
    wire [3:0] q;


    latch_counter latch_counter_inst (
        .en(en),
        .rst(rst),
        .q(q)
    );


    initial begin
        $display("Time\t rst en q");
        $monitor("%4t:\t %b   %b  %b", $time, rst, en, q);

        // Initial values
        rst = 1;
        en  = 0;

        // Apply reset
        #5 rst = 1;
        #5 rst = 0;

        // Count while enable is high
        #5 en = 1;
        #5 en = 1;
        #5 en = 1;

        // Hold value when enable is low
        #5 en = 0;
        #5 en = 0;

        // Enable again to continue counting
        #5 en = 1;
        #5 en = 1;

        // Apply reset again
        #5 rst = 1;
        #5 rst = 0;

        // Finish simulation
        #10 $finish;
    end

endmodule
