/*
 * NAME
 *
 * cpu_tb.v - generic cpu test bench
 *
 * DESCRIPTION
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

	cpu #(.NMEM(`NUM_IM_DATA), .IM_DATA(`IM_DATA_FILE))
			mips1(.clk(clk));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile(`DUMP_FILE);
		$dumpvars(0, cpu_tb);

		clk <= 1'b0;

		/* cpu will $display output when `DEBUG_CPU_STAGES is on */

		// Run all the lines, plus 5 extra to finish off the pipeline.
		for (i = 0; i < `NUM_IM_DATA + 5; i = i + 1) begin
			@(posedge clk);
		end

		$finish;
	end
endmodule

