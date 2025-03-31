module Decoder_1_out_of_5(input [2:0] count,
                          output reg [4:0] phase);
    
    always @(*)
    begin
        phase = 5'b00000;
        if (count < 5) phase[count] = 1'b1;
    end
endmodule
