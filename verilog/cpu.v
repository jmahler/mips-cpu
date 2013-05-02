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
`include "sreggy.v"
`include "zreggy.v"
`include "szreggy.v"
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
		if (stall_s1_s2) 
			pc <= pc;
		else if (pcsrc == 1'b1)
			pc <= baddr_s2;
		else
			pc <= pc4;
	end

	// pass PC + 4 to stage 2
	wire [31:0] pc4_s2;
	szreggy #(.N(32)) reggy_pc4_s2(.clk(clk),
						.stall(stall_s1_s2), .zero(branch_flush),
						.in(pc4), .out(pc4_s2));

	// instruction memory
	wire [31:0] inst;
	wire [31:0] inst_s2;
	im #(.NMEM(NMEM), .IM_DATA(IM_DATA))
		im1(.clk(clk), .addr(pc), .data(inst));
	szreggy #(.N(32)) reggy_im_s2(.clk(clk),
						.stall(stall_s1_s2), .zero(branch_flush),
						.in(inst), .out(inst_s2));

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
	assign opcode   = inst_s2[31:26];
	assign rs       = inst_s2[25:21];
	assign rt       = inst_s2[20:16];
	assign rd       = inst_s2[15:11];
	assign imm      = inst_s2[15:0];
	assign shamt    = inst_s2[10:6];
	assign jimm     = inst_s2[25:0];
	assign seimm 	= {{16{inst_s2[15]}}, inst_s2[15:0]};

	// register memory
	wire [31:0] data1, data2;
	regm regm1(.clk(clk), .read1(rs), .read2(rt),
			.data1(data1), .data2(data2),
			.regwrite(regwrite_s5), .wrreg(wrreg_s5),
			.wrdata(wrdata_s5));

	// pass rs to stage 3 (for forwarding)
	wire [4:0] rs_s3;
	sreggy #(.N(5)) reggy_s2_rs(.clk(clk), .stall(stall_s1_s2),
				.in(rs), .out(rs_s3));

	// transfer register data to stage 3
	wire [31:0]	data1_s3, data2_s3;
	sreggy #(.N(64)) reg_s2_mem(.clk(clk), .stall(stall_s1_s2),
				.in({data1, data2}),
				.out({data1_s3, data2_s3}));

	// transfer seimm, rt, and rd to stage 3
	wire [31:0] seimm_s3;
	wire [4:0] 	rt_s3;
	wire [4:0] 	rd_s3;
	sreggy #(.N(32)) reg_s2_seimm(.clk(clk), .stall(stall_s1_s2),
						.in(seimm), .out(seimm_s3));
	sreggy #(.N(10)) reg_s2_rt_rd(.clk(clk), .stall(stall_s1_s2),
						.in({rt, rd}), .out({rt_s3, rd_s3}));

	// transfer PC + 4 to stage 3
	wire [31:0] pc4_s3;
	sreggy #(.N(32)) reg_pc4_s2(.clk(clk), .stall(stall_s1_s2),
						.in(pc4_s2), .out(pc4_s3));

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

	// branch calculation
	reg pcsrc;
	always @(*) begin
		if (branch == 1'b1 && (rs == rt))
			pcsrc <= 1'b1; // take the branch
		else
			pcsrc <= 1'b0;
	end
	// signal to flush stage 3
	wire branch_flush;
	assign branch_flush = pcsrc;

	// branch calculation
	// shift left, seimm
	wire [31:0] seimm_sl2;
	assign seimm_sl2 = {seimm[29:0], 2'b0};  // shift left 2 bits
	// branch address
	wire [31:0] baddr_s2;
	assign baddr_s2 = pc4_s2 + seimm_sl2;

	// transfer the control signals to stage 3
	wire		regdst_s3;
	wire		memread_s3;
	wire		memwrite_s3;
	wire		memtoreg_s3;
	wire [1:0]	aluop_s3;
	wire		regwrite_s3;
	wire		alusrc_s3;
	// A bubble is inserted by setting all the control signals
	// to zero (stall_s1_s2).
	zreggy #(.N(8)) reg_s2_control(.clk(clk), .zero(stall_s1_s2),
			.in({regdst, memread, memwrite,
					memtoreg, aluop, regwrite, alusrc}),
			.out({regdst_s3, memread_s3, memwrite_s3,
					memtoreg_s3, aluop_s3, regwrite_s3, alusrc_s3}));
	// }}}

	// {{{ stage 3, EX (execute)

	// pass through some control signals to stage 4
	wire regwrite_s4;
	wire memtoreg_s4;
	wire memread_s4;
	wire memwrite_s4;
	reggy #(.N(4)) reg_s3(.clk(clk),
				.in({regwrite_s3, memtoreg_s3, memread_s3,
						memwrite_s3}),
				.out({regwrite_s4, memtoreg_s4, memread_s4,
						memwrite_s4}));

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
	reg [31:0] fw_data1_s3;
	always @(*)
	case (forward_a)
			2'd1: fw_data1_s3 = alurslt_s4;
			2'd2: fw_data1_s3 = wrdata_s5;
		 default: fw_data1_s3 = data1_s3;
	endcase
	alu alu1(.ctl(aluctl), .a(fw_data1_s3), .b(alusrc_data2),
				.out(alurslt));
	// pass ALU result and zero to stage 4
	wire [31:0]	alurslt_s4;
	reggy #(.N(32)) reg_alurslt(.clk(clk),
				.in({alurslt}),
				.out({alurslt_s4}));

	// pass data2 to stage 4
	wire [31:0] data2_s4;
	reg [31:0] fw_data2_s3;
	always @(*)
	case (forward_b)
			2'd1: fw_data2_s3 = alurslt_s4;
			2'd2: fw_data2_s3 = wrdata_s5;
		 default: fw_data2_s3 = data2_s3;
	endcase
	reggy #(.N(32)) reg_data2_s3(.clk(clk), .in(fw_data2_s3), .out(data2_s4));

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

	// pass wrreg to stage 5
	wire [4:0] wrreg_s5;
	reggy #(.N(5)) reg_wrreg_s4(.clk(clk),
				.in(wrreg_s4),
				.out(wrreg_s5));
	// }}}
			
	// {{{ stage 5, WB (write back)

	wire [31:0]	wrdata_s5;
	assign wrdata_s5 = (memtoreg_s5 == 1'b1) ? rdata_s5 : alurslt_s5;

	// }}}

	// {{{ forwarding

	// stage 3 (MEM) -> stage 2 (EX)
	// stage 4 (WB) -> stage 2 (EX)

	reg [1:0] forward_a;
	reg [1:0] forward_b;
	always @(*) begin
		// If the previous instruction (stage 4) would write,
		// and it is a value we want to read (stage 3), forward it.

		// data1 input to ALU
		if ((regwrite_s4 == 1'b1) && (wrreg_s4 == rs_s3)) begin
			forward_a <= 2'd1;  // stage 4
		end else if ((regwrite_s5 == 1'b1) && (wrreg_s5 == rs_s3)) begin
			forward_a <= 2'd2;  // stage 5
		end else
			forward_a <= 2'd0;  // no forwarding

		// data2 input to ALU
		if ((regwrite_s4 == 1'b1) & (wrreg_s4 == rt_s3)) begin
			forward_b <= 2'd1;  // stage 5
		end else if ((regwrite_s5 == 1'b1) && (wrreg_s5 == rt_s3)) begin
			forward_b <= 2'd2;  // stage 5
		end else
			forward_b <= 2'd0;  // no forwarding
	end
	// }}}

	// {{{ load use data hazard detection, signal stall

	/* If an operation in stage 4 (MEM) loads from memory (e.g. lw)
	 * and the operation in stage 3 (EX) depends on this value,
	 * a stall must be performed.  The memory read cannot 
	 * be forwarded because memory access is too slow.  It can
	 * be forwarded from stage 5 (WB) after a stall.
	 *
	 *   lw $1, 16($10)  ; I-type, rt_s3 = $1, memread_s3 = 1
	 *   sw $1, 32($12)  ; I-type, rt_s2 = $1, memread_s2 = 0
	 *
	 *   lw $1, 16($3)  ; I-type, rt_s3 = $1, memread_s3 = 1
	 *   sw $2, 32($1)  ; I-type, rt_s2 = $2, rs_s2 = $1, memread_s2 = 0
	 *
	 *   lw  $1, 16($3)  ; I-type, rt_s3 = $1, memread_s3 = 1
	 *   add $2, $1, $1  ; R-type, rs_s2 = $1, rt_s2 = $1, memread_s2 = 0
	 */
	reg stall_s1_s2;
	always @(*) begin
		if (memread_s3 == 1'b1 && ((rt == rt_s3) || (rs == rt_s3)) ) begin
			stall_s1_s2 <= 1'b1;  // perform a stall
		end else
			stall_s1_s2 <= 1'b0;  // no stall
	end
	// }}}

endmodule
