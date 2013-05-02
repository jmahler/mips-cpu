
/*
 * NAME
 *
 * sreggy - stallable register of data
 *
 * DESCRIPTION
 *
 * Works the same as the 'reggy' module except that the
 * data can be stalled (held).
 *
 *   wire       stall1;  // some external stall signal
 *   wire [7:0] in1;
 *   wire [7:0] out1;
 *
 *   sreggy #(.N(8)) r1(.clk(clk), .stall(stall1), .in(in1), .out(out1))
 *
 */

`ifndef _sreggy
`define _sreggy

module sreggy(
	input clk,
	input stall,
	input wire [N-1:0] in,
	output reg [N-1:0] out);

	parameter N = 8;

	always @(posedge clk) begin
		if (stall == 1'b1)
			out <= out;
		else
			out <= in;
	end

endmodule

`endif
