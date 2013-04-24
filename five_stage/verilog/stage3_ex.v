
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

module stage3_ex(
		input wire			clk,
		// diagnostic outputs
		output wire [31:0] 	ex_alua,	// upper A input
		output wire [31:0] 	ex_alub,	// lower B input
		output wire [3:0] 	ex_aluctl,	// 4-bit ALU control input

		// (PC + 4) + (imm << 2)
		input wire [31:0] 	pc4,
		output reg [31:0] 	pc4_out,

		// ALU
		input wire 			alusrc,
		input wire [31:0] 	data1,
		input wire [31:0] 	data2,

		output reg [31:0]	alurslt,
		output reg 			zero,

		output reg [31:0]	data2_out,

		// ALU Control
		input wire [1:0] aluop,
		input wire [31:0] seimm,

		// WriteReg, RegDst
		input wire regdst,
		input wire [4:0] rt,
		input wire [4:0] rd,

		output reg [4:0] wrreg_out);

 	// diagnostic outputs
	assign ex_alua = data1;
	assign ex_alub = alusrc_data2;
	assign ex_aluctl = aluctl;

	// (PC + 4) + (imm << 2)

	wire [31:0] seimm_sl2;
	assign seimm_sl2 = {seimm[29:0], 2'b0};  // shift left 2

	wire [31:0] _pc4_out;
	assign _pc4_out = pc4 + seimm_sl2;

	always @(posedge clk) begin
		pc4_out <= _pc4_out;
	end

	// ALU
	wire [31:0] alusrc_data2;
	wire [31:0]	_alurslt;
	wire 		_zero;

	assign alusrc_data2 = (alusrc) ? seimm : data2;

	alu alu1(.ctl(aluctl), .a(data1), .b(alusrc_data2),
		.out(_alurslt), .z(_zero));

	always @(posedge clk) begin
		alurslt <= _alurslt;
		zero   <= _zero;
		data2_out <= data2;
	end

	// ALU Control
	wire [3:0] aluctl;

	wire [5:0] funct;

	assign funct = seimm[5:0];

	alu_control alu_ctl1(.funct(funct), .aluop(aluop), .aluctl(aluctl));

	// WriteReg, RegDst
	wire [4:0] _wrreg;

	assign _wrreg = (regdst) ? rd : rt;

	always @(posedge clk) begin
		wrreg_out <= _wrreg;
	end

endmodule

`endif
