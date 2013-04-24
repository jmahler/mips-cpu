
/*
 * NAME
 *
 * reggy - regify some data
 *
 * DESCRIPTION
 *
 * The reggy module can be used to register variables.
 * And this is useful if data should be kept for several
 * stages.
 *
 *   wire [7:0] in1;
 *   wire [7:0] out1;
 *   wire [7:0] out2;
 *
 *   reggy #(.N(8)) r1(.clk(clk), .in(in1), .out(out1))
 *   reggy #(.N(8)) r2(.clk(clk), .in(out1), .out(out2))
 *
 * Or if it is desired to put a bunch of variables in a
 * register.
 *
 *   reggy #(.N(16)) r1(.clk(clk), .in({x1, x2}), .out({y1, y2}))
 *
 */

`ifndef _reggy
`define _reggy

module reggy(
	input clk,
	input wire [N-1:0] in,
	output reg [N-1:0] out);

	parameter N = 8;

	always @(posedge clk) begin
		out <= in;
	end

endmodule

`endif
