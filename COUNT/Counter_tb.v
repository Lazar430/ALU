module Counter_tb;
   reg clk, resetn;
   wire [2:0] count;

   Counter uut (
		.clk(clk),
		.resetn(resetn),
		.count_up(clk), // Use clock as count_up signal
		.count(count)
		);

   // Clock generation
   always #5 clk = ~clk;

   initial begin
      // Initialize signals
      clk = 0;
      resetn = 0;

      // Monitor variables
      $monitor("Time=%0t | resetn=%b | count=%b\t%d", $time, resetn, count, count);

      #10 resetn = 1; // Release reset

      #200 $finish; // Run long enough to observe counting
   end
endmodule
