module Parallel_Adder_tb();
   reg [7:0] a, b;
   reg	     cin;
   wire [7:0] sum;
   wire	      cout;
   
   Parallel_Adder tb (
		      .a(a),
		      .b(b),
		      .cin(cin),
		      .cout(cout),
		      .sum(sum)
		      );
   
   initial begin
      
      $monitor("Time=%0t a=%b b=%b cin=%b | sum=%b cout=%b", $time, a, b, cin, sum, cout);
      
      
      a = 8'b00001111; b = 8'b00000001; cin = 1'b0;
      #10;
      
      a = 8'b11111111; b = 8'b00000001; cin = 1'b0;
      #10;
      
      a = 8'b00001111; b = 8'b00001111; cin = 1'b1;
      #10;
      
      a = 8'b10101010; b = 8'b01010101; cin = 1'b0;
      #10;
      
      a = 8'b11111111; b = 8'b11111111; cin = 1'b1;
      #10;
      
      $stop;
      $dumpfile("dump.vcd"); $dumpvars;
   end
endmodule
