`ifndef _full_add32
`define _full_add32

`include "full_add8.v"

module full_add32(a, b, cin, s, cout, sign);
	input  [31:0]	a, b;
	input			cin;
	output [31:0]	s;
	output			cout;
	output			sign;

	wire c1, c2, c3;

	// An overflow occurs when the addition of two operands with
	// the same sign has a result with the opposite sign.
	assign oflow = (a[31] == b[31] && s[31] != a[31]) ? 1'b1 : 1'b0;

	// sign of the result, accounting for overflow
	assign sign = oflow ? ~(s[31]) : s[31];

	full_add8 fa1(.a(a[7:0]),   .b(b[7:0]),   .cin(cin),.s(s[7:0]),  .cout(c1));
	full_add8 fa2(.a(a[15:8]),  .b(b[15:8]),  .cin(c1), .s(s[15:8]), .cout(c2));
	full_add8 fa3(.a(a[23:16]), .b(b[23:16]), .cin(c2), .s(s[23:16]),.cout(c3));
	full_add8 fa4(.a(a[31:24]), .b(b[31:24]), .cin(c3), .s(s[31:24]),.cout(cout));

endmodule

`endif
