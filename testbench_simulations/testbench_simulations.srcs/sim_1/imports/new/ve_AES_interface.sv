/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: Class with all the matrix computed
// Module Name: ve_AES_interface.sv
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
/* interface mix_column_intf (
	output [7:0] b0,	
	output [7:0] b1,
	output [7:0] b2,
	output [7:0] b3,
	input  [7:0] a0,
	input  [7:0] a1,
	input  [7:0] a2,
	input  [7:0] a3,
	input  [7:0] c0,
	input  [7:0] c1,
	input  [7:0] c2,
	input  [7:0] c3
); */
`include "ve_AES_types.sv"
interface mix_column_intf;
	logic [7:0] b0;	
	logic [7:0] b1;
	logic [7:0] b2;
	logic [7:0] b3;
	logic [7:0] a0;
	logic [7:0] a1;
	logic [7:0] a2;
	logic [7:0] a3;
	logic [7:0] c0;
	logic [7:0] c1;
	logic [7:0] c2;
	logic [7:0] c3;

	modport drv ( output b0, output b1, output b2, output b3);
	
	modport rcv ( input b0, input b1, input b2, input b3,
				  input a0, input a1, input a2, input a3,
				  input c0, input c1, input c2, input c3);


endinterface : mix_column_intf

interface key_schedule_intf;

	logic   [`KEY_SIZE-1 : 0] key_in;
	logic   encrypt;
	logic   `u4 round_index;
	logic 	[`KEY_SIZE-1 : 0] key_out; 

endinterface: key_schedule_intf

interface reset_intf (
	input wire clock,
	output logic reset
);
	
	clocking drv_cb@(posedge clock);
		output reset;
	endclocking

	modport drv(clocking drv_cb, input clock);
	
	clocking rcv_cb@(negedge clock);
		input reset;
	endclocking
	
	modport rcv(clocking rcv_cb, input clock);
		
endinterface: reset_intf


interface aes_top_intf(
	input wire clock,
	
	output reg [`KEY_SIZE-1 : 0] key,
	output reg [`TEXT_SIZE-1: 0] text_in,
	output reg encrypt,
	
	input  [`TEXT_SIZE-1: 0] text_out,
	input  data_valid
);
	clocking drv_cb@(posedge clock);
		output key;
		output text_in;
		output encrypt;
		
	endclocking
	
	modport drv(clocking drv_cb, input clock);

	clocking rcv_cb@(negedge clock);
		input key;
		input text_in;
		input encrypt;
		input text_out;
		input data_valid;
		
	endclocking
	
	modport rcv(clocking rcv_cb, input clock);
	
endinterface: aes_top_intf
