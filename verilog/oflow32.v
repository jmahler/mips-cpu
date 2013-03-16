`ifndef _oflow32
`define _oflow32

module oflow32(a, b, s, oflow);

	input [31:0] a, b, s;

	output oflow;

	// An overflow occurs when the addition of two operands with
	// the same sign has a result with the opposite sign.
	assign oflow = (a[31] == b[31] && s[31] != a[31]) ? 1'b1 : 1'b0;

endmodule

`endif
