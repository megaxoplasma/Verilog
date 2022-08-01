
set_property -dict { PACKAGE_PIN AB7 IOSTANDARD LVCMOS15 DIRECTION IN} [get_ports { RESET }];

set_property -dict { PACKAGE_PIN AD11 IOSTANDARD DIFF_SSTL15 DIRECTION IN} [get_ports { CLK_N }];
set_property -dict { PACKAGE_PIN AD12 IOSTANDARD DIFF_SSTL15 DIRECTION IN} [get_ports { CLK_P }];

set_property -dict { PACKAGE_PIN M19 IOSTANDARD LVCMOS25 DIRECTION IN} [get_ports { RS232_Uart_1_sin }];
set_property -dict { PACKAGE_PIN K24 IOSTANDARD LVCMOS25 DIRECTION OUT} [get_ports { RS232_Uart_1_sout }];

#set_property -dict { PACKAGE_PIN AB8 IOSTANDARD LVCMOS15 DIRECTION OUT} [get_ports { up_status[0] }];
#set_property -dict { PACKAGE_PIN AA8 IOSTANDARD LVCMOS15 DIRECTION OUT} [get_ports { up_status[1] }];
#set_property -dict { PACKAGE_PIN AC9 IOSTANDARD LVCMOS15 DIRECTION OUT} [get_ports { up_status[2] }];
#set_property -dict { PACKAGE_PIN AB9 IOSTANDARD LVCMOS15 DIRECTION OUT} [get_ports { up_status[3] }];
#set_property -dict { PACKAGE_PIN AE26 IOSTANDARD LVCMOS25 DIRECTION OUT} [get_ports { up_status[4] }];
#set_property -dict { PACKAGE_PIN G19 IOSTANDARD LVCMOS25 DIRECTION OUT} [get_ports { up_status[5] }];
#set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS25 DIRECTION OUT} [get_ports { up_status[6] }];
#set_property -dict { PACKAGE_PIN F16 IOSTANDARD LVCMOS25 DIRECTION OUT} [get_ports { up_status[7] }];

set_property -dict {  PACKAGE_PIN F20  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_clk_in_p     }];
set_property -dict {  PACKAGE_PIN E20  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_clk_in_n     }];
set_property -dict {  PACKAGE_PIN E29  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_or_p    }];
set_property -dict {  PACKAGE_PIN E30  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_or_n    }];
set_property -dict {  PACKAGE_PIN H21  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[0] }];
set_property -dict {  PACKAGE_PIN H22  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[0] }];
set_property -dict {  PACKAGE_PIN G22  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[1] }];
set_property -dict {  PACKAGE_PIN F22  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[1] }];
set_property -dict {  PACKAGE_PIN C17  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[2] }];
set_property -dict {  PACKAGE_PIN B17  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[2] }];
set_property -dict {  PACKAGE_PIN G17  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[3] }];
set_property -dict {  PACKAGE_PIN F17  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[3] }];
set_property -dict {  PACKAGE_PIN C20  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[4] }];
set_property -dict {  PACKAGE_PIN B20  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[4] }];
set_property -dict {  PACKAGE_PIN E19  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[5] }];
set_property -dict {  PACKAGE_PIN D19  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[5] }];
set_property -dict {  PACKAGE_PIN B27  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[6] }];
set_property -dict {  PACKAGE_PIN A27  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[6] }];
set_property -dict {  PACKAGE_PIN C29  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_p[7] }];
set_property -dict {  PACKAGE_PIN B29  DIFF_TERM TRUE    IOSTANDARD LVDS_25 DIRECTION IN} [ get_ports { adc_data_in_n[7] }];

set_property -dict { PACKAGE_PIN F13  IOSTANDARD LVCMOS25 DIRECTION OUT} [ get_ports { spi_csn[0] }];
set_property -dict { PACKAGE_PIN K14  IOSTANDARD LVCMOS25 DIRECTION OUT} [ get_ports { spi_csn[1] }];
set_property -dict { PACKAGE_PIN L12  IOSTANDARD LVCMOS25 DIRECTION OUT} [ get_ports { spi_clk    }];
set_property -dict { PACKAGE_PIN L13  IOSTANDARD LVCMOS25 DIRECTION OUT} [ get_ports { spi_mosi   }];
set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS25 DIRECTION IN} [ get_ports { spi_miso   }];


#####################################################################################################################
make_diff_pair_ports CLK_P CLK_N
make_diff_pair_ports adc_clk_in_p adc_clk_in_n
make_diff_pair_ports adc_data_in_p[0] adc_data_in_n[0]
make_diff_pair_ports adc_data_in_p[1] adc_data_in_n[1]
make_diff_pair_ports adc_data_in_p[2] adc_data_in_n[2]
make_diff_pair_ports adc_data_in_p[3] adc_data_in_n[3]
make_diff_pair_ports adc_data_in_p[4] adc_data_in_n[4]
make_diff_pair_ports adc_data_in_p[5] adc_data_in_n[5]
make_diff_pair_ports adc_data_in_p[6] adc_data_in_n[6]
make_diff_pair_ports adc_data_in_p[7] adc_data_in_n[7]
make_diff_pair_ports adc_data_or_p adc_data_or_n