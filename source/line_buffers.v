`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:29:24 04/13/2012 
// Design Name: 
// Module Name:    line_buffers 
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
module line_buffers(
	input wire clock_slow,
	input wire clock_fast,
	input wire write_enable,
	input wire [9:0] address_in,
	input wire [7:0] data_in,
	input wire read_enable,
	input wire [9:0] address_out,
	input wire [2:0] select,
	
	output wire [7:0] data_out_1,	
	output wire [7:0] data_out_2,	
	output wire [7:0] data_out_3,	
	output wire [7:0] data_out_4,	
	output wire [7:0] data_out_5
    );
	
	wire [7:0] data_0;
	wire [7:0] data_1;
	wire [7:0] data_2;
	wire [7:0] data_3;
	wire [7:0] data_4;
	wire [7:0] data_5;
	
	wire enable_0;
	wire enable_1;
	wire enable_2;
	wire enable_3;
	wire enable_4;
	wire enable_5;	
	
	//***********************************************************
	//Buffers
	//***********************************************************
	//synthesis attribute box_type line_buffer "black_box"
	line_buffer buff_0(
	  .clka		(clock_slow),
	  .wea		(enable_0),
	  .addra		(address_in),
	  .dina		(data_in),
	  .clkb		(clock_fast),
	  .enb		(~enable_0 & read_enable),
	  .addrb		(address_out),
	  .doutb		(data_0)
	);
	
	line_buffer buff_1(
	  .clka		(clock_slow),
	  .wea		(enable_1),
	  .addra		(address_in),
	  .dina		(data_in),
	  .clkb		(clock_fast),
	  .enb		(~enable_1 & read_enable),
	  .addrb		(address_out),
	  .doutb		(data_1)
	);
	
	line_buffer buff_2(
	  .clka		(clock_slow),
	  .wea		(enable_2),
	  .addra		(address_in),
	  .dina		(data_in),
	  .clkb		(clock_fast),
	  .enb		(~enable_2 & read_enable),
	  .addrb		(address_out),
	  .doutb		(data_2)
	);
	
	line_buffer buff_3(
	  .clka		(clock_slow),
	  .wea		(enable_3),
	  .addra		(address_in),
	  .dina		(data_in),
	  .clkb		(clock_fast),
	  .enb		(~enable_3 & read_enable),
	  .addrb		(address_out),
	  .doutb		(data_3)
	);
	
	line_buffer buff_4(
	  .clka		(clock_slow),
	  .wea		(enable_4),
	  .addra		(address_in),
	  .dina		(data_in),
	  .clkb		(clock_fast),
	  .enb		(~enable_4 & read_enable),
	  .addrb		(address_out),
	  .doutb		(data_4)
	);
	
	line_buffer buff_5(
	  .clka		(clock_slow),
	  .wea		(enable_5),
	  .addra		(address_in),
	  .dina		(data_in),
	  .clkb		(clock_fast),
	  .enb		(~enable_5 & read_enable),
	  .addrb		(address_out),
	  .doutb		(data_5)
	);
	
	//********************************************************
	//Write Enable Selector
	//********************************************************
	decoder dec(
		.write_enable	(write_enable),
		.select			(select),
		.enable_0		(enable_0),
		.enable_1		(enable_1),
		.enable_2		(enable_2),
		.enable_3		(enable_3),
		.enable_4		(enable_4),
		.enable_5		(enable_5)
	);
	
	//********************************************************
	//Multiplexors
	//********************************************************
	mux_6_to_1 mux1(
		//.clock			(clock),
		.data_0			(data_0),
		.data_1			(data_1),
		.data_2			(data_2),
		.data_3			(data_3),
		.data_4			(data_4),
		.data_5			(data_5),
		.select			(select),
		.data_out		(data_out_1)
	);
	
	mux_6_to_1 mux2(
		//.clock			(clock),
		.data_0			(data_1),
		.data_1			(data_2),
		.data_2			(data_3),
		.data_3			(data_4),
		.data_4			(data_5),
		.data_5			(data_0),
		.select			(select),
		.data_out		(data_out_2)
	);
	
	mux_6_to_1 mux3(
		//.clock			(clock),
		.data_0			(data_2),
		.data_1			(data_3),
		.data_2			(data_4),
		.data_3			(data_5),
		.data_4			(data_0),
		.data_5			(data_1),
		.select			(select),
		.data_out		(data_out_3)
	);
	
	mux_6_to_1 mux4(
		//.clock			(clock),
		.data_0			(data_3),
		.data_1			(data_4),
		.data_2			(data_5),
		.data_3			(data_0),
		.data_4			(data_1),
		.data_5			(data_2),
		.select			(select),
		.data_out		(data_out_4)
	);
	
	mux_6_to_1 mux5(
		//.clock			(clock),
		.data_0			(data_4),
		.data_1			(data_5),
		.data_2			(data_0),
		.data_3			(data_1),
		.data_4			(data_2),
		.data_5			(data_3),
		.select			(select),
		.data_out		(data_out_5)
	);
	
endmodule
