
/*
 * Currently this just produces a dumpfile
 * suitable for Gtkwave (im_cached_tb.vcd).
 *
 * To build this filter run:
 *
 *   $ make im_cached_tb.vcd
 *
 */

`include "im_cached.v"

module im_cached_tb;

	integer i;

	reg clk;

	reg [31:0]	addr;
	wire		hit;
	wire [31:0]	data;

	im_cached #(.IM_DATA("im_slow_tb.hex"), .NMEM(14), .ND(3))
		im1(.clk(clk), .addr(addr), .hit(hit), .data(data));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("im_cached_tb.vcd");
		$dumpvars(0, im_cached_tb);

		clk <= 1'b0;

		// try address zero
		addr <= 32'd0;
		@(posedge hit);

		@(posedge clk);

		// try some other address
		addr <= 32'd4;
		@(posedge hit);

		@(posedge clk);

		// briefly try some other address
		addr <= 32'd8;
		@(posedge clk);

		// try the original address, it should be in the cache
		addr <= 32'd0;
		@(posedge hit);

		@(posedge clk);

		$finish;
	end

endmodule
