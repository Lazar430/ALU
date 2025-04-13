`timescale 1ns/1ps

module ALU_tb;
   reg clk, resetn;
   reg [7:0] X, Y;
   reg [2:0] op;
   reg	     BEGIN;
   
   wire [15:0] OUT;
   wire	       END;   
   wire [7 : 0]	Q;
   wire [7 : 0]	A;
   wire [2:0]	count;
   wire		ovr;
   wire		q8;
   wire		r;
   wire [7:0]	m;
   wire [7:0]	sum_out;
   wire [17 : 0] c;
   
   // DUT instantiation
   ALU DUT (
	    .clk(clk), 
	    .resetn(resetn), 
	    .X(X), 
	    .Y(Y), 
	    .op(op),
	    .BEGIN(BEGIN),
	    .OUT(OUT),
	    .END(END),
	    .A(A),
	    .Q(Q),
	    .count(count),
	    .ovr(ovr),
	    .q8(q8),
	    .r(r),
	    .m(m),
	    .sum_out(sum_out),
	    .control(c)
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
      #10 BEGIN = 0;
      
      // --- Insert test cases here --- (definitely not AI written)
      
      X = 8'b10111001;
      Y = 8'b10000101; 

      op = 3'b101;
      
      #1000;
      $finish;
   end

   reg [150:1] c_bits_str; 

   task build_c_bits_str;
      input [17:0] c;
      output [150:1] str;
      integer	     i, k;
      reg [8*5:1]    temp; 
      begin
         str = "";
         for (i = 0; i <= 17; i = i + 1) begin
            if (c[i]) begin
               $sformat(temp, "c%0d ", i);
               // Append temp to str
               for (k = 1; k <= 8*5; k = k + 8) begin
                  str = {str, temp[k +: 8]};
               end
            end
         end
      end
   endtask // build_c_bits_str

   always @(*) begin
      build_c_bits_str(c, c_bits_str);
   end

   // Modified $monitor: prints the count change information along with other signals
   initial begin
      $monitor("Time=%0t | COUNT=%b | OVR=%b | A=%b | Q8=%b | Q=%b | R=%b | M=%b | SUM=%b | C_ACTIVE=%s",
               $time, count, ovr, A, q8, Q, r, m, sum_out, c_bits_str);
   end

   always @(count) begin
      $display("\n");  
   end

   initial begin
      @(posedge END);
      #500;
      $display("\n\nX = \t%d (%b) \t Y = \t%d (%b) \t | OUT_A = \t%d (%b) \t OUT_B = \t%d (%b)", 
               X, X, Y, Y, OUT[15:8], OUT[15:8], OUT[7:0], OUT[7:0]);
      $display("Simulation has ended.");
      $finish;
   end
   
   always @(posedge clk) begin
      if (END) begin
         $display(">>> END signal activated at T=%0t. Simulation ends.", $time);
         $finish;
      end
   end

endmodule
