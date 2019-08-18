`include "../src/dec.v"
`include "../src/insfetch.v"
`include "../src/fifo.v"
`include "../src/queuman.v"
`include "../src/timctrl.v"

module WaveControlUnit(clk, rst);

  input clk;
  input rst;

  wire [31:0] instr;
  wire [15:0] op;
  wire ff1, ff2, fe1, fe2, ft1, ft2, f01, f02, fu1, fu2;
  wire [7:0] pop1;
  wire [7:0] pop2;
  wire [7:0] trg_wd;
  reg we1, we2;
  wire re1, re2;
  reg enable;

  initial begin
    enable <= 1'd1;
    we1 <= 1'd0;
    we2 <= 1'd0;
  end

  InstrFetch instr_fetch(clk, rst, instr);
  InstrDec instr_dec(instr[31:28], op, enable);

  /*always @(posedge clk)
    case (instr[27])
      1'd0 : begin
        we1 <= 1'b1; we2 <= 1'b0;
      end

      1'd1 : begin
        we1 <= 1'b0; we2 <= 1'b1;
      end
    endcase
  end*/

  QueuManager man( clk, op[9:0], instr[7:0], trg_wd[7:0] );

  FifoMem fifo1(pop1[7:0], ff1, fe1, ft1, fo1, fu1, clk, !rst, !instr[27], re1, trg_wd[7:0]);
  FifoMem fifo2(pop2[7:0], ff2, fe2, ft2, fo2, fu2, clk, !rst, instr[27], re2, trg_wd[7:0]);
  //fifo fifo1(clk, rst, !instr[27], re1, trg_wd[7:0], fe1 , ff1, pop1[7:0]);
  //fifo fifo2(clk, rst, instr[27], re2, trg_wd[7:0], fe2 , ff2, pop2[7:0]);

  //$display("(1) Time %t Amplitude ", $realtime);
  //$display("(1) Time %t Amplitude ", $realtime);

  TimingControlUnit tcu1(clk, pop1[7:0], fe1, re1, rst);
  TimingControlUnit tcu2(clk, pop2[7:0], fe2, re2, rst);

endmodule
