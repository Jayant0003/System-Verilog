class AA;
  rand logic[0:19] var1;
  int a;
 int count;
  int b=0;
  constraint c{$countones(var1)==0;}
  
  function void post_randomize();
    repeat(4) begin
      a=a+1;
      repeat(a) begin     
            if(b!=0)
            count++;
        b++;
      end
      repeat(a) begin
          count++;
          var1[count]=1;
        end
        
    end
    
  endfunction
endclass

module test;
  AA aa;
  initial begin
    aa=new;
    aa.randomize();
    $display("aa=%b",aa.var1);
  end
  
  
  
endmodule
