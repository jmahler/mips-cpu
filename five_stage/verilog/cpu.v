/*
 * NAME
 *
 * cpu - Five stage MIPS CPU.
 *
 * DEV NOTES
 *
 * Naming Convention
 *
 * Many variables (wires) pass through several stages.
 * The naming convention used for each stage is
 * accomplished by appending the stage number (_s<num>).
 * For example the variable named "data" which is
 * in stage 2 and stage 3 would be named as follows.
 *
 * wire data_s2;
 * wire data_s3;
 *	
 * If the stage number is omitted it is assumed to
 * be at the stage at which the variable is first
 * established.
 *
 * This file is best viewed in Vim with foldmethod=marker (zo, zc)
 */

`include "reggy.v"
`include "im.v"
`include "regm.v"
`include "control.v"
`include "alu.v"
`include "alu_control.v"
`include "dm.v"

module cpu(
		input wire clk,

		// diagnostic outputs
		output wire [31:0]	if_pc,		// program counter (PC)
		output wire [31:0]	if_instr,	// instruction read from memory (IM)

		output wire [31:0]	id_regrs,
		output wire [31:0]	id_regrt,

		output wire [31:0]	ex_alua,
		output wire [31:0]	ex_alub,
		output wire [3:0]	ex_aluctl,

		output wire [31:0]	mem_memdata,
		output wire			mem_memread,
		output wire			mem_memwrite,

		output wire [31:0]	wb_regdata,
		output wire 		wb_regwrite);

	parameter NMEM = 20;  // number in instruction memory
	parameter IM_DATA = "im_data.txt";

	/*
	 * Refer to the diagram of the 5 stage pipeline in order
	 * to view what should be in each stage.
	 */

 	// {{{ diagnostic outputs

	assign if_pc	= pc;
	assign if_instr = inst;

	assign id_regrs = data1;  // value read from $rs
	assign id_regrt = data2;  // value read from $rt

	assign ex_alua = data1_s3;
	assign ex_alub = alusrc_data2;
	assign ex_aluctl = aluctl;

	assign mem_memdata = data2_s4;
	assign mem_memread = memread_s4;
	assign mem_memwrite = memwrite_s4;

	assign wb_regdata = wrdata_s5;
	assign wb_regwrite = regwrite_s5;

	// }}}

	// {{{ stage 1, IF (fetch)

	reg  [31:0] pc;
	initial begin
		pc <= 32'd0;
	end

	wire [31:0] pc4;  // PC + 4
	assign pc4 = pc + 4;

	always @(posedge clk) begin
		if (pcsrc == 1'b1)
			pc <= baddr_s4;
		else
			pc <= pc4;
	end

	// pass PC + 4 to stage 2
	wire [31:0] pc4_s2;
	reggy #(.N(32)) reggy_pc4_s2(.clk(clk), .in(pc4), .out(pc4_s2));

	// instruction memory
	wire [31:0] inst;
	im #(.NMEM(NMEM), .IM_DATA(IM_DATA))
		im1(.clk(clk), .addr(pc[8:2]), .out(inst));
	// The output is already registerd so we don't need to do it ourselves.

	// }}}

	// {{{ stage 2, ID (decode)

	// decode instruction
	wire [5:0]  opcode;
	wire [4:0]  rs;
	wire [4:0]  rt;
	wire [4:0]  rd;
	wire [15:0] imm;
	wire [4:0]  shamt;
	wire [25:0] jimm;  // jump, immediate
	wire [31:0] seimm;  // sign extended immediate
	//
	assign opcode   = inst[31:26];
	assign rs       = inst[25:21];
	assign rt       = inst[20:16];
	assign rd       = inst[15:11];
	assign imm      = inst[15:0];
	assign shamt    = inst[10:6];
	assign jimm     = inst[25:0];
	assign seimm 	= {{16{inst[15]}}, inst[15:0]};

	// register memory
	wire [31:0] data1, data2;
	regm regm1(.clk(clk), .read1(rs), .read2(rt),
			.data1(data1), .data2(data2),
			.regwrite(regwrite_s5), .wrreg(wrreg_s5),
			.wrdata(wrdata_s5));

	// pass rs to stage 3 (for forwarding)
	wire [4:0] rs_s3;
	reggy #(.N(5)) reggy_s2_rs(.clk(clk), .in(rs), .out(rs_s3));

	// transfer register data to stage 3
	wire [31:0]	data1_s3, data2_s3;
	reggy #(.N(64)) reg_s2_mem(.clk(clk),
				.in({data1, data2}),
				.out({data1_s3, data2_s3}));

	// transfer seimm, rt, and rd to stage 3
	wire [31:0] seimm_s3;
	wire [4:0] 	rt_s3;
	wire [4:0] 	rd_s3;
	reggy #(.N(32)) reg_s2_seimm(.clk(clk), .in(seimm), .out(seimm_s3));
	reggy #(.N(10)) reg_s2_rt_rd(.clk(clk), .in({rt, rd}), .out({rt_s3, rd_s3}));

	// transfer PC + 4 to stage 3
	wire [31:0] pc4_s3;
	reggy #(.N(32)) reg_pc4_s2(.clk(clk), .in(pc4_s2), .out(pc4_s3));

	// control (opcode -> ...)
	wire		regdst;
	wire		branch;
	wire		memread;
	wire		memwrite;
	wire		memtoreg;
	wire [1:0]	aluop;
	wire		regwrite;
	wire		alusrc;
	//
	control ctl1(.opcode(opcode), .regdst(regdst),
				.branch(branch), .memread(memread),
				.memtoreg(memtoreg), .aluop(aluop),
				.memwrite(memwrite), .alusrc(alusrc),
				.regwrite(regwrite));

	// transfer the control signals to stage 3
	wire		regdst_s3;
	wire		branch_s3;
	wire		memread_s3;
	wire		memwrite_s3;
	wire		memtoreg_s3;
	wire [1:0]	aluop_s3;
	wire		regwrite_s3;
	wire		alusrc_s3;
	//
	reggy #(.N(9)) reg_s2_control(.clk(clk),
			.in({regdst, branch, memread, memwrite,
					memtoreg, aluop, regwrite, alusrc}),
			.out({regdst_s3, branch_s3, memread_s3, memwrite_s3,
					memtoreg_s3, aluop_s3, regwrite_s3, alusrc_s3}));
	// }}}

	// {{{ stage 3, EX (execute)

	// pass through some control signals to stage 4
	wire regwrite_s4;
	wire memtoreg_s4;
	wire branch_s4;
	wire memread_s4;
	wire memwrite_s4;
	reggy #(.N(5)) reg_s3(.clk(clk),
				.in({regwrite_s3, memtoreg_s3, branch_s3, memread_s3,
						memwrite_s3}),
				.out({regwrite_s4, memtoreg_s4, branch_s4, memread_s4,
						memwrite_s4}));

	// branch calculation
	// shift left, seimm
	wire [31:0] seimm_sl2;
	assign seimm_sl2 = {seimm_s3[29:0], 2'b0};  // shift left 2 bits
	// branch address
	wire [31:0] baddr_s3;
	assign baddr_s3 = pc4_s3 + seimm_sl2;
	// pass branch address to stage 4
	wire [31:0] baddr_s4;
	reggy #(.N(32)) reg_baddr(.clk(clk), .in(baddr_s3), .out(baddr_s4));

	// ALU
	// decode funct for ALU control
	wire [5:0] funct;
	assign funct = seimm_s3[5:0];
	// select ALU data2 source
	wire [31:0] alusrc_data2;
	assign alusrc_data2 = (alusrc_s3) ? seimm_s3 : fw_data2_s3;
	// ALU control
	wire [3:0] aluctl;
	alu_control alu_ctl1(.funct(funct), .aluop(aluop_s3), .aluctl(aluctl));
	// ALU
	wire [31:0]	alurslt;  // ALU result
	wire 		zero;
	alu alu1(.ctl(aluctl), .a(fw_data1_s3), .b(alusrc_data2),
				.out(alurslt), .z(zero));
	// pass ALU result and zero to stage 4
	wire [31:0]	alurslt_s4;
	wire		zero_s4;
	reggy #(.N(33)) reg_alurslt(.clk(clk),
				.in({alurslt, zero}),
				.out({alurslt_s4, zero_s4}));

	// pass data2 to stage 4
	wire [31:0] data2_s4;
	reggy #(.N(32)) reg_data2_s3(.clk(clk), .in(data2_s3), .out(data2_s4));

	// write register
	wire [4:0]	wrreg;
	wire [4:0]	wrreg_s4;
	assign wrreg = (regdst_s3) ? rd_s3 : rt_s3;
	// pass to stage 4
	reggy #(.N(5)) reg_wrreg(.clk(clk), .in(wrreg), .out(wrreg_s4));

	// }}}

	// {{{ stage 4, MEM (memory)

	// pass regwrite and memtoreg to stage 5
	wire regwrite_s5;
	wire memtoreg_s5;
	reggy #(.N(2)) reg_regwrite_s4(.clk(clk),
				.in({regwrite_s4, memtoreg_s4}),
				.out({regwrite_s5, memtoreg_s5}));

	// data memory
	wire [31:0] rdata;
	dm dm1(.clk(clk), .addr(alurslt_s4[8:2]), .rd(memread_s4), .wr(memwrite_s4),
			.wdata(data2_s4), .rdata(rdata));
	// pass read data to stage 5
	wire [31:0] rdata_s5;
	reggy #(.N(32)) reg_rdata_s4(.clk(clk),
				.in(rdata),
				.out(rdata_s5));

	// pass alurslt to stage 5
	wire [31:0] alurslt_s5;
	reggy #(.N(32)) reg_alurslt_s4(.clk(clk),
				.in(alurslt_s4),
				.out(alurslt_s5));

	// pcsrc
	wire pcsrc;
	assign pcsrc = zero_s4 & branch_s4;

	// pass wrreg to stage 5
	wire [4:0] wrreg_s5;
	reggy #(.N(5)) reg_wrreg_s4(.clk(clk),
				.in(wrreg_s4),
				.out(wrreg_s5));
	// }}}
			
	// {{{ stage 5, WB (write back)

	wire [31:0]	wrdata_s5;
	assign wrdata_s5 = (memtoreg_s5) ? rdata_s5 : alurslt_s5;

	// }}}

	// {{{ forwarding

	// stage 3 (MEM) -> stage 2 (EX)
	// stage 4 (WB) -> stage 2 (EX)

	reg [31:0] fw_data1_s3;
	reg [31:0] fw_data2_s3;
	always @(*) begin
		// If the previous instruction (stage 4) would write,
		// and it is a value we want to read (stage 3), forward it.

		// data1 input to ALU
		if ((regwrite_s4 == 1'b1) && (wrreg_s4 == rs_s3)) begin

			if (memtoreg_s4 == 1'b1)
				fw_data1_s3 <= rdata;
			else
				fw_data1_s3 <= alurslt_s4;

		end else if ((regwrite_s5 == 1'b1) && (wrreg_s5 == rs_s3))
			fw_data1_s3 <= wrdata_s5;
		else
			fw_data1_s3 <= data1_s3;

		// data2 input to ALU
		if ((regwrite_s4 == 1'b1) & (wrreg_s4 == rt_s3)) begin

			if (memtoreg_s4 == 1'b1)
				fw_data2_s3 <= rdata;
			else
				fw_data2_s3 <= alurslt_s4;

		end else if ((regwrite_s5 == 1'b1) && (wrreg_s5 == rt_s3))
			fw_data2_s3 <= wrdata_s5;
		else
			fw_data2_s3 <= data2_s3;
	end
	// }}}

endmodule
