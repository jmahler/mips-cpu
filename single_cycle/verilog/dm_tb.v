/*
 * Data memory test bench.
 */

`include "dm.v"

module dm_tb;

	integer err = 0;

	reg clk;

	reg	 [6:0]	addr;
	reg	 [31:0]	wdata;
	wire [31:0]	rdata;
	reg			rd, wr;

	dm dm1(.clk(clk), .addr(addr), .rd(rd), .wr(wr),
				.wdata(wdata), .rdata(rdata));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("dm_tb.vcd");
		$dumpvars(0, dm_tb);

		clk <= 1'b0;
		addr <= 0;
		rd <= 0;
		wr <= 0;
		wdata <= 0;
		@(posedge clk);

		// write some data
		addr <= 0;
		wdata <= 32'd6;
		wr <= 1;
		@(posedge clk);

		addr <= 4;
		wdata <= 12;
		wr <= 1;
		@(posedge clk);

		addr <= 127;
		wdata <= 128;
		wr <= 1;
		@(posedge clk);

		// read the values
		addr <= 0;
		wr <= 0;
		rd <= 1;
		@(posedge clk);
		if (rdata == 6) begin
		end else begin
			$display("mem[%d] = %d, expected %d", addr, rdata, 6);
			err = err + 1;
		end

		addr <= 127;
		wr <= 0;
		rd <= 1;
		@(posedge clk);
		if (rdata == 128) begin
		end else begin
			$display("mem[%d] = %d, expected %d", addr, rdata, 128);
			err = err + 1;
		end

		addr <= 4;
		wr <= 0;
		rd <= 1;
		@(posedge clk);
		if (rdata == 12) begin
		end else begin
			$display("mem[%d] = %d, expected %d", addr, rdata, 12);
			err = err + 1;
		end

		if (err > 0) begin
			$display("%d tests failed.", err);
		end else begin
			$display("All tests passed.");
		end

		$finish;
	end

endmodule
