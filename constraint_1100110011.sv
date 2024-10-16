
class A;
  rand int array[];
   bit k=1'b1;
  constraint c{array.size==8;}
  
  constraint c2{foreach(array[i]) array[i]== (i%4<2?1:0); }
  /*  function void post_randomize();
      foreach(array[i]) begin
        array[i]=k;
                  if((i+1)%2==0)
                    k=~k;
                    end
                endfunction
  */
  
endclass
A aa;
module test;
  initial begin
    aa=new;
    aa.randomize();
    $display("%p",aa.array);
  end
  
endmodule
