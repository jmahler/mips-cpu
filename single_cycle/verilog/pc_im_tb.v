`include "pc.v"
`include "im.v"

module pc_im_tb;

	integer i = 0;
	integer n = 0;
	integer err = 0;

	reg clk;

	wire [31:0] pcaddr;
	wire [31:0] imout;
	wire [6:0] imaddr;

	pc #(.START_ADDR(0)) pc1(.clk(clk), .pc_out(pcaddr));

	assign imaddr = pcaddr[8:2]; // right shift 2, lowest 7 bits

	im #(.NMEM(20), .IM_DATA("im_data.txt")) im1(.addr(imaddr), .out(imout));

	always begin
		clk <= ~clk;
		#5;
	end

	// Check that the program counter is incrementing
	// normally.  This wont work with jumps or branches.
	always @(posedge clk) begin
		n <= n + 1;

		if (pcaddr != n*4) begin
			$display("incorrect PC at %d, expected %d, got %d",
				n, n*4, pcaddr);

			err = err + 1;
		end

	end

	// Check the first few instructions
	initial begin
		@(posedge clk);
		if (imout == 32'h20000000) begin
		end else begin
			err = err + 1;
			$display("first instruction wrong.");
		end

		@(posedge clk);
		if (imout == 32'h20800000) begin
		end else begin
			err = err + 1;
			$display("second instruction wrong: %x.", imout);
		end

		@(posedge clk);
		if (imout == 32'h01000820) begin
		end else begin
			err = err + 1;
			$display("third instruction wrong: %x.", imout);
		end

	end

	initial begin
		$dumpfile("pc_im_tb.vcd");
		$dumpvars(0, pc_im_tb);

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
