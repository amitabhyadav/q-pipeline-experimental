module test;
  
  /* Make a reset that pulses once. */
  reg[6:0] addr;
  reg clk = 0;

  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars(0,test);

      # 1 addr = 7'b0;
      # 100 addr = 7'b0000000;
      # 100 addr = 7'b0000001;
      # 100 addr = 7'b0000010;
      # 100 addr = 7'b0000011;
      # 100 $finish;
  end

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

  wire[31:0] instr;
  InstrMem im1 (clk, addr, instr);

  initial
    $monitor("At time %t, intr addr = %h, inst = %h", $time, addr, instr);

endmodule // test
