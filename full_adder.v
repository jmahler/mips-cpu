`ifndef _full_adder
`define _full_adder

module full_adder(
		input	a,
		input	b,
		input	c_in,
		output	s,
		output	c);

	assign s = a ^ (b ^ c_in);
	assign c = (a & b) | (c_in & (a | b));

endmodule

`endif
