// Module Name: aes_shift_rows
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
module aes_shift_rows(data_in, encrypt, data_out);

	input [`DATA_SIZE -1 : 0] data_in;
	input encrypt;
	output [`DATA_SIZE -1 : 0] data_out;
	
	wire `u8 Mix_input0;
	wire `u8 Mix_input1;
	wire `u8 Mix_input2;
	wire `u8 Mix_input3;
	
	wire `u8 Mix_input4;
	wire `u8 Mix_input5;
	wire `u8 Mix_input6;
	wire `u8 Mix_input7;
	
	wire `u8 Mix_input8;
	wire `u8 Mix_input9;
	wire `u8 Mix_input10;
	wire `u8 Mix_input11;
	
	wire `u8 Mix_input12;
	wire `u8 Mix_input13;
	wire `u8 Mix_input14;
	wire `u8 Mix_input15;

	assign Mix_input15 =  data_in [`RANGE_U8(15)];
	assign Mix_input14 =  data_in [`RANGE_U8(14)];
	assign Mix_input13 =  data_in [`RANGE_U8(13)];
	assign Mix_input12 =  data_in [`RANGE_U8(12)];
                         
	assign Mix_input11 =  data_in [`RANGE_U8(11)];
	assign Mix_input10 =  data_in [`RANGE_U8(10)];
	assign Mix_input9  =  data_in [`RANGE_U8( 9)];
	assign Mix_input8  =  data_in [`RANGE_U8( 8)];
	                     
	assign Mix_input7  =  data_in [`RANGE_U8( 7)];
	assign Mix_input6  =  data_in [`RANGE_U8( 6)];
	assign Mix_input5  =  data_in [`RANGE_U8( 5)];
	assign Mix_input4  =  data_in [`RANGE_U8( 4)];
                         
	assign Mix_input3  =  data_in [`RANGE_U8( 3)];
	assign Mix_input2  =  data_in [`RANGE_U8( 2)];
	assign Mix_input1  =  data_in [`RANGE_U8( 1)];
	assign Mix_input0  =  data_in [`RANGE_U8( 0)];

	
	assign data_out [`RANGE_U8(15)] = (encrypt == `ENCRIPT)? Mix_input15 : Mix_input15;
	assign data_out [`RANGE_U8(14)] = (encrypt == `ENCRIPT)? Mix_input10 : Mix_input2;
	assign data_out [`RANGE_U8(13)] = (encrypt == `ENCRIPT)? Mix_input5  : Mix_input5;
	assign data_out [`RANGE_U8(12)] = (encrypt == `ENCRIPT)? Mix_input0  : Mix_input8;
	                                
	assign data_out [`RANGE_U8(11)] = (encrypt == `ENCRIPT)? Mix_input11  : Mix_input11;                                        
	assign data_out [`RANGE_U8(10)] = (encrypt == `ENCRIPT)? Mix_input6   : Mix_input14;
	assign data_out [`RANGE_U8( 9)] = (encrypt == `ENCRIPT)? Mix_input1   : Mix_input1;
	assign data_out [`RANGE_U8( 8)] = (encrypt == `ENCRIPT)? Mix_input12  : Mix_input4;          
	                         
	assign data_out [`RANGE_U8( 7)] = (encrypt == `ENCRIPT)? Mix_input7   : Mix_input7;                            
	assign data_out [`RANGE_U8( 6)] = (encrypt == `ENCRIPT)? Mix_input2   : Mix_input10;
	assign data_out [`RANGE_U8( 5)] = (encrypt == `ENCRIPT)? Mix_input13  : Mix_input13;
	assign data_out [`RANGE_U8( 4)] = (encrypt == `ENCRIPT)? Mix_input8   : Mix_input0;      
	                                
									
	assign data_out [`RANGE_U8( 3)] = (encrypt == `ENCRIPT)? Mix_input3   : Mix_input3; 
	assign data_out [`RANGE_U8( 2)] = (encrypt == `ENCRIPT)? Mix_input14  : Mix_input6;                                        
	assign data_out [`RANGE_U8( 1)] = (encrypt == `ENCRIPT)? Mix_input9   : Mix_input9;
	assign data_out [`RANGE_U8( 0)] = (encrypt == `ENCRIPT)? Mix_input4   : Mix_input12;
	
	
endmodule 