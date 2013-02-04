/*
 * This ALU is built from gates and does not "cheat"
 * by using Verilog builtins.  See alu1 for the "cheat" version.
 *
 */

`ifndef _alu2
`define _alu2

`include "full_add32.v"

module alu2(ctl, a, b, out, z);
	input [3:0] ctl;
	input [31:0] a, b;
	output reg [31:0] out;
	output z;

	wire [31:0] add_ab, and_ab, nor_ab, or_ab, slt_ab, sub_ab, xor_ab;
	wire [31:0] a_n, b_n;
	wire [31:0] _b;
	wire		cin;
	wire		sign;

	full_add32 a32_1(.a(a), .b(_b), .cin(cin), .s(add_ab), .sign(sign));

	assign sub_ab = add_ab;

	assign slt_ab = {{31{1'b0}}, sign};

	localparam [3:0]
		CTL_ADD = 4'b0010,  // 2
		CTL_AND = 4'b0000,  // 0
		CTL_NOR = 4'b1100,  // 12
		CTL_OR  = 4'b0001,  // 1
		CTL_SLT = 4'b0111,  // 7
		CTL_SUB = 4'b0110,  // 6
		CTL_XOR = 4'b1101;  // 13

	// b can be negated to perform subtraction with adder
	assign b_n = ~b;
	assign _b = (ctl == CTL_SLT || ctl == CTL_SUB) ? b_n : b;

	// for subtraction, the first carry in is 1 (2's complement)
	assign cin = (ctl == CTL_SLT || ctl == CTL_SUB) ? 1'b1 : 1'b0;

	assign and_ab = a & b;
	assign or_ab = a | b;
	assign nor_ab = ~(or_ab);
	assign xor_ab = a ^ b;

	assign z = (32'd0 == out);

	always @(*)
		case (ctl)
			CTL_ADD: out <= add_ab;
			CTL_AND: out <= and_ab;
			CTL_NOR: out <= nor_ab;
			CTL_OR:  out <= or_ab;
			CTL_SLT: out <= slt_ab;
			CTL_SUB: out <= sub_ab;
			CTL_XOR: out <= xor_ab;
			default: out <= {32{1'b0}};
		endcase
endmodule

`endif
