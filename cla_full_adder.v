/*
 * cla_full_adder - 1 bit full adder for carry lookahead
 */

`ifndef _cla_full_adder
`define _cla_full_adder

module cla_full_adder(
		input	a,
		input	b,
		input	c,
		output	g,
		output	p,
		output	s);

	assign g = a & b;
	assign p = a ^ b;
	assign s = a ^ (b ^ c);

endmodule

`endif
