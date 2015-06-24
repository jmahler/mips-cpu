/*
 * Program counter (PC) test bench for 5 stage
 * MIPS CPU.
 *
 * Currently only runs for several cycles and
 * dumps a .vcd for Gtkwave.
 */

`include "pc.v"

module pc_tb;

	integer i = 0;

	reg clk;

	wire [31:0]	pc;
	reg			branch;
	reg [31:0]	baddr;

	pc pc1(.clk(clk), .pc(pc), .branch(branch), .baddr(baddr));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("pc_tb.vcd");
		$dumpvars(0, pc_tb);

		clk <= 1'b0;

		branch <= 1'b0;
		baddr <= 12;

		for (i = 0; i < 2; i = i + 1) begin
			@(posedge clk);
		end

		branch <= 1'b1;
		baddr <= 10;
		@(posedge clk);

		branch <= 1'b0;
		@(posedge clk);

		for (i = 0; i < 3; i = i + 1) begin
			@(posedge clk);
		end

		$finish;
	end

endmodule
