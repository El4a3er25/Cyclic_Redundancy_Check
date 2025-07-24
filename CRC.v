`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/03/2024 11:24:10 PM
// Design Name: 
// Module Name: CRC
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


module CRC(
          input data, 
          input active,
          input reset , clk,
          output reg CRC , valid
    );
    
    integer i;
    reg [3:0] j;
    reg [3:0] n;
    parameter TAPS = 7'b100_0100;
    reg [7:0] LFSR;
    wire feedback;
   // wire enable;
  //  reg [2:0] counter;
    
    assign feedback = LFSR[0] ^ data;
    
   always @(posedge clk , negedge reset)
   begin
     //    LFSR <= 8'hD8;
     // valid <= 1'b0;
     //  CRC <= 1'b0;
            if (!reset)
           begin
              LFSR <= 8'hD8;
              valid <= 1'b0;
              CRC <= 1'b0;
              n <= 1'b0;
              j <= 1'b0;
         
           end
         else if (active)
           begin
           
           j <= j+1;
           
           LFSR[0] <= LFSR[1];     // is equivalent to LFSR <= {Feedback, LFSR[7] ^ Feedback , LFSR[6:4], LFSR[3] ^ Feedback, LFSR[2:1]} ;
           LFSR[1] <= LFSR[2];
           LFSR[2] <= LFSR[3] ^ feedback; 
           LFSR[3] <= LFSR[4];
           LFSR[4] <= LFSR[5];
           LFSR[5] <= LFSR[6];
           LFSR[6] <= LFSR[7] ^ feedback;
           LFSR[7] <= feedback;
           valid <= 1'b0;
          /*LFSR[7] <= feedback;    
              for (i=6 ; i>=0 ; i=i-1)
                begin
                 if (TAPS[i] == 1)
                   LFSR[i] <= LFSR[i+1] ^ feedback ; 
                  else
                    LFSR[i] <= LFSR[i+1];
               end */
               
          end 
         else if (active ==0 && n<8 && j==8)
         begin
           valid <= 1;
       //    {LFSR[6:0],CRC} <= LFSR;
             {LFSR,CRC} <= {1'b0,LFSR};
           n <= n+1;
            if (n==7)
            begin
               n <= 1'b0;
               j <= 1'b0;
               valid <= 1'b0;
            end  
         end
        /* else 
         begin
           valid <= 0;
           LFSR <= LFSR;
            CRC <= 1'b0;
         end  */
   end
   
  /*always @(posedge clk , negedge reset)
   begin
       // counter <= 0;
          if (!reset)        
             counter <= 0;
           
           else if (counter < 8 && !active)
             counter <= counter + 1;
    end 
    
      always @(posedge clk)
     begin    
              if (active) 
                   counter <= 0;   
             else if (counter < 8 && !active)
               counter <= counter + 1;
              else
                counter <= 0;
      end 
     
    assign enable = (counter == 7)   ;  */
endmodule
