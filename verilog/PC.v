/*
 * Single stage program counter (PC).
 *
 * On each clock tick it increments the 32-bit
 * address by 4.
 *
 * The starting address can be specified using
 * the .START_ADDR parameter.
 */

`ifndef _PC
`define _PC

module PC(clk, PC_out);
	parameter START_ADDR = 0;

	input clk;

	output reg [31:0] PC_out = START_ADDR;

	always @(posedge clk) begin
		PC_out <= PC_out + 4;
	end
endmodule

`endif
