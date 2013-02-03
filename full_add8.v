`ifndef _full_add8
`define _full_add8

`include "full_add4.v"

module full_add8(a, b, cin, s, cout);
	input  [7:0]	a, b;
	input 			cin;
	output [7:0]	s;
	output 			cout;

	full_add4 fa1(.a(a[3:0]), .b(b[3:0]), .cin(cin), .s(s[3:0]), .cout(c1));
	full_add4 fa2(.a(a[7:4]), .b(b[7:4]), .cin(c1),  .s(s[7:4]), .cout(cout));

endmodule

`endif
