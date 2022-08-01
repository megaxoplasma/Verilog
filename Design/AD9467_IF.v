//////////////////////////////////////////////////////////////////////////////////
// Company: BLT
// Engineer: Ying Zhu
// 
// Design Name:  AD9467 interface
// Module Name: AD9467_IF

//Data will be read and stored to memory when DCO changes and is 1 to condition a stable signal
//CLK and DCO will never be algined due to native timeing delay so a artificial delay will not be created for this interface
//////////////////////////////////////////////////////////////////////////////////
module AD9467_IF(
input CLK_P, CLK_N,
input RESET,
input adc_clk_in_p, adc_clk_in_n, //DCO on ADC
input adc_data_or_p, adc_data_or_n,
input [7:0] adc_data_in_p,adc_data_in_n,  //Double data rate ADC data input

//spi ports
output [1:0] spi_csn,
output spi_clk,
output spi_mosi,
input spi_miso,

//RS232 ports
input RS232_Uart_1_sin,
output RS232_Uart_1_sout,


//test bench test parameters
//output reg [15:0] data_store_reg, //check storage timing
output [15:0] data_reg_check,      //check data timing and consistancy per bits
input spi_send_trigger,               //Triggers a send from SPI
input AD9467_spi_trigger,  //Trigger 16 bit instruction follow by 8bit data
output TX_DV_check
);

wire [15:0] data_reg = 3; //16 bit data reg
reg data_store_reg;

integer upper_lower;
reg adc_clock_counter;
reg internal_div_clock;

//Block RAM wire and regs
reg [12:0]BRAM_PORTA_0_addr = 0;     //Address, base of 0
reg BRAM_PORTA_0_clk = 0;         // input clock
//reg [7:0]BRAM_PORTA_0_din;  //Data in
wire [7:0]BRAM_PORTA_0_dout;  //Data out
reg BRAM_PORTA_0_en = 1;   //RAM enable 
reg BRAM_PORTA_0_we = 0; //write enable



//spi parameters and regs
  integer SPI_MODE = 0; // CPOL = 1, CPHA = 1
  localparam CLKS_PER_HALF_BIT = 4;  
  wire w_SPI_Clk;
  wire w_SPI_MOSI;

  // Master Specific, with default test values
  reg [7:0] r_Master_TX_Byte = 8'b10010011;  //Data byte for ADC
  reg r_Master_TX_DV = 1'b0;
  wire w_Master_TX_Ready;
  wire r_Master_RX_DV;
  wire [7:0] r_Master_RX_Byte;

//SPI TEST wire
  reg [7:0] spi_data = 8'b00011000;
  reg [15:0] spi_instruction = 16'hF10F;
  integer spi_counter = 8; //Counter value is NUMBER_OF_BYTE * 2
  wire w_spi_send_trigger;
  integer instruct_check = 4;
  reg spi_CS0 = 1;
  reg spi_CS1 = 1;


