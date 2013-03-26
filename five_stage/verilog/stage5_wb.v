
/*
 * stage5_wb.v
 *
 * Stage 5 of the five cycle MIPS CPU.
 * Performs the wribe back operations.
 *
 */

`ifndef _stage5_wb
`define _stage5_wb

`include "dm.v"

module stage5_wb(clk,
			wb_regdata, wb_regwrite,
			regwrite, regwrite_out,
			memtoreg,
			rdata, alurslt, wrdata,
			wrreg, wrreg_out);

	input wire			clk;

 	// {{{ diagnostic outputs
	output wire [31:0]	wb_regdata;
	output wire			wb_regwrite;

	assign wb_regdata = _wrdata;
	assign wb_regwrite = regwrite;
	// }}}

	input wire regwrite;
	output wire regwrite_out;

	assign regwrite_out = regwrite;


	input  wire memtoreg;
	input  wire [31:0] 	rdata;
	input  wire [31:0] 	alurslt;
	output wire [31:0] 	wrdata;
		   wire [31:0] 	_wrdata;

	assign _wrdata = (memtoreg) ? rdata : alurslt;
	assign wrdata = _wrdata;


	input wire [4:0] wrreg;
	output wire [4:0] wrreg_out;

	assign wrreg_out = wrreg;

endmodule

`endif
