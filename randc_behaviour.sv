// Code your testbench here
// oe Examples
class A;
  rand bit[2:0] mytype_t;
  bit [2:0] list[$];
  constraint cycle { unique {mytype_t,list};}
   function void post_randomize;
     if(list.size==2**$bits(mytype_t)-1)
       list.delete();
     
     list.push_back(mytype_t); //storing each myvar into list[$]
   endfunction 
  
endclass
module test;
  A a;
  initial begin
    a=new;
   
    repeat(10) begin
      	 a.randomize();
      $display("%p",a.list);
    end
    
  end
    	
endmodule
