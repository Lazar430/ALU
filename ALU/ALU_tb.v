`timescale 1ns/1ps

module ALU_tb;
   reg clk, resetn;
   reg [7:0] X, Y;
   reg [2:0] op;
   reg	     BEGIN;
   
   wire [15:0] OUT;
   wire	       END;   
   
   // DUT instantiation
   ALU DUT (
	    .clk(clk), 
	    .resetn(resetn), 
	    .X(X), 
	    .Y(Y), 
	    .op(op),
	    .BEGIN(BEGIN),
	    .OUT(OUT),
	    .END(END)
	    );

   // Clock generation
   always #5 clk = ~clk;

   initial begin
      $dumpfile("ALU_tb.vcd");
      $dumpvars(0, ALU_tb);

      clk = 0;
      resetn = 0;
      #10 resetn = 1;

      BEGIN = 1;
      
      // --- Insert test cases here --- (defintely not AI written)

      X = 8'd2;
      Y = 8'd10;

      op = 3'b101;
      
      #100;
      $finish;
   end

   initial begin
      $monitor("Time =\t%0t | X = \t%d (%b) \t Y = \t%d (%b) \t op = \t%3b | OUT_A = \t%d (%b) \t OUT_B = \t%d (%b)", 
	       $time, X, X, Y, Y, op, OUT[15:8], OUT[15:8], OUT[7:0], OUT[7:0]);

   end

endmodule
