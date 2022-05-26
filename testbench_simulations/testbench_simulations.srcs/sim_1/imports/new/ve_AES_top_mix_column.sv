/////////////////////////////////////////////////////////////////////////////////
// Faculty: AC Isi
// Student: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: Class with all the matrix computed
// Module Name: ve_AES_top.sv
// Project Name: AES - Crypto
// Target Devices: 
// Tool Versions: 
// Description: top file for the verification environment
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define 	U_8 8
`define AES_TOP_TEST
`timescale 1ns/1ps
module top;
        
	
	
	reg clk;
	reg reset;
	reg [127:0] text_in;
	reg [127:0] key;
	reg encrypt;
	wire [127:0] text_out;
	wire data_valid;
	
	aes_top DUT_Top(clk, reset, text_in, key, encrypt, text_out, data_valid);
	
	aes_top_intf aes_inst_intf(
		.clock(clk),
		.key(key),
		.text_in(text_in),
		.encrypt(encrypt),
		.text_out(text_out),
		.data_valid(data_valid)
		);
	
	reset_intf reset_inst_intf(
		.clock(clk),
		.reset(reset)
		);
	
	initial begin
	       text_in = 128'h3243_f6a8_885a_308d_31_31_98a2_e037_0734;
           //text_in = 0;
		   //key = 128'h2b7e1516_28aed2a6_abf71588_09cf4f3c;
           //key = 0;
		   //encrypt = 1;
           //reset = 1;
           
           clk = 0;
           forever #1 clk = ~clk;
	end
		
	key_schedule_intf key_intf();
	
	key_schedule KScheduleDutTop(key_intf.key_in, key_intf.encrypt, key_intf.round_index, key_intf.key_out);
	
	MixColumns MixColumns_DUT (
							.b0			(mix_column_intf0.b0), //input
							.b1			(mix_column_intf0.b1), //input
							.b2			(mix_column_intf0.b2), //input
							.b3			(mix_column_intf0.b3), //input
							.a0			(mix_column_intf0.a0), //output
							.a1			(mix_column_intf0.a1), //output
							.a2			(mix_column_intf0.a2), //output
							.a3			(mix_column_intf0.a3), //output
							.c0			(mix_column_intf0.c0), //output
							.c1			(mix_column_intf0.c1), //output
							.c2			(mix_column_intf0.c2), //output.c0			(c0), //output
							.c3			(mix_column_intf0.c3) //output
							);
                                                            
        				
	mix_column_intf mix_column_intf0();		
	
	
	main_program test(mix_column_intf0, mix_column_intf0, key_intf, reset_inst_intf, aes_inst_intf.drv, aes_inst_intf.rcv );
	
endmodule