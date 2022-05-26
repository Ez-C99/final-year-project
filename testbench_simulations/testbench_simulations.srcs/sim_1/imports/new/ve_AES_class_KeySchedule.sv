/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// File Name: AES Class, implemeting High Level Algorithm
// Project Name: AES - Crypto
// Description: Key Schedule Generator
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



class agent_KeySchedule extends BaseUnit;

	virtual key_schedule_intf intf;
	AesCore aes;


	extern function new(
						virtual key_schedule_intf p_intf,
						string name, 
						int id,
						const ref AesCore aes_core);
	extern task run();




endclass: agent_KeySchedule

function agent_KeySchedule :: new(
								virtual key_schedule_intf p_intf,
								string name, 
								int id,
								const ref AesCore aes_core);
	super.new(name,id);
	this.aes		 = aes_core;
	intf = p_intf;
	
endfunction : new

task agent_KeySchedule :: run();

	word128 internal_key = 0;
	for (int i = 0; i <= `NO_OF_ROUNDS; i++) begin
		intf.key_in 	= internal_key;
		intf.encrypt 	= `ENCRIPT;
		intf.round_index = i;
		#1;
		$display("[%0t] %s %0d Internal key Generated %0h", $time, super.name,i, internal_key);
		internal_key = intf.key_out;
	end	
	

endtask:run
