/////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Mihai Olaru
// 
// Create Date: 02/18/2019 02:52:17 PM
// Design Name: AES Class, implemeting High Level Algorithm
// Module Name: AES_Class.sv
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
`include "ve_AES_types.sv"
class AesCore extends BaseUnit;

	int BC, KC, ROUNDS;
	word8 data_block[4][`MAXBC];
	
	AlreadyComputed computed_val;
	extern function new(string name, int id, ref AlreadyComputed com_val);
	extern function word8 mul(word8 a, word8 b);
	extern function void MixColumn(ref word8 a[4][`MAXBC]);
	extern function void InvMixColumn(ref word8 a[4][`MAXBC]);
	extern function void AddRoundKey(word8 rk[4][`MAXBC], ref word8 a[4][`MAXBC]);
	extern function void SubBytes(word8 box[256], ref word8 a[4][`MAXBC]);
	extern function void ShiftRows(word8 d, ref word8 a[4][`MAXBC]);
	extern function int KeyExpansion(word8 k[4][`MAXBC], ref word8 W[`MAXROUNDS + 1][4][`MAXBC]);
	extern function int Encrypt ( ref word8 a[4][`MAXBC], word8 rk[`MAXROUNDS + 1][4][`MAXBC]);
	extern function int Decrypt ( ref word8 a[4][`MAXBC],ref  word8 rk[`MAXROUNDS + 1][4][`MAXBC]);
	
	extern function void setDataBlock(logic [127:0] text, ref word8 a[4][`MAXBC]);
	extern function logic [127:0] getDataFromBlock(word8 a[4][`MAXBC]);
	extern function logic [127:0] apiGetCipher(logic [127:0] text, logic [127:0] key);
	extern function logic [127:0] apiGetPlaintext(logic [127:0] cipher, logic [127:0] key);
	
	extern function void printBlockLiniar(string start_mesage, word8 a[4][`MAXBC]);
	
	extern task run();
	
endclass : AesCore

function AesCore :: new(string name, int id, ref AlreadyComputed com_val);
	super.new(name,id);
	if(com_val == null) begin
         com_val = new();
    end
	this.computed_val = com_val;
	
	BC = 4;
	KC = 4;
	ROUNDS = computed_val.numrounds[KC-4][BC-4];
	
endfunction : new

function word8 AesCore :: mul(word8 a, word8 b); 
	word32 temp;
	word8 val;
	if (a && b) begin 
		//temp = computed_val.Alogtable[(computed_val.Logtable[a] + computed_val.Logtable[b]) % 255];
		temp = (computed_val.Logtable[a] + computed_val.Logtable[b]) % 255;
		val =  computed_val.Alogtable[temp];
	end 
	else begin
		temp = 0;
	end
	return val;
endfunction : mul

function void AesCore :: AddRoundKey(word8 rk[4][`MAXBC], ref word8 a[4][`MAXBC]);
	//XOR with the corresponding text from input
	for (int i = 0; i < 4; i++) begin
		for (int j = 0; j < BC; j++) begin
			a[i][j] = a[i][j] ^ rk[i][j];
		end
	end
endfunction : AddRoundKey

