/*
 * Data Memory.
 *
 * 32-bit data with a 7 bit address (128 entries).
 *
 * The read and write operations operate somewhat independently.
 *
 * Any time the read signal (rd) is high the data stored at the
 * given address (addr) will be placed on 'rdata'.
 *
 * Data can be written simultaneously.
 * When the write signal (wr) is high the data on 'wdata' will
 * be stored at the given address (addr).
 * 
 * While data can be read and written simultaneously, the data
 * written will not be available to read until the next clock step.
 */

`ifndef _dm
`define _dm

module dm(clk, addr, rd, wr, wdata, rdata);

	input wire			clk;
	input wire	[6:0]	addr;
	input wire			rd, wr;
	input wire 	[31:0]	wdata;
	output wire	[31:0]	rdata;

	reg [31:0] mem [0:127];  // 32-bit memory with 128 entries

	always @(posedge clk) begin
		if (wr) begin
			mem[addr] <= wdata;
		end
	end

	assign rdata = mem[addr][31:0];

endmodule

`endif
