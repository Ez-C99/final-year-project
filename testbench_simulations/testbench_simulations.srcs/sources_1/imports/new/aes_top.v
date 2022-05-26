//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: GF(2^4) squarer and scalar.
// Module Name: aes_top
// Project Name: AES - Crypto
// Target Devices: 
// Tool Versions: 
// Description: Multiplexor
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef KEY_SIZE
    `define KEY_SIZE      128
`endif

`ifndef DATA_SIZE
    `define DATA_SIZE	  128
`endif

`ifndef R_ACTIV
 `define R_ACTIV     1'b1
`endif

`ifndef NO_OF_ROUNDS
    `define NO_OF_ROUNDS 10
`endif

`ifndef RANGE_U8
    `define RANGE_U8(x) x*8 +: 8
`endif

module aes_top (clk, reset, text_in, key, encrypt, text_out, data_valid);
	input clk;
	input reset;
	input [`DATA_SIZE -1:0] text_in;
	input [`KEY_SIZE -1:0]  key;
	
	
	//ToDo Update encryption signal just when Pipeline is empty
	input encrypt;
	
	output [`DATA_SIZE -1:0] text_out;
	output data_valid; 
	
	wire [1:0] 			     selection;
	
	reg  [1:0] 				 clock_divider;
	
	reg  [`DATA_SIZE -1:0]  data_after_round_e;
	
	reg  [3:0] round_counter;
	
	reg  [`KEY_SIZE-1 : 0] round_key;
	reg  [`KEY_SIZE-1 : 0] w_extended_key[0:`NO_OF_ROUNDS+1];
	
	
	reg wait_for_key_gen;
	
	wire [`KEY_SIZE-1 : 0] round_key_d;
	
	wire [3:0] round_counter_d;
	
	assign round_counter_d = `NO_OF_ROUNDS - round_counter;
	
	wire [`KEY_SIZE-1 : 0] round_key_out;
	
	wire [`KEY_SIZE-1 : 0] select_key;
	
	
	wire [`DATA_SIZE -1:0] data_pip_e;
	
	
	wire  [`DATA_SIZE -1:0] SB_input;
	wire  [`DATA_SIZE -1:0] SB_input_aux;
	wire [`DATA_SIZE -1:0]  SB_output;
	
	wire [`DATA_SIZE -1:0] SH_out;
	
	wire [`DATA_SIZE -1:0] MC_input;
	
	wire [`DATA_SIZE -1:0] MC_output_e;
	wire [`DATA_SIZE -1:0] MC_output_d;
	
	
	wire r_cnt_zero;
	
	wire [7:0] debug; 
	
	wire [`KEY_SIZE-1 : 0] first_key;
	
	wire [`KEY_SIZE-1 : 0] last_key;
	
	assign round_key_d = w_extended_key[round_counter_d];
	
	assign select_key = (r_cnt_zero)? key : round_key;
	
	assign data_pip_e = MC_output_e ^ round_key;
	
	assign text_out = SH_out ^ last_key;
	
	assign last_key = (encrypt)? round_key : w_extended_key[0];
	
	assign first_key = (encrypt)? key : w_extended_key[`NO_OF_ROUNDS];
	
	assign debug = MC_input[`RANGE_U8(1)];
	
	assign data_valid = ((round_counter == `NO_OF_ROUNDS) && (!wait_for_key_gen || encrypt));
	
	assign r_cnt_zero = (round_counter == 0)? 1:0;
	
	assign MC_input = (encrypt) ? SH_out : SH_out ^ w_extended_key[round_counter_d];
	
	// data in selection
	assign selection[0] = encrypt & (~ r_cnt_zero);
	assign selection[1] = r_cnt_zero;
	
	assign SB_input_aux = (selection == 1)?   data_pip_e : MC_output_d;
	assign SB_input = (selection == 2'b10)?  (text_in ^ first_key) : SB_input_aux;

	always @(posedge clk) begin
		if (reset == `R_ACTIV) begin
			round_counter <= (encrypt == 1)? 0 : `NO_OF_ROUNDS;
			
			data_after_round_e <= text_in ^ key;	
		end
		
		else begin
				
			if (round_counter == `NO_OF_ROUNDS) begin
				round_counter <= 0;
				
			end
			else begin
				round_counter <= round_counter + 1;
				w_extended_key[round_counter+1] <= round_key_out;
			end
			
			data_after_round_e 	<= SB_output;
			round_key 		 	<= round_key_out;			
		end	
	end
	
	
	always @(posedge clk) begin
		if(reset == `R_ACTIV) 
		begin
			w_extended_key[0] <= key;
			wait_for_key_gen <= 1;
		end
		else begin
			if (r_cnt_zero == 1) begin
				if (w_extended_key[0] != key) begin
					wait_for_key_gen <= 1;
				end
				else begin
					wait_for_key_gen <= 0;
				end			
				w_extended_key[0] <= key;
			end
		end
	end
	
		
	aes_s_box128 	sbox_inst(SB_input, encrypt, SB_output);
	
	aes_shift_rows  shift_row_inst(data_after_round_e, encrypt, SH_out); 
	
	key_schedule 	key_schedule_inst(select_key, encrypt, round_counter, round_key_out);
	
	MixColumns		mix_inst0(MC_input[`RANGE_U8(0)],
							  MC_input[`RANGE_U8(1)],
							  MC_input[`RANGE_U8(2)],
							  MC_input[`RANGE_U8(3)],
							  MC_output_e[`RANGE_U8(0)],
							  MC_output_e[`RANGE_U8(1)],
							  MC_output_e[`RANGE_U8(2)],
							  MC_output_e[`RANGE_U8(3)],
							  MC_output_d[`RANGE_U8(0)],
							  MC_output_d[`RANGE_U8(1)],
							  MC_output_d[`RANGE_U8(2)],
							  MC_output_d[`RANGE_U8(3)]);
							  
							  
	MixColumns		mix_inst1(MC_input[`RANGE_U8(4)],
							  MC_input[`RANGE_U8(5)],
							  MC_input[`RANGE_U8(6)],
							  MC_input[`RANGE_U8(7)],
							  MC_output_e[`RANGE_U8(4)],
							  MC_output_e[`RANGE_U8(5)],
							  MC_output_e[`RANGE_U8(6)],
							  MC_output_e[`RANGE_U8(7)],
							  MC_output_d[`RANGE_U8(4)],
							  MC_output_d[`RANGE_U8(5)],
							  MC_output_d[`RANGE_U8(6)],
							  MC_output_d[`RANGE_U8(7)]);
							  
							  
	MixColumns		mix_inst2(MC_input[`RANGE_U8(8)],
							  MC_input[`RANGE_U8(9)],
							  MC_input[`RANGE_U8(10)],
							  MC_input[`RANGE_U8(11)],
							  MC_output_e[`RANGE_U8(8)],
							  MC_output_e[`RANGE_U8(9)],
							  MC_output_e[`RANGE_U8(10)],
							  MC_output_e[`RANGE_U8(11)],
							  MC_output_d[`RANGE_U8(8)],
							  MC_output_d[`RANGE_U8(9)],
							  MC_output_d[`RANGE_U8(10)],
							  MC_output_d[`RANGE_U8(11)]);
							  
	MixColumns		mix_inst3(MC_input[`RANGE_U8(12)],
							  MC_input[`RANGE_U8(13)],
							  MC_input[`RANGE_U8(14)],
							  MC_input[`RANGE_U8(15)],
							  MC_output_e[`RANGE_U8(12)],
							  MC_output_e[`RANGE_U8(13)],
							  MC_output_e[`RANGE_U8(14)],
							  MC_output_e[`RANGE_U8(15)],
							  MC_output_d[`RANGE_U8(12)],
							  MC_output_d[`RANGE_U8(13)],
							  MC_output_d[`RANGE_U8(14)],
							  MC_output_d[`RANGE_U8(15)]);
	
	
endmodule