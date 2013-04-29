/*
 * General test bench.
 *
 * Runs the code given main.hex and displays the values
 * as they are updated.  This output can be redirected
 * to a file and checked against known good values.
 * And this is what 'make test' will do.
 *
 * It also outputs to main_tb.vcd for use with Gtkwave.
 */

`include "cpu.v"

module main_tb;

	// number of operations
	//   $ wc -l main.hex
	//     30 main.hex
	parameter N = 48;

	integer i = 0;

	reg			clk;

	// diagnostic output variables
	// stage 1 (IF)
	wire [31:0] if_pc;		// instruction fetch (IF), program counter (PC)
	wire [31:0]	if_instr;	// instruction read from IM
	// stage 2 (ID)
	wire [31:0] id_regrs;	// register $rs
	wire [31:0] id_regrt;	// register $rt
	// stage 3 (EX)
	wire [31:0] ex_alua;
	wire [31:0] ex_alub;
	wire [3:0] ex_aluctl;
	// stage 4 (MEM)
	wire [31:0] mem_memdata;
	wire		mem_memwrite;
	wire		mem_memread;
	// stage 5 (WB)
	wire [31:0] wb_regdata;
	wire 		wb_regwrite;

	cpu #(.NMEM(N), .IM_DATA("main.hex"))
			mips1(.clk(clk),
				.if_pc(if_pc), .if_instr(if_instr),
				.id_regrs(id_regrs), .id_regrt(id_regrt),
				.ex_alua(ex_alua), .ex_alub(ex_alub), .ex_aluctl(ex_aluctl),
				.mem_memdata(mem_memdata), .mem_memread(mem_memread),
				.mem_memwrite(mem_memwrite),
				.wb_regdata(wb_regdata), .wb_regwrite(wb_regwrite));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("main_tb.vcd");
		$dumpvars(0, main_tb);

		clk <= 1'b0;

		$display("if_pc,    if_instr, id_regrs, id_regrt, ex_alua,  ex_alub,  ex_aluctl, mem_memdata, mem_memread, mem_memwrite, wb_regdata, wb_regwrite");
		$monitor("%x, %x, %x, %x, %x, %x, %x,         %x,    %x,           %x,            %x,   %x",
					if_pc, if_instr,
					id_regrs, id_regrt,
					ex_alua, ex_alub, ex_aluctl,
					mem_memdata, mem_memread, mem_memwrite,
					wb_regdata, wb_regwrite);

		for (i = 0; i < N + 5; i = i + 1) begin
			@(posedge clk);
		end

		$finish;
	end

endmodule
