`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:19:25 04/25/2012 
// Design Name: 
// Module Name:    fifo_buffer 
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
module fifo_buffer(
	input wire clock,
	input wire [19:0] data_in,
	input wire valid,
	input wire [5:0] disparity,
	input wire read,
	
	output wire empty,
	output wire [19:0] data_out
    );
	
	reg [19:0] din;
	reg wr_en;
	reg rd_en;
	
	//synthesis attribute box_type disparity_fifo "black_box"
	disparity_fifo buff (
		.clk			(clock),
		.din			(din),
		.wr_en		(wr_en),
		.rd_en		(rd_en),
		.dout			(data_out),
		.full			(),
		.empty		(empty)
	);
	
	
	always @(valid, disparity, data_in, data_out, read)
	begin
		if (valid == 1)
		begin
			if (disparity == 0)
			begin
				wr_en		<= 1;
				rd_en		<= 0;
				din		<= data_in;
			end
			else
			begin
				wr_en		<= 1;
				rd_en		<= 1;
				if (data_in[13:0] < data_out[13:0])
					din	<= data_in;
				else
					din	<= data_out;
			end
		end
		else if (read == 1)
		begin
			wr_en <= 0;
			rd_en <= 1;
			din	<= 0;
		end
		else
		begin
			wr_en <= 0;
			rd_en <= 0;
			din	<= 0;
		end
	end

endmodule
