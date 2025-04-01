// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// FILE: ALU.v
// PURPOSE: implements a FSM that is able to add, subtract, multiply, divide and perform logical operations between two 8-bit inputs
// TO DO: initialize Q8
// TO DO: save sum into A
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
module ALU(
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // CLK and RESET
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	    input	    clk,
	    input	    resetn,
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // INPUTS
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	    input [7 : 0]   X, Y,
	    input [2 : 0]   op,
	    input	    BEGIN,
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	   // OUTPUTS
	   // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	    output [15 : 0] OUT,
	    output wire	END
	   );

   wire [7 : 0] A;
   wire [7 : 0]	Q;
   wire [7 : 0]	M;

   //wire [7 : 0]	A_star;

   //wire [7 : 0]	A_AND;
   //wire [7 : 0]	A_OR;
   //wire [7 : 0]	A_XOR;
   
   reg [1 : 0]	shift;

   always @(*) begin
      shift = { c[0] | (c[11] | c[17]), c[0] | c[5] };
   end

   wire		A_D0;
   wire		Q8;
   wire		Q_D0;

   wire		S;

   wire [7 : 0]	sum;
   wire		cout;
   wire		overflow;

   wire		R;
   wire		OVR;
   
   wire [2 : 0]	count7;

   wire [17 : 0] c;

   MUX_4_to_1 A_D0_mux(
		       .in0(1'bx),
		       .in1(OVR),
		       .in2(Q[7]),
		       .in3(1'bx),
		       .select(shift),
		       .out(A_D0)
		       );

   REG A_Register(
		  .clk(clk),
		  .resetn(resetn),
		  .load_data({8{1'b0}}),
		  .shift(shift),
		  .load_D0(1'b0),
		  .D0(A_D0),
		  .Q(A)
		  );

   D_FlipFlop Q8_FlipFlop(
			  .clk(clk),
			  .resetn(resetn),
			  .enable(c[5]),
			  .D(A[0]),
			  .Q(Q8)
			  );

   MUX_4_to_1 Q_D0_mux(
		       .in0(1'bx),
		       .in1(Q8),
		       .in2(1'b0),
		       .in3(1'bx),
		       .select(shift),
		       .out(Q_D0)
		       );

   MUX S_mux(
	     .in0(1'b0),
	     .in1(1'b1),
	     .select(A[7]),
	     .out(S)
	     );

   reg load_S;

   always @(*) begin
      load_S = c[13] | c[14];
   end

   
   REG Q_Register(
		  .clk(clk),
		  .resetn(resetn),
		  .load_data(X),
		  .shift(shift),
		  .load_D0(load_S),
		  .D0(load_S ? S : Q_D0),
		  .Q(Q)
		  );

   REG M_Register(
		  .clk(clk),
		  .resetn(resetn),
		  .load_data(Y),
		  .shift({ c[0], c[0] }),
		  .load_D0(1'b0),
		  .D0(1'b0),
		  .Q(M)
		  );

   Parallel_Adder RCA(
		      .a(A),
		      .b(M),
		      .cin(c[15] | c[12] | c[14]),
		      .cout(cout),
		      .sum(sum),
		      .overflow(overflow)
		      );

   D_FlipFlop OVR_FlipFlop(
			   .clk(clk),
			   .resetn(resetn),
			   .enable(1'b1),
			   .D(overflow),
			   .Q(OVR)
			   ); 

   D_FlipFlop R_FlipFlop(
			 .clk(clk),
			 .resetn(resetn),
			 .enable(1'b1),
			 .D( ( Q[1] & Q[0] ) | ( R & (Q[1] | Q[0]) ) ),
			 .Q(R)
			 );

   Counter counter(
		   .clk(clk),
		   .resetn(resetn | c[0]),
		   .count_up(c[5]),
		   .count(count7)
		   );
   
   Control_Unit CU(
		   .clk(clk),
		   .reset(resetn),
		   .begin_signal(BEGIN),
		   .Q1(Q[1]),
		   .Q0(Q[0]),
		   .R(R),
		   .A7(A[7]),
		   .count7(count7[0] & count7[1] & count7[2]),
		   .op(op),
		   .c(c),
		   .end_signal(END)
		   );
   
endmodule // ALU
