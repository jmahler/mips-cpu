`ifndef _alu
`define _alu

module alu(clk, ctl, a, b, out, z);
	input				clk;
	input		[3:0]	ctl;
	input		[31:0]	a, b;
	output reg	[31:0]	out;
	output				z;

	wire [31:0] sub_ab;
	wire [31:0] add_ab;
	wire 		oflow_add;
	wire 		oflow_sub;
	wire 		oflow;
	wire 		slt;

	assign z = (0 == out);

	assign sub_ab = a - b;
	assign add_ab = a + b;

	// overflow occurs (with 2's complement numbers) when
	// the operands have the same sign, but the sign of the result is
	// different.  The actual sign is the opposite of the result.
	// It is also dependent on wheter addition or subtraction is performed.
	assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0;
	assign oflow_sub = (a[31] == b[31] && sub_ab[31] != a[31]) ? 1 : 0;

	assign oflow = (ctl == 4'b0010) ? oflow_add : oflow_sub;

	// set if less than, 2s compliment 32-bit numbers
	assign slt = oflow_sub ? ~(a[31]) : a[31];

	always @(posedge clk) begin
		case (ctl)
			4'b0010: out <= add_ab;
			4'b0000: out <= a & b;
			4'b1100: out <= ~(a | b);
			4'b0001: out <= a | b;
			4'b0111: out <= {{30{1'b0}}, slt};
			4'b0110: out <= sub_ab;
			4'b1101: out <= a ^ b;
			default: out <= 0;
		endcase
	end

endmodule

`endif
