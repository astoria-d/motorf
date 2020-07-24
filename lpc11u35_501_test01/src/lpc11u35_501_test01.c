/*
===============================================================================
 Name        : lpc11u35_501_test01.c
 Author      : $(author)
 Version     :
 Copyright   : $(copyright)
 Description : main definition
===============================================================================
*/

#ifdef __USE_CMSIS
#include "LPC11Uxx.h"
#endif

#include <cr_section_macros.h>

// TODO: insert other include files here

// TODO: insert other definitions and declarations here

typedef unsigned int reg_t;

#define GPIO_BASE (0x50000000)
reg_t *GPIO_P0_W0 = GPIO_BASE + 0x1000;
reg_t *GPIO_P0_DIR0 = GPIO_BASE + 0x2000;
reg_t *GPIO_P0_PIN0 = GPIO_BASE + 0x2100;
reg_t *GPIO_P0_SET0 = GPIO_BASE + 0x2200;
reg_t *GPIO_P0_CLR0 = GPIO_BASE + 0x2280;

#define TIME_BASE (0xE000E000)
reg_t *SYST_CSR = TIME_BASE + 0x0010;
reg_t *SYST_CVR = TIME_BASE + 0x0018;

int main(void) {

    // TODO: insert code here
	//port 19 out
	*GPIO_P0_DIR0 = (0x00080000);
	*GPIO_P0_SET0 = (0x00080000);

	//enable timer
	*SYST_CSR = 0x1;

    // Force the counter to be placed into memory
    volatile static int i = 0 ;
    // Enter an infinite loop, just incrementing a counter
    while(1) {
        i++ ;
        // "Dummy" NOP to allow source level single
        // stepping of tight while() loop
        __asm volatile ("nop");

        //PIO_19 (LED) on
        reg_t time = *SYST_CVR;
        if((time >> 20) % 2 == 0) {
//       if((i >> 15) % 2 == 0) {
        	*GPIO_P0_SET0 = (0x00080000);
        } else {
        	*GPIO_P0_CLR0 = (0x00080000);
        }


    }
    return 0 ;
}
