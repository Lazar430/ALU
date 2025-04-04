`timescale 1ns/1ps

module Control_Unit_tb();
    reg clk, begin_signal, reset, Q1, Q0, R, A7, count7;
    reg [2:0] op;
    wire [17:0] c;
    wire end_signal;
    
    // Instantiere modul
    Control_Unit uut (
        .clk(clk),
        .begin_signal(begin_signal),
        .reset(reset),
        .Q1(Q1),
        .Q0(Q0),
        .R(R),
        .A7(A7),
        .count7(count7),
        .op(op),
        .c(c),
        .end_signal(end_signal)
    );
    
    // Generare clock
    always #5 clk = ~clk;
    
    initial begin
       $dumpfile("Control_Unit_tb.vcd");
       $dumpvars(0, Control_Unit_tb);
        // Initializare semnale
        clk = 0;
        reset = 0;
        begin_signal = 0;
        Q1 = 0;
        Q0 = 0;
        R = 0;
        A7 = 0;
        count7 = 0;
        op = 3'b000;
        
        // Resetare sistem
        #10 reset = 1;
        #10 reset = 0;
        
        // Test 1: Pornire
        #10 begin_signal = 1;
        #10 begin_signal = 0;
        
        // Test 2: Operatii logice
        #20 op = 3'b000; // Test AND
        #20 op = 3'b001; // Test OR
        #20 op = 3'b010; // Test XOR
        
        // Finalizare simulare
        #100;
        $finish;
    end
    
    // Monitorizare semnale
    initial begin
        $monitor("Time=%0t | clk=%b | reset=%b | begin_signal=%b | op=%b | c=%b | end_signal=%b",
                 $time, clk, reset, begin_signal, op, c, end_signal);
    end
endmodule
