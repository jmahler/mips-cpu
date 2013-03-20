/*
 * CPU Registers.
 *
 * 32 registers are provided.
 * The register at address $zero is treated special.
 * It ignores assignment and always remains at zero.
 *
 * When write is enable (regwrite = 1) the register
 * to write (regtowrite) is written with data (wrdata)
 * on the rising edge of the clock.
 */

`ifndef _regm
`define _regm

module regm(clk, read1, read2, data1, data2, regwrite, wrreg, wrdata);

	input wire			clk;
	input wire  [4:0]	read1, read2;
	output wire [31:0]	data1, data2;
	input wire			regwrite;
	input wire	[4:0]	wrreg;
	input wire	[31:0]	wrdata;

	reg [31:0] mem [0:31];  // 32-bit memory with 32 entries

	assign data1 = mem[read1][31:0];
	assign data2 = mem[read2][31:0];

	// set the $zero register
	initial begin
		mem[0] = 32'd0;
	end

	always @(posedge clk) begin
		if (regwrite && wrreg != 5'd0) begin
			// write a non $zero register
			mem[wrreg] <= wrdata;
		end
	end
endmodule

`endif
