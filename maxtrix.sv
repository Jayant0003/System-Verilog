// compiler directive: +define+M1
class A;

  rand bit [2:0]  A[][]; 
`ifdef M1
  constraint SIZE_CONSTRAINT_1D { A.size()  == 4 ; }

// all elements in a row 
constraint sum_constraint_2d {   foreach(A[i])
                                  {
                                    A[i].size==4;
                                    A[i].sum() with ( int'(item) ) == 20 ;	  
                          
				  }
			     }
  // all elements in a column
  constraint c1{
    foreach(A[i])
      A.sum() with (int'(A[item.index][i]))==20;
  }
// all elements in diagonal
  
   constraint c2{
     foreach(A[i,j]) 
      // if(i==j)
       A.sum() with (int'(A[i][i] ))==20;
  				}
    
  constraint c3{
    
    foreach(A[i]) {
      
      A.sum() with (int'(A[i][A.size()-1-i]))==20;
    }
  }
				  
`endif
  
`ifdef M2 // Size for 2nd Dimension// sum of all elements in an array

  constraint SIZE_CONSTRAINT_1D { A.size()  == 4 ; }

constraint S2_2d {       foreach(A[i])
                      {
                        A[i].size() == 4 ;	  
		      }
	         }

constraint sum_constraint_2d {   foreach(A[i,j])
                                  {
			             
                                    A.sum() with ( item.sum() with ( int'(item) ) ) == 20 ; 
		     
				  }
			     }

`endif

// Either M1 or S2 Would be Active at a time 

endclass


module test;

initial begin
A a1;
a1 = new();


  repeat(1)
begin

  a1.randomize();
 
  foreach(a1.A[i,j]) begin
    $write(" %0d ",a1.A[i][j]);
    if(j==$size(a1.A[i])-1)
      $display();
  end
  $display("oRRRR /n");
  foreach(a1.A[i])
    foreach(a1.A[i][j]) begin
      $write(" %0d ",a1.A[i][j]);
      if(j==$size(a1.A[i])-1)
      $display();
      end

end

end
endmodule
