
/*
 * cpu_tb.v - generic cpu test bench
 *
 * This generic cpu test bench can be used to run a program, which is in
 * ASCII hex format, and output the results.
 *
 * Configuration is done by setting preprocessor defines at compile
 * time.  The result is an executable for that specific test.
 *
 *   iverilog -DIM_DATA_FILE="\"t0001-no_hazard.hex\"" \
 *            -DNUM_IM_DATA=`wc -l t0001-no_hazard.hex | awk {'print $$1'}` \
 *            -DDUMP_FILE="\"t0001-no_hazard.vcd\"" \
 *            -I../ -g2005 \
 *            -o t0001-no_hazard \
 *            cpu_tb.v
 *
 * Then it can be run in the usual manner.  $monitor variables will be
 * output to STDOUT and a .vcd for use with Gtkwave will be output to
 * 'DUMP_FILE'.
 *
 *   ./t0001-no_hazard > t0001-no_hazard.out
 */

`include "cpu.v"

module cpu_tb;

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

	cpu #(.NMEM(`NUM_IM_DATA), .IM_DATA(`IM_DATA_FILE))
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
		$dumpfile(`DUMP_FILE);
		$dumpvars(0, cpu_tb);

		clk <= 1'b0;

		$display("if_pc,    if_instr, id_regrs, id_regrt, ex_alua,  ex_alub,  ex_aluctl, mem_memdata, mem_memread, mem_memwrite, wb_regdata, wb_regwrite");
		$monitor("%x, %x, %x, %x, %x, %x, %x,         %x,    %x,           %x,            %x,   %x",
					if_pc, if_instr,
					id_regrs, id_regrt,
					ex_alua, ex_alub, ex_aluctl,
					mem_memdata, mem_memread, mem_memwrite,
					wb_regdata, wb_regwrite);

		// Run all the lines, plus 5 extra to finish it off the pipeline.
		for (i = 0; i < `NUM_IM_DATA + 5; i = i + 1) begin
			@(posedge clk);
		end

		$finish;
	end
endmodule

