`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:00 04/19/2012 
// Design Name: 
// Module Name:    decoder 
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
module decoder(
	input wire write_enable,
	input wire [2:0] select,
	
	output reg enable_0,
	output reg enable_1,
	output reg enable_2,
	output reg enable_3,
	output reg enable_4,
	output reg enable_5
    );
	
	always @(write_enable, select)
	begin
		if (write_enable==1)
		begin
			case(select)
				0:				begin
									enable_0 = 1;
									enable_1 = 0;
									enable_2 = 0;
									enable_3 = 0;
									enable_4 = 0;
									enable_5 = 0;
								end
				1:				begin
									enable_0 = 0;
									enable_1 = 1;
									enable_2 = 0;
									enable_3 = 0;
									enable_4 = 0;
									enable_5 = 0;
								end				
				2:				begin
									enable_0 = 0;
									enable_1 = 0;
									enable_2 = 1;
									enable_3 = 0;
									enable_4 = 0;
									enable_5 = 0;
								end				
				3:				begin
									enable_0 = 0;
									enable_1 = 0;
									enable_2 = 0;
									enable_3 = 1;
									enable_4 = 0;
									enable_5 = 0;
								end			
				4:				begin
									enable_0 = 0;
									enable_1 = 0;
									enable_2 = 0;
									enable_3 = 0;
									enable_4 = 1;
									enable_5 = 0;
								end
				5:				begin
									enable_0 = 0;
									enable_1 = 0;
									enable_2 = 0;
									enable_3 = 0;
									enable_4 = 0;
									enable_5 = 1;
								end
				default:		begin
									enable_0 = 1'bx;
									enable_1 = 1'bx;
									enable_2 = 1'bx;
									enable_3 = 1'bx;
									enable_4 = 1'bx;
									enable_5 = 1'bx;
								end
			endcase
		end
		
		else
		begin
			enable_0 = 0;
			enable_1 = 0;
			enable_2 = 0;
			enable_3 = 0;
			enable_4 = 0;
			enable_5 = 0;
		end
	end

endmodule
