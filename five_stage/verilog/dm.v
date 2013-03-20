/*
 * Data Memory.
 *
 * 32-bit data with a 7 bit address (128 entries).
 *
 * Data is written by applying data to wdata and then
 * setting read low and write high.  On the negedge
 * of the clock the data will be latched.
 *
 * When read (rd) is high and write (wr) is low data
 * can be read out.
 */

`ifndef _dm
`define _dm

module dm(clk, addr, rd, wr, wdata, rdata);

	input wire			clk;
	input wire	[6:0]	addr;
	input wire			rd, wr;
	input wire 	[31:0]	wdata;
	output reg	[31:0]	rdata;

	reg [31:0] mem [0:127];  // 32-bit memory with 128 entries

	always @(negedge clk) begin
		if (wr) begin
			mem[addr] <= wdata;
		end
	end

	always @(posedge clk) begin
		rdata <= mem[addr][31:0];
	end

endmodule

`endif
