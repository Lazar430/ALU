// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// FILE: REG.v
// Purpose: implements an 8-bit register that stores an initial value and shifts it bitwise (left or right) when told to do so
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
module REG(
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // CLOCK and RESET
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	    input	      clk,
	    input	      resetn,

	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // LOAD DATA
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
	    input [7:0]	      load_data,
	    input	      load_D0, 
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // SHIFT FUNCTIONALITY
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	    input [1 : 0]     shift,
	    input	      D0, 

	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // OUTPUTS
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	    output wire [7:0] Q  
	   );

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   // either stores initial value or neighbouring flip-flops outputs
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   wire [7:0] D;

   generate
      genvar i;
      for (i = 0; i < 8; i = i + 1) begin: v
         if (i == 0)
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // Choose between initial value (on LOAD) or arbitrary incoming bit (on SHIFT)
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	   MUX_4_to_1 mux_0(
			    .in0(Q[0]),
			    .in1(Q[1]),
			    .in2(D0),
			    .in3(load_data[0]),
			    .select(shift),
			    .out(D[0])
			    );
	 
	 else if(i == 7)
	   MUX_4_to_1 mux_7(
			    .in0(Q[7]),
			    .in1(D0),
			    .in2(Q[6]),
			    .in3(load_data[7]),
			    .select(shift),
			    .out(D[7])
			    );
	 
	 
         else
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // Choose between initial value (on LOAD) or neighbouring bit (on SHIFT)
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
           MUX_4_to_1 mux_i (
			     .in0(Q[i]),
			     .in1(Q[i + 1]),
			     .in2(Q[i - 1]),
			     .in3(load_data[i]), 
			     .select(shift), 
			     .out(D[i])
			     );

	 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 // Store bits in memory units
	 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	 if(i == 0)
           D_FlipFlop flip_flop_0 (
				   .clk(clk), 
				   .resetn(resetn), 
				   .enable( shift[0] | shift[1] | load_D0 ), 
				   .D(load_D0 ? D0 : D[i]), 
				   .Q(Q[i])  
				   );
	 
	 else
	   D_FlipFlop flip_flop_i (
				   .clk(clk), 
				   .resetn(resetn), 
				   .enable( shift[0] | shift[1] ), 
				   .D(D[i]), 
				   .Q(Q[i])  
				   );
	 
      end
   endgenerate

endmodule // REG
