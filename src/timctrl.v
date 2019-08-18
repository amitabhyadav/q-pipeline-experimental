module TimingControlUnit(clk, pop, fifo_empty, re, rst);
  
  localparam IDLE = 2'b00;
  localparam PULSE = 2'b01;
  localparam WAIT = 2'b10;
 
  input rst;
  input clk;
  input [7:0] pop;
  input fifo_empty;
  output reg re;

  reg [6:0] timer;
  reg [6:0] next_timer;
  reg [6:0] amp;
  reg [6:0] next_amp;
  reg [1:0] cur_state;
  reg [1:0] next_state;

  initial
  begin
    timer <= 7'b0000000;
    amp <= 7'b0000000;
    next_amp <= 7'b0000000;
    next_timer <= 7'b0000000;
    re <= 1'b0;
    cur_state <= IDLE;
  end

  // Current State Logic
  always @(posedge clk)
  begin
    if( rst == 1'b1 )
      cur_state <= IDLE;
    else cur_state <= next_state;
  end

 // Next State Logic
 always @(posedge clk)
 begin
   if( cur_state == IDLE )
     begin
       if( fifo_empty == 1'b1 )
         begin
           next_state <= IDLE;
           re <= 1'd1;
	 end
       else
         begin
           if( pop[7] == 1'b0 ) // Poped a wait instruction
	     next_state <= WAIT;
           else if( pop[7] == 1'b1 ) // Poped a pulse instruction
	     next_state <= PULSE;
	   
	   re <= 1'b0;
         end
     end

   else if( cur_state == WAIT )
     begin
       if( timer == 7'b0000001 )
         begin
               next_state <= IDLE;
	       re <= 1'b1;
	 end
       else 
         begin
           next_state <= cur_state;
	   re <= 1'b0;
	 end
     end

   else if( cur_state == PULSE )
     begin
       if( next_timer == 7'b0000000 )
         begin
               next_state <= IDLE;
               re <= 1'b1;
         end
       else
         begin
       	   next_state <= WAIT;
           re <= 1'b1;
	 end
     end
 end

 // Output Logic
 always @(posedge clk)
  begin

   amp <= next_amp;
   timer <= next_timer;

   if( cur_state == IDLE )
     begin
       if( fifo_empty == 1'b0)
         begin
           if( pop[7] == 1'b0 ) // Poped a wait instruction
             begin
	       next_amp <= next_amp;
	       next_timer <= pop[6:0] - 7'b0000001;
	     end
           else if( pop[7] == 1'b1 ) // Poped a pulse instruction
	     //begin
	       next_amp <= pop[6:0];
	       //timer <= pop[6:0];
	     //end
         end
       else next_amp <= next_amp;
     end

   else if ( cur_state == WAIT )
     begin
       next_amp <= next_amp;
       if ( next_timer != 7'b0000000 ) next_timer <= next_timer - 7'b0000001;
     end
   else if ( cur_state == PULSE )
     begin
       next_amp <= next_amp;
     end
 
 $display("At time %t, amplitude %d and timer %d", $time, amp, timer);
 end


/*  always @(posedge clk)
  begin
    if ( timer == 7'b0000000 )
      //begin
        //if ( fifo_empty == 1'b1 ) out <= out; // Problem, signal FIFO is obly empty after cycle of having poped it. Therefore, if it starts empty, it will be stuck always outputting result even if it should way (this is not a problem if )
        //else
	   begin
            //aux <= pop;
            if (fifo_empty == 1'b0)
              begin
                if ( status == 1'b1)
                  begin
                    re <= 1'd1;
                    if ( pop[7] == 1'b0 )
                      begin
                        timer <= pop[6:0];
                        out <= out;
                        re <= 1'b0;
                      end
                    else
                      begin
                        out <= pop[6:0];
                        re <= 1'd1;
                      end
                  end
                else
                  // Adds one clock delay after getting one thing in FIFO
                  begin
                    out <= out;
                    status <= 1'b1;
                  end
              end
            else
              begin
                re <= 1'd0;
                status <= 1'b0;
              end
          end
      //end
    else
      begin
        timer <= timer - 7'b0000001;
        out <= out;
      end

    //if( timer == 7'b0000000 ) re <= 1'd1;

    $display("At time %t, amplitude %d and timer %d", $time, out, timer);
  end
*/
endmodule

