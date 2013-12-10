`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:16:43 01/19/2012 
// Design Name: 
// Module Name:    DelayReg 
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
module DelayReg(
    input wire [data-1:0] in,
	 input wire clock,
	 input wire reset_n,
    output reg [data-1:0] out
	 );
	 
	initial
	begin
		out = 0;
	end
	
	parameter data=8;
	 
	always @(posedge clock or negedge reset_n)
	begin: pass_value
		if(~reset_n)
			out = 0;
		else
			out = in;
	end
	
endmodule
