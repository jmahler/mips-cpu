
/*
 * This ALU works by using Verilog builtins (+, -, <)
 * which should be implemented by the student.
 * See alu2 for this implementation.
 * They should both work identically.
 *
 */

module alu1(ctl, a, b, out, z);
	input [3:0] ctl;
	input [31:0] a, b;
	output reg [31:0] out;
	output z;

	wire [31:0] b_n;
	wire [31:0] sub_ab;
	wire oflow;
	wire slt;

	assign z = (0 == out);

	assign sub_ab = a + b_n;

	// overflow occurs (with 2's complement numbers) when
	// the operands have the same sign, but the sign of the result is
	// different.  The actual sign is the opposite of the result.
	assign oflow = (a[31] == b_n[31] && sub_ab[31] != a[31]) ? 1 : 0;

	assign slt = oflow ? ~(a[31]) : a[31];

	always @(*)
		case (ctl)
			4'b0010: out <= a + b;
			4'b0000: out <= a & b;
			4'b1100: out <= ~(a | b);
			4'b0001: out <= a | b;
			4'b0111: out <= {{30{1'b0}}, slt};
			4'b0110: out <= sub_ab;
			4'b1101: out <= a ^ b;
			default: out <= 0;
		endcase
endmodule

