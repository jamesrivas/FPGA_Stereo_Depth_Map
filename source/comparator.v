`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:12:31 04/24/2012 
// Design Name: 
// Module Name:    comparator 
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
module comparator(
	input wire clock,
	input wire reset_n,
	input wire [13:0] ws1,
	input wire [13:0] ws2,
	input wire [5:0] disp1,
	input wire [5:0] disp2,
		
	output reg [5:0] disparity,
	output reg [13:0] window_sum
	 );
	
	initial
	begin
		disparity	<= 0;
		window_sum 	<= 0;
	end
	
	always @(posedge clock or negedge reset_n)
	begin
		if(~reset_n)
		begin
			disparity	<= 0;
			window_sum 	<= 0;
		end
		else
		begin
			if (ws2 < ws1)
			begin
				window_sum <= ws2;
				disparity <= disp2;
			end
			else
			begin
				window_sum <= ws1;
				disparity <= disp1;
			end
		end
	end

endmodule
