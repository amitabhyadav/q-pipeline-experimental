module decoder_tb ( binary_in, decoder_out, enable );

  initial
    begin
      $dumpfile("test.vcd");
      $dumpvars();
    end
  
  input binary_in;
  input enable ;
  output [15:0] decoder_out ;

  wire [15:0] decoder_out ;

  assign decoder_out = (enable) ? (1 << binary_in) : 16'b0 ;

endmodule
