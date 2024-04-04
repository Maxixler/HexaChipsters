// Matrak M10 RV32I RISC-V Processor
// Gülpare II Architechture 2023
// Nexys A7 Wrapper Module

module wrapper (
   input             clk_100_i,
   input             rst_i,
   output [7:0]      gpio_o,
   output [7:0]      gpio_test,   // GPIO ��k�� pinleri
   input             uart_rx_i,  // UART RX ba�lant�s�
   output            uart_tx_o   // UART TX ba�lant�s�
);

   wire clk_50;

   clk_50mhz clk1 (
      .clk_out1(clk_50),
      .clk_in1(clk_100_i)
   );

   top t1 (
      .clk_i(clk_50),
      .rst_i(!rst_i),
      .gpio_o(gpio_o),
      .gpio_test(gpio_test),
      .uart_tx_o(uart_tx_o),
      .uart_rx_i(uart_rx_i)
   );

endmodule
