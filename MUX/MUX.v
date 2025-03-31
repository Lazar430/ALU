// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// FILE: MUX.v
// PURPOSE: implement a multiplexer (chooses between inputs based on a selector)
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
module MUX (
	     input  in0, in1,
	     input  select,
	     output out
	    );

   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   // select decides between inputs
   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   assign out = (~select & in0) | (select & in1);
endmodule // MUX

module MUX_4_to_1 (
		    input	  in0, in1, in2, in3,
		    input [1 : 0] select,
		    output wire	out
		   );

   wire out_0, out_1;
   
   MUX mux_0(
	     .in0(in0),
	     .in1(in1),
	     .select(select[0]),
	     .out(out_0)
	     );

   MUX mux_1(
	     .in0(in2),
	     .in1(in3),
	     .select(select[0]),
	     .out(out_1)
	     );

   MUX mux(
	   .in0(out_0),
	   .in1(out_1),
	   .select(select[1]),
	   .out(out)
	   );

endmodule // MUX_4_to_1
