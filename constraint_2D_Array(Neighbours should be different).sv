class packet;
  rand bit [3:0] array[4][5];
  
  constraint unique_elements {foreach (array[i,j]) 
    if(i<($size(array,1)-1)) //$size(arr,2) is the size of array’s second dimension
      array[i][j] != array[i+1][j]; //|| array[i+1][j+1];
  }
//   constraint unique_element {foreach (array[i,j]) {
//       if(j<($size(array,1)-1))
//         array[i][j] != array[i][j+1] ;    }}
    constraint unique_elemen {foreach (array[i,j]) {
      if(i>0 && (j<$size(array,1)-1))
       array[i][j] != array[i-1][j+1];  }}
//   constraint unique_eleme {foreach (array[i,j]) 
//     if((i<$size(array,1)-1) && (j<$size(array,1)-1))
//     array[i][j] != array[i+1][j+1]; }              
  function void print();  
    for (int i = 0; i < $size(array,1); i++) begin
      $display("\n");
      for (int j = 0; j < $size(array,2); j++) begin
        $write(array[i][j],"\t"); 
      end 
    end
  endfunction 
endclass



module test;
  packet p;
  
  initial begin
    p=new();
      p.randomize;
      p.print();
  end
endmodule
