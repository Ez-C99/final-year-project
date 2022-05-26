/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "aes_crypto_drv.h"

void printfBlock(u8* buff)
{
	int i;
	xil_printf("Buff Print\n\r");
	for (i = 0; i < AES_DATA_SIZE_U8; i++)
	{
		xil_printf("%02x",buff[i]);
	}
	xil_printf("\n\r");
}

void printMemory(u32 base_addr, int no_of_words)
{
	int i;
	u32 data;
	xil_printf("Memory Print\n\r");
	for (i = 0; i < no_of_words;i++)
	{
		data = Xil_In32(base_addr + 4*i);
		xil_printf("%04x\n\r", data);
	}
	xil_printf("End od Memory\n\r");
}

int main()
{
    init_platform();

    print("Hello World\n\r");
    u8 buff_test[16] = {
							0xA0, 0xA1, 0xAA, 0xAA,
							0xAA, 0xAA, 0xAA, 0xAA,
							0xAA, 0xAA, 0xAA, 0xAA,
							0xAA, 0xAA, 0xAA, 0xAA
    };
//    u8 buff_test2[16] = {0};

    AesCore test = {0};

    AES_begin(&test, AES_BASEADDR0);
    AES_setEncryptionState(&test, AES_ENCRYPT);
    AES_setData(&test, buff_test);
    AES_SendRequestBlocking(&test);
    printfBlock(test.data_out);
    printMemory(test.CoreAddress, 14);
    AES_setData(&test, test.data_out);
    AES_setEncryptionState(&test, AES_DECRYPT);
    AES_SendRequestBlocking(&test);
    printfBlock(test.data_out);
    AES_SendRequestBlocking(&test);
    printfBlock(test.data_out);
    // test
    printMemory(test.CoreAddress, 14);
	cleanup_platform();
    return 0;
}
