`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:14 02/02/2012 
// Design Name: 
// Module Name:    Accumulator 
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
module Accumulator(
	input wire [num_bits-1:0] in,
	input wire clock,
	input wire reset_n,
	
	output wire [num_bits_out-1:0] window_sum
    );
	
	parameter window_size=5;
	parameter num_bits=11;
	parameter num_bits_out=14;
	
	wire [num_bits-1:0] cons [window_size-1:0]; //Connects delay registers together
	
	//Adds new value, sum, and remove old value
	AddSubtract #(num_bits_out,num_bits) as1 (
		.in1		(window_sum),
		.in2		(in),
		.in3		(cons[window_size-1]),
		.clock	(clock),
		.reset_n (reset_n),
		.out		(window_sum)
	);
	
	//Creates the same number of delay registers as the window size
	genvar i;	
	generate
		DelayReg #(num_bits) dreg1 (
			.in		(in),
			.clock	(clock),
			.reset_n (reset_n),
			.out		(cons[0])
		);
		for (i=0; i<window_size-1; i=i+1)
		begin: create_delay
			DelayReg #(num_bits) dreg (
			.in		(cons[i]),
			.clock	(clock),
			.reset_n (reset_n),
			.out		(cons[i+1])
			);
		end
	endgenerate
	
endmodule
