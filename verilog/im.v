/*
 * im.v - instruction memory
 *
 * Given a 32-bit address the data is latched and driven
 * on the rising edge of the clock.
 *
 * Currently it supports 7 address bits resulting in
 * 128 bytes of memory.  The lowest two bits are assumed
 * to be byte indexes and ignored.  Bits 8 down to 2
 * are used to construct the address.
 *
 * The memory is initialized using the Verilog $readmemh
 * (read memory in hex format, ascii) operation. 
 * The file to read from can be configured using .IM_DATA
 * parameter and it defaults to "im_data.txt".
 * The number of memory records can be specified using the
 * .NMEM parameter.  This should be the same as the number
 * of lines in the file (wc -l im_data.txt).
 */

`ifndef _im
`define _im

module im(
		input wire			clk,
		input wire 	[31:0] 	addr,
		output wire [31:0] 	data);

	parameter NMEM = 128;   // Number of memory entries,
							// not the same as the memory size
	parameter IM_DATA = "im_data.txt";  // file to read data from

	reg [31:0] mem [0:127];  // 32-bit memory with 128 entries

	initial begin
		$readmemh(IM_DATA, mem, 0, NMEM-1);
	end

	assign data = mem[addr[8:2]][31:0];
endmodule

`endif
