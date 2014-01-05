`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:29:29 04/24/2012 
// Design Name: 
// Module Name:    toplevel 
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
module Main(
	input wire clock_100,
	input wire pixel_clock,
	input wire frame_valid,
	input wire line_valid,
	input wire [7:0] pixel_data,
	
	// FX2 interface
	input  wire      fx2Clk_in,     // 48MHz clock from FX2
	output wire[1:0] fx2Addr_out,   // select FIFO: "10" for EP6OUT, "11" for EP8IN
	inout  wire[7:0] fx2Data_io,    // 8-bit data to/from FX2
	output wire      fx2Read_out,   // asserted (active-low) when reading from FX2
	output wire      fx2OE_out,     // asserted (active-low) to tell FX2 to drive bus
	input  wire      fx2GotData_in, // asserted (active-high) when FX2 has data for us
	output wire      fx2Write_out,  // asserted (active-low) when writing to FX2
	input  wire      fx2GotRoom_in, // asserted (active-high) when FX2 has room for more data from us
	output wire      fx2PktEnd_out  // asserted (active-low) when a host read needs to be committed early

    );
	
	//200MHz clock to run stereo pipeline
	wire clock_200;
	
	//Signals for camera_interface
	wire reset_n;
	wire read_start;
	wire left_enable;
	wire right_enable;
	wire [9:0] address_in;
	wire [7:0] data_in;
	wire [2:0] select;
	
	//Input to the stereo pipeline
	wire [39:0] column_left;
	wire [39:0] column_right_1;
	wire [39:0] column_right_2;
	wire [39:0] column_right_3;
	wire [39:0] column_right_4;
	
	//Outputs from the pipeline
	wire [13:0] ws1;
	wire [13:0] ws2;
	wire [13:0] ws3;
	wire [13:0] ws4;
	
	//Disparity values that correspond to the pipeline outputs 
	wire [5:0] disparity_1;
	wire [5:0] disparity_2;
	wire [5:0] disparity_3;
	wire [5:0] disparity_4;
	
	//Final disparity and window sume values
	wire [5:0] disparity;
	wire [13:0] window_sum;
	
	//Signals for the output FIFO
	wire valid;
	wire [19:0] data_out;
	wire clear_buffer;
	wire valid_out;
    wire [7:0] decoded_output;
	
	
	clock_creator clks (
		.CLK_IN1		(clock_100),
		.CLK_OUT1	    (clock_200)
	);
	
	camera_interface cam (
		//Inputs 
		.pixel_clock	(pixel_clock),
		.frame_valid	(frame_valid),
		.line_valid		(line_valid),
		.pixel_data		(pixel_data),
		//Outputs
		.reset_n		(reset_n),
		.read_start		(read_start),
		.pixels_ps		(address_in),
		.left_valid		(right_enable), //INTENTIONALLY SWITCHED
		.right_valid	(left_enable),  //LEFT=RIGHT and RIGHT=LEFT
		.select_ps		(select),
		.data			(data_in)
	);	
	
	buffer_to_pipeline uut (
		//Inputs
		.clock_slow		(pixel_clock),
		.clock_fast		(clock_200),
		.reset_n		(reset_n),
		.read_start		(read_start), 
		.left_enable	(left_enable),
		.right_enable	(right_enable),
		.address_in		(address_in), 
		.data_in		(data_in),
		.select			(select),
		//Outputs
		.out_left       (column_left), 
		.out_right_1	(column_right_1), 
		.out_right_2	(column_right_2), 
		.out_right_3	(column_right_3), 
		.out_right_4	(column_right_4)
	);

	Pipeline pipe1 (
        //Inputs
		.clock		    (clock_200),
		.reset_n	    (reset_n),
		.in_left	    (column_left),
		.in_right	    (column_right_1),
		//Outputs
        .window_sum	    (ws1)
	);
	Pipeline pipe2 (
		//Inputs
        .clock		    (clock_200),
		.reset_n		(reset_n),
		.in_left		(column_left),
		.in_right	    (column_right_2),
		//Outputs
        .window_sum	    (ws2)
	);
	Pipeline pipe3 (
		//Inputs
        .clock		    (clock_200),
		.reset_n		(reset_n),
		.in_left		(column_left),
		.in_right	    (column_right_3),
		//Outputs
        .window_sum	    (ws3)
	);
	Pipeline pipe4 (
		//Inputs
        .clock		    (clock_200),
		.reset_n		(reset_n),
		.in_left		(column_left),
		.in_right	    (column_right_4),
		//Outputs
        .window_sum	    (ws4)
	);
	
	compare_ws compare (
		//Inputs
        .clock		    (clock_200),
		.reset_n		(reset_n),
		.ws1			(ws1),
		.ws2			(ws2),
		.ws3			(ws3),
		.ws4			(ws4),
		.disp_1		    (disparity_1),
		.disp_2		    (disparity_2),
		.disp_3		    (disparity_3),
		.disp_4		    (disparity_4),
		//Outputs
        .disparity	    (disparity),
		.window_sum	    (window_sum)
	);
	
	disparity_counter disp (
		//Inputs
        .clock			(clock_200),
		.reset_n		(reset_n),
		.read_start		(read_start),
		//Outputs
        .valid			(valid),
		.pixel			(),
		.disparity_1	(disparity_1),
		.disparity_2	(disparity_2),
		.disparity_3	(disparity_3),
		.disparity_4	(disparity_4),
		.clear_buffer	(clear_buffer)
	);
	
	fifo_buffer	fifo (
		//Inputs
        .clock			(clock_200),
		.data_in		({disparity, window_sum}),
		.valid			(valid),
		.disparity		(disparity_1),
		.read			(clear_buffer),
		//Outputs
        .empty			(),
		.data_out		(data_out)
	);
	
	output_decoder dec (
		//Inputs
        .clock			(clock_200),
		.valid_in		(clear_buffer),
		.data_in		(data_out[19:14]),
		//Outputs
        .valid_out		(valid_out),
		.data_out		(decoded_output)
	);
	
	FPGALink usb (
		//FX2
		.fx2Clk_in		(fx2Clk_in), 
		.fx2Addr_out	(fx2Addr_out), 
		.fx2Data_io		(fx2Data_io), 
		.fx2Read_out	(fx2Read_out), 
		.fx2OE_out		(fx2OE_out), 
		.fx2GotData_in	(fx2GotData_in), 
		.fx2Write_out	(fx2Write_out), 
		.fx2GotRoom_in	(fx2GotRoom_in), 
		.fx2PktEnd_out	(fx2PktEnd_out),
		//FIFO
		.data_clock		(clock_200), 
		.data_valid		(valid_out), 
		.data_in		(decoded_output)
	);

endmodule
