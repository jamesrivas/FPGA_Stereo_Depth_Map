`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:13:24 04/13/2012 
// Design Name: 
// Module Name:    left_counter 
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
module left_counter(
   	input wire rea,
		input wire clock,
		output reg read_enable,
		output reg [9:0] addrb
    );
	 
	reg [4:0] cycle;
	reg [9:0] count; 
	reg running;
	
	initial
	begin
		cycle <= 0;
		count <= 1;
		addrb <= 0;
		running <= 0;
		read_enable <= 0;
	end
	
	always @(posedge clock)
	begin
		//Wait for start signal
		if (running == 0)
		begin
			if (rea==1)
			begin
				running <= 1;
				read_enable <= 1;
			end
		end
		
		else
		begin
			//Output addresses 0-643 16 times
			if (cycle == 16)
			begin
				cycle <= 0;
				count <= 1;
				addrb <= 0;
				running <= 0;
				read_enable <= 0;
			end
			
			//Reset and return to waiting
			else
			begin			
				if (count == 643)
				begin
					addrb <= count;
					cycle <= cycle+1'b1;
					count <= 0;
				end
				else
				begin
					addrb <= count;
					count <= count+1'b1;				
				end
			end
		end
	end
endmodule
