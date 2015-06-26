/*
 * cla_adder_4bit.v - 4 bit carry lookahead adder
 */

`include "cla_full_adder.v"

`ifndef _cla_adder_4bit
`define _cla_adder_4bit

module cla_adder_4bit(
		input wire	[3:0]	a,
		input wire	[3:0]	b,
		input wire			c_in,
		output wire	[3:0]	s,
		output wire			c_out);

	wire [4:0] c;
	wire [3:0] g, p;

	assign c[0] = c_in;
	assign c_out = c[4];

	cla_full_adder add0(.a(a[0]), .b(b[0]), .c(c[0]),
						.g(g[0]), .p(p[0]), .s(s[0]));

	assign c[1] = g[0] | (p[0] & c[0]);

	cla_full_adder add1(.a(a[1]), .b(b[1]), .c(c[1]),
						.g(g[1]), .p(p[1]), .s(s[1]));

	/*assign c[2] = g[1] | (p[1] & c[1]);*/
	assign c[2] = g[1] | (p[1] & (g[0] | (p[0] & c[0])));

	cla_full_adder add2(.a(a[2]), .b(b[2]), .c(c[2]),
						.g(g[2]), .p(p[2]), .s(s[2]));

	/*assign c[3] = g[2] | (p[2] & c[2]);*/
	assign c[3] = g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & c[0])))));

	cla_full_adder add3(.a(a[3]), .b(b[3]), .c(c[3]),
						.g(g[3]), .p(p[3]), .s(s[3]));

	/*assign c[4] = g[3] | (p[3] & c[3]);*/
	assign c[4] = g[3] | (p[3] &
					(g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & c[0])))))));

endmodule

`endif
