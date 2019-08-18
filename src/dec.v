// Main Module
// Inputs: binary_in
// Output: op_word
// 4-to-16 Decoder
module InstrDec ( opcode, op_word, enable );

  input [3:0] opcode  ;
  input  enable ;
  output [15:0] op_word ;
  reg [15:0] op_word ;

  always @ (enable or opcode)
  begin
    op_word = 0;
    if (enable) begin
      case (opcode)
        4'h0 : op_word = 16'h0000;
        4'h1 : op_word = 16'h0001;
        4'h2 : op_word = 16'h0002;
        4'h3 : op_word = 16'h0003;
        4'h4 : op_word = 16'h0004;
        4'h5 : op_word = 16'h0005;
        4'h6 : op_word = 16'h0006;
        4'h7 : op_word = 16'h0007;
        4'h8 : op_word = 16'h0008;
        4'h9 : op_word = 16'h0009;
        4'hA : op_word = 16'h000A;
        4'hB : op_word = 16'h000B;
        4'hC : op_word = 16'h000C;
        4'hD : op_word = 16'h000D;
        4'hE : op_word = 16'h000E;
        4'hF : op_word = 16'h000F;
      endcase
    end
  end

endmodule
