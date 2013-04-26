
/*
 * NAME
 *
 * zreggy - register of data that can be zeroed out
 *
 * DESCRIPTION
 *
 * Works the same as the 'reggy' module except that the
 * data can be zeroed.
 *
 *   wire       zero1;  // some external zero signal
 *   wire [7:0] in1;
 *   wire [7:0] out1;
 *
 *   sreggy #(.N(8)) r1(.clk(clk), .zero(zero1), .in(in1), .out(out1))
 *
 */

`ifndef _zreggy
`define _zreggy

module zreggy(
	input clk,
	input zero,
	input wire [N-1:0] in,
	output reg [N-1:0] out);

	parameter N = 8;

	always @(posedge clk) begin
		if (zero)
			out <= {N{1'b0}};
		else
			out <= in;
	end
endmodule

`endif
