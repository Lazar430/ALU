`timescale 1ns / 1ps

module mux_testbench;
   reg in0, in1;
   reg select;
   wire out;
   
   MUX uut(
      .in0(in0),
      .in1(in1),
      .select(select),
      .out(out)
   );

   initial begin
      // Test Case 1: select = 0, output should be in0
      in0 = 0; in1 = 1; select = 0; #10;
      $display("select = %b, in0 = %b, in1 = %b, output = %b (expected: %b)", 
                select, in0, in1, out, in0);

      // Test Case 2: select = 1, output should be in1
      in0 = 0; in1 = 1; select = 1; #10;
      $display("select = %b, in0 = %b, in1 = %b, output = %b (expected: %b)", 
                select, in0, in1, out, in1);
      
      // Test Case 3: select = 0, output should be in0
      in0 = 1; in1 = 0; select = 0; #10;
      $display("select = %b, in0 = %b, in1 = %b, output = %b (expected: %b)", 
                select, in0, in1, out, in0);
      
      // Test Case 4: select = 1, output should be in1
      in0 = 1; in1 = 0; select = 1; #10;
      $display("select = %b, in0 = %b, in1 = %b, output = %b (expected: %b)", 
                select, in0, in1, out, in1);

      $finish;
   end
endmodule // mux_testbench
