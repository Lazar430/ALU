module Counter(
	       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	       // CLK and RESET
	       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		input	       clk, resetn,
	       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	       // COUNT UP
	       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		input	       count_up,
	       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	       // OUTPUT
	       // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		output [2 : 0] count
	       );

   wire [2 : 0] c;

   T_FlipFlop t0(
		 .clk(clk),
		 .resetn(resetn),
		 .T(count_up),
		 .Q(c[0])
		 );

   T_FlipFlop t1(
		 .clk(clk),
		 .resetn(resetn),
		 .T(count_up & c[0]),
		 .Q(c[1])
		 );

   T_FlipFlop t2(
		 .clk(clk),
		 .resetn(resetn),
		 .T(count_up & c[1] & c[0]),
		 .Q(c[2])
		 );

   assign count = c;
   
   
endmodule // Counter
