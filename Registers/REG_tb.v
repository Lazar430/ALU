`timescale 1 ns / 100 ps

module REG_tb();
   // DUT Inputs
   reg clk, resetn, D0;
   reg [1 : 0] shift;
   reg [7:0]   load_data;
   
   // DUT Outputs
   wire [7:0]  Q;
   
   // Instantiate DUT
   REG dut (
            .clk(clk),
            .resetn(resetn),
            .load_data(load_data),
            .shift(shift),
            .D0(D0),
            .Q(Q)
            );

   // Clock Generation
   localparam CLOCK_PERIOD = 100;
   initial begin
      clk = 1'b0;
      forever #(CLOCK_PERIOD / 2) clk = ~clk;
   end

   // Reset sequence
   localparam RESET_PULSE = 25;

   initial begin
      $display("%-8t << Beginning the reset >>", $time);
      shift = 2'b0; // DO NOTHING
      D0 = 0;
      load_data = 8'b0;
      resetn = 1'b0;
      #RESET_PULSE resetn = 1'b1;
      $display("\n%-8t << Coming out of the reset >>\n", $time);
   end

   initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0, REG_tb);
   end

   initial begin
      // Load initial data
      #50 load_data = 8'b11101011;  //11110101 //01111010
      shift = 2'b11; // LOAD
      @(posedge clk);  // Ensure load is captured at the clock edge
      shift = 2'b0; // Load complete
      
      // Shift twice
      @(posedge clk); shift = 2'b01; D0 = 1;  // Shift in 1
      @(posedge clk); D0 = 0;  // Shift in 0
      @(posedge clk); shift = 2'b0;

      @(posedge clk); shift = 2'b01; D0 = 0;  // Shift in 1
      @(posedge clk); D0 = 1;  // Shift in 0
      @(posedge clk); shift = 2'b0;
      
      // Load new data
      #50 load_data = 8'b01011001; //10110010 //01100101
      shift = 2'b11;
      @(posedge clk);
      shift = 2'b00;
      
      // Shift once more
      @(posedge clk); shift = 2'b10; D0 = 0;
      @(posedge clk); D0 = 1;
      @(posedge clk); shift = 2'b00;

      @(posedge clk); shift = 2'b10; D0 = 1;
      @(posedge clk); D0 = 0;
      @(posedge clk); shift = 2'b00;
      
      #500;
      $finish;
   end
   
   // Declare color codes as localparams
   localparam BLUE    = "\t\t\033[1;34m";
   localparam YELLOW  = "\t\t\033[1;33m";
   localparam CYAN    = "\t\t\033[1;36m";
   localparam RED     = "\t\t\033[1;31m";
   localparam RESET   = "\t\033[0m";

   reg	      prev_D0;
   reg [1 : 0] prev_shift;
   reg [7:0]   prev_Q;

   // Initialize previous values
   initial begin
      prev_shift = 2'b00;
      prev_D0 = 0;
      prev_Q = 8'b0;
   end

   // Continuous monitoring of the signals with color codes when they change
   always @(posedge clk or posedge shift or D0 or Q) begin
      // Print a newline when load is set to 1
      if (shift == 2'b11) begin
         $display("\n");
      end

      // Print when there is a change in any of the signals
      if (shift != prev_shift || D0 != prev_D0 || Q != prev_Q) begin
         $display("%t | Shift=%s%2b%s | D0=%s%b%s | Q=%s%b%s", 
		  $time, 
		  (shift == 2'b01 || shift == 2'b10) ? YELLOW : ((shift == 2'b11) ? BLUE : RESET), shift, RESET,
		  (D0 != prev_D0) ? CYAN : RESET, D0, RESET,
		  (Q != prev_Q) ? RED : RESET, Q, RESET);

      end
      
      // Update previous values for comparison
      prev_shift <= shift;
      prev_D0 <= D0;
      prev_Q <= Q;
   end
endmodule
