`ifndef _add8
`define _add8

`include "add4.v"
`include "full_add4.v"

module add8(a, b, s, cout);
	input  [7:0]	a, b;
	output [7:0]	s;
	output			cout;

	wire c1;

		 add4 ha1(.a(a[3:0]), .b(b[3:0]),           .s(s[3:0]), .cout(c1));
	full_add4 fa2(.a(a[7:4]), .b(b[7:4]), .cin(c1), .s(s[7:4]), .cout(cout));
endmodule

`endif
