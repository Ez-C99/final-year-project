/*
 * aes_crypto_drv.h
 *
 *  Created on: 13 iun. 2019
 *      Author: Mihai
 */

#ifndef SRC_AES_CRYPTO_DRV_H_
#define SRC_AES_CRYPTO_DRV_H_

/******************************************************************************/
/*                                                                            */
/* aes_crypto_drv.h -- Driver definitions for the Aes Crypto                  */
/*                                                                            */
/******************************************************************************/
/* Author: Mihai Olaru                                                        */
/*                                                                            */
/******************************************************************************/
/* File Description:                                                          */
/*                                                                            */
/* This library contains function implementation for AesCrypto Core module.   */
/*                                                                            */
/*                                                                            */
/******************************************************************************/

/******************************************************************************/


/****************************** Include Files ***************************/

#include "xil_io.h"
#include "xstatus.h"
#include "xil_types.h"

/**************************** Type Definitions **************************/
#define AES_DATA_SIZE_U8			16
#define AES_KEY_SIZE_U8				16


typedef struct AesCore {

	u32 CoreAddress;
	u32 ControlReg;
	u32 StatusReg;
	u8  data_in[16];
	u8  key[16];
	u8  data_out[16];

} AesCore;


#define AES_ENCRYPT 				1
#define AES_DECRYPT 				0

#define AES_OFFSET_DATA_IN			8
#define AES_OFFSET_KEY				24
#define AES_OFFSET_DATA_OUT			40
#define AES_OFFSET_CTRL				0
#define AES_OFFSET_STS				4

#define READ_WRITE_MUL_FACTOR 0x10

#define AESCRYPTOCORE_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))


#define AES_BASEADDR0 				XPAR_AESCRYPTOCORE_V1_0_S_0_BASEADDR

#define AESCRYPTOCORE_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

/************************** Function Definitions ************************/

void AES_begin(AesCore* InstancePtr, u32 CORE_Address);
void AES_setEncryptionState(AesCore* InstancePtr, u8 encryption_state);
u8 	 AES_getEncryptionState(AesCore* InstancePtr);
void AES_setData(AesCore*InstancePtr, u8*data);
void AES_setKey(AesCore*InstancePtr, u8*key);

void AES_DriveBuff(u32 StartAddress, u8* buff);
void AES_StoreBuff(u32 StartAddress, u8*buff);
void AES_SendRequestBlocking(AesCore*InstancePtr);

XStatus AESCRYPTOCORE_Reg_SelfTest(void * baseaddr_p);
#endif /* SRC_AES_CRYPTO_DRV_H_ */
