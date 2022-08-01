///////////////////////////////////////////////////////////////////////////////
// Description:      Testbench for SPI module
//Sends out 8 bit at a time
///////////////////////////////////////////////////////////////////////////////
module SPI_Master_TB ();
  
  parameter SPI_MODE = 3; // CPOL = 1, CPHA = 1
  parameter CLKS_PER_HALF_BIT = 4;  // 6.25 MHz
  parameter MAIN_CLK_DELAY = 2;  // 25 MHz

  logic r_Rst_L     = 1'b0;  
  logic w_SPI_Clk;
  logic r_Clk       = 1'b0;
  logic w_SPI_MOSI;

  // Master Specific
  logic [7:0] r_Master_TX_Byte = 0;  //Data byte for ADC
  logic [15:0] r_Master_INSTR = 0; //Instruction for ADC
  logic r_Master_TX_DV = 1'b0;
  logic w_Master_TX_Ready;
  logic r_Master_RX_DV;
  logic [7:0] r_Master_RX_Byte;
  
  logic instruct_done = 0;

  // Clock Generators:
  always #(MAIN_CLK_DELAY) r_Clk = ~r_Clk;

  // Instantiate UUT
  SPI_Master 
  #(.SPI_MODE(SPI_MODE),
    .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)) SPI_Master_UUT
  (
   // Control/Data Signals,
   .i_Rst_L(r_Rst_L),     // FPGA Reset
   .i_Clk(r_Clk),         // FPGA Clock
   
   // TX (MOSI) Signals
   .i_TX_Byte(r_Master_TX_Byte),     // Byte to transmit on MOSI
   .i_TX_DV(r_Master_TX_DV),         // Data Valid Pulse with i_TX_Byte
   .o_TX_Ready(w_Master_TX_Ready),   // Transmit Ready for Byte
   
   // RX (MISO) Signals
   .o_RX_DV(r_Master_RX_DV),       // Data Valid pulse (1 clock cycle)
   .o_RX_Byte(r_Master_RX_Byte),   // Byte received on MISO

   // SPI Interface
   .o_SPI_Clk(w_SPI_Clk),
   .i_SPI_MISO(w_SPI_MOSI), //loop back to test
   .o_SPI_MOSI(w_SPI_MOSI)
   );


  // Sends a instruction and a single byte from master.  Do instruction first, then data
  task SendSingleByte(input [7:0] data);
    @(posedge r_Clk);
    r_Master_TX_Byte <= data; //send first 8
    r_Master_TX_DV   <= 1'b1;  
    
    @(posedge r_Clk);
    r_Master_TX_DV <= 1'b0;
    @(posedge w_Master_TX_Ready);  //when TX buffer is empty
    
  endtask // SendSingleByte

task SendMultipleByte(input integer numb_byte);

endtask;
  
  initial
    begin
      
      repeat(2) @(posedge r_Clk);
      r_Rst_L  = 1'b0;
      repeat(2) @(posedge r_Clk);
      r_Rst_L          = 1'b1;   //Reset for initial start
      
      // Test single
      SendSingleByte(16'hC1C3);
      $display("Sent, Received 0x%X", r_Master_RX_Byte); 
      SendSingleByte(8'hAA);
      $display("Sent, Received 0x%X", r_Master_RX_Byte); 
   
   
      repeat(10) @(posedge r_Clk);
      $finish();      
    end // initial begin

endmodule // SPI_Slave
