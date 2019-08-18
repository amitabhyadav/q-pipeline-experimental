module test;
  
  /* Make a reset that pulses once. */
  reg clk = 0;
  reg [9:0] op;
  reg [7:0] instr;
  wire [7:0] trg;

  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars(0,test);

      instr = 8'b11111111;
      op = 10'b0000000000;
      # 5 op = 10'b0000000001;
      # 2 op = 10'b1111111110;
      # 2 op = 10'b1111111111;
      # 2 instr = 8'b00000000;
      # 100 $finish;
  end

  /* Make a regular pulsing clock. */
  always #1 clk = !clk;

  QueuManager mod1(clk, op, instr, trg);

  initial
    $monitor("At time %t, op %h, instr %h and trg %h", $time, op, instr, trg);

endmodule // test
