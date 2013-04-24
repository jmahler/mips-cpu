
/*
 * stage2_id.v
 *
 * Stage 2 of the five cycle MIPS CPU.
 * Performs the instruction decode (ID) step.
 *
 */

`ifndef _stage2_id
`define _stage2_id

`include "control.v"
`include "regm.v"

module stage2_id(
		// inputs
		input wire			clk,
		input wire 	[31:0]	inst,		// instruction

		// diagnostic outputs
		output wire [31:0] id_regrs,
		output wire [31:0] id_regrt,

		// control
		output reg			regdst,
		output reg 			branch,
		output reg			memread,
		output reg 			memtoreg,
		output reg [1:0]	aluop,
		output reg			memwrite,
		output reg			alusrc,
		output reg			regwrite_out,

		// Register Memory
		input wire          regwrite,	// 1 = write register
		input wire [4:0]	wrreg,		// register to write
		input wire [31:0]	wrdata,		// data to write to register

		output reg [31:0] 	data1,
		output reg [31:0] 	data2,

		// instruction decoding
		output	reg  [31:0] seimm, // sign extended immediate
		output 	reg  [4:0]  rt,
		output 	reg  [4:0]  rd);

 	// diagnostic outputs
	assign id_regrs = _data1;  // value read from $rs
	assign id_regrt = _data2;  // value read from $rt

	// {{{ Instruction Decoding

	wire [5:0]  _opcode;
	wire [4:0]  _rs;
	wire [4:0]  _rt;
	wire [4:0]  _rd;
	wire [15:0] _imm;
	wire [4:0]  _shamt;
	wire [5:0]  _funct;
	wire [25:0] _jimm;  // jump, immediate
	wire [31:0] _seimm;  // sign extended immediate

	assign _opcode   = inst[31:26];
	assign _rs       = inst[25:21];
	assign _rt       = inst[20:16];
	assign _rd       = inst[15:11];
	assign _imm      = inst[15:0];
	assign _shamt    = inst[10:6];
	assign _funct    = inst[5:0];
	assign _jimm     = inst[25:0];
	//assign _seimm 	 = {{16{imm[15]}}, imm[15:0]};
	assign _seimm 	 = {{16{inst[15]}}, inst[15:0]};

	always @(posedge clk) begin
		rt 		<= _rt;
		rd 		<= _rd;
		seimm 	<= _seimm;
	end

	// }}}

	// {{{ Control
	wire 		_regdst;
	wire 		_branch;
	wire		_memread;
	wire 		_memtoreg;
	wire [1:0]	_aluop;
	wire		_memwrite;
	wire 		_alusrc;
	wire 		_regwrite_out;

	control ctl1(.opcode(_opcode), .regdst(_regdst),
				.branch(_branch), .memread(_memread),
				.memtoreg(_memtoreg), .aluop(_aluop),
				.memwrite(_memwrite), .alusrc(_alusrc),
				.regwrite(_regwrite_out));

	always @(posedge clk) begin
		regdst			<= _regdst;
		branch			<= _branch;
		memread			<= _memread;
		memtoreg		<= _memtoreg;
		aluop			<= _aluop;
		memwrite		<= _memwrite;
		alusrc			<= _alusrc;
		regwrite_out	<= _regwrite_out;
	end
	// }}}

	// {{{ Register Memory
	wire [31:0] _data1, _data2;

	regm regm1(.clk(clk), .read1(_rs), .read2(_rt),
			.data1(_data1), .data2(_data2),
			.regwrite(regwrite), .wrreg(wrreg),
			.wrdata(wrdata));

	always @(posedge clk) begin
		data1 <= _data1;
		data2 <= _data2;
	end
	// }}}

endmodule

`endif
