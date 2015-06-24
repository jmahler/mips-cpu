/*
 * NAME
 *
 * regr - register of data that can be held or cleared
 *
 * DESCRIPTION
 *
 * The regr (register) module can be used to store data in the current
 * cylcle so it will be output on the next cycle.  Signals are also
 * provided to hold the data or clear it.  The hold and clear signals
 * are both synchronous with the clock.
 *
 * The first example creates a 8-bit register.  The clear and hold
 * signals are taken from elsewhere.
 *
 *   wire [7:0] data_s1;
 *   wire [7:0] data_s2;
 *
 *   regr #(.N(8)) r1(.clk(clk), .clear(clear), .hold(hold),
 *                      .in(data_s1), .out(data_s2))
 *
 * Multiple signals can be grouped together using array notation.
 *
 *   regr #(.N(8)) r1(.clk(clk), .clear(clear), .hold(hold),
 *                      .in({x1, x2}), .out({y1, y2}))
 */

`ifndef _regr
`define _regr

module regr (
	input clk,
	input clear,
	input hold,
	input wire [N-1:0] in,
	output reg [N-1:0] out);

	parameter N = 1;

	always @(posedge clk) begin
		if (clear)
			out <= {N{1'b0}};
		else if (hold)
			out <= out;
		else
			out <= in;
	end
endmodule

`endif
