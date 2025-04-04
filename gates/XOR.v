module XOR (
	     input [7 : 0]  in0, in1,
	     output [7 : 0] out
	    );

   assign out = in0 ^ in1;
endmodule // XOR
