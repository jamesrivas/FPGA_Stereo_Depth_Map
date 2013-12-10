`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:04 01/17/2012 
// Design Name: 
// Module Name:    Adder 
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
module Adder(
	 input wire clock,
	 input wire reset_n,
    input wire [data1-1:0] in1,
    input wire [data2-1:0] in2,
    output reg [out_bits:0] sum
	 );
	 
	initial
	begin
		sum = 0;
	end
	 
	parameter data1=8;
	parameter data2=8;
	parameter out_bits=data1;
	 
	always @(posedge clock or negedge reset_n)
	begin: add
		if(~reset_n)
			sum = 0;
		else
			sum=in1+in2;
	end

endmodule
