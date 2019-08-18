// Main Module
// Inputs: addr, clk
// Output: instr
// Instruction Memory with 128 32-bit width instruction words 

module InstrMem(clk, addr, instr);

  input clk;
  input[6:0] addr;
  output[31:0] instr;

  reg[31:0] instr;
  reg[6:0] memAddr;
  reg[31:0] DataMem[0:9];

  //    Definition of the latency to latch the address and
  //    read the memory.
  //    parameter addrLatch = 10, memDelay = 70;

  // Loading of the Instruction Memory
  // opcode[31:28], channel[27], amp/wait[26:0] (only [7:0] used)
  initial
        $readmemb("../src/instrmem.data", DataMem);
  
  // Instruction Memory is read in every cycle (read signal could be added)
  always @(posedge clk) begin
        //#addrLatch 
        memAddr = addr;
        //#memDelay 
        instr = DataMem[memAddr];
  end

endmodule