function void AesCore :: SubBytes(word8 box[256], ref word8 a[4][`MAXBC]);
	//Every byte from current State is replaced with the value from Sbox 
	for (int i = 0; i < 4; i++) begin
		for (int j = 0; j < BC; j++) begin
			a[i][j] = box [a[i][j]];
		end
	end
	
endfunction : SubBytes

function void AesCore :: ShiftRows( word8 d, ref word8 a[4][`MAXBC]);
	// d is encryption
	word8 tmp[`MAXBC];
	int i, j;
	
	if (d == 0) begin

		for ( i = 1; i < 4; i++) begin
		
			for ( j = 0; j < BC; j++) begin
				tmp [j] = a[i][(j + computed_val.shifts[BC - 4][i]) % BC ];
			end	
			for ( j = 0; j < BC; j++) begin
				a[i][j] = tmp[j];
			end		
			
		end	
	end
	else begin
		for ( i = 1; i < 4; i++) begin
			for ( j = 0; j < BC; j++) begin
				tmp [j] = a[i][(BC + j - computed_val.shifts[BC - 4][i]) % BC ];
			end	
			for ( j = 0; j < BC; j++) begin
				a[i][j] = tmp[j];
			end		
		end
	end
endfunction : ShiftRows

function void AesCore :: MixColumn(ref word8 a[4][`MAXBC]);
	// The byte of every column are mixed in a linear way
	// Equation is
	// 2 3 1 1 * a0
	// 1 2 3 1	 a1
	// 1 1 2 3   a2
	// 3 1 1 2   a3
	word8 res [4][`MAXBC];
	
	int i, j;
	
	for(j = 0; j < BC; j++) begin
		for (i = 0; i < 4; i++)	begin
			res[i][j] = mul(2, a[i][j])
				^ mul(3, a[(i+1) % 4][j])
				^ a[(i + 2) % 4][j]
				^ a[(i + 3) % 4][j];
		end
	end

	for(i = 0; i < 4; i++) begin
		for( j = 0; j < 4; j++) begin
			a[i][j] = res[i][j];
		end
	end
	
endfunction : MixColumn

function void AesCore :: InvMixColumn(ref word8 a[4][`MAXBC]);
	// Decryption MixColumn
	// Equation is
	// 0x0e 0x0b 0x0d 0x09 * a0
	// 0x09 0x0e 0x0b 0x0d	 a1
	// 0x0d 0x09 0x0e 0x0b   a2
	// 0x0b 0x0d 0x09 0x0e   a3
	word8 res [4][`MAXBC];
	int i, j;
	
	for(j = 0; j < BC; j++) begin
		for (i = 0; i < 4; i++)	begin
			res[i][j] = mul(8'h0E, a[i][j])
				^ mul(8'h0B, a[(i+1) % 4][j])
				^ mul(8'h0D, a[(i+2) % 4][j])
				^ mul(8'h09, a[(i+3) % 4][j]);
		end
	end

	for(i = 0; i < 4; i++) begin
		for( j = 0; j < 4; j++) begin
			a[i][j] = res[i][j];
		end
	end
	
endfunction : InvMixColumn

function int AesCore :: KeyExpansion(word8 k[4][`MAXBC], ref word8 W[`MAXROUNDS + 1][4][`MAXBC]);
	int i, j, t, RCpointer = 1;
	word8 tk[4][`MAXKC];
	
	for (j = 0; j < KC; j++) begin
		for(i = 0; i < 4; i++) begin
			tk[i][j] = k[i][j];
		end	
	end
	
	t = 0;
	// prepare values into round key array
	
	for (j = 0; (j < KC) && (t < (ROUNDS + 1)*BC); j++, t++) begin
		for (i = 0; i < 4; i++) begin 
			W[t/BC][i][t % BC] = tk[i][j];
		end	
	end
	while (t < (ROUNDS + 1) * BC) begin
	
		//function g non liniar 4 bytes input 
		for (i = 0; i < 4; i++) begin
			tk[i][0] = tk[i][0] ^ computed_val.S[tk[(i+1) % 4][KC -1]];
		end
		
		tk[0][0] = tk[0][0] ^ computed_val.RC[RCpointer++];
		//
		
		if (KC <= 6) begin
			for( j = 1; j < KC; j++) begin
				for (i = 0; i < 4; i++) begin
					tk[i][j] = tk[i][j] ^ tk[i][j-1];
				end
			end
		end
		
		else begin
			for (j = 1; j < 4; j++) begin
				for (i = 0; i < 4; i++) begin
					tk[i][j] = tk[i][j] ^ tk[i][j-1];
				end
			end
			for (i = 0; i < 4; i++) begin
				tk[i][4] = tk[i][4] ^ computed_val.S[tk[i][3]];
			end
			for (j = 5; j < KC; j++) begin
				tk[i][j] = tk[i][j] ^ tk[i][j-1];
			end			
		end	
		
		for (j = 0; (j < KC) && (t < (ROUNDS + 1)*BC); j++, t++) begin
			for (i = 0; i < 4; i++) begin
				W[t/BC][i][t%BC] = tk[i][j];
			end
		end
			
	end	
	return 0;
endfunction : KeyExpansion

function int AesCore :: Encrypt ( ref word8 a[4][`MAXBC], word8 rk[`MAXROUNDS + 1][4][`MAXBC]);
 	int r;
	int i, j;
	AddRoundKey(rk[0], a);
	printBlockLiniar("ENCRYPT ROUND KEY", a);
	for(r = 1; r < ROUNDS; r++) begin
		printBlockLiniar("ENCRYPT ROUND KEY", rk[r]);
		SubBytes(computed_val.S, a);
		printBlockLiniar("ENCRYPT After Subbyte", a);
		ShiftRows(0, a);
		printBlockLiniar("ENCRYPT After ShiftRow", a);
		MixColumn(a);
		printBlockLiniar("ENCRYPT After MixColumn", a);
		AddRoundKey(rk[r], a);
		printBlockLiniar("ENCRYPT After AddRound", a);
		$display("ENCRYPT ROUND %d\n", r);
	end 
	$display("\n");
	printBlockLiniar("ENCRYPT ROUND KEY",  rk[r]);
	SubBytes(computed_val.S, a);
	printBlockLiniar("ENCRYPT After Subbyte", a);
 	ShiftRows(0, a);
	printBlockLiniar("ENCRYPT After ShiftRow", a);
	AddRoundKey(rk[ROUNDS], a); 
	printBlockLiniar("ENCRYPT After AddRound", a);
	$display("ENCRYPT ROUND %d\n", r);
	
	return 0;
endfunction : Encrypt

