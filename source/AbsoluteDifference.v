`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:05 02/01/2012 
// Design Name: 
// Module Name:    AbsoluteDifference 
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
module AbsoluteDifference(
	input wire [num_bits*window_size-1:0] in1,
	input wire [num_bits*window_size-1:0] in2,
	input wire clock,
	input wire reset_n,
	
	output wire [num_bits*window_size-1:0] out
    );
	
	parameter window_size=5;
	parameter num_bits=8;
	
	genvar i;
	
	generate	
		for (i=0; i<window_size; i=i+1)
		begin: abs_dif
			Subtractor #(num_bits) s1 (
				.in1		(in1[num_bits*i+:num_bits]),
				.in2		(in2[num_bits*i+:num_bits]),
				.clock	(clock),
				.reset_n	(reset_n),
				.out		(out[num_bits*i+:num_bits])
			);
		end
	endgenerate
	
endmodule
