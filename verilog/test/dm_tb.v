/*
 * Data memory test bench for five stage MIPS CPU.
 *
 * Currently only runs for several cycles and
 * dumps a .vcd for Gtkwave.
 */

`include "dm.v"

module dm_tb;

	reg clk;

	reg [6:0]	addr;
	reg			rd, wr;
	reg [31:0]	wdata;
	wire [31:0]	rdata;

	dm dm1(.clk(clk), .addr(addr), .rd(rd), .wr(wr),
				.rdata(rdata), .wdata(wdata));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("dm_tb.vcd");
		$dumpvars(0, dm_tb);

		$display("addr,  rd, wr, rdata,    wdata");
		$monitor("%x,    %x,  %x,  %x, %x", addr, rd, wr, rdata, wdata);

		clk <= 1'b0;
		rd <= 1'b0;
		wr <= 1'b0;
		addr <= 7'd0;

		@(posedge clk);

		wdata <= 32'hABCDEF01;
		addr <= 7'd0;
		rd <= 1'b0;
		wr <= 1'b1;

		@(posedge clk);

		wdata <= 32'hFFFFAAAA;
		addr <= 7'd1;
		rd <= 1'b0;
		wr <= 1'b1;

		@(posedge clk);

		rd <= 1'b1;
		wr <= 1'b0;
		addr <= 7'd0;

		@(posedge clk);

		rd <= 1'b1;
		wr <= 1'b0;
		addr <= 7'd1;

		@(posedge clk);

		rd <= 1'b1;
		wr <= 1'b1;
		wdata <= 32'hFEFEFEFE;
		addr <= 7'd0;

		$finish;
	end

endmodule
