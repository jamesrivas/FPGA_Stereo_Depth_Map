`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:03 04/19/2012 
// Design Name: 
// Module Name:    mux_6_to_1 
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
module mux_6_to_1(
	//input wire clock,
	input wire [7:0] data_0,
	input wire [7:0] data_1,
	input wire [7:0] data_2,
	input wire [7:0] data_3,
	input wire [7:0] data_4,
	input wire [7:0] data_5,
	input wire [2:0] select,
	
	output reg [7:0] data_out
    );
	 
	//********************************************************
	//Multiplexors
	//********************************************************
	always @(select, data_0, data_1, data_2, data_3, data_4, data_5)
	begin
		case(select)
			0:			data_out <= data_1;		
			1:			data_out <= data_2;					
			2:			data_out <= data_3;				
			3:			data_out <= data_4;					
			4:			data_out <= data_5;		
			5:			data_out <= data_0;
			default:	data_out <= 8'bx;
		endcase
	end
endmodule
