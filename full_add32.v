`ifndef _full_add32
`define _full_add32

`include "full_add8.v"

module full_add32(a, b, cin, s, cout);
	input  [31:0]	a, b;
	input			cin;
	output [31:0]	s;
	output			cout;

	wire c1, c2, c3;

	full_add8 fa1(.a(a[7:0]),   .b(b[7:0]),   .cin(cin),.s(s[7:0]),  .cout(c1));
	full_add8 fa2(.a(a[15:8]),  .b(b[15:8]),  .cin(c1), .s(s[15:8]), .cout(c2));
	full_add8 fa3(.a(a[23:16]), .b(b[23:16]), .cin(c2), .s(s[23:16]),.cout(c3));
	full_add8 fa4(.a(a[31:24]), .b(b[31:24]), .cin(c3), .s(s[31:24]),.cout(cout));

endmodule

`endif
