`define num 10 // single line macro
`define sum(a,b) a+b
//multiline macro using backslash(if it is not present in a line then it is last line of macro
//there should not be any character or space after \
`define calc(var1,var2,var3)\
var3=var1+var2;\
$display("calc is=%0d",var3);

`define for_loop(element, start_val, end_val) \
     for (int ii=start_val; ii<end_val; ii++) begin \
	if ((ii != 0)) \
    	$display("0x%x ", element[ii]); \
     end
//`define my_feature

//to change variable name
`define name Jayant
`define master(x,y) x``y

typedef enum {black,grey,white,yellow} color_type;
color_type m_color_type;

`define multi_color_code(color)\
(color==black?10\
:color==grey?20\
:color==white?30\
:40)


  

    module TB;
      int data[5]='{1,2,3,4,5};
      int addr[5]='{6,7,8,9,10};
      int a;
      int result;
      
      int `master(v_,`name)=32;//can't be integer at place of v
      
     // string signal_``ARG;
      
      initial begin
       `for_loop(data, 0, 3)   //here 5 line of code converted into single line
       `for_loop(addr, 2, 5)  //here 5 line of code converted into single line
       
       a=`num+10;
       $display("a=%0d",a);
        `ifdef sum
        `ifdef my_feature
               a=`sum(5,6)
        $display("sum is %0d",a);
        		
        `else
        $display("no macro is defined for sum");
        `endif
        `endif
       
       `calc(4,7,result)
  
        $display(`master(v_,`name));
        
        $display("code of black color= %0d",`multi_color_code(black));
       
     end   
      
     
    endmodule
