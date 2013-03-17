/*
 * Single stage program counter (PC).
 *
 * On each clock tick it increments the 32-bit
 * address by 4.
 *
 * The starting address can be specified using
 * the .START_ADDR parameter.
 */

`ifndef _pc
`define _pc

module pc(clk, pc_out);
	parameter START_ADDR = 0;

	input clk;

	output reg [31:0] pc_out = START_ADDR;

	always @(posedge clk) begin
		pc_out <= pc_out + 4;
	end
endmodule

`endif
