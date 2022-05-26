// Module Name: aes_sub_byte
// Project Name: AES - Crypto
// Target Devices: 
// Tool Versions: 
// Description: Subbyte is a briklayer permutation consisting of an S-box applied of the state.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "utils/aes_types.v"
module aes_s_box128( A, encrypt, Q );
	input [`DATA_SIZE -1 : 0] A;
	input encrypt;
	input [`DATA_SIZE -1 : 0] Q;
	
	bSbox s0  (A[`RANGE_U8(0)], encrypt, Q[`RANGE_U8(0)]);
	bSbox s1  (A[`RANGE_U8(1)], encrypt, Q[`RANGE_U8(1)]);
	bSbox s2  (A[`RANGE_U8(2)], encrypt, Q[`RANGE_U8(2)]);
	bSbox s3  (A[`RANGE_U8(3)], encrypt, Q[`RANGE_U8(3)]);
	                           
	bSbox s4  (A[`RANGE_U8(4)], encrypt, Q[`RANGE_U8(4)]);
	bSbox s5  (A[`RANGE_U8(5)], encrypt, Q[`RANGE_U8(5)]);
	bSbox s6  (A[`RANGE_U8(6)], encrypt, Q[`RANGE_U8(6)]);
	bSbox s7  (A[`RANGE_U8(7)], encrypt, Q[`RANGE_U8(7)]);
	                                                                    
	bSbox s8  (A[`RANGE_U8(8)], encrypt, Q[`RANGE_U8(8)]);
	bSbox s9  (A[`RANGE_U8(9)], encrypt, Q[`RANGE_U8(9)]);
	bSbox s10 (A[`RANGE_U8(10)], encrypt, Q[`RANGE_U8(10)]);
	bSbox s11 (A[`RANGE_U8(11)], encrypt, Q[`RANGE_U8(11)]);
	          
	bSbox s12 (A[`RANGE_U8(12)], encrypt, Q[`RANGE_U8(12)]);
	bSbox s13 (A[`RANGE_U8(13)], encrypt, Q[`RANGE_U8(13)]);
	bSbox s14 (A[`RANGE_U8(14)], encrypt, Q[`RANGE_U8(14)]);
	bSbox s15 (A[`RANGE_U8(15)], encrypt, Q[`RANGE_U8(15)]);

endmodule