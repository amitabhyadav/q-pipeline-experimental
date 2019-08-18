`define W 32
  
module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0,test);

     # 17 reset = 1;
     # 11 reset = 0;
     # 29 reset = 1;
     # 5  reset =0;
     # 513 $finish;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #1 clk = !clk;

  wire [`W-1:0] value;
  counter #(`W) c1 (value, clk, reset);

  initial
     $monitor("At time %t, value = %h (%0d)",
              $time, value, value);
endmodule // test
