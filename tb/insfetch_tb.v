module test;
  
  /* Make a reset that pulses once. */
  reg rst = 0;
  reg clk = 0;

  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars(0,test);

      # 5 rst = 1'b1;
      # 1 rst = 1'b0;
      # 1000 $finish;
  end

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

  wire[31:0] instr;
  InstrFetch mod1(clk, rst, instr);

  initial
    $monitor("At time %t, rst = %h, inst = %h", $time, rst, instr);

endmodule // test
