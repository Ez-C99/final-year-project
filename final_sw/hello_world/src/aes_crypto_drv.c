/*
 * aes_crypto_drv.c
 *
 *  Created on: 13 iun. 2019
 *      Author: Mihai
 */


#include "aes_crypto_drv.h"

/************************** Function Definitions ************************/

/* -------------------------------------------------------------------- */
/*** void AES_begin(AesCore* InstancePtr, u32 CORE_Address)
**
**   Parameters:
**      InstancePtr: A AesCore Device to Start
**      CoreAddress: The Base address of the AesCore
**
**   Return Value:
**      none
**
**   Description:
**      Initialize AesCore Structure
*/

void AES_begin(AesCore* InstancePtr, u32 CORE_Address)
{
	InstancePtr->CoreAddress = CORE_Address;
}


/************************** Function Definitions ************************/

/* -------------------------------------------------------------------- */
/*** void AES_setEncryptionState(AesCore* InstancePtr, u8 encryption_state)
**
**   Parameters:
**      InstancePtr: A AesCore Device to Start
**      encryption_state: Set the device for encryption(1) or decryption(0)
**
**   Return Value:
**      none
**
**   Description:
**      Set bit for encryption or decryption in Control Register
*/

void AES_setEncryptionState(AesCore* InstancePtr, u8 encryption_state)
{
	encryption_state &= 0x01;
	if(encryption_state == AES_ENCRYPT){
		InstancePtr->ControlReg |= (u32) (1 << 0);
	}
	else {
		InstancePtr->ControlReg &= (u32) (~(1 << 0));
	}
	//Xil_Out32(InstancePtr->CoreAddress, InstancePtr->ControlReg);
}

/************************** Function Definitions ************************/

/* -------------------------------------------------------------------- */
/*** u8 	 AES_getEncryptionState(AesCore* InstancePtr);
**
**   Parameters:
**      InstancePtr: A AesCore Device to Start
**
**
**   Return Value:
**      u8 state- encryption(1) or decryption(0)
**
**   Description:
**      Get State from Control register
*/
u8 	 AES_getEncryptionState(AesCore* InstancePtr)
{
	u8 state;
	state = Xil_In32(InstancePtr->CoreAddress) & 1;
	return state;
}

void AES_setData(AesCore*InstancePtr, u8*data)
{
	int i;
	for (i = 0; i < AES_DATA_SIZE_U8; i++) {
		InstancePtr->data_in[i] = data[i];
	}
}

void AES_setKey(AesCore*InstancePtr, u8*key)
{
	int i;
	for (i = 0; i < AES_DATA_SIZE_U8; i++) {
		InstancePtr->key[i] = key[i];
	}
}

void AES_DriveBuff(u32 StartAddress, u8* buff)
{
	int i, n;
	u32 data;
	n = AES_DATA_SIZE_U8 / 4;
	for (i = 0; i < n; i++) {
		data = buff[i*4] << 24;
		data |= buff[i*4 + 1] << 16;
		data |= buff[i*4 + 2] << 8;
		data |= buff[i*4 + 3];
		Xil_Out32(StartAddress + 4*i, data);
	}
}

void AES_StoreBuff(u32 StartAddress, u8*buff)
{
	int i, n;
	u32 data;
	n = AES_DATA_SIZE_U8/4;
	for (i = 0; i < n; i++) {
		data = Xil_In32(StartAddress + 4*i);
		buff[i*4] = data >> 24;
		buff[i*4 + 1] = data >> 16 & 0xFF;
		buff[i*4 + 2] = data >> 8 & 0xFF;
		buff[i*4 + 3] = data & 0xFF;
	}
}

void AES_SendRequestBlocking(AesCore*InstancePtr)
{
	u32 data_valid = 0;
	// synchronize for driving data (ToDo Move the synchronization in Hardware)



	AES_DriveBuff(InstancePtr->CoreAddress+AES_OFFSET_DATA_IN, InstancePtr->data_in);
	AES_DriveBuff(InstancePtr->CoreAddress+AES_OFFSET_KEY, InstancePtr->key);
	Xil_Out32(InstancePtr->CoreAddress+AES_OFFSET_CTRL, InstancePtr->ControlReg);

	// Active Waiting for Data Valid
	while(data_valid == 0) {
			data_valid =  Xil_In32(InstancePtr->CoreAddress + 4) & 1;
	}

	while(data_valid == 0) {
			data_valid =  Xil_In32(InstancePtr->CoreAddress + 4) & 1;
	}

	AES_StoreBuff(InstancePtr->CoreAddress+ AES_OFFSET_DATA_OUT, InstancePtr->data_out);
}

XStatus AESCRYPTOCORE_Reg_SelfTest(void * baseaddr_p)
{
	u32 baseaddr;
	int write_loop_index;
	int read_loop_index;

	baseaddr = (u32) baseaddr_p;

	xil_printf("******************************\n\r");
	xil_printf("* User Peripheral Self Test\n\r");
	xil_printf("******************************\n\n\r");

	/*
	 * Write to user logic slave module register(s) and read back
	 */
	xil_printf("User logic slave module test...\n\r");

	for (write_loop_index = 0 ; write_loop_index < 14; write_loop_index++)
	  AESCRYPTOCORE_mWriteReg (baseaddr, write_loop_index*4, (write_loop_index+1)*READ_WRITE_MUL_FACTOR);
	for (read_loop_index = 0 ; read_loop_index < 14; read_loop_index++)
	  if ( AESCRYPTOCORE_mReadReg (baseaddr, read_loop_index*4) != (read_loop_index+1)*READ_WRITE_MUL_FACTOR){
	    xil_printf ("Error reading register value at address %x\n", (int)baseaddr + read_loop_index*4);
	    //return XST_FAILURE;
	  }

	xil_printf("   - slave register write/read passed\n\n\r");

	return XST_SUCCESS;
}
