/*
 * Program Counter (PC) for a 5 stage MIPS cpu.
 *
 * On each clock tick it increments the 32-bit
 * address by 4.
 *
 * The branch is controlled in stage 3.
 * If branch is held high it will added to the
 * value to the PC + 4 from two cycles ago
 * (from stage 1).
 * 
 * If a branch was directed in stage 3 this
 * trigger a branch in stage 1 during the next step.
 *
 */

`ifndef _pc
`define _pc

module pc(
		input 				clk,
		output		[31:0]	pc,
		input				branch,
		input		[31:0]	baddr);  // branch address (relative)

	reg 		b1 = 1'b0;  // branch in stage 1
	reg	[31:0]	pc0 = 32'd0;
	reg	[31:0]	pc1 = 32'd0;
	reg	[31:0]	pc2 = 32'd0;
	reg	[31:0]	pc3 = 32'd0;

	assign pc = pc0;

	// stage 1
	always @(posedge clk) begin
		if (b1)
			pc0 <= pc3;
		else
			pc0 <= pc0 + 4;

		pc1 <= pc0;
	end

	// stage 2
	always @(posedge clk) begin
		pc2 <= pc1;
	end

	// stage 3
	always @(posedge clk) begin
		// default
		pc3 <= 32'd0;	// don't care
		b1 <= 1'b0;  	// don't branch

		if (branch) begin
			pc3 <= pc2 + baddr;
			b1 <= 1'b1;  // branch on the next stage
		end
	end

endmodule

`endif
