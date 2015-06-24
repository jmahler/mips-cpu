/*
 * Slow version of Instruction Memory
 *
 * This slow version of instruction memory takes
 * several cycles (param ND) to produce a valid result (rdy = 1).
 * This attempts to be a more realistic representation of memory.
 * And this is useful along with a cache implementation.
 *  
 * The operation is the same as 'im.v' except with the
 * addition of a 'rdy' signal which will be set after
 * the address has been held for ND (parameter ND) clock
 * cycles.  ND must have a minimum size of 2.
 */

`ifndef _im_slow
`define _im_slow

`include "im.v"

module im_slow(
		input wire			clk,
		input wire 	[31:0] 	addr,
		output wire			rdy,
		output wire [31:0] 	data);

	parameter NMEM = 128;	// Number of memory entries,
							// not the same as the memory size
	parameter IM_DATA = "im_data.txt";  // file to read data from

	parameter MEM_SIZE = 128;

	parameter ND = 3;  // address held delay

	// fast (no delay) instruction memory
	wire [31:0] raw_data;
	im #(.NMEM(NMEM), .IM_DATA(IM_DATA))
			im1(.clk(clk), .addr(addr), .data(raw_data));

	// The address must be held for ND clock cycles
	// before it is ready (rdy = 1).
	//
	// Here this is accomplished with a shift register.
	// When address is equal to the previous address
	// the lowest bit is set.  When all the bits in
	// the shift register are set, the address has
	// been held long enough.
	//
	reg [31:0] last_addr;

	wire cur_equal;
	assign cur_equal = (last_addr == addr) ? 1'b1 : 1'b0;

	reg [ND-1:0] next_equals;
	wire [ND-1:0] equals;
	assign equals = {next_equals[ND-2:0], cur_equal};

	always @(posedge clk) begin
		last_addr <= addr;

		next_equals <= equals;
	end

	// When all the equals bits are set, it is ready
	assign rdy = (&equals) ? 1'b1 : 1'b0;

	// only produce valid data when ready
	assign data = (rdy) ? raw_data : {32{1'b0}};

endmodule

`endif