////////////////////IDDR instances for each bit
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR7 ( //for bit 15 and 14
      .Q1(data_reg_check[15]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[14]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[7]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );
   ////////////////////////////////   IDDR 6    ////////////////////////////
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR6 (
      .Q1(data_reg_check[13]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[12]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[6]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );

///////////////////////////////////   IDDR5  //////////////////////////////////
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR5 (
      .Q1(data_reg_check[11]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[10]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[5]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );

///////////////////////////////////  IDDR4   /////////////////////////////////////
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR4 (
      .Q1(data_reg_check[9]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[8]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[4]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );

/////////////////////////////  IDDR3  ///////////////////////////////////////////
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR3 (
      .Q1(data_reg_check[7]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[6]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[3]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );

//////////////////////////   IDDR2    /////////////////////////////
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR2 (
      .Q1(data_reg_check[5]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[4]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[2]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );

///////////////////////////////    IDDR1   //////////////////////////////////
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR1 (
      .Q1(data_reg_check[3]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[2]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[1]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );

////////////////////////////     IDDR0    /////////////////////////////////////////
  IDDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"), // "OPPOSITE_EDGE", "SAME_EDGE" 
                                      //    or "SAME_EDGE_PIPELINED" 
      .INIT_Q1(1'b0), // Initial value of Q1: 1'b0 or 1'b1
      .INIT_Q2(1'b0), // Initial value of Q2: 1'b0 or 1'b1
      .SRTYPE("SYNC") // Set/Reset type: "SYNC" or "ASYNC" 
   ) 
Input_DDR0 (
      .Q1(data_reg_check[1]), // 1-bit output for positive edge of clock
      .Q2(data_reg_check[0]), // 1-bit output for negative edge of clock
      .C(adc_clk_in_p),   // 1-bit clock input
      .CE(1), // 1-bit clock enable input
      //.D(adc_data_in_p),   // 1-bit DDR data input
      .D(adc_data_in_p[0]),
      .R(0),   // 1-bit reset
      .S(0)    // 1-bit set
   );
//Now data_reg has the 16 bits in DDR time frames. 

always @(negedge adc_clk_in_p) begin
        #5;// simulation delay
        data_store_reg = data_reg_check;  //reg for storing
end//end always

//TODO : Can now use a delay primitve IDELAYCTRL -> IDELAY -> BRAM(or some memory)

////////////////////////////////////////  SPI module usage portion   //////////////////////////////////////
 SPI_Master #( 
  .SPI_MODE(3),
  .CLKS_PER_HALF_BIT(CLKS_PER_HALF_BIT)
  )
  SPI_Master_Inst(
   // Control/Data Signals,
   .i_Rst_L(RESET),     // FPGA Reset
   .i_Clk(adc_clk_in_p),         // FPGA Clock
   
   // TX (MOSI) Signals
   .i_TX_Byte(r_Master_TX_Byte),     // Byte to transmit on MOSI
   .i_TX_DV(r_Master_TX_DV),         // Data Valid Pulse with i_TX_Byte
   .o_TX_Ready(w_Master_TX_Ready),   // Transmit Ready for Byte
   
   // RX (MISO) Signals
   .o_RX_DV(r_Master_RX_DV),       // Data Valid pulse (1 clock cycle)
   .o_RX_Byte(r_Master_RX_Byte),   // Byte received on MISO

   // SPI Interface
   .o_SPI_Clk(w_SPI_Clk),
   .i_SPI_MISO(w_SPI_MISO),
   .o_SPI_MOSI(w_SPI_MOSI)
   );
   
   
//SPI output assign   
assign spi_clk = w_SPI_Clk;//w_SPI_Clk;
//Following given XDC for this, even though MOSI and MISO don't exist for AD9467, it use SDIO.  Guess it can just be muxed later on
assign spi_mosi = w_SPI_MOSI;
assign spi_miso = w_SPI_MISO;
assign TX_DV_check = r_Master_TX_DV;
assign w_spi_send_trigger = spi_send_trigger;
assign spi_csn[0] = spi_CS0;
assign spi_csn[1] = spi_CS1;

////////////////////////  always process section  //////////////////
  
//Sends 8 byte to slave
  always @(posedge adc_clk_in_p) begin
    if (w_spi_send_trigger == 1 && w_Master_TX_Ready) begin  //when TX buffer is empty) begin
    r_Master_TX_DV   = ~r_Master_TX_DV;  //trigger the send, what ever is in the TX_Buffer now gets sent out

    end //end if
    else 
    r_Master_TX_DV = 0;
  end // end always
  
 // Send 16bit instruction then 8 bit data
  always @(posedge adc_clk_in_p) begin
  //If a send is internally triggered and the buffer is not empty and TX is ready, send
    if ( AD9467_spi_trigger == 1  && spi_counter != 0 && w_Master_TX_Ready) begin
        //send instruction
        spi_CS0 = 0; // drop CS
        case(instruct_check)
            3  :  r_Master_TX_Byte = spi_instruction[15 : 8 ];
            1  :  r_Master_TX_Byte = spi_instruction[7 : 0 ];
            0  :  r_Master_TX_Byte = spi_data;
            default : r_Master_TX_Byte = spi_data;
        endcase
        r_Master_TX_DV   = ~r_Master_TX_DV;  //trigger the send, what ever is in the TX_Buffer now gets sent out
 
        spi_counter = spi_counter - 1;
        if (instruct_check != 0)  //instruction is not done sending
            instruct_check = instruct_check - 1;
         end
    
    //if buffer is empty and TX is ready, then transmittion has ended, set CS
    else if ( spi_counter == 0 && w_Master_TX_Ready) begin
    spi_CS0 = 1; 
    end //end else if
    
    else begin
        r_Master_TX_DV = 0;
       
   end // end else
        

  end//end always
  
  //////////////////////////////////  Block RAM section  /////////////////////////
    BRAM BRAM_i
       (.BRAM_PORTA_0_addr(BRAM_PORTA_0_addr),
        .BRAM_PORTA_0_clk(BRAM_PORTA_0_clk),
        .BRAM_PORTA_0_din(data_store_reg),
        .BRAM_PORTA_0_dout(BRAM_PORTA_0_dout),
        .BRAM_PORTA_0_en(BRAM_PORTA_0_en),
        .BRAM_PORTA_0_we(BRAM_PORTA_0_we)
        );
        
   always @(data_store_reg) begin
   if (BRAM_PORTA_0_dout != data_store_reg) begin
   BRAM_PORTA_0_addr = BRAM_PORTA_0_addr + 1;
   BRAM_PORTA_0_we = 1;
   end //end if
   
   else begin
   BRAM_PORTA_0_we = 0;
   end //end else
   
   end //end always
   
   /////////////////////////////////  RS232 section ////////////////////////////////////
   wire w_RS232_Uart_1_sin;
   wire w_RS232_Uart_1_sout;
   wire w_CLK_P;
   wire [7:0] r_GPout; 
   wire [7:0] r_GPin; 
   
   serialGPIO RS232_inst
   (
     .clk(w_CLK_P),
     .RxD(w_RS232_Uart_1_sin),
     .TxD(w_RS232_Uart_1_sout),
     .GPout(r_GPout),
     .GPin(r_GPin)
   );
   
   assign RS232_Uart_1_sin = w_RS232_Uart_1_sin;
   assign RS232_Uart_1_sout = w_RS232_Uart_1_sout;   
   
   
        
endmodule
