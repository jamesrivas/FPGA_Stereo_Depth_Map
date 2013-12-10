`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:33:16 04/13/2012 
// Design Name: 
// Module Name:    right_counter 
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
module right_counter(
		input wire rea,
		input wire clock,
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
	end
	
	always @(posedge clock)
	begin
		//Wait for start signal
		if (running == 0)
		begin
			if (rea == 1)
			begin
				running <= 1;
			end
		end
		
		else
		begin
			//Output addresses
			if (cycle == 16)
			begin
				cycle <= 0;
				count <= 1;
				addrb <= 0;
				running <= 0;
			end
			//Reset and return to waiting
			else
			begin
				if (count == 643+cycle*3'b100)
				begin
					addrb <= count;
					cycle <= cycle+1'b1;
					count <= (cycle+1'b1)*3'b100;
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
