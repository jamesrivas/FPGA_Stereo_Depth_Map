`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:16 04/19/2012 
// Design Name: 
// Module Name:    buffer_to_pipeline 
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
module buffer_to_pipeline(
    input wire clock_slow,
    input wire clock_fast,
    input wire reset_n,
    input wire read_start,
    input wire left_enable,
    input wire right_enable,
    input wire [9:0] address_in,
    input wire [7:0] data_in,
    input wire [2:0] select,
    
    output wire [39:0] out_left,
    output wire [39:0] out_right_1,
    output wire [39:0] out_right_2,
    output wire [39:0] out_right_3,
    output wire [39:0] out_right_4
    );
    
    
    //***********************************************************************
    //Address counters
    //***********************************************************************
    wire read_enable;
    wire [9:0] address_left; 
    wire [9:0] address_right_1;
    wire [9:0] address_right_2; 
    wire [9:0] address_right_3; 
    wire [9:0] address_right_4; 
    
    ram_counters count(
    //Inputs
    .clock              (clock_fast),
    .reset_n            (reset_n),
    .read_start         (read_start),
    //Outputs
    .read_enable        (read_enable),
    .address_left_1     (address_left),
    .address_right_1    (address_right_1),
    .address_right_2    (address_right_2),
    .address_right_3    (address_right_3),
    .address_right_4    (address_right_4)
    );
    
    //**********************************************************************
    //Left image line buffers
    //**********************************************************************
    line_buffers buff_left(
    //Inputs
    .clock_slow         (clock_slow),
    .clock_fast         (clock_fast),
    .write_enable       (left_enable),
    .address_in         (address_in),
    .data_in            (data_in),
    .read_enable        (read_enable),
    .address_out        (address_left),
    .select             (select),
    //Outputs
    .data_out_1         (out_left[7:0]),
    .data_out_2         (out_left[15:8]),
    .data_out_3         (out_left[23:16]),
    .data_out_4         (out_left[31:24]),
    .data_out_5         (out_left[39:32])   
    );
    
    //**********************************************************************
    //Right image line buffers
    //**********************************************************************
    line_buffers buff_right_1(
    //Inputs
    .clock_slow         (clock_slow),
    .clock_fast         (clock_fast),
    .write_enable       (right_enable),
    .address_in         (address_in),
    .data_in            (data_in),
    .read_enable        (read_enable),
    .address_out        (address_right_1),
    .select             (select),
    //Outputs
    .data_out_1         (out_right_1[7:0]),
    .data_out_2         (out_right_1[15:8]),
    .data_out_3         (out_right_1[23:16]),
    .data_out_4         (out_right_1[31:24]),
    .data_out_5         (out_right_1[39:32])    
    );
    
    line_buffers buff_right_2(
    //Inputs
    .clock_slow         (clock_slow),
    .clock_fast         (clock_fast),
    .write_enable       (right_enable),
    .address_in         (address_in),
    .data_in            (data_in),
    .read_enable        (read_enable),
    .address_out        (address_right_2),
    .select             (select),
    //Outputs
    .data_out_1         (out_right_2[7:0]),
    .data_out_2         (out_right_2[15:8]),
    .data_out_3         (out_right_2[23:16]),
    .data_out_4         (out_right_2[31:24]),
    .data_out_5         (out_right_2[39:32])    
    );
    
    line_buffers buff_right_3(
    //Inputs
    .clock_slow         (clock_slow),
    .clock_fast         (clock_fast),
    .write_enable       (right_enable),
    .address_in         (address_in),
    .data_in            (data_in),
    .read_enable        (read_enable),
    .address_out        (address_right_3),
    .select             (select),
    //Outputs
    .data_out_1         (out_right_3[7:0]),
    .data_out_2         (out_right_3[15:8]),
    .data_out_3         (out_right_3[23:16]),
    .data_out_4         (out_right_3[31:24]),
    .data_out_5         (out_right_3[39:32])        
    );
    
    line_buffers buff_right_4(
    //Inputs
    .clock_slow         (clock_slow),
    .clock_fast         (clock_fast),
    .write_enable       (right_enable),
    .address_in         (address_in),
    .data_in            (data_in),
    .read_enable        (read_enable),
    .address_out        (address_right_4),
    .select             (select),
    //Outputs
    .data_out_1         (out_right_4[7:0]),
    .data_out_2         (out_right_4[15:8]),
    .data_out_3         (out_right_4[23:16]),
    .data_out_4         (out_right_4[31:24]),
    .data_out_5         (out_right_4[39:32])    
    );

endmodule
