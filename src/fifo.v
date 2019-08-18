// Main Module
// Inputs: data_in, rd, wr, rst_n, clk
// Output: data_out, fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow
// First in First out memory with 16 8-bit data width 

module FifoMem(data_out,fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow,clk, rst_n, wr, rd, data_in);

  input wr, rd, clk, rst_n;
  input[7:0] data_in;
  output[7:0] data_out;
  output fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;
  wire[4:0] wptr,rptr;
  wire fifo_we,fifo_rd;

  write_pointer top1(wptr,fifo_we,wr,fifo_full,clk,rst_n);
  read_pointer top2(rptr,fifo_rd,rd,fifo_empty,clk,rst_n);
  memory_array top3(data_out, data_in, clk,fifo_we, wptr,rptr);
  status_signal top4(fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow, wr, rd, fifo_we, fifo_rd, wptr,rptr,clk,rst_n);

 endmodule



// Verilog code for Memory Array submodule 
// At every positive edge, if the FIFO write enable is active, then data in is stored (data_out2) in position wptr. At every cycle, data at rptr is put in data_out for reading.
 module memory_array(data_out, data_in, clk, fifo_we, wptr, rptr);

  input[7:0] data_in;
  input clk, fifo_we;
  input[4:0] wptr, rptr;
  output[7:0] data_out;
  reg[7:0] data_out2[15:0];
  wire[7:0] data_out;

  always @(posedge clk)
  begin
   if(fifo_we)
      data_out2[wptr[3:0]] <=data_in ;
  end

  assign data_out = data_out2[rptr[3:0]];

 endmodule


// Verilog code for Read Pointer sub-module
// Module responsible to update read pointer. If FIFO read is enabled, pointer is incremented. If reset is enabled, then set to 0.
 module read_pointer(rptr,fifo_rd,rd,fifo_empty,clk,rst_n);

  input rd,fifo_empty,clk,rst_n;
  output[4:0] rptr;
  output fifo_rd;
  reg[4:0] rptr;

  // FIFO_rd set (only when FIFO is not empty) to rd. If it is emply then set to 0.
  assign fifo_rd = (~fifo_empty)& rd;

  always @(posedge clk or negedge rst_n)
  begin
   // reset signal makes read pointer 0
   if(~rst_n) rptr <= 5'b00000;

   // if reading FIFO, increment read pointer to next position
   else if(fifo_rd)
    rptr <= rptr + 5'b00001;

   // otherwise maintain read pointer
   else
    rptr <= rptr;

  end
 endmodule



// Verilog code for Status Signals sub-module
// Module responsible for refreshing the status signals: Full, Emply, Overflow, Underflow, Threshold
 module status_signal(fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow, wr, rd, fifo_we, fifo_rd, wptr,rptr,clk,rst_n);

  input wr, rd, fifo_we, fifo_rd,clk,rst_n;
  input[4:0] wptr, rptr;
  output fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;
  wire fbit_comp, overflow_set, underflow_set;
  wire pointer_equal;
  wire[4:0] pointer_result;
  reg fifo_full, fifo_empty, fifo_threshold, fifo_overflow, fifo_underflow;


 // Bitwise XOR so 000 if similar and 111 if different
  // Wptr and rptr represent pointers for reading and writting, where 3 LSB represent address
  assign fbit_comp = wptr[4] ^ rptr[4];
  assign pointer_equal = (wptr[3:0] - rptr[3:0]) ? 0:1;
  assign pointer_result = wptr[4:0] - rptr[4:0];

  // Possible Under/overflow if read/write operation but FIFO already full/empty
  assign overflow_set = fifo_full & wr;
  assign underflow_set = fifo_empty & rd;

  always @(*)
  begin
   fifo_full = fbit_comp & pointer_equal;
   fifo_empty = (~fbit_comp) & pointer_equal;
   // Threshold set at 16?
   fifo_threshold = (pointer_result[4]||pointer_result[3]) ? 1:0;
  end

  // OVERFLOW check
  always @(posedge clk or negedge rst_n)
  begin
  if(~rst_n) fifo_overflow <=0;
  // if there is possible overfull and no read, then definetely overflow
  else if((overflow_set==1)&&(fifo_rd==0))

   fifo_overflow <=1;
   // if there is read at same time, no overflow will happen
   else if(fifo_rd)

    fifo_overflow <=0;
    else
     fifo_overflow <= fifo_overflow;
  end


// UNDERFLOW check
  always @(posedge clk or negedge rst_n)
  begin
  if(~rst_n) fifo_underflow <=0;
  // if there is possible underflow and no write, then definetely underflow
  else if((underflow_set==1)&&(fifo_we==0))
   fifo_underflow <=1;
   // if a write will happen, then no underflow
   else if(fifo_we)
    fifo_underflow <=0;
    else
     fifo_underflow <= fifo_underflow;
  end
 endmodule



// Verilog code for Write Pointer sub-module
// Module responsible for updating the writing pointer after each clock cycle (wether reset, increment or maintain are required)
 module write_pointer(wptr,fifo_we,wr,fifo_full,clk,rst_n);
  input wr,fifo_full,clk,rst_n;
  output[4:0] wptr;
  output fifo_we;
  reg[4:0] wptr;

  assign fifo_we = (~fifo_full)&wr;

  always @(posedge clk or negedge rst_n)
  begin
   // if we reset, the place to write is beginning
   if(~rst_n) wptr <= 5'b00000;
   // increment writing pointer after a write operation
   else if(fifo_we)
    wptr <= wptr + 5'b00001;
   // otherwise maintain
   else
    wptr <= wptr;
  end

 endmodule
