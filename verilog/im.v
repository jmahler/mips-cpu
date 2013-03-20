/*
 * Instruction Memory.
 *
 * Given a 32-bit address from the program counter (PC)
 * it outputs the data at that address.
 *
 * Currently it supports 7 address bits resulting in
 * 128 bytes of memory.
 *
 * The memory is initialized by using the Verilog $readmemh
 * (read memory in hex format, ascii) operation. 
 * The file to read from can be configured using .IM_DATA
 * parameter and it defaults to "IM_DATA.txt".
 * The number of memory records can be specified using the
 * .NMEM parameter.  This should be the same as the number
 * of lines in the file (wc -l IM_DATA.txt).
 *  
 */

`ifndef _im
`define _im

module im(addr, out);
	parameter NMEM = 128;  // Number of memory entries
	parameter IM_DATA = "IM_DATA.txt";

	input wire 	[6:0] 	addr;
	output wire [31:0] 	out;

	reg [31:0] mem [0:127];  // 32-bit memory with 128 entries

	initial begin
		$readmemh(IM_DATA, mem, 0, NMEM-1);
	end

	assign out = mem[addr][31:0];

endmodule

`endif
