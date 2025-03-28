module Parallel_Adder(
		       input [7:0]  a, b,
		       input	    cin,
		       output	    cout,
		       output [7:0] sum);

   wire [7:0]cout_aux;
   wire [7:0] b_xor; 

   assign b_xor= b ^ {8{cin}}; 

   generate
      genvar i;
      for(i = 0; i < 8; i = i + 1) begin: v
         if(i == 0)
           FAC f1(.a(a[0]), .b(b_xor[0]), .cin(cin), .cout(cout_aux[0]), .sum(sum[0]));
         else
           FAC f2(.a(a[i]), .b(b_xor[i]), .cin(cout_aux[i-1]), .cout(cout_aux[i]), .sum(sum[i]));
      end
      
   endgenerate
   assign cout = cout_aux[7];

endmodule
