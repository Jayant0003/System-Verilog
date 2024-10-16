class basics;

  rand bit[3:0] matrix[4][4];
  
  constraint c1{foreach(matrix[i,j]) { 
    foreach(matrix[k,l]) {
      if(k<i)
        matrix[i][j]!=matrix[k][l];
      if(j<l)
        matrix[i][j]!=matrix[k][l];
    }}}
//     if(i>0)
//    matrix[i][j]!=matrix[i-1][j];  }
//                					}
//   constraint c1{foreach(matrix[i,j])
//     foreach(matrix[k,l])
//       matrix[i][j]!=matrix[k][l];  }
    
//     module test;
//   int a[4][4];
//   initial
//     begin
//       a='{'{10,20,30,40},
//           '{5,6,1,7},
//           '{89,78,36,45},
//           '{110,120,130,140}};
//       foreach(a[i,j])
//         begin
//            $display("outer loop: i=%0d,j=%0d and value=%0d",i,j,a[i][j]);
//           foreach(a[ii,jj]) //the inner foreach loop within the outer loop starts iterating over the entire 2-D array a again for each element accessed by outer loop
//             begin
//               $display("inner loop: ii=%0d jj=%0d and value=%0d",ii,jj,a[ii][jj]);
//             end
//         end
//     end
// endmodule
  
endclass

module test;
  basics basic;
  initial begin
    basic=new;
    
    repeat(3)
      begin
      basic.randomize();
    $display("%p",basic.matrix);
      end
    
    
  end
  
 endmodule
