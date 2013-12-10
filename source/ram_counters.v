`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:04:17 04/18/2012 
// Design Name: 
// Module Name:    ram_counters 
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
module ram_counters(
   input wire clock,
	input wire reset_n,
	input wire read_start, //Pulse high to read output addresses for one line's worth of data
	
	output wire read_enable,
	output reg [9:0] address_left_1,  //Output addresses for left image's line buffers
	output reg [9:0] address_right_1, //Output addresses for right image's line buffers
	output reg [9:0] address_right_2, //Output addresses for right image's line buffers
	output reg [9:0] address_right_3, //Output addresses for right image's line buffers
	output reg [9:0] address_right_4  //Output addresses for right image's line buffers
    );
	
	wire [9:0] address_left;
	wire [9:0] address_right;
	
	initial
	begin
		address_left_1  <= 0;
		address_right_1 <= 0;
		address_right_2 <= 1;
		address_right_3 <= 2;
		address_right_4 <= 3;
	end
	
	
	//For left image buffering
	//Should count from 0 to 643 16 times
	left_counter l_count (
		.rea				(read_start), 
		.clock			(clock),
		.read_enable	(read_enable),
		.addrb			(address_left)
	);
	
	
	//4 sets of buffers for the right image
	//These will be used with four stereo processing pipelines
	//Each one will need to be offset by one from the last one
	//They need to run through each 640 pixel row 16 times, for 16x4=64 disparity levels
	//The address_b for each one will need to be changed so that they can access different pixels and calculate four disparity levels at the same time.
	
	right_counter r_count (
		.rea		(read_start), 
		.clock	(clock),
		.addrb	(address_right)
	);
	
	//Updates output registers
	always @(address_left, address_right, reset_n)
	begin
		if(~reset_n)
		begin
			address_left_1  <= 0;
			address_right_1 <= 0;
			address_right_2 <= 1;
			address_right_3 <= 2;
			address_right_4 <= 3;
		end
		else
		begin
			address_left_1  <= address_left;
			address_right_1 <= address_right;
			address_right_2 <= address_right+2'b01;
			address_right_3 <= address_right+2'b10;
			address_right_4 <= address_right+2'b11;
		end
	end
	
endmodule
