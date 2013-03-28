
/*
 * stage3_ex.v
 *
 * Stage 3 of the five cycle MIPS CPU.
 * Performs the execute step (EX) which includes
 * all ALU operations as well as the addition to PC + 4
 * if it is a branch.
 *
 */

`ifndef _stage3_ex
`define _stage3_ex

`include "alu.v"
`include "alu_control.v"

module stage3_ex(clk,
			ex_alua, ex_alub, ex_aluctl,
			branch, memread, memwrite, memtoreg,
			branch_out, memread_out, memwrite_out, memtoreg_out,
			regwrite, regwrite_out,
			pc4, pc4_out,
			alusrc, data1, data2, alurslt, zero, data2_out,
			aluop, seimm,
			regdst, rt, rd, wrreg_out);

	input wire			clk;

 	// {{{ diagnostic outputs
	output wire [31:0] ex_alua;		// upper A input
	output wire [31:0] ex_alub;		// lower B input
	output wire [3:0] ex_aluctl;	// 4-bit ALU control input

	assign ex_alua = data1;
	assign ex_alub = alusrc_data2;
	assign ex_aluctl = aluctl;

	// }}}

	// {{{ Control Pass Through for WB and M

	// Memory (M) stage
	input wire			branch;
	input wire			memread;
	input wire			memwrite;
	input wire			memtoreg;

	output reg			branch_out;
	output reg			memread_out;
	output reg			memwrite_out;
	output reg			memtoreg_out;

	// Write Back (WB) stage
	input wire			regwrite;
	output reg			regwrite_out;

	always @(posedge clk) begin
		branch_out   <= branch;
		memread_out  <= memread;
		memwrite_out <= memwrite;
		memtoreg_out <= memtoreg;

		regwrite_out <= regwrite;
	end

	// }}}

	// {{{ (PC + 4) + (imm << 2)

	wire [31:0] seimm_sl2;
	assign seimm_sl2 = {seimm[29:0], 2'b0};  // shift left 2

	input wire [31:0] pc4;

	wire [31:0] _pc4_out;
	assign _pc4_out = pc4 + seimm_sl2;

	output reg [31:0] pc4_out;

	always @(posedge clk) begin
		pc4_out <= _pc4_out;
	end

	// }}}

	// {{{ ALU

	input wire alusrc;
	input wire [31:0] data1;
	input wire [31:0] data2;

	wire [31:0] alusrc_data2;
	wire [31:0]	_alurslt;
	wire 		_zero;

	assign alusrc_data2 = (alusrc) ? seimm : data2;

	alu alu1(.ctl(aluctl), .a(data1), .b(alusrc_data2),
		.out(_alurslt), .z(_zero));

	output reg [31:0]	alurslt;
	output reg 			zero;

	output reg [31:0]	data2_out;

	always @(posedge clk) begin
		alurslt <= _alurslt;
		zero   <= _zero;
		data2_out <= data2;
	end

	// }}}

	// {{{ ALU Control
	wire [3:0] aluctl;

	input wire [1:0] aluop;
	input wire [31:0] seimm;

	wire [5:0] funct;

	assign funct = seimm[5:0];

	alu_control alu_ctl1(.funct(funct), .aluop(aluop), .aluctl(aluctl));

	// }}}

	// {{{ WriteReg, RegDst
	input wire regdst;
	input wire [4:0] rt;
	input wire [4:0] rd;

	wire [4:0] _wrreg;

	assign _wrreg = (regdst) ? rd : rt;

	output reg [4:0] wrreg_out;

	always @(posedge clk) begin
		wrreg_out <= _wrreg;
	end
	// }}}

endmodule

`endif
