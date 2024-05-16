#include "matrak.h"

#define HIGH 1
#define LOW 0

   float float_deger1=12.7;
   float float_deger2=23.3;
   uint8_t float_sonuc;
   char arr[4];

   int carp=3;

void main(void) {

   put_str(".:|>HexaChipsters<|:.\n");
   put_str("Marmara Universitesi\n");
   put_str("Elektrik Elektronik Muhendisligi\n");
   put_str("2024\n");
   char rx_ctrl=0x61;//a
   char text[] = "Gelen Veri=";

   int id;
   char buffer[10];

   while(1){

      float_sonuc=float_deger1+5;
      put_str("Float isleminin sonucu==>");
      put_char(float_sonuc);  

      //delay_ms(20);

      put_str(text);
      uint8_t data_receive[5]={'\0','\0','\0','\0','\0'};
      get_str(data_receive,5);//uart dan 5 li char al
      put_str(data_receive);
      put_char('\n');
      uint8_t say =0;
      say=(data_receive[1]) * carp;//mul
      put_char(say);
      put_char('\n');
      say=(data_receive[2]) / 3;//div
      put_char(say);
      put_char('\n');
      say=(data_receive[3]) % 10;//rem
      put_char(say);
      put_char('\n');

 //     sprintf(buffer, "%d \n", id++);
 //     put_str(buffer);
 //     put_char('\n');


    //float fd =2.11 * (data_receive[4]);
    //(fd>=0x6A) ? gpio_write(2, HIGH) : gpio_write(2, LOW);

    (data_receive[1]>=0x35) ? gpio_write(0, HIGH) : gpio_write(0, LOW);

    //sprintf(buffer, "%d \n", id);
    //itoa(id,buffer,10);
    //snprintf (buffer, sizeof(buffer), "%d",id);

  //    int2char(say++,arr);

  //    put_str(arr);
   }
}

//export PATH=$PATH:/opt/riscv/bin

