module latch_counter (
    input wire en,   // Level-sensitive clock (acts like enable)
    input wire rst,      // Asynchronous reset
    output reg [3:0] q   // 4-bit counter output
);

    always @(rst, q, en) begin
        if (rst)
            q = 4'b0000;             // Reset counter
        else if (en)
            q = q + 1;               // Count up when enable is high
        // else: latch holds previous value (do nothing)
    end

endmodule
