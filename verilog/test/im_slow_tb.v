
/*
 * Currently this just produces a dumpfile
 * suitable for Gtkwave (im_slow_tb.vcd).
 *
 * To build this filter run:
 *
 *   $ make im_slow_tb.vcd
 *
 */

`include "im_slow.v"

module im_slow_tb;

	integer i;

	reg clk;

	reg [31:0]	addr;
	wire		rdy;
	wire [31:0]	data;

	im_slow #(.IM_DATA("im_slow_tb.hex"), .NMEM(14), .ND(3))
		im1(.clk(clk), .addr(addr), .rdy(rdy), .data(data));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("im_slow_tb.vcd");
		$dumpvars(0, im_slow_tb);

		//$display("addr,  rd, wr, rdata,    wdata");
		//$monitor("%x,    %x,  %x,  %x, %x", addr, rd, wr, rdata, wdata);

		clk <= 1'b0;
		addr <= 32'd0;

		for (i = 0; i < 5; i = i + 1) begin
			@(posedge clk);
		end

		addr <= 32'd4;
		@(posedge clk);
		@(posedge clk);

		addr <= 32'd8;

		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		$finish;
	end

endmodule
