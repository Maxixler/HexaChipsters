// Matrak M10 RV32I RISC-V Processor
// Gülpare II Architechture 2023
// Top Module

module top (
   input             clk_i,
   input             rst_i,
   output [7:0]      gpio_o,
   output [7:0]      gpio_test,   // GPIO ��k�� pinleri
   input             uart_rx_i,  // UART RX ba�lant�s�
   output            uart_tx_o   // UART TX ba�lant�s�
);

   // İşlemci bağlantıları
   wire stall;
   wire wen;
   wire ren;
   wire [3:0] stb;
   wire [31:0] inst_addr;
   wire [31:0] data_addr;
   wire [31:0] wdata;
   wire [31:0] rdata;

   matrak mt1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .stall_i(stall),
      .inst_i(mem_rdata),
      .data_i(rdata),
      .wen_o(wen),
      .ren_o(ren),
      .stb_o(stb),
      .inst_addr_o(inst_addr),
      .data_addr_o(data_addr),
      .data_o(wdata)
   );

   // Bellek bağlantıları
   wire [31:0] mem_addr;
   wire [31:0] mem_rdata;
   wire mem_wen;

   memory me1 (
      .clk_i(clk_i),
      .wen_i(mem_wen),
      .stb_i(stb),
      .addr_i(mem_addr),
      .data_i(wdata),
      .data_o(mem_rdata)
   );

   // GPIO bağlantıları
   wire [31:0] gpio_rdata;
   wire gpio_request;

   gpio g1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .sel_i(gpio_request),
      .wen_i(wen),
      .data_i(wdata),
      .data_o(gpio_rdata),
      .gpio_o(gpio_o)
   );

   // UART bağlantıları
   wire uart_request;
   wire [31:0] uart_rdata;
   //ren_o

   uart u1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .sel_i(uart_request),
      .wen_i(wen),
      .ren_i(ren),
      .addr_i(data_addr),
      .data_i(wdata),
      .data_o(uart_rdata),
      .uart_rx_i(uart_rx_i),
      .gpio_test(gpio_test),
      .uart_tx_o(uart_tx_o)
   );

   // Saat sayacı bağlantıları
   wire clock_counter_request;
   wire [31:0] clock_counter_rdata;

   clock_counter cc1(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .sel_i(clock_counter_request),
      .data_o(clock_counter_rdata)
   );

   wire loadstore_request;
   wire peripheral_access;
   wire memory_ls_access;
   wire [31:0] periph_rdata;

   // Load Store isteği kontrol ediliyor.
   assign loadstore_request   = wen | ren;

   // Adres: 0x8XXXXXXX, çevrebirimlere yönlendiriliyor.
   assign peripheral_access   = loadstore_request & data_addr[31];

   // Okuma yazma isteği belleğe yönlendiriliyor.
   assign memory_ls_access    = loadstore_request & !peripheral_access;

   // Çevrebirimlerden okunan veri seçiliyor.
   assign periph_rdata        = gpio_request ? gpio_rdata : (uart_request ? uart_rdata :
                                 (clock_counter_request ? clock_counter_rdata : 32'b0));
   
   // Adrese göre seçilen çevrebirim belirleniyor.
   assign gpio_request           = peripheral_access & data_addr[12] & !data_addr[13]; // 0x80001000
   assign uart_request           = peripheral_access & data_addr[13] & !data_addr[12]; // 0x80002000
   assign clock_counter_request  = peripheral_access & data_addr[12] & data_addr[13];  // 0x80003000

   // Belleğe yazma isteği gönderiliyor.
   assign mem_wen    = wen & memory_ls_access;

   // Belleğe aktarılacak adres seçiliyor. (veri adresi veya buyruk adresi)
   assign mem_addr   = memory_ls_access ? data_addr : inst_addr;

   // İşlemciye gönderilecek veri seçiliyor. (bellekten veya çevrebirimlerinden okunan veri)
   assign rdata      = memory_ls_access ? mem_rdata : periph_rdata;

   // Bellek meşgulse işlemciyi durdur.
   assign stall      = memory_ls_access;

endmodule
