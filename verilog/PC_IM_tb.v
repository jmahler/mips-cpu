`include "PC.v"
`include "IM.v"

module PC_IM_tb;

	integer i = 0;
	integer n = 0;
	integer err = 0;

	reg clk;

	wire [31:0] addr;
	wire [31:0] IM_out;

	PC #(.START_ADDR(0)) PC1(.clk(clk), .PC_out(addr));
	IM #(.NMEM(20), .IM_DATA("IM_DATA.txt")) IM1(.addr(addr), .out(IM_out));

	always begin
		clk <= ~clk;
		#5;
	end

	// Check that the program counter is incrementing
	// normally.  This wont work with jumps or branches.
	always @(posedge clk) begin
		n <= n + 1;

		if (addr != n*4) begin
			$display("incorrect PC at %d, expected %d, got %d",
				n, n*4, addr);

			err = err + 1;
		end

	end

	// Check the first few instructions
	initial begin
		@(posedge clk);
		if (IM_out != 32'h20000000) begin
			$display("first instruction wrong.\n");
		end

		@(posedge clk);
		if (IM_out != 32'h20800000) begin
			$display("second instruction wrong: %x.\n", IM_out);
		end

		@(posedge clk);
		if (IM_out != 32'h01000820) begin
			$display("third instruction wrong: %x.\n", IM_out);
		end

	end

	initial begin
		$dumpfile("PC_IM_tb.vcd");
		$dumpvars(0, PC_IM_tb);

		clk <= 1'b0;

		for (i = 0; i < 20; i = i + 1) begin
			@(posedge clk);
		end


		if (err > 0) begin
			$display("%d tests failed.", err);
		end else begin
			$display("All tests passed.");
		end

		$finish;
	end

endmodule
