// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: Sbox.
// Module Name: bSbox
// Project Name: AES - Crypto
// Target Devices: 
// Tool Versions: 
// Description: MixColumn Transformation. Difusion Layer in AES
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module MixColumns( b0, b1, b2, b3, a0, a1, a2, a3, c0, c1, c2, c3);

	input    [7:0] b0, b1, b2, b3;
	output   [7:0] a0, a1, a2, a3;
	output   [7:0] c0, c1, c2, c3;
	
	wire 	 [7:0] x0, x1, x2, x3;
	wire 	 [7:0] x0_out, x1_out, x2_out, x3_out;
	wire     [7:0] z0, z1;
	
	wire     [7:0] d_out0, d_out1, d_out2, d_out3, d_out4;
	
	assign x0 = b3 ^ b0;
	assign x1 = b1 ^ b0;
	assign x2 = b2 ^ b1;
	assign x3 = b3 ^ b2;
	
	x_times xtime_inst0 (x0, x0_out);
	x_times xtime_inst1 (x1, x1_out);
	x_times xtime_inst2 (x2, x2_out);
	x_times xtime_inst3 (x3, x3_out);
	
	assign a0 = (x0_out ^ b1) ^ x3;
	assign a1 = (x1_out ^ b0) ^ x3;
	assign a2 = (x2_out ^ b3) ^ x1;
	assign a3 = (x3_out ^ b2) ^ x1;
	
	// Decription part
	
	x_times xtime_dec0(b0^ b2, d_out0);
	x_times xtime_dec1(b1^ b3, d_out1);
	x_times xtime_dec2(d_out0, d_out2);
	x_times xtime_dec3(d_out1, d_out3);
	 
	x_times xtime_dec4(d_out2^d_out3, d_out4);
	
	

	
	assign c0 = a0 ^ (d_out2 ^ d_out4);
	assign c1 = a1 ^ (d_out3 ^ d_out4);
	assign c2 = a2 ^ (d_out2 ^ d_out4);
	assign c3 = a3 ^ (d_out3 ^ d_out4);
	
endmodule