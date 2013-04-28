
/*
 * NAME
 *
 * szreggy - register of data that can be stalled and zeroed out
 *
 * DESCRIPTION
 *
 * Works the same as the 'reggy' module except that the
 * data can be zeroed and/or stalled.
 *
 */

`ifndef _szreggy
`define _szreggy

module szreggy(
	input clk,
	input zero,
	input stall,
	input wire [N-1:0] in,
	output reg [N-1:0] out);

	parameter N = 8;

	always @(posedge clk) begin
		if (zero)
			out <= {N{1'b0}};
		else if (stall)
			out <= out;
		else
			out <= in;
	end
endmodule

`endif
