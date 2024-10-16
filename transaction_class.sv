`define D_BUS2IP_DATA_WIDTH 32
`define D_BUS2IP_ADDR_WIDTH 32
`define D_CLK_DIV_WIDTH     12
`define D_TAR_ID_WIDTH 8
`define D_CCC_WIDTH 8
`define D_TA_WIDTH 7
`define D_DEF_BYTE_WIDTH 8
`define D_DATA_LEN_WIDTH 8
`define D_DATA_BYTE_WIDTH 8
`define D_PAYLD_SIZE_WIDTH 12
`define D_BUS2IP_TARG_ADDR_08_11_RANGE 8'h08:8'h11
`define D_BUS2IP_DATA_BYTE_01_FE_RANGE 8'h01:8'hfe
`define D_BUS2IP_DIRECT_CCC_WR_RANGE 8'h80:8'h8a
`define D_BUS2IP_DIRECT_CCC_RD_RANGE 8'h8b:8'h8f
`define D_BUS2IP_BROAD_CCC_WR_RANGE 8'h00:8'h0a
`define D_BUS2IP_DATA_LEN_0_7_RANGE 8'h00:8'h07
`define D_BUS2IP_WDTH_1_0      1:0 
`define D_BUS2IP_WDTH_7_0      7:0 
`define D_BUS2IP_WDTH_7_4      7:4 
`define D_BUS2IP_WDTH_15_0     15:0 
`define D_BUS2IP_WDTH_15_8     15:8 
`define D_BUS2IP_WDTH_23_16    23:16 
`define D_BUS2IP_WDTH_31_24    31:24 
`define D_BUS2IP_WDTH_2        2 
`define D_BUS2IP_WDTH_3        3 
`define D_PKT_WIDTH_2_0 2:0


parameter P_BUS2IP_ENABLE = 1'b1;
parameter P_BUS2IP_DISABLE = 1'b0;
parameter P_BUS2IP_NOT_USED_CCC = 8'hff;
parameter P_BUS2IP_DATA_LEN_4   = 8'h04;
parameter P_BUS2IP_CCC_1_0                       =  2'b1_0;             //CCC Enables
parameter P_BUS2IP_PVT_1_1                       =  2'b1_1;             //Private Enables
parameter P_BUS2IP_I2C_1_1                       =  2'b1_1;             //I2C Enables
parameter P_BUS2IP_ROC_0                         =  1'b0;               //ROC as Low         
parameter P_BUS2IP_ROC_1                         =  1'b1;               //ROC as High
parameter P_BUS2IP_TOC_0                         =  1'b0;               //TOC as Low
parameter P_BUS2IP_TOC_1                         =  1'b1;               //TOC as High
parameter P_BUS2IP_UNUSED_BYTE                   =  8'h00;              //Byte of Data is Empty

