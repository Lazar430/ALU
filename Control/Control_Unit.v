module Control_Unit(
		     input	   clk, begin_signal, reset, Q1, Q0, R, A7, count7,
		     input [2:0]   op,
		     output [17:0] c,
		     output reg	end_signal);

   wire [4:0]phase;
   wire	     phi0, phi1, phi2, phi3, phi4;
   wire	     q0, q1_8, q9;
   wire	     reset_cycle_0, reset_cycle_1_8; 

   assign phi0 = phase[0];
   assign phi1 = phase[1];
   assign phi2 = phase[2];
   assign phi3 = phase[3];
   assign phi4 = phase[4];

   assign reset_cycle_0 = phi4 & q0;
   //(suntem in ciclul 1-8 si count7=1 si faza e 4) sau (sarim peste ciclurile 1-8(cand c2) si faza e 4) => reset_cycle_1_8
   assign reset_cycle_1_8 = (q1_8 & count7 & phi4) | (((~op[0] & ~op[1]) | ~op[2]) & phi4); 

   Modulo_5_Sequence_Counter sc(.clk(clk), .reset(reset), .begin_signal(begin_signal), .end_signal(end_signal), .phase(phase));

   SR_FF cycle_0 (.s(begin_signal), .r(reset_cycle_0), .clk(clk), .q(q0));
   SR_FF cycle_1_8 (.s(reset_cycle_0), .r(reset_cycle_1_8), .clk(clk), .q(q1_8));
   SR_FF cycle_9 (.s(reset_cycle_1_8), .r(end_signal), .clk(clk), .q(q9));

   //cycle 0
   assign c[0] = q0 & phi0;
   assign c[1] = q0 & phi1;
   assign c[2] = q0 & phi2 & ((~op[0] & ~op[1]) | ~op[2]);        //se activeaza la SI, SAU, XOR, +, -
   assign c[15] = q0 & phi2 & (op[2] & ~op[1] & ~op[0]);          // exclusiv la -
   assign c[10] = q0 & phi2 & (op[2] & op[1] & ~op[0]);           // la :
   assign c[16] = q0 & phi3 & ((~op[0] | ~op[1]) & ~op[2]);       // la SI, SAU, XOR
   assign c[11] = q0 & phi3 & (op[2] & op[1] & ~op[0]);           // la :

   //cycle 1-8 (pentru * si :)
   assign c[3] = q1_8 & phi0 & (Q0 ^ R) & (op[2] & ~op[1] & op[0]);                 // Q1Q0R < {001, 010, 101, 110}, la *
   assign c[4] = q1_8 & phi0 & (Q1 & (Q0 ^ R)) & (op[2] & ~op[1] & op[0]);          // Q1Q0R < {101, 110}, la *
   assign c[12] = q1_8 & phi0 & (op[2] & op[1] & ~op[0]);                           // la :
   assign c[5] = q1_8 & phi1 & (op[2] & ~op[1] & op[0]);                            // la *
   assign c[13] = q1_8 & phi1 & A7 & (op[2] & op[1] & ~op[0]);                      // la :
   assign c[14] = q1_8 & phi1 & ~A7 & (op[2] & op[1] & ~op[0]);                    // la :
   assign c[6] = q1_8 & phi2 & ~count7 ;                                             // la :, *
   assign c[17] = q1_8 & phi3 & ~count7 & (op[2] & op[1] & ~op[0]);                 // la :

   //cycle 9
   assign c[7] = q9 & phi0;
   assign c[8] = q9 & phi1;
   assign c[9] = q9 & phi1;

   always @(posedge clk) begin
      if (!reset)
        end_signal <= 1'b0;
      else
        end_signal <= c[8] | c[9];
   end


endmodule
