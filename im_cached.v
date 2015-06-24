
/*
 * im_cached
 *
 * Read only 4 block direct mapped cache with one
 * word (32-bit) blocks.
 * Interfaces to the slow instruction memory (im_slow).
 *
 * On the next clock edge after an address has been asserted,
 * data is valid and can be read if hit is high, otherwise
 * hit will be low and additional cycles will be needed to
 * retrieve the data from (slow) memory.
 */

`ifndef _im_cached
`define _im_cached

`include "im_slow.v"

module im_cached(
		input wire			clk,
		input wire 	[31:0] 	addr,
		output wire			hit,
		output wire [31:0] 	data);

	// parameters to im_slow.v and im.v,
	// refer to the documentation of those modules
	parameter NMEM = 128;
	parameter IM_DATA = "im_data.txt";
	parameter MEM_SIZE = 128;
	parameter ND = 3;

	wire		rdy;
	wire [31:0] mem_data;

	im_slow #(.NMEM(NMEM), .IM_DATA(IM_DATA), .ND(ND))
			ims1(.clk(clk), .addr(addr), .rdy(rdy), .data(mem_data));

	//
	//            ADDRESS
	//  31         4 3         2 1   0
	// +------------+-----------+-----+
	// |     tag    |   index   | X X |
	// +------------+-----------+-----+
	//
	// 							  X X - byte index
	//
	//  tag: 28 bits
	//  index: 2 bits (4 blocks)
	//
	//             BLOCK
	//    60  59     32 31     0
	//   +---+---------+--------+
	//   | V |   tag   |  word  |
	//   +---+---------+--------+
	//

	// decode address
	//wire [1:0]		byte_idx;
	wire [1:0]		index;
	wire [27:0]		addr_tag;
	//
	//assign byte_idx 	= addr[1:0];
	assign index 		= addr[3:2];
	assign addr_tag 	= addr[31:4];

	reg [60:0] block;  // selected block
	reg [60:0] block0;
	reg [60:0] block1;
	reg [60:0] block2;
	reg [60:0] block3;

	// initialize valid bit to false
	initial begin
		block0[60] = 1'b0;
		block1[60] = 1'b0;
		block2[60] = 1'b0;
		block3[60] = 1'b0;
	end

	// select block in cache to read from
	always @(*) begin
		case (index)
			0: block = block0;
			1: block = block1;
			2: block = block2;
			//3: block = block3;
			default: block = block3;
		endcase
	end

	// decode block
	wire 			valid;
	wire [27:0]		block_tag;
	//wire [31:0]		block_data;
	//
	assign valid		= block[60];
	assign block_tag	= block[59:32];
	//assign block_data	= block[31:0];
	//
	//assign data = block_data;
	assign data = (rdy == 1'b1) ? mem_data : block[31:0];

	// Update block from memory,
	// or hold current value.
	//
	// Anytime the address has been asserted long
	// enough for the memory to become ready (rdy)
	// the cache will be updated.
	always @(posedge clk) begin
		// default
		block0 <= block0;
		block1 <= block1;
		block2 <= block2;
		block3 <= block3;

		if (index == 2'd0 && rdy)
			block0 <= {1'b1, addr_tag, mem_data};  // { valid, tag, data }

		if (index == 2'd1 && rdy)
			block1 <= {1'b1, addr_tag, mem_data};

		if (index == 2'd2 && rdy)
			block2 <= {1'b1, addr_tag, mem_data};

		if (index == 2'd3 && rdy)
			block3 <= {1'b1, addr_tag, mem_data};
	end

	assign hit = (rdy || (valid && (addr_tag == block_tag))) ? 1'b1 : 1'b0;

endmodule

`endif
