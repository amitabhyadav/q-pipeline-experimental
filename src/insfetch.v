`include "../src/instrmem.v"

// Program Counter
// Inputs: clk, rst, pc_control, reg_addr;
// Output: pc
// 32-bit Program Counter with control for loading of addr
module Program_Counter(clk, rst, pc, pc_control, reg_addr);

  input clk;
  input rst;
  input pc_control;
  input [31:0] reg_addr;

  output reg [31:0] pc;
  wire [31:0] npc;

  initial
  begin
    pc <= 0;
  end

  assign npc = pc + 1;

  always @(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          pc <= 32'd0;
        end
      else
        begin
          case (pc_control)
            1'b0 : // begin 
              pc <= npc;
              //$display("@%t : pc = %d ",$realtime,pc); 
            //end
            1'b1 : pc <= reg_addr;
            default : pc <= npc;
          endcase
        end
    end

endmodule



// Instruction Fetch
// Inputs: clk, rst
// Output: instr
// 
module InstrFetch(clk, rst, instr);

  input clk;
  input rst;
  output wire [31:0] instr;

  wire [31:0] pc;
  reg pc_control;
  reg [31:0] reg_addr = 32'd0;

  initial begin
      pc_control <= 1'd0;
  end

  // Reading Program Counter
  //always @(posedge clk)
      Program_Counter prog_counter(clk, rst, pc, pc_control, reg_addr);
      InstrMem instr_mem(clk, pc[6:0], instr);

endmodule

