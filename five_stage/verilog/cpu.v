/*
 * Five stage MIPS CPU.
 *
 */

`include "stage1_if.v"
`include "stage2_id.v"
`include "stage3_ex.v"
`include "stage4_mem.v"
`include "stage5_wb.v"

module cpu(clk,
			if_pc, if_instr,
			id_regrs, id_regrt,
			ex_alua, ex_alub, ex_aluctl,
			mem_memdata, mem_memread, mem_memwrite,
			wb_regdata, wb_regwrite);
	parameter NMEM = 20;
	parameter IM_DATA = "im_data.txt";

	input wire clk;

	// {{{ stage 1, IF

	// takes inputs from other stages (e.g. pcsrc4)

	stage1_if #(.NMEM(NMEM), .IM_DATA(IM_DATA))
		s1(.clk(clk),
			.if_pc(if_pc), .if_instr(if_instr),
			.pc_src(pcsrc4), .pc_addr(pc4_3),
			.pc_p4(pc_p4_1), .im_out(inst));

	// outputs to next stage
	wire [31:0] pc_p4_1;
	wire [31:0] inst;

	// diagnostic outputs
	output wire [31:0] if_pc;		// program counter (PC)
	output wire [31:0] if_instr;	// instruction read from memory (IM)

	// }}}

	// {{{ stage 2, ID

	stage2_id s2(.clk(clk), .inst(inst),
			.id_regrs(id_regrs), .id_regrt(id_regrt),
			.pc_p4_in(pc_p4_1), .pc_p4(pc_p4_2),
			.rt(rt), .rd(rd), .seimm(seimm2),
			.regdst(regdst), .branch(branch),
			.memread(memread), .memtoreg(memtoreg),
			.aluop(aluop), .memwrite(memwrite), .alusrc(alusrc),
			.regwrite(regwrite5), .regwrite_out(regwrite2),
			.wrreg(wrreg5), .wrdata(wrdata5),
			.data1(data1), .data2(data2));

	// outputs to next stage
	wire [31:0] seimm2;
	wire [4:0] 	rt;
	wire [4:0] 	rd;
	wire		branch;
	wire		memread;
	wire		memwrite;
	wire		memtoreg;
	wire		regwrite2;
	wire [31:0] pc_p4_2;
	wire		regdst;
	wire [1:0]	aluop;
	wire		alusrc;
	wire [31:0]	data1, data2;

	// diagnostic outputs
	output wire [31:0] id_regrs;
	output wire [31:0] id_regrt;

	// }}}

	// {{{ stage 3, EX

	stage3_ex s3(.clk(clk),
			.ex_alua(ex_alua), .ex_alub(ex_alub), .ex_aluctl(ex_aluctl),
			.branch(branch), .memread(memread),
			.memwrite(memwrite), .memtoreg(memtoreg),
			.branch_out(branch3), .memread_out(memread3),
			.memwrite_out(memwrite3), .memtoreg_out(memtoreg3),
			.regwrite(regwrite2), .regwrite_out(regwrite3),
			.pc4_out(pc4_3),
			.alusrc(alusrc), .data1(data1), .data2(data2),
			.alurslt(alurslt3), .zero(zero), .data2_out(data2_3),
			.aluop(aluop), .seimm(seimm2),
			.regdst(regdst), .rt(rt), .rd(rd),
			.wrreg_out(wrreg3));

	// outputs to next stage
	wire		branch3;
	wire		memread3;
	wire		memwrite3;
	wire		memtoreg3;
	wire		regwrite3;
	wire [31:0]	pc4_3;
	wire [31:0]	alurslt3;
	wire 		zero;
	wire [31:0]	data2_3;
	wire [4:0]	wrreg3;

	// diagnostic outputs
	output wire [31:0]	ex_alua;
	output wire [31:0]	ex_alub;
	output wire [3:0]	ex_aluctl;

	// }}}

	// {{{ stage 4, MEM
	stage4_mem s4(.clk(clk),
			.mem_memdata(mem_memdata), .mem_memread(mem_memread),
			.mem_memwrite(mem_memwrite),
			.zero(zero), .branch(branch3), .pcsrc(pcsrc4),
			.alurslt(alurslt3), .alurslt_out(alurslt4),
			.memwrite(memwrite3), .memread(memread3),
			.data2(data2_3), .rdata(rdata4),
			.regwrite(regwrite3), .regwrite_out(regwrite4),
			.memtoreg(memtoreg3), .memtoreg_out(memtoreg4),
			.wrreg(wrreg3), .wrreg_out(wrreg4));

	// outputs to next stage
	wire		pcsrc4;
	wire [31:0] alurslt4;
	wire [31:0] rdata4;
	wire 		regwrite4;
	wire 		memtoreg4;
	wire [4:0]  wrreg4;

	// diagnostic outputs
	output wire [31:0]	mem_memdata;
	output wire			mem_memread;
	output wire			mem_memwrite;
	// }}}
			
	// {{{ stage 5, WB

	stage5_wb s5(.clk(clk),
			.wb_regdata(wb_regdata), .wb_regwrite(wb_regwrite),
			.regwrite(regwrite4), .regwrite_out(regwrite5),
			.memtoreg(memtoreg4),
			.rdata(rdata4), .alurslt(alurslt4),
			.wrdata(wrdata5),
			.wrreg(wrreg4), .wrreg_out(wrreg5));
	
	// outputs
	wire		regwrite5;
	wire [31:0]	wrdata5;
	wire [4:0]	wrreg5;

	// diagnostic outputs
	output wire [31:0]	wb_regdata;
	output wire 		wb_regwrite;

	// }}}

endmodule
