/*
 * Single stage program counter (PC).
 *
 * On each clock tick it increments the 32-bit
 * address by 4.
 *
 * If 'branch' is high it will take the branch
 * address (baddr) and add it to PC + 4.
 *
 * The starting address can be specified using
 * the .START_ADDR parameter.
 */

`ifndef _pc
`define _pc

module pc(clk, pc_out, branch, baddr);
	parameter START_ADDR = 0;

	input 				clk;
	output reg	[31:0]	pc_out = START_ADDR;
	input				branch;
	output		[31:0]	baddr;

	always @(posedge clk) begin
		if (branch)
			pc_out <= pc_out + baddr;
		else
			pc_out <= pc_out + 4;
	end
endmodule

`endif
