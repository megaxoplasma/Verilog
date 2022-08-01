`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ying Zhu
//ADC TB
// 
//////////////////////////////////////////////////////////////////////////////////
module ADC_TB();

reg [7:0] adc_data_in_p = 0;
logic adc_clk_in_p = 0;
logic RESET;
reg [15:0] data_reg_check;
reg [15:0] data_store_reg;
logic spi_clk;
logic spi_mosi;
logic spi_miso;
logic spi_send_trigger;
logic AD9467_spi_trigger;
logic TX_DV_check;
logic [1:0] spi_csn;

  // Instantiate UUT
  AD9467_IF AD9467_IF_UUT (
  .adc_clk_in_p(adc_clk_in_p),
  .RESET(RESET),
  .adc_data_in_p(adc_data_in_p),
  .data_reg_check(data_reg_check),
//  .data_store_reg(data_store_reg),  //uncomment to test output
  .spi_clk(spi_clk),
  .spi_mosi(spi_mosi),
  .spi_miso(spi_miso),
  .spi_send_trigger(spi_send_trigger),
  .AD9467_spi_trigger(AD9467_spi_trigger),
  .TX_DV_check(TX_DV_check),
  .spi_csn(spi_csn)
  
   );
   
   always begin
   #2 adc_clk_in_p = ~adc_clk_in_p;
   end
   
initial begin
RESET = 0; //reset the device
#10;
RESET = 1; //enable device

//1 bit test
//#100;
//#5 adc_data_in_p[7] = 1; 
//#10 adc_data_in_p[7] = 0;

//8 bit test
#100;
#15 adc_data_in_p = 8'b10101010; //cccc when doubled
#100;
#20 adc_data_in_p = 8'b01010101; // 3333 when doubled
#50;
//spi_send_trigger = 1; //trigger spi send
AD9467_spi_trigger = 1;
#20
//spi_send_trigger = 0; //end send
#20
//spi_send_trigger = 1; //stream send
#50;
$finish;
end


endmodule