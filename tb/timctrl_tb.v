module test;
  
  /* Make a reset that pulses once. */
  reg clk = 0;
  reg [7:0] trg_wrd;
  reg fifo_empty;
  wire re;

  wire [6:0] out;

  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars(0,test);

      fifo_empty = 1'b0;
      trg_wrd = 8'b00000000;
      # 1 rst = 1'b1;
      # 1 rst = 1'b0;
      # 1 trg_wrd = 8'b10000001;
      # 1 trg_wrd = 8'b00000011;
      # 1 fifo_empty = 1'b0;
      # 100 $finish;
  end

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

  TimingControlUnit mod1(clk, trg_wrd, fifo_empty, re, rst);

//  initial
    //$monitor("At time %t, trigger word %h, fifo_empty %h and re %h", $time, trg_wrd, fifo_empty, re);

endmodule // test
