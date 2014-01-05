`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:05 04/24/2012 
// Design Name: 
// Module Name:    compare_ws 
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
module compare_ws(
    input wire clock,
    input wire reset_n,
    input wire [13:0] ws1,
    input wire [13:0] ws2,
    input wire [13:0] ws3,
    input wire [13:0] ws4,
    input wire [5:0] disp_1,
    input wire [5:0] disp_2,
    input wire [5:0] disp_3,
    input wire [5:0] disp_4,
    
    output wire [5:0]  disparity,
    output wire [13:0] window_sum
    );
    
    wire [13:0] con1;
    wire [13:0] con2;
    wire [5:0]  con3;
    wire [5:0]  con4;
    
    comparator compare_1 (
    .clock              (clock),
    .reset_n            (reset_n),
    .ws1                (ws1),
    .ws2                (ws2),
    .disp1              (disp_1),
    .disp2              (disp_2),
    .disparity          (con3),
    .window_sum         (con1)
    );
    
    comparator compare_2 (
    .clock              (clock),
    .reset_n            (reset_n),
    .ws1                (ws3),
    .ws2                (ws4),
    .disp1              (disp_3),
    .disp2              (disp_4),
    .disparity          (con4),
    .window_sum         (con2)
    );
    
    comparator compare_3 (
    .clock              (clock),
    .reset_n            (reset_n),
    .ws1                (con1),
    .ws2                (con2),
    .disp1              (con3),
    .disp2              (con4),
    .disparity          (disparity),
    .window_sum         (window_sum)
    );    
    

endmodule
