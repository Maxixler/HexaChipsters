#include "matrak.h"
#include "stdio.h"
#include "string.h"
#include <stdlib.h>
#include <string.h>

#define HIGH 1
#define LOW 0

char arr[4];
void main(void) {
   put_str("HexaChipsters\n");
   put_str("Marmara Universitesi\n");
   put_str("Elektrik Elektronik Muhendisligi\n");
   put_str("2024 \n");
   char rx_ctrl=0x61;//a
   char text[] = "Gelen veri=";

   int id;
   char buffer[10];

   while(1){
      delay_ms(500);
      put_str(text);
      uint8_t data_receive[5]={'\0','\0','\0','\0','\0'};
      get_str(data_receive,5);//uart dan 5 li char al
      put_str(data_receive);
      put_char('\n');
      uint8_t say =0;
      say=(data_receive[1]) * 3;//mul
      put_char(say);
      put_char('\n');
      say=(data_receive[2]) / 2;//div
      put_char(say);
      put_char('\n');
      say=(data_receive[3]) % 10;//rem
      put_char(say);
      put_char('\n');

 //     sprintf(buffer, "%d \n", id++);
 //     put_str(buffer);
 //     put_char('\n');

//    float fd =35.54 * (data_receive[4]);

    (data_receive[0]>=0x35) ? gpio_write(2, HIGH) : gpio_write(2, LOW);

    //sprintf(buffer, "%d \n", id);
    //itoa(id,buffer,10);
    //snprintf (buffer, sizeof(buffer), "%d",id);

  //    int2char(say++,arr);
  //    put_str(arr);
   }
}

//export PATH=$PATH:/opt/riscv/bin
