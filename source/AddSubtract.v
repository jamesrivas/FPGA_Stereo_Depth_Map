`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:01:04 02/02/2012 
// Design Name: 
// Module Name:    AddSubtract 
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
module AddSubtract(
    input wire [num_bits_1-1:0] in1,
    input wire [num_bits_2-1:0] in2,
	 input wire [num_bits_2-1:0] in3,
	 input wire clock,
	 input wire reset_n,
    output reg [num_bits_1-1:0] out
	 );
	 
	initial
	begin
		out = 0;
	end
	 
	parameter num_bits_1=16;
	parameter num_bits_2=12;
	 
	always @(posedge clock or negedge reset_n)
	begin: add
		if(~reset_n)
			out = 0;
		else
			out = in1+in2-in3;
	end
endmodule
