`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:54:58 01/20/2012 
// Design Name: 
// Module Name:    AdderTree 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:  
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module AdderTree(
	input wire [num_bits*window_size-1:0] abs_difs,
	input wire clock,
	input wire reset_n,
	
	output wire [num_bits_out-1:0] sum
    );
	 
	parameter window_size = 5;
	parameter num_bits = 8;
	parameter num_bits_out = 11;
	
	//window_size=5 num_bits_out=11
	
	//Row 1------------------------------------------
	wire [num_bits:0] con11;
	Adder #(num_bits,num_bits) add11 (
		.in1		(abs_difs[num_bits*0+:num_bits]),
		.in2		(abs_difs[num_bits*1+:num_bits]),
		.clock	(clock),
		.reset_n (reset_n),
		.sum		(con11)			
	);
	wire [num_bits:0] con12;
	Adder #(num_bits,num_bits) add12 (
		.in1		(abs_difs[num_bits*2+:num_bits]),
		.in2		(abs_difs[num_bits*3+:num_bits]),
		.clock	(clock),
		.reset_n (reset_n),
		.sum		(con12)			
	);
	wire [num_bits-1:0] con13;
	DelayReg #(num_bits) reg13 (
		.in		(abs_difs[num_bits*4+:num_bits]),
		.clock	(clock),
		.reset_n (reset_n),
		.out		(con13)
	);

	//Row 2------------------------------------
	wire [num_bits+1:0] con21;
	Adder #(num_bits+1,num_bits+1) add21 (
		.in1		(con11),
		.in2		(con12),
		.clock	(clock),
		.reset_n (reset_n),
		.sum		(con21)			
	);
	wire [num_bits-1:0] con22;
	DelayReg #(num_bits) reg22 (
		.in		(con13),
		.clock	(clock),
		.reset_n (reset_n),
		.out		(con22)
	);

	//Row 3------------------------------------
	Adder #(num_bits+2,num_bits) add31 (
		.in1		(con21),
		.in2		(con22),
		.clock	(clock),
		.reset_n (reset_n),
		.sum		(sum)			
	);
	
endmodule
