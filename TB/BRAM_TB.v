`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 08/09/2021 02:24:23 AM
// Module Name: BRAM_TB
// Project Name: Ying Zhu
//////////////////////////////////////////////////////////////////////////////////
module BRAM_TB();
  reg [12:0]BRAM_PORTA_0_addr;     //Address
  reg BRAM_PORTA_0_clk = 0;         // input clock
  reg [7:0]BRAM_PORTA_0_din;  //Data in
  wire [7:0]BRAM_PORTA_0_dout;  //Data out
  reg BRAM_PORTA_0_en = 0;   //RAM enable 
  reg BRAM_PORTA_0_we = 0; //write enable

  BRAM BRAM_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(BRAM_PORTA_0_din),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we)
        );
        
  always begin
  #2 BRAM_PORTA_0_clk = ~BRAM_PORTA_0_clk;
  end
        
  initial begin
  #100;
  BRAM_PORTA_0_addr = 13'b0000000000001;
  BRAM_PORTA_0_din = 8'h02;
  BRAM_PORTA_0_we = 1;
  #300;
  BRAM_PORTA_0_en = 1;
  #300;
  BRAM_PORTA_0_we = 0;
  BRAM_PORTA_0_addr = 13'b0000000000010;
  #200;
   BRAM_PORTA_0_addr = 13'b0000000000010;
  
  end 
             
        
endmodule
