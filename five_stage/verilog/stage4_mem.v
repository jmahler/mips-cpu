
/*
 * stage4_mem.v
 *
 * Stage 4 of the five cycle MIPS CPU.
 * Performs data memory operations.
 *
 * And signals the pcsrc for the PC if it is a branch.
 *
 */

`ifndef _stage4_mem
`define _stage4_mem

`include "dm.v"

module stage4_mem(
		input wire			clk,

		// diagnostic outputs
		output wire [31:0]	mem_memdata,	// write data input to data memory
		output wire			mem_memread,	// mem read control signal
		output wire			mem_memwrite,	// mem write control signal

		// data memory
		input wire memwrite,
		input wire memread,
		input wire [31:0] data2,

		input wire [31:0] alurslt,
		output reg [31:0] alurslt_out,
		output reg [31:0] rdata,

		input wire zero,
		input wire branch,
		output wire pcsrc);

 	// diagnostic outputs
	assign mem_memdata = data2;
	assign mem_memread = memread;
	assign mem_memwrite = memwrite;

	// data memory
	wire [6:0] addr;
	assign addr = alurslt[8:2];

	wire [31:0] _rdata;
	dm dm1(.clk(clk), .addr(addr), .rd(memread), .wr(memwrite),
				.wdata(data2), .rdata(_rdata));

	always @(posedge clk) begin
		alurslt_out <= alurslt;
		rdata <= _rdata;
	end

	assign pcsrc = zero & branch;

endmodule

`endif
