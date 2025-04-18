`timescale 1ns/1ps

module ALU_tb;
   reg clk, resetn;
   reg [7:0] X, Y, A_divide;
   reg signed [7 : 0] X_signed, Y_signed;
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
     	    .A_divide(A_divide),
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

   always @(*) begin
      X_signed = X;
      Y_signed = Y;
   end

   initial begin
      $dumpfile("ALU_tb.vcd");
      $dumpvars(0, ALU_tb);

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // 5771 : 135 = 42 R 101
      A_divide = 8'b00010110;
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // 7321 : 83 = 88 R 17
      //A_divide = 8'b00011100;
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -;

      clk = 0;
      resetn = 0;
      #10 resetn = 1;

      BEGIN = 1;
      #10 BEGIN = 0;
      
      // --- Insert test cases here --- (definitely not AI written)

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // 5771 : 135 = 42 R 101
      X = 8'b10001011; //pt :
      Y = 8'b10000111; //pt :
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // 7321 : 83 = 88 R 17
      //X = 8'b10011001;
      //Y = 8'b01010011;
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      
      //X = 8'b00010001; //pt celelalte
      //Y = 8'b00000101; //pt celelalte

      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      // -71 * (-123) = 8733
      //X = 8'b10111001; //pt *
      //Y = 8'b10000101; //pt *
      // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      
      //op = 3'b000; // AND
      //op = 3'b001; // OR
      //op = 3'b010; // XOR
      //op = 3'b011; // ADD
      //op = 3'b100; // SUB
      //op = 3'b101; // MUL
      op = 3'b110; // DIV
      
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
      $monitor("Time=%0t | COUNT=%b | OVR=%b | A=%b %b | Q8=%b | Q=%b %b | R=%b |M=%b %b | SUM=%b %b | C_ACTIVE=%s",
	       $time, count, ovr, A[7 : 4], A[3 : 0], q8, Q[7 : 4], Q[3 : 0], r, m[7 : 4], m[3 : 0], sum_out[7 : 4], sum_out[3 : 0], c_bits_str);
   end

   always @(count) begin
      $display("\n"); 
   end

   always @(posedge clk) begin
      @(posedge END);
      
      if(op == 3'b110) begin       
	 $display("\n\n\033[1;32m\n\nX = \t%d (%b) \t Y = \t%d (%b %b) \t | REST = \t%d (%b %b) \t QUOTIENT = \t%d (%b %b)\033[0m", 
		  {A_divide, X}, {A_divide, X}, Y, Y[7:4], Y[3:0], OUT[15:8], OUT[15:12], OUT[11:8], OUT[7:0], OUT[7:4], OUT[3:0]);
	 $display("\n\n\033[1;31m>>> END signal activated at T=%0t. Simulation ends.\033[0m", $time);
      end

      else begin 
	 $display("\n\n\033[1;32m\n\nX = \t%d (%b %b) \t Y = \t%d (%b %b) \t | OUT_A = \t%d (%b %b) \t OUT_B = \t%d (%b %b) | OUT = \t%d (%b)\033[0m", 
		  X_signed, X[7:4], X[3:0], Y_signed, Y[7:4], Y[3:0], OUT[15:8], OUT[15:12], OUT[11:8], OUT[7:0], OUT[7:4], OUT[3:0], OUT, OUT);
	 $display("\n\n\033[1;31m>>> END signal activated at T=%0t. Simulation ends.\033[0m", $time);
      end
      
      $finish;
   end

endmodule // ALU_tb
