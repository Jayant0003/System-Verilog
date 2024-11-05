class A;
  
  //rand int a[3];
  rand  int a;
  //constraint a1{foreach(a[i])  //sum=sum+a[i];
 //   a.sum()==16;     };
 // constraint a2{foreach (a[i]) a[i] inside {[1:9]};};
  
  constraint c1{a<999;};
  constraint c2{a/100+(a%100)/10+a%10==16;};
  function int sum1(int b);
  int sum=0;
  while(b>0) begin
    sum1=sum1+b%10;
    b=b/10;
  end
    if(sum1==16)
    	return sum1;
  else
    	return 0;
endfunction
  
endclass



module test;
  A aa=new;
  initial begin
    repeat(20) begin
    aa.randomize();
      $display("%0d",aa.a);
      
    end
  end
endmodule
