/*
 * NAME
 *
 * pc.v - program counter
 *
 * DESCRIPTION
 *
 * On each clock tick it increments the 32-bit address by 4.
 *
 * The branch is controlled in stage 3.  If the 'branch' signal is held
 * high the branch address ('baddr') will added to the value of PC + 4
 * from two cycles ago (from stage 1).
 * 
 * If a branch was directed in stage 3 this triggers a branch in stage
 * 1 during the next step.
 *
 */

`ifndef _pc
`define _pc

module pc(
		input				clk,
		output		[31:0]	pc,
		input				branch,
		input		[31:0]	baddr);  // branch address (relative)

	reg 	branch3 = 1'b0;
	reg	[31:0]	pc0 = 32'd0;
	reg	[31:0]	pc1 = 32'd0;
	reg	[31:0]	pc2 = 32'd0;
	reg	[31:0]	pc3 = 32'd0;

	assign pc = pc0;

	always @(posedge clk) begin

		if (branch3)
			pc0 <= pc3;		// stage 3 said to branch
		else
			pc0 <= pc0 + 4;	// normal increment

		// propagate pc through stage 1 and 2
		pc1 <= pc0;
		pc2 <= pc1;

		// default
		pc3		<= 32'd0;	// don't care
		branch3 <= 1'b0;  	// don't branch

		if (branch) begin
			pc3 <= pc2 + baddr;
			branch3 <= 1'b1;  // branch on the next stage
		end
	end

endmodule

`endif
