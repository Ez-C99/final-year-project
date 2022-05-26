/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: Class with all the matrix computed
// Module Name: AlreadyComputed.sv
// Project Name: AES - Crypto
// Target Devices: 
// Tool Versions: 
// Description: aes_calculator
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

	
`ifndef VE_AES_TYPES_SV
	`define VE_AES_TYPES_SV

	`define 	MAXBC 			8



	`define 	MAXKC			8


	`define  	MAXROUNDS 		14



	`define 	U_8 			8



	`define 	KEY_SIZE 		128

	`define 	TEXT_SIZE		128

	`define		u4  			[3:0]	


	typedef bit [7 : 0]		 word8;
	typedef logic [31 : 0]    	 word32;
	typedef logic [127:0]		 word128;
	
	typedef enum {Decryption, Encryption } encrypt_t;
	
	
	`ifndef ENCRIPT 		
		`define ENCRIPT 			1
	`endif
	
	`ifndef DECRIPT 		
		`define DECRIPT 			0
	`endif
	
	`ifndef NO_OF_ROUNDS 		
		`define NO_OF_ROUNDS 			10
	`endif
	
	`ifndef SIM_NR_ITEMS				
            `define SIM_NR_ITEMS             20
    `endif
	
	`ifndef RANGE_U8
		`define RANGE_U8(x) x*8 +: 8
	`endif
	
	`ifndef AUTO_GENERATION
		`define MANUAL_TEXT_IN					'h66e94bd4ef8a2c3b884cfa59ca342b2e
		`define	MANUAL_KEY						0
		`define	MANUAL_ENCRYPT					0
	`endif
	
`endif