module Counter_tb;
   reg clk, resetn;
   reg count_up;
   wire [2:0] count;

   Counter uut (
		.clk(clk),
		.resetn(resetn),
		.count_up(count_up), // Use clock as count_up signal
		.count(count)
		);

   // Clock generation
   always #5 clk = ~clk;

   initial begin
      // Initialize signals
      clk = 0;
      count_up = 0;    
      resetn = 0;

      // Monitor variables
      $monitor("Time=%0t | resetn=%b | count_up=%b | count=%b\t%d", $time, resetn, count_up, count, count);

      #10 resetn = 1; // Release reset

      count_up = 1;

      #50 count_up = 0;

      #50 count_up = 1;

      #100 count_up = 0;

      #200 count_up = 1;

      #200 count_up = 0;

      #200 count_up = 1;
      
      $finish; // Run long enough to observe counting
   end



endmodule
