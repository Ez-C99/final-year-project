`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2019 08:38:04 PM
// Design Name: 
// Module Name: test_program
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//`include "ve_AES_Include.sv"
`include "ve_AES_types.sv"
//`define AUTO_GENERATION	

constraint AesItem :: keep_encrypt { 
							//encrypt == `DECRIPT;
							//key == 0;
							//text_in == 'h66e94bd4ef8a2c3b884cfa59ca342b2e;
							//text_in == 4'he;
					}

program main_program( 
						mix_column_intf.drv intf_drv,
						mix_column_intf.rcv intf_rcv,
						key_schedule_intf key_intf,
					    reset_intf reset_intf_p,
						aes_top_intf.drv top_intf_drv,
						aes_top_intf.rcv top_intf_rcv
					);
    AesEnvironment env;
    word8 mult_test;
    initial begin
        env = new("Environment", 1, intf_drv, intf_rcv, key_intf, reset_intf_p, top_intf_drv, top_intf_rcv);
        //mult_test = env.aes.mul(0, 2);
		//$display("Mul test DEBUG %0b", mult_test);
		//mult_test = env.aes.mul(1, 2);
		//$display("Mul test DEBUG %0b", mult_test);
        env.run();
    end
endprogram

