/*
 * Instruction Memory (single stage).
 *
 * Given a 32-bit address the data is latched and driven
 * on the rising edge of the clock.
 *
 * Currently it supports 7 address bits resulting in
 * 128 bytes of memory.
 *
 * The memory is initialized using the Verilog $readmemh
 * (read memory in hex format, ascii) operation. 
 * The file to read from can be configured using .IM_DATA
 * parameter and it defaults to "im_data.txt".
 * The number of memory records can be specified using the
 * .NMEM parameter.  This should be the same as the number
 * of lines in the file (wc -l im_data.txt).
 *  
 */

`ifndef _im
`define _im

module im(
		input wire			clk,
		input wire 	[6:0] 	addr,
		output reg [31:0] 	out);

	parameter NMEM = 128;  // Number of memory entries
	parameter IM_DATA = "im_data.txt";

	reg [31:0] mem [0:127];  // 32-bit memory with 128 entries

	initial begin
		$readmemh(IM_DATA, mem, 0, NMEM-1);
	end

	always @(posedge clk) begin
		out <= mem[addr][31:0];
	end

endmodule

`endif
