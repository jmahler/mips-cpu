
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

module stage4_mem(clk,
			mem_memdata, mem_memread, mem_memwrite,
			zero, branch, pcsrc,
			alurslt, alurslt_out,
			memwrite, memread,
			data2,
			rdata,
			regwrite, regwrite_out,
			memtoreg, memtoreg_out,
			wrreg, wrreg_out);

	input wire			clk;

 	// {{{ diagnostic outputs
	output wire [31:0]	mem_memdata;	// write data input to data memory
	output wire			mem_memread;	// mem read control signal
	output wire			mem_memwrite;	// mem write control signal

	assign mem_memdata = addr;
	assign mem_memread = memread;
	assign mem_memwrite = memwrite;

	// }}}

	// {{{ Data Memory

	wire [6:0] addr;
	assign addr = alurslt[8:2];

	input wire memwrite;
	input wire memread;
	input wire [31:0] data2;

	wire [31:0] _rdata;
	dm dm1(.clk(clk), .addr(addr), .rd(memread), .wr(memwrite),
				.wdata(data2), .rdata(_rdata));

	input wire [31:0] alurslt;
	output reg [31:0] alurslt_out;
	output reg [31:0] rdata;

	always @(posedge clk) begin
		alurslt_out <= alurslt;
		rdata <= _rdata;
	end

	// }}}

	input wire zero;
	input wire branch;
	output wire pcsrc;

	assign pcsrc = zero & branch;

	// {{{ pass through

	input wire memtoreg;
	output reg memtoreg_out;

	input wire regwrite;
	output reg regwrite_out;

	input wire [4:0] wrreg;
	output reg [4:0] wrreg_out;

	always @(posedge clk) begin
		regwrite_out <= regwrite;
		memtoreg_out <= memtoreg;
		wrreg_out	 <= wrreg;
	end


	// }}}

endmodule

`endif
