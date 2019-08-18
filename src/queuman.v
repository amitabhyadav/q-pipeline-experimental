module QueuManager(clk, op, instr, trg);
  
  input clk;
  input [9:0] op;
  input [7:0] instr;
  output reg [7:0] trg;

  initial
  begin
    trg <= 8'b0;
  end

  // For now only to possible operations are distinguished, either wait or puls,
  // respectively op[]=0 and op[]=1
  always @(posedge clk)
    begin
      if (op[0])
        begin
          trg = {1'b1, instr[6:0]};
        end
      else
        begin
          trg = {1'b0, instr[6:0]};
        end
    end

endmodule