typedef enum bit [`D_PKT_WIDTH_2_0] {PVT_WR,PVT_RD,B_CCC_WR,B_CCC_RD,D_CCC_WR,D_CCC_RD,I2C_WR,I2C_RD} pkt; //enum declare for pvt_wr,pvt_rd,B_CCC,D_CCC

class mipi_i3c_bus2ip_item;
 
  //---------declaring BUS2IP transaction fields--data, acknowledgement, error and control signals-------------//
  rand pkt                             bus2ip_pkt_t;                         //Enums for Enable
  rand bit                             m_bus2ip_rstn;                        //BUS2IP Reset Active Low
  rand bit [`D_BUS2IP_DATA_WIDTH-1:0]  m_bus2ip_data;                        //BUS2IP Data Input; data to be written into a register, define BUS2IP_DATA_WIDTH 31:0
  rand bit [`D_BUS2IP_ADDR_WIDTH-1:0]  m_bus2ip_addr;                        //BUS2IP Address to access the Register Map of I3C IP, define BUS2IP_ADDR_WIDTH 31:0
  rand bit                             m_bus2ip_wrce;                        //BUS2IP Write Enable
  rand bit                             m_bus2ip_rdce;                        //BUS2IP Read Enable
  bit      [`D_BUS2IP_DATA_WIDTH-1:0]  m_ip2bus_data;                        //IP2BUS Data Output, define IP2BUS_DATA_WIDTH 31:0
  bit                                  m_ip2bus_rdack;                       //BUS2IP Read Acknowledgement, confirms successful read from a register
  bit                                  m_ip2bus_wrack;                       //BUS2IP Write Acknowledgement, confirms successful write into a register
  bit                                  m_ip2bus_error;                       //IP2BUS Error Output; informs the HLE about an invalid access to the Register Map
  bit                                  m_intr;                               //System Interrupt; generated to notify the occurrence of an event in the I3C IP
  rand bit [`D_CLK_DIV_WIDTH-1:0]      m_clk_div;                            //Clock Divide Vaue for dividing clock to controller
  rand bit [`D_TAR_ID_WIDTH-1:0]       m_tar_id;                             //Target ID
  rand bit [`D_CCC_WIDTH-1:0]          m_ccc;                                //Common Cammand Codes
  rand bit [`D_TA_WIDTH-1:0]           m_targ_addr;                          //Target Address
  rand bit [`D_DEF_BYTE_WIDTH-1:0]     m_defining_byte;                      //Defining Byte
  rand bit [`D_DATA_LEN_WIDTH-1:0]     m_data_len;                           //Data Length
  rand bit [`D_DATA_BYTE_WIDTH-1:0]    m_data_byte;                          //Data Byte 
  rand bit [`D_PAYLD_SIZE_WIDTH-1:0]   m_payload_size;                       //Payload Size 
  rand bit                             m_rnw;                                //RnW Bit for CCC
  rand bit                             m_error_f;                            //For Generating Error Scenarios


  //-------BUS2IP Active Low Reset-------------------------------------------------------------------------------------------//
  constraint active_low_resetn { soft m_bus2ip_rstn  ==  P_BUS2IP_ENABLE; }

  //-------Bus2ip Error Flag as low------------------------------------------------------------------------------------------//
  constraint error_flag_low    { soft m_error_f  ==  P_BUS2IP_DISABLE; }

  //-------hFF is not used in MIPI I3C Specs---------------------------------------------------------------------------------//
  constraint reserved_ccc { m_ccc  !=  P_BUS2IP_NOT_USED_CCC; }
  
  //-------Traget Address range 8 to 11--------------------------------------------------------------------------------------//
  constraint targ_addr    { soft m_targ_addr inside {[`D_BUS2IP_TARG_ADDR_08_11_RANGE]};}

  //-------Solve Before Constraints--------------------------------------------------------------------------------------------------//
  constraint solve_before_c                { 
                                             solve bus2ip_pkt_t    before m_ccc;
                                             solve m_data_len before m_data_byte;     
                                             solve m_rnw      before m_data_byte;
                                           }

  //-------Private Write Transfer Frame From Bus2ip to Controller FSM----------------------------------------------------------------------------------------//
  constraint private_write_xtns            {
                                             if(bus2ip_pkt_t  ==  PVT_WR)
                                               {
                                                 m_rnw          ==  P_BUS2IP_DISABLE;                         //rnw bit as HIGH
                                                 m_data_len     ==  P_BUS2IP_DATA_LEN_4;                      //No of Data to be written
                                                 m_data_byte    inside {[`D_BUS2IP_DATA_BYTE_01_FE_RANGE]};   //Data Byte in range of 8'h01 to 8'hFE
                                                 m_bus2ip_wrce  ==  P_BUS2IP_ENABLE;                          //Write Chip Enable as High
                                               }
                                           }

  //-------Private Read Transfer Frame From Bus2ip to Controller FSM----------------------------------------------------------------------------------------//
  constraint private_read_xtns             {
                                             if(bus2ip_pkt_t  ==  PVT_RD)
                                               {
                                                 m_rnw          ==  P_BUS2IP_ENABLE;              //rnw bit as HIGH
                                                 m_bus2ip_wrce  ==  P_BUS2IP_ENABLE;              //Write Chip Enable as High
                                                 m_bus2ip_rdce  ==  P_BUS2IP_DISABLE;             //Read Chip Enable as Low
                                               }
                                           }

  //-------Direct Comman comand Code for Writing from Bus2ip to Controller FSM------------------------------------------------------------------------------//
  constraint d_ccc_wr_xtns                 { 
                                             if(bus2ip_pkt_t  ==  D_CCC_WR)
                                               {
                                                 m_ccc          inside {[`D_BUS2IP_DIRECT_CCC_WR_RANGE]};    //[80-8A]
                                                 m_rnw          ==  P_BUS2IP_DISABLE;                        //rnw bit as LOW
                                                 m_bus2ip_wrce  ==  P_BUS2IP_ENABLE;                         //Write Chip Enable as High
                                                 m_bus2ip_rdce  ==  P_BUS2IP_DISABLE;                        //Read Chip Enable as Low
                                   
                                                 if(m_ccc  ==   8'h80|| m_ccc  ==  8'h81)
                                                   {
                                                     m_data_len  ==  8'h01;
                                                   }
                                                 
                                                   if(m_ccc  ==   8'h82|| m_ccc  ==   8'h83|| m_ccc  ==   8'h84|| m_ccc  ==  8'h85|| m_ccc  ==   8'h86|| m_ccc  ==  8'h88)
                                                   {
                                                     m_data_len  ==  8'h00;
                                                   }
                                                 
                                                     if(m_ccc  ==  8'h89)
                                                   {
                                                     m_data_len  ==  8'h02;
                                                   }
                                               
                                                       if(m_ccc  == 8'h8a)
                                                   {
                                                     m_data_len  ==  8'h03;
                                                   }
                                               }
                                           }

  //-------Direct Comman comand Code for Readinf from Bus2ip to Controller FSM------------------------------------------------------------------------------//
  constraint d_ccc_rd_xtns                 { 
                                             if(bus2ip_pkt_t  ==  D_CCC_RD)
                                               {
                                                 m_ccc          inside {[`D_BUS2IP_DIRECT_CCC_RD_RANGE]};    //[80-8A]
                                                 m_rnw          ==  P_BUS2IP_ENABLE;                         //rnw bit as HIGH
                                                 m_bus2ip_wrce  ==  P_BUS2IP_ENABLE;                         //Write Chip Enable as High
                                                 m_bus2ip_rdce  ==  P_BUS2IP_DISABLE;                        //Read Chip Enable as Low
                                               }
                                           }

  //-------Broadcast Comman comand Code for Writing from Bus2ip to Controller FSM------------------------------------------------------------------------------//
  constraint b_ccc_wr_xtns                 { 
                                             if(bus2ip_pkt_t  ==  B_CCC_WR)
                                               {      
                                                 m_ccc          inside {[`D_BUS2IP_BROAD_CCC_WR_RANGE]};  //[00-0A]
                                                 m_rnw          ==  P_BUS2IP_DISABLE;                     //rnw bit as LOW
                                                 m_bus2ip_wrce  ==  P_BUS2IP_ENABLE;                      //Write Chip Enable as High
                                                 m_bus2ip_rdce  ==  P_BUS2IP_DISABLE;                     //Read Chip Enable as Low
                                                
                                                 if(m_ccc  ==   8'h00 || m_ccc  ==  8'h01)
                                                    {
                                                      m_data_len  == 8'h01;
                                                    }
 
                                                   if(m_ccc  ==   8'h02|| m_ccc  ==  8'h03|| m_ccc  ==  8'h04|| m_ccc  ==   8'h05|| m_ccc  ==  8'h06)
                                                    {
                                                      m_data_len  ==  8'h00;
                                                    }

                                                     if(m_ccc  ==  8'h09)
                                                    {
                                                      m_data_len  ==  8'h02;
                                                    }

                                                       if(m_ccc  ==  8'h0a)
                                                    {
                                                      m_data_len  ==  8'h03;
                                                    }
                                               } 
                                           }

  //-------I2C Write from Bus2ip to Controller FSM------------------------------------------------------------------------------//
  constraint i2c_wr_xtns                   { 
                                             if(bus2ip_pkt_t  ==  I2C_WR)
                                               {
                                                 m_rnw          ==  P_BUS2IP_DISABLE;                          //rnw bit as LOW
                                                 m_bus2ip_wrce  ==  P_BUS2IP_ENABLE;                           //Write Chip Enable as High
                                                 m_bus2ip_rdce  ==  P_BUS2IP_DISABLE;                          //Read Chip Enable as Low
                                                 m_data_len     inside {[`D_BUS2IP_DATA_LEN_0_7_RANGE]};             //Data Lenght is in range of 0:7
                                               }
                                           }

  //-------I2C Read from Bus2ip to Controller FSM------------------------------------------------------------------------------//
  constraint i2c_rd_xtns                   { 
                                             if(bus2ip_pkt_t  ==  I2C_RD)
                                               {
                                                 m_rnw          ==  P_BUS2IP_ENABLE;                           //rnw bit as HIGH
                                                 m_bus2ip_wrce  ==  P_BUS2IP_ENABLE;                           //Write Chip Enable as High
                                                 m_bus2ip_rdce  ==  P_BUS2IP_DISABLE;                          //Read Chip Enable as Low
                                                 m_data_len     inside {[`D_BUS2IP_DATA_LEN_0_7_RANGE]};       //Data Lenght is in range of 0:7
                                               }
                                           }

endclass:mipi_i3c_bus2ip_item
                                               module tb;
                                                 mipi_i3c_bus2ip_item h=new();
                                                 bit [7:0] m_local_data_len;
                                                 
                                                 initial begin
                                                   
                                                   
                                                   if(!(h.randomize() with { bus2ip_pkt_t                 ==  B_CCC_WR;                       //Broadcast CCC Enable
                             m_bus2ip_data[`D_BUS2IP_WDTH_1_0]    ==  P_BUS2IP_CCC_1_0;               //CCC
                             m_bus2ip_data[`D_BUS2IP_WDTH_2]      ==  P_BUS2IP_ROC_1;                 //ROC
                             m_bus2ip_data[`D_BUS2IP_WDTH_3]      ==  m_rnw;                          //RnW 
                             m_bus2ip_data[`D_BUS2IP_WDTH_7_4]    ==  m_tar_id;                       //TID
                             m_bus2ip_data[`D_BUS2IP_WDTH_15_8]   ==  m_ccc;                          //I3C CCC Directed
                             m_bus2ip_data[`D_BUS2IP_WDTH_23_16]  ==  m_defining_byte;                //no_of_defining bytes
                             m_bus2ip_data[`D_BUS2IP_WDTH_31_24]  ==  {P_BUS2IP_TOC_0,m_targ_addr};   //TOC + Target Address
                           }
                                                       ) )  begin
                                                     $display("FAILED RANDOMIZATION ...");
                                                   $display(" DATA_LEN =%0d  ...",h.m_data_len);
      m_local_data_len = h.m_data_len;
   
                                                   end
  
    //If No of Data lenght is 0
    if(m_local_data_len == 0)
      begin
       
        if(!(h.randomize() with { bus2ip_pkt_t                   ==  B_CCC_WR;                       //Broadcast CCC Enable
                                 m_bus2ip_data[`D_BUS2IP_WDTH_7_0]    ==  m_local_data_len;               //No of Data Length of Target_1
                                 m_bus2ip_data[`D_BUS2IP_WDTH_15_8]   ==  P_BUS2IP_UNUSED_BYTE;           //Byte is Empty
                                 m_bus2ip_data[`D_BUS2IP_WDTH_23_16]  ==  P_BUS2IP_UNUSED_BYTE;           //Byte is Empty
                                 m_bus2ip_data[`D_BUS2IP_WDTH_31_24]  ==  P_BUS2IP_UNUSED_BYTE;           //Byte is Empty                         
                                }
            ) );
          // $display("FAILED RANDOMIZATION ...");

      end

    //If No of Data lenght is 1
    else if(m_local_data_len == 1)
      begin
      
        if(!(h.randomize() with { bus2ip_pkt_t                   ==  B_CCC_WR;                       //Broadcast CCC Enable
                                 m_bus2ip_data[`D_BUS2IP_WDTH_7_0]    ==  m_local_data_len;               //No of Data Length of Target_1
                                 m_bus2ip_data[`D_BUS2IP_WDTH_15_8]   ==  m_data_byte;                    //Data Byte
                                 m_bus2ip_data[`D_BUS2IP_WDTH_23_16]  ==  P_BUS2IP_UNUSED_BYTE;           //Byte is Empty
                                 m_bus2ip_data[`D_BUS2IP_WDTH_31_24]  ==  P_BUS2IP_UNUSED_BYTE;           //Byte is Empty
                               } 
              ) )
          $display("FAILED RANDOMIZATION ...");
        
      end
    //If No of Data lenght is 2
    else if(m_local_data_len == 2)
      begin
       
        if(!(h.randomize() with { bus2ip_pkt_t                 ==  B_CCC_WR;                         //Broadcast CCC Enable
                               m_bus2ip_data[`D_BUS2IP_WDTH_7_0]    ==  m_local_data_len;                 //No of Data Length of Target_1
                               m_bus2ip_data[`D_BUS2IP_WDTH_15_8]   ==  m_data_byte;                      //Data Byte
                               m_bus2ip_data[`D_BUS2IP_WDTH_23_16]  ==  m_data_byte;                      //Data Byte
                               m_bus2ip_data[`D_BUS2IP_WDTH_31_24]  ==  P_BUS2IP_UNUSED_BYTE;             //Byte is Empty
                               } 
              ) )
            $display("FAILED RANDOMIZATION ...");
     
      end
    //If No of Data lenght is 3
    else if(m_local_data_len == 3 )
      begin
       
        if(!(h.randomize() with { bus2ip_pkt_t                    ==  B_CCC_WR;                      //Broadcast CCC Enable
                                  m_bus2ip_data[`D_BUS2IP_WDTH_7_0]    ==  m_local_data_len;              //No of Data Length of Target_1
                                  m_bus2ip_data[`D_BUS2IP_WDTH_15_8]   ==  m_data_byte;                   //Data Byte
                                  m_bus2ip_data[`D_BUS2IP_WDTH_23_16]  ==  m_data_byte;                   //Data Byte
                                  m_bus2ip_data[`D_BUS2IP_WDTH_31_24]  ==  m_data_byte;                   //Data Byte
                             } 
            ) )
          $display("FAILED RANDOMIZATION ...");
  
      end
                                                 end
                                               endmodule
  
