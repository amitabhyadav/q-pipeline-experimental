module test;
  
  /* Make a reset that pulses once. */
  //  reg rst = 0;
  reg clk = 0;
  reg rst = 0;

  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars(0,test);

      # 1 rst = 1'b1;
      # 1 rst = 1'b0;
      # 100 $finish;
  end

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

  WaveControlUnit mod1(clk, rst);

endmodule // test
