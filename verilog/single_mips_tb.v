/*
 * single_mips_tb
 *
 * Test bench for the single cycle MIPS cpu.
 *
 * When run it will perform unit tests and display
 * tests that have failed along with summary at the end.
 *
 *   $ make
 *
 *   $ ./single_mips_tb
 *
 * It also generates output (single_mips_tb.vcd) suitable for
 * use with Gtkwave.
 */

`include "single_mips.v"

module single_mips_tb;

	integer tests, errs;

	integer i;
	reg clk;

	wire [31:0] pc;
	wire [31:0] im;
	wire [31:0] alurslt;
	wire [31:0] writedata;
	wire		regdst;
	wire		branch;
	wire		memread;
	wire		memtoreg;
	wire [1:0]	aluop;
	wire		memwrite;
	wire		alusrc;
	wire		regwrite;

	single_mips #(.NMEM(18), .IM_DATA("im_data.txt"))
			single_mips1(.clk(clk),
					.pc(pc), .im(im), .alurslt(alurslt),
					.writedata(writedata), .regdst(regdst),
					.branch(branch), .memread(memread),
					.memtoreg(memtoreg), .aluop(aluop),
					.memwrite(memwrite), .alusrc(alusrc),
					.regwrite(regwrite));

	always begin
		clk <= ~clk;
		#5;
	end

	// {{{ test functions
	// test a 32 bit value
	task t32;
		input reg [8*10:0] name;  // string
		input [31:0] a;
		input [31:0] b;

		begin
			tests = tests + 1;
			if (a == b) begin
			end else begin
				$display("ERROR: %s = %x, expected %x.", name, a, b);
				errs = errs + 1;
			end
		end
	endtask

	// test a single bit value
	task t1;
		input reg [8*10:0] name;  // string
		input a;
		input b;

		begin
			tests = tests + 1;
			if (a == b) begin
			end else begin
				$display("ERROR: %s = %x, expected %x.", name, a, b);
				errs = errs + 1;
			end
		end
	endtask

	// test a dual bit value
	task t2;
		input reg [8*10:0] name;  // string
		input [1:0] a;
		input [1:0] b;

		begin
			tests = tests + 1;
			if (a == b) begin
			end else begin
				$display("ERROR: %s = %x, expected %x.", name, a, b);
				errs = errs + 1;
			end
		end
	endtask
	// }}}

	initial begin
		$dumpfile("single_mips_tb.vcd");
		$dumpvars(0, single_mips_tb);

		tests = 0;
		errs = 0;

		clk <= 1'b0;

		@(posedge clk);

		// add $0, $0, $0
		t32("PC", pc, 0);
		t32("IM", im, 32'h00000020);
		t32("ALUResult", alurslt, 0);
		t32("WriteData", writedata, 0);
		t1("RegDst", regdst, 1);
		t1("Branch", branch, 0);
		t1("MemRead", memread, 0);
		t1("MemToReg", memtoreg, 0);
		t2("ALUOp", aluop, 2'd2);
		t1("MemWrite", memwrite, 0);
		t1("ALUSrc", alusrc, 0);
		t1("RegWrite", regwrite, 1);
		@(posedge clk);

		// add $s0, $zero, $zero
		t32("PC", pc, 4);
		t32("IM", im, 32'h00008020);
		t32("ALUResult", alurslt, 0);
		t32("WriteData", writedata, 0);
		t1("RegDst", regdst, 1);  // rd
		t1("Branch", branch, 0);
		t1("MemRead", memread, 0);
		t1("MemToReg", memtoreg, 0);
		t2("ALUOp", aluop, 2);
		t1("MemWrite", memwrite, 0);
		t1("ALUSrc", alusrc, 0);
		t1("RegWrite", regwrite, 1);
		@(posedge clk);

		// addi $t0, $zero, 1
		t32("PC", pc, 8);
		t32("IM", im, 32'h20080001);
		t32("ALUResult", alurslt, 1);
		t32("WriteData", writedata, 1);
		t1("RegDst", regdst, 0);
		t1("Branch", branch, 0);
		t1("MemRead", memread, 0);
		t1("MemToReg", memtoreg, 0);
		t2("ALUOp", aluop, 0);
		t1("MemWrite", memwrite, 0);
		t1("ALUSrc", alusrc, 1);
		t1("RegWrite", regwrite, 1);
		@(posedge clk);

		// sw $t0, 0($s0)
		t32("PC", pc, 12);
		t32("IM", im, 32'hAE080000);
		t32("ALUResult", alurslt, 0);
		t32("WriteData", writedata, 0);
		//t1("RegDst", regdst, 1);  // X
		t1("Branch", branch, 0);
		t1("MemRead", memread, 0);
		t1("MemToReg", memtoreg, 0);
		t2("ALUOp", aluop, 0);
		t1("MemWrite", memwrite, 1);
		t1("ALUSrc", alusrc, 1);
		t1("RegWrite", regwrite, 0);
		@(posedge clk);

		// addi $t0, $zero, 2
		t32("PC", pc, 16);
		t32("IM", im, 32'h20080002);
		t32("ALUResult", alurslt, 2);
		t32("WriteData", writedata, 2);
		t1("RegDst", regdst, 0);
		t1("Branch", branch, 0);
		t1("MemRead", memread, 0);
		t1("MemToReg", memtoreg, 0);
		t2("ALUOp", aluop, 0);
		t1("MemWrite", memwrite, 0);
		t1("ALUSrc", alusrc, 1);
		t1("RegWrite", regwrite, 1);
		@(posedge clk);

		// sw $t0, 4($s0)
		t32("PC", pc, 20);
		t32("IM", im, 32'hAE080004);
		t32("ALUResult", alurslt, 4);
		t32("WriteData", writedata, 4);
		//t1("RegDst", regdst, 1);  // X
		t1("Branch", branch, 0);
		t1("MemRead", memread, 0);
		t1("MemToReg", memtoreg, 0);
		t2("ALUOp", aluop, 0);
		t1("MemWrite", memwrite, 1);
		t1("ALUSrc", alusrc, 1);
		t1("RegWrite", regwrite, 0);
		@(posedge clk);

		$display("%d tests performed, %d failed.", tests, errs);

		$finish;
	end
endmodule
