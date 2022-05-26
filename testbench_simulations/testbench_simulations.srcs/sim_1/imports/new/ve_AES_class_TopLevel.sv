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

class agent_AesTop extends BaseUnit;
	
	virtual aes_top_intf.drv intf_drv;
	
	virtual	aes_top_intf.rcv intf_rcv;
	
	AesCore core;
	
	AesItem item_gen; // Item is generated and injected on the interface
	
	AesItem item_collected;
	
    function new(	
							virtual aes_top_intf.drv intf_drv_p,
							virtual	aes_top_intf.rcv intf_rcv_p,
							input string name, 
							input int id,
							const ref AesCore aes_core
						);
	   super.new(name, id);
	   this.core = aes_core;
	   this.intf_drv = intf_drv_p;
	   this.intf_rcv = intf_rcv_p;
	endfunction: new
						
	// generate stimuls to AES top interface
	
	task generate_aes_item();
		int err;
		
		for (int i = 0; i < `SIM_NR_ITEMS; i++) begin
			item_gen = new(i);
			`ifdef AUTO_GENERATION 
				err = item_gen.randomize();
				if(err) begin
					driving_aes_item();
				end
			`else
				item_gen.text_in = `MANUAL_TEXT_IN;
				item_gen.key     = `MANUAL_KEY;
				item_gen.encrypt = `MANUAL_ENCRYPT;
				driving_aes_item();
			`endif
		end
	endtask: generate_aes_item
	
	// driving stimuls to AES top interface
	task driving_aes_item();
		
		repeat(item_gen.delay) begin
			@(intf_drv.drv_cb);
		end
		@(posedge intf_rcv.rcv_cb.data_valid);
		//@(intf_drv.drv_cb);
		//@(intf_drv.drv_cb);
		/// driving stimuls : plainText, encrypt, key
		$display("[%0t] %s Start driving a new Item", $time, super.name);
		//item_gen.printf("BFM");
		intf_drv.drv_cb.text_in <= item_gen.text_in;
		intf_drv.drv_cb.key 	<= item_gen.key;
		intf_drv.drv_cb.encrypt <= item_gen.encrypt;
	
	endtask: driving_aes_item
	
	task init_value();
		intf_drv.drv_cb.text_in <= 0;
		intf_drv.drv_cb.key 	<= 0;
		intf_drv.drv_cb.encrypt <= 1;
	endtask:init_value
	
	task items_monitoring();
		int msgId = 0;
		while(1) begin 
			@(posedge intf_rcv.rcv_cb);
			if (intf_rcv.rcv_cb.data_valid) begin
				item_collected = new(msgId);
				msgId++;
				item_collected.text_in  = intf_rcv.rcv_cb.text_in;
				item_collected.encrypt  = intf_rcv.rcv_cb.encrypt;
				item_collected.key		= intf_rcv.rcv_cb.key;
				item_collected.text_out = intf_rcv.rcv_cb.text_out;
				$display("[%0t] %s Aes Item Collected", $time, super.name);
				item_collected.printf("MONITOR");
				if (item_collected.encrypt == 1) begin
					match_item_e();
				end
				else begin
					match_item_d();
				end
			end
		end
	
	endtask: items_monitoring
	
	function void match_item_e();
		// check the output for encryption process
		
		logic [127 : 0] text_expected;
		text_expected = core.apiGetCipher(item_collected.text_in, item_collected.key);
		assert (text_expected == item_collected.text_out) 
			$display("[%0t] %0s Encryption MATCH Expected %0h, Found %0h", $time, super.name, text_expected, item_collected.text_out);
		else
			$error("[%0t] %0s **Error Encryption** MissMatch Expected %0h, Found %0h", $time, super.name, text_expected, item_collected.text_out);
		
	endfunction: match_item_e
	
	function void match_item_d();
		// check the output for decryption process
		logic[127:0] text_expected;
		text_expected = core.apiGetPlaintext(item_collected.text_in, item_collected.key);
		assert (text_expected == item_collected.text_out) 
			$display("[%0t] %0s Decryption MATCH Expected %0h, Found %0h", $time, super.name, text_expected, item_collected.text_out);
		else
			$error("[%0t] %0s **Error Decryption** MissMatch Expected %0h, Found %0h", $time, super.name, text_expected, item_collected.text_out);
	endfunction:match_item_d
	
	task run();
		fork 
		begin
			items_monitoring();
		end
		begin 
			generate_aes_item();
		end
		join_any;
		
	endtask: run
	
endclass: agent_AesTop