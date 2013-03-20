/*
 * Single cycle MIPS cpu.
 *
 * Refer to 'single_mips.png' for an overview
 * of this CPU design.
 */

`include "pc.v"
`include "im.v"
`include "control.v"
`include "regm.v"
`include "alu.v"
`include "alu_control.v"
`include "dm.v"

module single_mips(clk, pc, im, alurslt, writedata,
					regdst, branch, memread, memtoreg,
					aluop, memwrite, alusrc, regwrite);
	parameter NMEM = 20;
	parameter IM_DATA = "im_data.txt";

	input wire clk;

	// outputs for debugging
	output wire [31:0] 	pc;
	output wire [31:0] 	im;
	output wire [31:0] 	alurslt;
	output wire [31:0] 	writedata;
	output wire			regdst;
	output wire			branch;
	output wire			memread;
	output wire			memtoreg;
	output wire [1:0] 	aluop;
	output wire			memwrite;
	output wire			alusrc;
	output wire			regwrite;

	assign pc = pc_addr;
	assign im = im_out;
	assign alurslt = aluout;
	assign writedata = wrdata;
	assign regdst = _regdst;
	assign branch = _branch;
	assign memread = _memread;
	assign memtoreg = _memtoreg;
	assign aluop = _aluop;
	assign memwrite = _memwrite;
	assign alusrc = _alusrc;
	assign regwrite = _regwrite;

	// Program Counter
	wire [31:0] pc_addr;
	wire [31:0] baddr;
	assign baddr = {seimm[29:0], 1'b0, 1'b0};
	wire abranch;
	assign abranch = branch & zero;
	pc pc1(.clk(clk), .pc_out(pc_addr), .branch(abranch), .baddr(baddr));

	// Instruction Memory
	wire [31:0] im_out;
	im #(.NMEM(NMEM), .IM_DATA(IM_DATA)) im1(.addr(pc_addr[8:2]),
			.out(im_out));

	// Instruction Decoding
	wire [5:0]	opcode;
	wire [4:0]	rs;
	wire [4:0]	rt;
	wire [4:0]	rd;
	wire [15:0]	imm;
	wire [4:0]	shamt;
	wire [5:0]	funct;
	wire [25:0]	jimm;  // jump, immediate

	assign opcode 	= im_out[31:26];
	assign rs 		= im_out[25:21];
	assign rt 		= im_out[20:16];
	assign rd 		= im_out[15:11];
	assign imm 		= im_out[15:0];
	assign shamt 	= im_out[10:6];
	assign funct 	= im_out[5:0];
	assign jimm 	= im_out[25:0];

	// Control
	wire 		_regdst;
	wire 		_branch;
	wire		_memread;
	wire 		_memtoreg;
	wire [1:0]	_aluop;
	wire		_memwrite;
	wire 		_alusrc;
	wire 		_regwrite;
	control ctl1(.opcode(opcode), .regdst(_regdst),
				.branch(_branch), .memread(_memread),
				.memtoreg(_memtoreg), .aluop(_aluop),
				.memwrite(_memwrite), .alusrc(_alusrc),
				.regwrite(_regwrite));

	// Register Memory
	wire [4:0]	wrreg;
	assign wrreg = (_regdst) ? rd : rt;
	wire [31:0] wrdata;
	wire [31:0] data1;
	wire [31:0] data2;

	regm regm1(.clk(clk), .read1(rs), .read2(rt),
			.data1(data1), .data2(data2),
			.regwrite(_regwrite), .wrreg(wrreg),
			.wrdata(wrdata));

	// ALU Control
	wire [3:0]	alucnt;
	alu_control aluc1(.funct(funct), .aluop(_aluop), .alucnt(alucnt));

	// ALU
	wire [31:0] alub;
	wire [31:0] aluout;
	wire		zero;
	wire [31:0] seimm;
	assign seimm = {{16{imm[15]}}, imm};  // sign extend
	assign alub = (_alusrc) ? seimm : data2;

	alu alu1(.ctl(alucnt), .a(data1), .b(alub), .out(aluout), .z(zero));

	// Data Memory
	wire [31:0]	rs2_aluout;
	assign rs2_aluout = { 1'b0, 1'b0, aluout[31:2] };

	wire [31:0] dmrdata;
	dm dm1(.clk(clk), .addr(rs2_aluout[6:0]), .rd(_memread), .wr(_memwrite),
			.wdata(data2), .rdata(dmrdata));

	assign wrdata = (_memtoreg) ? dmrdata : aluout;

endmodule
