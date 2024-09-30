//-------------------------------fork join_any to fork join------------------------------------------------------

module test;
  initial begin
    fork
      #2 $display("A");
      $display("B");
    join_any
    wait fork;
      $display("C");
  end
endmodule

//-----------------------------------fork join_any to fork join_none---------------------------------------------------------------------------------------

module test;
  initial begin
    fork
      //#0;
      $display("K");
      
      begin
        #2 $display("A");
      end
      begin
        #2 $display("B");
      end
    join_any
      
      $display("C");
  end
endmodule

//-------------------------fork join to fork join_none-----------------------------------------------------------------------------

module test;
  event e;
  initial begin
    fork
      begin
        ->e;
      	#2 $display("A");
      end
      begin
        ->e;
      	#1$display("B");
      end
      begin
        wait(e.triggered);
        $display("E");
      end
    join
  end
endmodule
// -----------------------fork join to fork join_any---------------------------------------------------------------------------

module test;
  event e;
  initial begin
    fork
      begin
      	#2 $display("A");
        ->e;
      end
      begin
        
      	#1 $display("B");
        ->e;
      end
      begin
        wait(e.triggered);
        $display("E");
      end
    join
  end
endmodule

//------------------------------------------fork join_none to fork join---------------------------------------------------------------------

module test;
  event e;
  initial begin
    fork
      begin
      	#2 $display("A");
      end
      begin
      	#1 $display("B");
      end
      begin
        $display("E");
      end
    join_none
    wait fork;
      $display("K");
  end
endmodule

//-------------------------------------------fork join_none to fork join_any-----------------------------------------------------------
module test;
  event e;
  initial begin
    fork
      begin
      	#2 $display("A");
        ->e;
      end
      begin
      	#1 $display("B");
        ->e;
      end
      begin
        #4 $display("E");
        ->e;
      end
    join_none
    wait(e.triggered);
    $display("K");
  end
endmodule

//---------------------------disable kills all active threads by all previous fork block----------------------------------------------------------------------------------

module disable_fork;
  initial begin
    $display("**********BEFORE_DISABLE_FORK**********");
    fork
      begin
        $display($time,"\tThread A");
        #15;
        $display($time,"\tThread B");
      end
      begin
        $display($time,"\tThread C");
        #30;
        $display($time,"\tThread D");
      end
    join_any    
    fork
      begin
        $display($time,"\tThread A1");
        #15;
        $display($time,"\tThread B1");
      end
      begin
        $display($time,"\tThread C1");
        #30;
        $display($time,"\tThread D1");
      end
    join_none    
    disable fork; 
    $display("**********AFTER_DISABLE_FORK**********");
  end
endmodule

//---------------------TO disable threads of a specific fork block-----------------------------------------------------------------

module disable_fork; 
  initial begin
    $display("**********BEFORE_DISABLE_FORK**********");
    fork:A
      begin
        $display($time,"\tThread A1 started");
        #15;
        $display($time,"\tThread A1 ended");
      end
      begin
        $display($time,"\tThread A2 started");
        #30;
        $display($time,"\tThread A2 ended");
      end
    join_any    
    fork:B
      begin
        $display($time,"\tThread B1 started");
        #15;
        $display($time,"\tThread B1 ended");
      end
      begin
        $display($time,"\tThread B2 stared");
        #30;
        $display($time,"\tThread B2 ended");
      end
    join_none    
    disable A; 
    $display("**********AFTER_DISABLE_FORK**********");
  end
endmodule
//---------------------------------------------------------------------------------------------------------------------------
class fork_join_task; 
  task fork_join_wait(int random_time);
    fork: fork_1
      begin
       #random_time;
       $display("process1 %t",$time);
      end
      begin
        #20;
        $error("Process 1 not completed at %t",$time);
       end
    join_any
    disable fork_1; //giving label name,kill all process for wenever you call and different time to call
  endtask
endclass
//---------------------------------------------------------------------------------------------------------------------------
module fork_join;
  fork_join_task c1,c2;
  initial begin
    c1=new();
    c2=new();
    fork
      c1.fork_join_wait(10);
      c2.fork_join_wait(30);
    join
 //   #200;
    $display($stime,"\t out side the fork");
 //   $finish;
  end

endmodule

/*
disable label; kills any process executing under that label name. At the point you execute the first disable fork_1;, there are 3 active processes to be disabled, and the second disable fork_1 executes with nothing to disable.

disable fork; only kills the children of the process executing the disable command. So if you change to adisable fork; only 1 process forked by the c2.fork_join_wait(10) gets killed. The other process forked by the c1.fork_join_wait(30) will get to the #20 $error message.
*/
//---------------------------------------------------------------------------------------------------------------------------
module test;
  
 initial begin 
  fork
    	fork
          #0 $display("A");
          $display("B");
        join_none   // here join_none is one single thread which gets executed immediately..hece join_any(D) will be 1st
    $display("C");
  join_any
  $display("D");
 end
endmodule
//---------------------------------------------------------------------------------------------------------------------------
module test;
initial	begin
for	(int	j=0;j<3;j++)	begin
	fork
      automatic int result;
			begin
				result=	j*j;// here j is not automatic but static..result will be 9 for all three threads..j is increment and all 3 threads are created first then all are executed...so all threds get value of j as 3
              // solution is to wait for fork or make j automatic...take an automatic variable and assign j to it
              $display("Thread=%0d	result=%0d",	j,	result);
			end
		join_none

end
end
 endmodule
//--------------------------------------------------------------------------------------------------
module test;
initial	begin
for	(int	j=0;j<3;j++)	begin
	fork
	  automatic	int	k=j;
      automatic int result;
			begin
				result=	k*k;
              $display("Thread=%0d	result=%0d",	j,	result);
			end
		join_none
	//wait fork;
	end
end
 endmodule
 //-----------------------------------------------------------------------------------------------------
