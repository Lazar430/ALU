`timescale 1ns / 1ps

module d_flipflop_testbench;
    reg clk, resetn, D;
    wire Q;
    
    // Instantiate D Flip-Flop
    D_FlipFlop uut (
        .clk(clk),
        .resetn(resetn),
        .D(D),
        .Q(Q)
    );

    // Clock Generation
    always #5 clk = ~clk;  // 10ns clock period (100MHz)

    initial begin
        $dumpfile("dff_test.vcd"); 
        $dumpvars(0, d_flipflop_testbench);
        
        clk = 0;    // Initialize clock
        resetn = 0; // Start with reset active
        D = 0;      
        
        // Apply Reset
        #10 resetn = 1; // Release reset
        
        // Test Case 1: D = 1, should reflect on Q at the next clk edge
        #10 D = 1;
        #10 $display("D = %b, Q = %b (Expected: 1)", D, Q);
        
        // Test Case 2: D = 0, Q should follow at next clk edge
        #10 D = 0;
        #10 $display("D = %b, Q = %b (Expected: 0)", D, Q);

        // Test Case 3: Reset should clear Q
        #5 resetn = 0;
        #5 $display("After reset: Q = %b (Expected: 0)", Q);
        
        // End Simulation
        #10 $finish;
    end
endmodule // d_flipflop_testbench
