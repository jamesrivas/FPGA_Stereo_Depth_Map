`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:06:38 04/24/2012 
// Design Name: 
// Module Name:    disparity_counter 
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
module disparity_counter(
    input wire clock,
    input wire reset_n,
    input wire read_start,
    
    output reg valid,
    output reg [9:0] pixel,
    output reg [5:0] disparity_1,
    output reg [5:0] disparity_2,
    output reg [5:0] disparity_3,
    output reg [5:0] disparity_4,
    output reg clear_buffer
    );
    
    reg [1:0] state;
    reg [3:0] count;
    reg [4:0] cycle;
    reg [9:0] clear_buffer_count;
    
    initial
    begin
        valid                   <= 0;
        pixel                   <= 0;
        disparity_1             <= 63;
        disparity_2             <= 63;
        disparity_3             <= 63;
        disparity_4             <= 63;    
        state                   <= 0;
        count                   <= 0;
        cycle                   <= 0;
        clear_buffer            <= 0;
        clear_buffer_count      <= 0;
    end
    
    always @(posedge clock or negedge reset_n)
    begin
        if(~reset_n)
        begin
            valid               <= 0;
            pixel               <= 0;
            disparity_1         <= 63;
            disparity_2         <= 63;
            disparity_3         <= 63;
            disparity_4         <= 63;    
            state               <= 0;
            count               <= 0;
            cycle               <= 0;
            clear_buffer        <= 0;
            clear_buffer_count  <= 0;
        end
        else
        begin
            case (state)
                0:        begin
                            if (read_start == 1)
                            begin
                                count           <= 0;
                                disparity_1     <= 0;
                                disparity_2     <= 1;
                                disparity_3     <= 2;
                                disparity_4     <= 3;
                                state           <= 1;
                            end
                        end
                        
                1:        begin
                            //Wait until entire window has been summed by the pipeline
                            if (count == 11)
                            begin
                                valid           <= 1;
                                pixel           <= 0;
                                state           <= 2;
                            end
                            else
                            begin
                                count <= count + 1'b1;
                            end
                        end
                        
                2:        begin
                            if (cycle == 16)
                            begin
                                valid           <= 0;
                                count           <= 0;
                                pixel           <= 0;
                                cycle           <= 0;
                                disparity_1     <= 0;
                                disparity_2     <= 0;
                                disparity_3     <= 0;
                                disparity_4     <= 0;
                                clear_buffer    <= 1;
                                state           <= 3;
                            end
                            else
                            begin
                                if (pixel == 639)
                                begin
                                    valid       <= 0;
                                    disparity_1 <= disparity_1 + 3'b100; 
                                    disparity_2 <= disparity_2 + 3'b100;
                                    disparity_3 <= disparity_3 + 3'b100;
                                    disparity_4 <= disparity_4 + 3'b100;
                                    pixel       <= pixel + 1'b1;
                                end
                                else if (pixel == 643 && cycle != 15)
                                begin
                                    valid       <= 1;
                                    pixel       <= 0;
                                    cycle       <= cycle +1'b1;
                                end
                                else if (pixel == 643 && cycle == 15)
                                begin
                                    valid       <= 0;
                                    pixel       <= 0;
                                    cycle       <= cycle +1'b1;
                                end
                                else
                                begin
                                    pixel       <= pixel + 1'b1;
                                end
                            end
                        end
                        
                3:        begin
                            if (clear_buffer_count == 639)
                            begin
                                clear_buffer        <= 0;
                                clear_buffer_count  <= 0;
                                state               <= 0;
                            end
                            else
                            begin
                                clear_buffer_count  <= clear_buffer_count + 1'b1;
                            end
                        end
            endcase
        end
    end

endmodule
