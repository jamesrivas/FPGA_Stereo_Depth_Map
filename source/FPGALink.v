//
// Copyright (C) 2009-2012 Chris McClelland
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
module FPGALink(
		// FX2 interface
		input  wire      fx2Clk_in,     // 48MHz clock from FX2
		output wire[1:0] fx2Addr_out,   // select FIFO: "10" for EP6OUT, "11" for EP8IN
		inout  wire[7:0] fx2Data_io,    // 8-bit data to/from FX2
		output wire      fx2Read_out,   // asserted (active-low) when reading from FX2
		output wire      fx2OE_out,     // asserted (active-low) to tell FX2 to drive bus
		input  wire      fx2GotData_in, // asserted (active-high) when FX2 has data for us
		output wire      fx2Write_out,  // asserted (active-low) when writing to FX2
		input  wire      fx2GotRoom_in, // asserted (active-high) when FX2 has room for more data from us
		output wire      fx2PktEnd_out,  // asserted (active-low) when a host read needs to be committed early
		
		// Input data
		input wire data_clock,
		input wire data_valid,
		input wire [7:0] data_in
	);

	//Fifo Connections
	wire [7:0] FifoOut;
	wire FifoRead;
	wire FifoEmpty;
	wire [6:0] chanAddr;
	
	
	// CommFPGA module
	// Needed so that the comm_fpga module can drive both fx2Read_out and fx2OE_out
	wire   fx2Read;
	assign fx2Read_out = fx2Read;
	assign fx2OE_out = fx2Read;
	assign fx2Addr_out[1] = 1'b1;  // Use EP6OUT/EP8IN, not EP2OUT/EP4IN.
	comm_fpga comm_fpga(
		// FX2 interface
		.fx2Clk_in			(fx2Clk_in),
		.fx2FifoSel_out	(fx2Addr_out[0]),
		.fx2Data_io			(fx2Data_io),
		.fx2Read_out		(fx2Read),
		.fx2GotData_in		(fx2GotData_in),
		.fx2Write_out		(fx2Write_out),
		.fx2GotRoom_in		(fx2GotRoom_in),
		.fx2PktEnd_out		(fx2PktEnd_out),

		// Channel read/write interface
		.chanAddr_out		(chanAddr),
		.chanData_in		(FifoOut),
		.chanRead_out		(FifoRead),
		.chanGotData_in	(~FifoEmpty),
		.chanData_out		(),
		.chanWrite_out		(),
		.chanGotRoom_in	(1'b0)
	);


	// Data is read by computer
	//synthesis attribute box_type fifo "black_box"
	fifo read_fifo(
		.wr_clk				(data_clock),
		.rd_clk				(fx2Clk_in),
		.din					(data_in),
		.wr_en				(data_valid),
		.rd_en				(FifoRead & (chanAddr == 7'b0000000)),
		.dout					(FifoOut),
		.full					(),
		.empty				(FifoEmpty)
	);


endmodule
