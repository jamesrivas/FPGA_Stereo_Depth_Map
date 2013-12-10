`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:17:28 02/01/2012 
// Design Name: 
// Module Name:    Subtractor 
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
module Subtractor(
	input wire clock,
	input wire reset_n,
	input wire [num_bits-1:0] in1,
	input wire [num_bits-1:0] in2,	
	output reg [num_bits-1:0] out
    );
	
	initial
	begin
		out = 0;
	end
	
	parameter num_bits=8;
	
	always @(posedge clock or negedge reset_n)
	begin: abs_diff
		if(~reset_n)
			out = 0;
		else
		begin
			if (in1>in2)
			begin
				out=in1-in2;
			end
			else
			begin
				out=in2-in1;
			end
		end
	end
	
	
//	reg [num_bits:0] diff;
//	wire diff_neg = diff[num_bits];
//	always @(posedge clock) begin
//		 // compute difference
//		 diff <= {1'b0,in1} - {1'b0,in2};
//		 // take absolute value
//		 out <= ( diff[num_bits-1:0] ^ {num_bits{diff_neg}} ) + {{(num_bits-1){1'b0}},diff_neg};
//	end
	
endmodule
