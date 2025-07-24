`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/04/2024 10:11:21 PM
// Design Name: 
// Module Name: CRC_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CRC_TB();

          reg  data_TB ;
          reg  active_TB;
          reg  reset_TB , clk_TB;
          wire CRC_TB , valid_TB;
          
   CRC DUT (
        .data(data_TB),
        .active(active_TB),
        .reset(reset_TB),
        .clk(clk_TB),
        .CRC(CRC_TB),
        .valid(valid_TB)
   );  
   
   integer  oper;
   //clock
   always  #50 clk_TB = ~clk_TB;
   
  //////////////////////memory//////////////////
  reg [7:0] DATA_CRC [9:0];
  reg [7:0] Expec_Outs [9:0];
       
   initial 
   begin
        $dumpfile ("CRC_DUMP.vcd");
        $dumpvars;
        
        $readmemh("DATA_h.mem",DATA_CRC);
        $readmemh("Expec_Out_h.mem",Expec_Outs);
        
       initialize ();
       for (oper=0 ; oper<10 ; oper=oper+1)
        begin
          do_oper(DATA_CRC[oper]);
          check_out(Expec_Outs[oper],oper); 
        
        end
        //@(negedge clk_TB) $stop;
   end 
   
   task initialize ;
   begin
       clk_TB = 0;
       reset_TB = 1;
       active_TB = 0;
       data_TB = 8'h11; 
       
       @(negedge clk_TB) reset_TB = 0;
       @(negedge clk_TB) reset_TB = 1;
   end
   endtask   
   //////////////operation/////////////
   task  do_oper ;
    input [7:0] data_in;
    integer N;
   begin
       $display ("the data is %b",data_in);  
      // for (N=7 ; N>0 ; N=N-1)
     // @(negedge clk_TB) data_TB = data_in >> N;
      //reset ();
   //  data_TB = IN;
      
   
        active_TB = 1;
     for (N=0 ; N<8 ; N=N+1)
       begin
       @(negedge clk_TB) data_TB= data_in[N] ;
       end 
      
    // #800;
     //repeat(8) @(negedge clk_TB)
    //@ (negedge clk_TB)
      active_TB = 0;
   end
   endtask
     //////////////////////////////check the output ////////////////////////
   task check_out;
     input [7:0] expec_out;
    
     input integer oper_num;
     
     reg [7:0] gener_out;
     integer i;
     
   begin
   active_TB = 0;
  
   @(posedge valid_TB)
      for (i=0 ; i<8 ; i=i+1)
       @(negedge clk_TB) gener_out[i] = CRC_TB;
      
      if (expec_out == gener_out )
       begin
          $display("test case %d is succeeded with gener_out = %h and expec_out =%h",oper_num,gener_out,expec_out);
       end
      else 
         $display("test case %d is failed with gener_out = %h and expec_out =%h",oper_num,gener_out,expec_out);
   end
   endtask
   
  /* task reset ;
     begin
       reset_TB = 0;
       @(negedge clk_TB)
       reset_TB = 1;
     //  @(negedge clk_TB)
    //   reset_TB = 1;
     end
    endtask*/
endmodule
