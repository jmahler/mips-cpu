
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

	assign z = (0 == out);

	always @(*)
		case (ctl)
			4'b0010: out <= a + b;
			4'b0000: out <= a & b;
			4'b1100: out <= ~(a | b);
			4'b0001: out <= a | b;
			4'b0111: out <= a < b ? 1 : 0;
			4'b0110: out <= a - b;
			4'b1101: out <= a ^ b;
			default: out <= 0;
		endcase
endmodule

