`ifndef _alu
`define _alu

/*`include "rc_adder.v"*/

module alu(
		input		[3:0]	ctl,
		input		[31:0]	a, b,
		output reg	[31:0]	out,
		output				zero);

	wire [31:0] sub_ab;
	wire [31:0] add_ab;
	wire 		oflow_add;
	wire 		oflow_sub;
	wire 		oflow;
	wire 		slt;

	assign zero = (0 == out);

	assign sub_ab = a - b;
	assign add_ab = a + b;
	/*rc_adder #(.N(32)) add0(.a(a), .b(b), .s(add_ab));*/

	// overflow occurs (with 2s complement numbers) when
	// the operands have the same sign, but the sign of the result is
	// different.  The actual sign is the opposite of the result.
	// It is also dependent on whether addition or subtraction is performed.
	assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0;
	assign oflow_sub = (a[31] == b[31] && sub_ab[31] != a[31]) ? 1 : 0;

	assign oflow = (ctl == 4'b0010) ? oflow_add : oflow_sub;

	// set if less than, 2s compliment 32-bit numbers
	assign slt = oflow_sub ? ~(a[31]) : a[31];

	always @(*) begin
		case (ctl)
			4'd2:  out <= add_ab;				/* add */
			4'd0:  out <= a & b;				/* and */
			4'd12: out <= ~(a | b);				/* nor */
			4'd1:  out <= a | b;				/* or */
			4'd7:  out <= {{31{1'b0}}, slt};	/* slt */
			4'd6:  out <= sub_ab;				/* sub */
			4'd13: out <= a ^ b;				/* xor */
			default: out <= 0;
		endcase
	end

endmodule

`endif
