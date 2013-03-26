
/*
 * stage1_if.v
 *
 * Stage 1 of the five cycle MIPS CPU.
 * Performs the instruction fetch (IF) step.
 *
 * With pc_src = 0, the program counter (PC)
 * will increment by 4 on each step.
 * When pc_src = 1, the program counter
 * will take its new address from pc_addr.
 *
 * The instruction memory is initialized using
 * the parameter IM_DATA to specify the data file
 * in ascii hex and NMEM to specify the number of
 * lines (instructions).
 */

`ifndef _stage1_if
`define _stage1_if

`include "im.v"

module stage1_if(clk, pc_src, pc_addr, pc_p4, im_out, if_pc, if_instr);

	parameter NMEM = 128;
	parameter IM_DATA = "im_data.txt";

	// control inputs and data outputs
	input wire			clk;
	input wire			pc_src;  // 1 -> use pc_addr, 0 -> PC + 4
	input wire [31:0]	pc_addr;
	output reg [31:0]	pc_p4;  // PC + 4
	output wire [31:0]	im_out;	// instruction memory output

	// diagnostic outputs
	output wire [31:0] if_pc;
	output wire [31:0] if_instr;

	assign if_pc = pc;

	wire [31:0] _im_out;
	assign im_out = _im_out;
	assign if_instr = _im_out;

	// instruction memory
	im #(.NMEM(NMEM), .IM_DATA(IM_DATA))
		im1(.clk(clk), .addr(pc[8:2]), .out(_im_out));

	reg [31:0] pc;

	initial begin
		pc <= 32'd0;
	end

	always @(posedge clk) begin
		if (pc_src == 1'b1)
			pc <= pc_addr;
		else
			pc <= pc + 4;

		pc_p4 <= pc + 4;
	end

endmodule

`endif
