`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:21:58 05/09/2012 
// Design Name: 
// Module Name:    output_decoder 
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
module output_decoder(
    input wire clock,
    input wire valid_in,
    input wire [5:0] data_in,
    
    output reg valid_out,
    output reg [7:0] data_out
    );
    //16 - 0,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255
    //
    //6  - 0,37,74,111,148,185,222,255
    //
    
    initial
    begin
        data_out    <= 8'b0;
        valid_out   <= 1'b0;
    end
    
    always @(posedge clock)
    begin
        
        valid_out <= valid_in;
        
        case (data_in)
            0:          data_out    <= 8'd0;
            1:          data_out    <= 8'd0;
            2:          data_out    <= 8'd0;
            3:          data_out    <= 8'd0;
            
            4:          data_out    <= 8'd17;
            5:          data_out    <= 8'd17;
            6:          data_out    <= 8'd17;
            7:          data_out    <= 8'd17;
            
            8:          data_out    <= 8'd34;
            9:          data_out    <= 8'd34;
            10:         data_out    <= 8'd34;
            11:         data_out    <= 8'd34;
            
            12:         data_out    <= 8'd51;
            13:         data_out    <= 8'd51;
            14:         data_out    <= 8'd51;
            15:         data_out    <= 8'd51;
            
            16:         data_out    <= 8'd68;
            17:         data_out    <= 8'd68;
            18:         data_out    <= 8'd68;
            19:         data_out    <= 8'd68;
            
            20:         data_out    <= 8'd85;
            21:         data_out    <= 8'd85;
            22:         data_out    <= 8'd85;
            23:         data_out    <= 8'd85;
            
            24:         data_out    <= 8'd102;
            25:         data_out    <= 8'd102;
            26:         data_out    <= 8'd102;
            27:         data_out    <= 8'd102;
            
            28:         data_out    <= 8'd119;
            29:         data_out    <= 8'd119;
            30:         data_out    <= 8'd119;
            31:         data_out    <= 8'd119;
            
            32:         data_out    <= 8'd136;
            33:         data_out    <= 8'd136;
            34:         data_out    <= 8'd136;
            35:         data_out    <= 8'd136;
            
            36:         data_out    <= 8'd153;
            37:         data_out    <= 8'd153;
            38:         data_out    <= 8'd153;
            39:         data_out    <= 8'd153;
            
            40:         data_out    <= 8'd170;
            41:         data_out    <= 8'd170;
            42:         data_out    <= 8'd170;
            43:         data_out    <= 8'd170;
            
            44:         data_out    <= 8'd187;
            45:         data_out    <= 8'd187;
            46:         data_out    <= 8'd187;
            47:         data_out    <= 8'd187;
            
            48:         data_out    <= 8'd204;
            49:         data_out    <= 8'd204;
            50:         data_out    <= 8'd204;
            51:         data_out    <= 8'd204;
            
            52:         data_out    <= 8'd221;
            53:         data_out    <= 8'd221;
            54:         data_out    <= 8'd221;
            55:         data_out    <= 8'd221;
            
            56:         data_out    <= 8'd238;
            57:         data_out    <= 8'd238;
            58:         data_out    <= 8'd238;
            59:         data_out    <= 8'd238;
            
            60:         data_out    <= 8'd255;
            61:         data_out    <= 8'd255;
            62:         data_out    <= 8'd255;
            63:         data_out    <= 8'd255;
        endcase
    end
endmodule
