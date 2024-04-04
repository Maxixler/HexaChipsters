// Matrak M10 RV32I RISC-V Processor
// Gülpare II Architechture 2023
// UART TX Module

//ren_o

module uart (
   input                clk_i,
   input                rst_i,
   input                sel_i,      // Seçim sinyali
   input                wen_i,      // Yazma yetkilendirme
   input                ren_i,      // okuma yetkilendirme
   input [31:0]         addr_i,     // Adres girişi, işlemciden geliyor.
   input [31:0]         data_i,     // Veri girişi, işlemciden geliyor.
   output[31:0]         data_o,     // Veri çıkışı, işlemciye gidiyor.
   input                uart_rx_i,  // UART RX bağlantısı
   output [7:0]         gpio_test,   // GPIO ��k�� pinleri
   output               uart_tx_o   // UART TX bağlantısı
);

   localparam UART_TRANSMIT_REG  = 4'h0;
   localparam UART_STATUS_REG    = 4'h4;
   localparam UART_RECEIVE_REG   = 4'h8;
   localparam UART_RX_STATUS_REG = 4'hc;

   wire done;
   wire rx_done;
   wire [7:0] rx_data;

   // Kaydedici adresi çözümleniyor.
   wire tx_sel       = (UART_TRANSMIT_REG == addr_i[3:0]);
   wire status_sel   = (UART_STATUS_REG == addr_i[3:0]);
   wire rx_sel       = (UART_RECEIVE_REG == addr_i[3:0]);
   wire rx_status_sel= (UART_RX_STATUS_REG == addr_i[3:0]);

   // Gönderilecek veri yazılıyor. (gönderimi başlat)
   wire tx_en     = sel_i & wen_i & tx_sel;
   // Durum okunuyor.
   wire status_en = sel_i & status_sel;
   
   wire rx_en     = sel_i & rx_sel;
   
   wire rx_status_en = sel_i & rx_status_sel;

   assign data_o  = status_en ? {30'b0, done} :
                    rx_en ? {24'b0, rx_data[7:0]}:
                    rx_status_en ? {30'b0, rx_done}:
                    31'b0 ;
   
   

   transmitter t1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .tx_data_i(data_i[7:0]),
      .tx_en_i(tx_en),
      .tx_done_o(done),
      .tx_o(uart_tx_o)
   );
   
    receiver r1 (
      .clk_i(clk_i),
      .rst_i(rst_i),
      .rx_data_o(rx_data[7:0]), //problemli
      .rx_en_i(rx_en),
      .rx_done_o(rx_done),
      .gpio_t(gpio_test),
      .rx_i(uart_rx_i)
   ); 

endmodule

module transmitter (
   input                clk_i,
   input                rst_i,
   input                tx_en_i,
   output reg           tx_o,
   input [7:0]          tx_data_i,
   output reg           tx_done_o
   
);

   localparam IDLE      = 2'b00;
   localparam START     = 2'b01;
   localparam TRANSMIT  = 2'b10;
   localparam DONE      = 2'b11;

   localparam CLKFREQ   = 50_000_000;
   localparam BAUD_RATE = 115200;

   localparam BAUD_DIV  = CLKFREQ/BAUD_RATE;

   reg [15:0] t_counter;
   reg [2:0] b_counter;

   reg [7:0] shr;

   reg [1:0] state;

   always @(posedge clk_i, posedge rst_i) begin
      if (rst_i) begin
         state       <= IDLE;
         t_counter   <= 0;
         b_counter   <= 0;
         shr         <= 8'b0;
         tx_done_o   <= 1'b1;
         tx_o        <= 1'b1;
      end else begin
         case (state)
            IDLE : begin
               b_counter   <= 0;
               tx_done_o   <= 1'b1;
               tx_o        <= 1'b1;
               if (tx_en_i) begin
                  tx_o     <= 1'b0;
                  shr      <= tx_data_i;
                  state    <= START;
               end else begin
                  state    <= IDLE;
               end
            end
            START : begin
               tx_done_o   <= 1'b0;
               if (t_counter == BAUD_DIV-1) begin
                  t_counter   <= 0;
                  shr[7]      <= shr[0];
                  shr[6:0]    <= shr[7:1];
                  tx_o        <= shr[0];
                  state       <= TRANSMIT;
               end else begin
                  t_counter   <= t_counter + 1;
               end
            end
            TRANSMIT : begin
               tx_done_o   <= 1'b0;
               if (b_counter == 7) begin
                  if (t_counter == BAUD_DIV-1) begin
                     t_counter   <= 0;
                     b_counter   <= 0;
                     tx_o        <= 1'b1;
                     state       <= DONE;
                  end else begin
                     t_counter   <= t_counter + 1;
                  end
               end else begin
                  if (t_counter == BAUD_DIV-1) begin
                     t_counter   <= 0;
                     b_counter   <= b_counter + 1;
                     shr[7]      <= shr[0];
                     shr[6:0]    <= shr[7:1];
                     tx_o        <= shr[0];
                  end else begin
                     t_counter   <= t_counter + 1;
                  end
               end
            end
            DONE : begin
               if (t_counter == BAUD_DIV-1) begin
                  t_counter   <= 0;
                  tx_done_o   <= 1'b1;
                  state       <= IDLE;
               end else begin
                  t_counter   <= t_counter + 1;
               end
            end
            default : state <= IDLE;
         endcase
      end
   end 
endmodule
 


//receiver




module receiver (
  input        clk_i,
  input        rst_i,
  input        rx_en_i,
  input        rx_i,
  output reg [7:0]  rx_data_o, //islemci ye giden veri
  output reg [7:0]  gpio_t,   // GPIO ��k�� pinleri
  output reg     rx_done_o
);

  localparam BAUD_DIV = 50000000 / 115200;

  reg [15:0] clk_counter;
  reg [1:0] state;
  reg [7:0] data;
  reg [3:0] bit_counter;

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state <= 2'b00;
      clk_counter <= 0;
      bit_counter <= 0;
      rx_done_o <= 1'b1;
      rx_data_o <= 8'b0;
    end else begin 
      case (state)
        2'b00: begin // Bekleme
          rx_done_o <= 1'b1;
          if (rx_en_i) begin
            state <= 2'b01;
          end
        end
        2'b01: begin // Ba�lang�� biti
          rx_done_o <= 1'b0;
          if (clk_counter == BAUD_DIV - 1) begin
            clk_counter <= 0;
            if (rx_i == 1'b0) begin
              state <= 2'b10;
              bit_counter <= 0;
            end
          end else begin
            clk_counter <= clk_counter + 1;
          end
        end
        2'b10: begin // Veri bitleri
          rx_done_o <= 1'b0;
          if (clk_counter == BAUD_DIV - 1) begin
            clk_counter <= 0;
            data[bit_counter] <= rx_i;
            bit_counter <= bit_counter + 1;
            if (bit_counter == 7) begin
              state <= 2'b11;
            end
          end else begin
            clk_counter <= clk_counter + 1;
          end
        end
        2'b11: begin // Durdurma biti
          if (clk_counter == BAUD_DIV - 1) begin
            clk_counter <= 0;
            rx_done_o <= 1'b1;
            if (rx_i == 1'b1) begin
              rx_data_o <= data; 
              gpio_t <= data;//gelen veriyi gpio ya aktar
              state <= 2'b00;
            end else begin
              state <= 2'b00; // Hata
            end 
          end else begin
            clk_counter <= clk_counter + 1;
          end
        end 
      endcase 
    end
  end
endmodule
