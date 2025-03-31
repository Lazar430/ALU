module Modulo_5_Sequence_Counter(input clk, reset, begin_signal, end_signal,
                                 output [4:0] phase);
    
    wire q;
    wire [2:0] count;
    
    SR_FF sr_ff (.s(begin_signal), .r(end_signal), .clk(clk), .q(q));
    Modulo_5_Counter counter (.clk(clk), .reset(reset), .count_up(q), .count(count));
    Decoder_1_out_of_5 decoder (.count(count), .phase(phase));

endmodule