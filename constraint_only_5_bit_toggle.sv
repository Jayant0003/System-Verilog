// Code your testbench here
// or browse Examples
class test;
  rand bit [7:0] a;
  bit[7:0] b;
  
  //constraint c1{foreach;}
 // constraint c2{}
  //constraint c3{$countones(b)==5;}
  constraint c{ $countones(a^b)==5;};
  
  // constraint so that only odd no of 1's shoud be there
  //constraint c2{$countones(a) & '1==1;}
  function void post_randomize();
    
   
    b=a;
  endfunction
  
endclass

module top;
  test t;
  initial begin
    t=new();
    repeat(10)
      begin
    assert(t.randomize);
        $display("value of a is %b" ,t.a);
      end
  end
    endmodule
