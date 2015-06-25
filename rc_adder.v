/*
 * rc_adder.v - ripple carry adder
 */

`include "full_adder.v"
`include "half_adder.v"

`ifndef _rc_adder
`define _rc_adder

module rc_adder(
		input wire	[N-1:0] a,
		input wire	[N-1:0] b,
		output wire [N-1:0] s,
		output wire			c);

	parameter N = 32;  /* number of bits */

	wire [N-1:0] _c;

	assign c = _c[N-1];

	half_adder add0(.a(a[0]), .b(b[0]), .s(s[0]),
					.c(_c[0]));

	genvar i;
	generate
		for (i = 1; i < N; i = i + 1) begin : gen_adder
			full_adder addN(.a(a[i]), .b(b[i]), .s(s[i]),
							.c_in(_c[i - 1]), .c(_c[i]));
		end
	endgenerate

endmodule

`endif
