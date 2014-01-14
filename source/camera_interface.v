`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:30:54 05/10/2012 
// Design Name: 
// Module Name:    camera_interface 
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
module camera_interface(
    input wire pixel_clock,
    input wire frame_valid,
    input wire line_valid,
    input wire [7:0] pixel_data,
    
    output reg reset_n,
    output reg [9:0] pixels_ps,
    output reg read_start,
    output reg left_valid,
    output reg right_valid,
    output reg [2:0] select_ps,
    output reg [7:0] data
    );
    
    parameter RESET_1           = 4'b0000;
    parameter RESET_2           = 4'b0001;
    parameter RESET_3           = 4'b0010;
    parameter RESET_4           = 4'b0011;
    parameter RESET_5           = 4'b0100;
    parameter FIND_FRAME_1      = 4'b0101;
    parameter FIND_FRAME_2      = 4'b0110;
    parameter FIND_FRAME_3      = 4'b0111;
    parameter FIND_LINE_1       = 4'b1000;
    parameter FIND_LINE_2       = 4'b1001;
    parameter READ_LEFT         = 4'b1010;
    parameter READ_RIGHT        = 4'b1011;
    
    //State Machine Connections
    //_ps = present state
    //_ns = next state
    reg [3:0] stream_vid_ps;
    reg [3:0] stream_vid_ns;
    //Counter Connections
    reg [9:0] pixels_ns;
    reg [8:0] lines_ps;
    reg [8:0] lines_ns;
    reg pixels_en;
    reg lines_en;
    //Valid connections
    reg left_valid_ns;
    reg right_valid_ns;
    //Select
    reg [2:0] select_delay;
    reg [2:0] select_ns;
    reg select_en;
    reg select_r;
    
    //Initialize values
    initial
    begin
        stream_vid_ps   <= RESET_1;
        stream_vid_ns   <= RESET_1;
        pixels_ps       <= 2;
        pixels_ns       <= 2;
        lines_ps        <= 0;
        lines_ns        <= 0;
        pixels_en       <= 0;
        lines_en        <= 0;
        select_ps       <= 0;
        select_delay    <= 0;
        select_ns       <= 0;
        select_en       <= 0;
        select_r        <= 0;
        left_valid      <= 0;
        right_valid     <= 0;
        data            <= 0;
    end
    
    //**********************************************************
    // Main state machine
    //**********************************************************
    always @(posedge pixel_clock)
    begin
        stream_vid_ps   <= stream_vid_ns;
    end
    
    always @(stream_vid_ps, frame_valid, line_valid, pixels_ps, lines_ps)
    begin
    
        stream_vid_ns   <= stream_vid_ps;
        pixels_en       <= 1'b0;
        lines_en        <= 1'b0;
        select_en       <= 1'b0;
        select_r        <= 1'b0;
        read_start      <= 1'b0;
        reset_n         <= 1'b1;
        
        case (stream_vid_ps)
            RESET_1:            begin
                                    reset_n             <= 1'b0;
                                    stream_vid_ns       <= RESET_2;
                                end
                                
            RESET_2:            begin
                                    reset_n             <= 1'b0;
                                    stream_vid_ns       <= RESET_3;
                                end
                                
            RESET_3:            begin
                                    reset_n             <= 1'b0;
                                    stream_vid_ns       <= RESET_4;
                                end
                                
            RESET_4:            begin
                                    reset_n             <= 1'b0;
                                    stream_vid_ns       <= RESET_5;
                                end
                                
            RESET_5:            begin
                                    reset_n             <= 1'b0;
                                    stream_vid_ns       <= FIND_FRAME_1;
                                end
                                
            FIND_FRAME_1:    begin
                                    if (frame_valid == 0)
                                        stream_vid_ns   <= FIND_FRAME_2;
                                end
            
            FIND_FRAME_2:    begin
                                    if (frame_valid == 0)
                                        stream_vid_ns   <= FIND_FRAME_3;
                                    else
                                        stream_vid_ns   <= FIND_FRAME_1;
                                end
                                
            FIND_FRAME_3:    begin
                                    if (frame_valid == 1)
                                        stream_vid_ns   <= FIND_LINE_1;
                                end
                                
            FIND_LINE_1:    begin
                                    if (line_valid == 0)
                                    begin
                                        stream_vid_ns   <= FIND_LINE_2;
                                    end
                                end
                                
            FIND_LINE_2:    begin
                                    if (line_valid == 1)
                                    begin
                                        pixels_en       <= 1'b1;
                                        stream_vid_ns   <= READ_LEFT;
                                    end
                                end
                                
            READ_LEFT:        begin
                                    if (pixels_ps == 641)
                                    begin
                                        pixels_en       <= 1'b1;
                                        stream_vid_ns   <= READ_RIGHT;
                                    end
                                    else
                                    begin
                                        pixels_en       <= 1'b1;
                                    end                                        
                                end
                                
            READ_RIGHT:        begin
                                    if (pixels_ps == 641 && lines_ps == 479)
                                    begin
                                        read_start      <= 1'b1;
                                        pixels_en       <= 1'b1;
                                        lines_en        <= 1'b1;
                                        select_r        <= 1'b1;
                                        stream_vid_ns   <= FIND_FRAME_1;
                                    end
                                    else if (pixels_ps == 641 && lines_ps >= 5)
                                    begin
                                        read_start      <= 1'b1;
                                        pixels_en       <= 1'b1;
                                        lines_en        <= 1'b1;
                                        select_en       <= 1'b1;
                                        stream_vid_ns   <= FIND_LINE_1;
                                    end
                                    else if (pixels_ps == 641)
                                    begin
                                        pixels_en       <= 1'b1;
                                        lines_en        <= 1'b1;
                                        select_en       <= 1'b1;
                                        stream_vid_ns   <= FIND_LINE_1;
                                    end
                                    else
                                    begin
                                        pixels_en       <= 1'b1;
                                    end                                        
                                end
        endcase
    end
    
    //**********************************************************
    // Valid state machines
    //**********************************************************
    always @(posedge pixel_clock)
    begin
        data                <= {pixel_data[7:5], 5'b0}; //Use only the top 3 bits to "color blob"
        left_valid          <= left_valid_ns;
        right_valid         <= right_valid_ns;
    end    
    
    always @(stream_vid_ps, line_valid)
    begin
        if (((stream_vid_ps == FIND_LINE_2) && (line_valid == 1)) || (stream_vid_ps == READ_LEFT))
            left_valid_ns   <= 1'b1;
        else
            left_valid_ns   <= 1'b0;
    end
    
    always @(stream_vid_ps)
    begin
        if (stream_vid_ps == READ_RIGHT)
            right_valid_ns  <= 1'b1;
        else
            right_valid_ns  <= 1'b0;
    end
    
    //**********************************************************
    // Counter state machines
    //**********************************************************
    always @(posedge pixel_clock)
    begin
        pixels_ps           <= pixels_ns;
    end
    
    always @(pixels_en, pixels_ps)
    begin
        if (pixels_en)
        begin
            if (pixels_ps == 641)
                pixels_ns   <= 2;
            else
                pixels_ns   <= pixels_ps + 1'b1;
        end
        else
            pixels_ns       <= pixels_ps;
    end
    
    
    always @(posedge pixel_clock)
    begin
        lines_ps             <= lines_ns;
    end
    
    always @(lines_en, lines_ps)
    begin
        if (lines_en)
        begin
            if (lines_ps == 479)
                lines_ns    <= 0;
            else
                lines_ns    <= lines_ps + 1'b1;
        end
        else
            lines_ns        <= lines_ps;
    end
    
    
    always @(posedge pixel_clock)
    begin
        select_ps           <= select_delay;
        select_delay        <= select_ns;
    end
    
    always @(select_en, select_ps, select_r)
    begin
        if (select_en)
        begin
            if (select_ps == 5)
                select_ns   <= 0;
            else
                select_ns   <= select_ps + 1'b1;
        end
        else if (select_r)
            select_ns       <= 0;
        else
            select_ns       <= select_ps;
    end
endmodule
