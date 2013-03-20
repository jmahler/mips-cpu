`include "alu_control.v"

module alu_control_tb;

	integer err = 0;

	reg clk;

	alu_control aluc1(.funct(funct), .aluop(aluop), .alucnt(alucnt));

	reg [5:0] funct;
	reg [1:0] aluop;
	wire [3:0] alucnt;

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("alu_control_tb.vcd");
		$dumpvars(0, alu_control_tb);

		clk <= 1'b0;

		funct = 0;
		aluop = 0;
		@(posedge clk);
		if (alucnt != 2) begin
			err = err + 1;
			$display("funct = %d, aluop = %d => %d, not %d",
				funct, aluop, 2, alucnt);
		end

		funct = 0;
		aluop = 2;
		@(posedge clk);
		if (alucnt != 2) begin
			err = err + 1;
			$display("funct = %d, aluop = %d => %d, not %d",
				funct, aluop, 2, alucnt);
		end

		funct = 6;
		aluop = 2;
		@(posedge clk);
		if (alucnt != 4'hd) begin
			err = err + 1;
			$display("funct = %d, aluop = %d => %d, not %d",
				funct, aluop, 4'hd, alucnt);
		end


		if (err > 0)
			$display("%d tests failed.\n", err);
		else
			$display("All tests passed.\n");

		$finish;
	end
endmodule
