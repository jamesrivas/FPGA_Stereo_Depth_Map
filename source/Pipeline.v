`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:53 02/29/2012 
// Design Name: 
// Module Name:    Pipeline 
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
module Pipeline(
	input wire clock,
	input wire reset_n,
	input wire [num_bits*window_size-1:0] in_left,
	input wire [num_bits*window_size-1:0] in_right,
	
	output wire [num_bits_out-1:0] window_sum
    );
	
	//window_size=5 num_bits_out_add=11 num_bits_out=14
	
	parameter window_size=5;
	parameter num_bits=8;
	parameter num_bits_out_add=11;
	parameter num_bits_out=14;
	
	wire [num_bits*window_size-1:0] abs_difs;
	wire [num_bits_out_add-1:0] sum;
	
	AbsoluteDifference #(window_size,num_bits) absdif (
		.in1		(in_left),
		.in2		(in_right),
		.clock	    (clock),
		.reset_n    (reset_n),
		.out		(abs_difs)
	);
	
	AdderTree #(window_size,num_bits,num_bits_out_add) add (
		.abs_difs	(abs_difs),
		.clock		(clock),
		.reset_n	(reset_n),
		.sum		(sum)
	);

	Accumulator #(window_size,num_bits_out_add,num_bits_out) acc (
		.in			(sum),
		.clock		(clock),
		.reset_n	(reset_n),
		.window_sum	(window_sum)
	);
	
endmodule
