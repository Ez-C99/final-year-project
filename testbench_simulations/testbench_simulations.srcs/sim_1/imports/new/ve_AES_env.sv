/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: Class with all the matrix computed
// Module Name: AesVE.sv
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
`include "ve_AES_BaseUnit.sv"
`include "ve_AES_AlreadyComputed.sv"
`include "ve_AES_Core.sv"
`include "ve_AES_class_MixColumn.sv"
class AesEnvironment extends BaseUnit;

 	AlreadyComputed computed_val;
    BaseUnit units[$];
	AesCore aes; 

	
	virtual mix_column_intf.drv intf_drv;
	virtual mix_column_intf.rcv intf_rcv;
	
	virtual key_schedule_intf intf;
	
	virtual reset_intf intf_r;
	virtual aes_top_intf.drv top_intf_drv;
	virtual	aes_top_intf.rcv top_intf_rcv;
	
	agent_MixColumn mix_column_inst;
	agent_KeySchedule key_schedule_inst;
	agent_AesTop ve_aes_inst;
	
	function new(	
					string name, int id, 
					virtual mix_column_intf.drv intf_drv_i,
					virtual mix_column_intf.rcv intf_rcv_i,
					virtual key_schedule_intf intf_p,
					virtual reset_intf r_p,
					virtual aes_top_intf.drv top_intf_drv_p,
					virtual	aes_top_intf.rcv top_intf_rcv_p
				);
		super.new(name, id);
 		computed_val = new;
 		this.intf_drv = intf_drv_i;
		this.intf_rcv = intf_rcv_i;
		this.intf_r   = r_p;
		this.top_intf_drv = top_intf_drv_p;
		this.top_intf_rcv = top_intf_rcv_p;

		aes = new ("AES CORE", 0, computed_val);
		//units.push_back(aes);
		mix_column_inst = new(this.intf_drv, this.intf_rcv, "AGENT MIX COLUMN", 1, aes);
		//units.push_back(mix_column_inst);
		intf = intf_p;
		key_schedule_inst = new (intf, "AGENT KEY SCHEDULE", 2, aes);
		//units.push_back(key_schedule_inst);
		
		ve_aes_inst = new(top_intf_drv, top_intf_rcv, "AGENT AES TOP", 3, aes);
		units.push_back(ve_aes_inst);
		
	endfunction

    task end_of_simulation_mechanism();  
		#100;
		$display("[%0t] %s End of simulation", $time, super.name);
		$finish;
    endtask: end_of_simulation_mechanism

    task run();
		$display("UNITS SIZE %0d", units.size());
		ve_aes_inst.init_value();
		intf_r.drv_cb.reset <= 1;
		#10;
		intf_r.drv_cb.reset <= 0;
		for(int i=0;i<units.size();i++) 
		  fork
			automatic int k=i;
			begin
				units[k].run();
			end
		  join_any
      end_of_simulation_mechanism();
	endtask: run
endclass : AesEnvironment