function int AesCore :: Decrypt ( ref word8 a[4][`MAXBC],ref  word8 rk[`MAXROUNDS + 1][4][`MAXBC]);
	int r;
	// for decryption methods, apply the operation in oposite order 
	AddRoundKey(rk[ROUNDS], a);
	printBlockLiniar("ROUND KEY", rk[ROUNDS]);
	printBlockLiniar("Init Data", a);
	SubBytes(computed_val.Si, a);
	printBlockLiniar("Data After SubByte", a);
	ShiftRows(1,a);
	printBlockLiniar("Data after Shift Round", a);
	for (r = ROUNDS -1; r > 0; r--) begin
		$display("\n");
		printBlockLiniar("ROUND KEY", rk[r]);
		AddRoundKey(rk[r], a);
		printBlockLiniar("After AddRound", a);
		InvMixColumn(a);
		printBlockLiniar("After InvMixColumn", a);
		SubBytes(computed_val.Si, a);
		printBlockLiniar("After SubByte", a);
		ShiftRows(1, a);
		printBlockLiniar("After ShiftRows", a);
	end
	
	AddRoundKey(rk[0], a);
endfunction : Decrypt


function void AesCore:: printBlockLiniar(string start_mesage, word8 a[4][`MAXBC]);
	int i, j;
	string value = "";
	string current_byte;
	for (j = 0; j < BC; j++) begin
			for ( i = 0; i < BC; i++) begin
				$sformat(current_byte, "%02X", a[i][j]);
				value = {value, current_byte};
			end
	end
	$display("[%0t] %0s: %0s - %0s ", $time, super.name, start_mesage, value);
endfunction:printBlockLiniar



function void AesCore:: setDataBlock(logic [127:0] text, ref word8 a[4][`MAXBC]);
		
		int i, j;
		int index = 15;
		
		for (j = 0; j < BC; j++) begin
			for ( i = 0; i < BC; i++) begin
				a[i][j] = text[`RANGE_U8(index)];
				index--;
			end
		end

endfunction : setDataBlock

function logic [127:0] AesCore:: getDataFromBlock(word8 a[4][`MAXBC]);
	int i, j;
	logic [127:0] text = 0;
	int index = 15;
	
		for (j = 0; j < BC; j++) begin
			for ( i = 0; i < BC; i++) begin
				text[`RANGE_U8(index)] = a[i][j];
				index--;
			end
		end
	return text;
endfunction: getDataFromBlock


function logic [127:0] AesCore:: apiGetCipher(logic [127:0] text, logic [127:0] key);
	logic [127:0] cipher;
	word8 rk[`MAXROUNDS + 1][4][`MAXBC], sk[4][`MAXKC];
	setDataBlock(text, data_block);
	//printBlockLiniar("DBG - After Set PlainText", data_block);
	
	setDataBlock(key, sk);
	//printBlockLiniar("DBG - After Set Key", sk);
	KeyExpansion(sk, rk);
	Encrypt(data_block, rk);
	//printBlockLiniar("DBG", data_block);
	cipher = getDataFromBlock(data_block);
	//$display("[%0t] %0s: DBG Cipher = %0h ", $time, super.name,cipher);
	
	return cipher;
endfunction: apiGetCipher

function logic [127:0] AesCore:: apiGetPlaintext(logic [127:0] cipher, logic [127:0] key);
	logic [127:0] plaitext;
	word8 rk[`MAXROUNDS + 1][4][`MAXBC], sk[4][`MAXKC];
	setDataBlock(cipher, data_block);
	setDataBlock(key, sk);
	KeyExpansion(sk, rk);
	Decrypt(data_block, rk);
	plaitext = getDataFromBlock(data_block);
	return plaitext;
endfunction: apiGetPlaintext

task AesCore :: run();
	int i, j;
	
	word8 a[4][`MAXBC], rk[`MAXROUNDS + 1][4][`MAXBC], sk[4][`MAXKC];
	

	for ( i = 0; i < BC; i++) begin
		for (j = 0; j < BC; j++) begin
			a[i][j] = 0;
		end		
	end
	
	for (j = 0; j < KC; j++) begin
		for ( i = 0; i < 4; i++) begin
			sk[i][j] = 0;
		end		
	end
	
	printBlockLiniar("LiniarBlockPlaintext", a);
	
	KeyExpansion(sk, rk);
	//MixColumn(a);
	Encrypt(a, rk);
	printBlockLiniar("LiniarBlockCipher", a);
	
	/*
	Encrypt(a, rk);
	
	$display("\nCipher ");
	for (j = 0; j < BC; j++) begin
		for ( i = 0; i < BC; i++) begin
			$write("%0h", a[i][j]);
		end
	end
	Decrypt(a, rk);
	Decrypt(a, rk);
	
	$display("\nCipher Decrypt");
	for (j = 0; j < BC; j++) begin
		for ( i = 0; i < BC; i++) begin
			$write("%0h", a[i][j]);
		end
	end */
	#10;
endtask : run