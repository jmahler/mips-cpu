
`ifndef _add4
`define _add4

`include "half_adder.v"
`include "full_adder.v"

module add4(a, b, s, cout);
	input  [3:0] 	a, b;
	output [3:0] 	s;
	output 			cout;

	wire c1, c2, c3;

	half_adder hfadd1(.a(a[0]), .b(b[0]), 			.s(s[0]), .cout(c1));
	full_adder  fadd2(.a(a[1]), .b(b[1]), .cin(c1), .s(s[1]), .cout(c2));
	full_adder  fadd3(.a(a[2]), .b(b[2]), .cin(c2), .s(s[2]), .cout(c3));
	full_adder  fadd4(.a(a[3]), .b(b[3]), .cin(c3), .s(s[3]), .cout(cout));

endmodule

`endif
