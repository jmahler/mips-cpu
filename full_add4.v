
`ifndef _full_add4
`define _full_add4

`include "full_adder.v"

module full_add4(a, b, cin, s, cout);
	input [3:0]		a, b;
	input			cin;
	output [3:0]	s;
	output			cout;

	wire cout1, cout2, cout3;

	full_adder fadd_1(.a(a[0]), .b(b[0]), .cin(cin),   .s(s[0]), .cout(cout1));
	full_adder fadd_2(.a(a[1]), .b(b[1]), .cin(cout1), .s(s[1]), .cout(cout2));
	full_adder fadd_3(.a(a[2]), .b(b[2]), .cin(cout2), .s(s[2]), .cout(cout3));
	full_adder fadd_4(.a(a[3]), .b(b[3]), .cin(cout3), .s(s[3]), .cout(cout));

endmodule

`endif
