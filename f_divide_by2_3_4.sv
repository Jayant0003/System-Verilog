
 module divide_by_3;
bit clk_in;
   bit clk_out_3;
   bit clk_out_2;
   bit clk_out_4;
   reg [1:0] pos_cnt=0;
   reg [1:0] neg_cnt=0;
 
   
   always #2 clk_in=!clk_in;
   //posedge counter
 always @ (posedge clk_in)
   pos_cnt <= (pos_cnt == 2) ? 0 : pos_cnt + 1;
 
 // Neg edge counter
 always @ (negedge clk_in)
   neg_cnt <= (neg_cnt == 2) ? 0 : neg_cnt + 1;
 
 
   // frequence divide by 2
   always @(posedge clk_in) 
     clk_out_2=!clk_out_2;
   // frequency divide by 3
   assign clk_out_3 = ((pos_cnt  == 2) || (neg_cnt  == 2));
   // frequency divide by 4
   always_comb begin
     if(pos_cnt==2)
		clk_out_4<=!clk_out_4;     
   end
   initial begin
     $dumpfile("dump.vcd");
     $dumpvars;
   end
   initial begin
     #100;
     $finish;
   end
 
 endmodule
 
 
