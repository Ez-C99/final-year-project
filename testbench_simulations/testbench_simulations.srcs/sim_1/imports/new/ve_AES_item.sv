/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: Class with all the matrix computed
// Module Name: ve_AES_class_TopLevel.sv
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

class AesItem;

	int msg_id;
	
	rand int delay;
		constraint keep_delay { delay inside {[1:10]}; } 
	
	rand logic [127 : 0] text_in;
	
	rand logic [`KEY_SIZE-1 : 0] key;
	
	rand logic encrypt;
		constraint keep_encrypt;
	
	logic [127 : 0] text_out;

	function new ( input int id );

		this.msg_id = id;
		text_out = 0;
	endfunction : new
	
	function void printf(input string name);
	    encrypt_t e;
	    e = encrypt_t'(encrypt);
		$display("[%0t] %0s Aes Item %0d: %0s", $time, name, msg_id, e.name());
		$display("[%0t] %0s PlaintText: %0h", $time, name, text_in);
		$display("[%0t] %0s Key       : %0h", $time, name, key);
		$display("[%0t] %0s Cipher    : %0h", $time, name, text_out);
	endfunction: printf
	
	
endclass: AesItem