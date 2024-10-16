// The streaming operator uses the terminology pack when you take multiple variables and stream them into a single variable. And conversely, unpack is when you stream a single variable into multiple variables. Those terms are loose descriptions for usage. Your examples are neither; they are more like bit stream casting. When applied to arrays and structs, the terms packed and unpacked have a specific meaning about their data type. All packed types may be used in a bit-stream, but not all unpacked types can be used.
// t does not matter which side the streaming operator appears because both sides are a single variables of the same size. There is one slight difference when the variables are not the same size 
// streaming operator are cyclic.
module x;
  bit [1:0] arr_1[0:1] = {2'b01, 2'b01};
  bit [3:0] arr_2;
  bit [3:0] arr_3;
  bit arr_4[0:3];
  bit arr_5[0:3];
  int array[4]='{10,20,40,30};
  
  initial begin
    {>>{arr_2}} = arr_1;
    {<<{arr_3}} = arr_1;
    {>>{arr_4}} = arr_1;
    arr_5 = {<<{arr_1}};
    array={<<32{array}};// to reverse an array without reverse method
    
    $display ("%p ", arr_2);
    $display ("%p ", arr_3);
    $display ("%p ", arr_4);
    $display ("%p ", arr_5);
    $display("array = %p",array);
  end
endmodule
