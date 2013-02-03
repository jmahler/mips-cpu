
`include "alu1.v"
`include "alu2.v"

module alu_tb;

	integer tests, errors;

	integer i, j;

	reg clk;

	reg [31:0] a, b;
	reg [3:0] ctl;

	wire [31:0] out1, out2;
	wire z1, z2;

	localparam [3:0]
		CTL_ADD = 4'b0010,
		CTL_AND = 4'b0000,
		CTL_NOR = 4'b1100,
		CTL_OR  = 4'b0001,
		CTL_SLT = 4'b0111,
		CTL_SUB = 4'b0110,
		CTL_XOR = 4'b1101;

	// test results
	task t;
		input [31:0] out1;
		input [31:0] out2;
		input		 z1;
		input		 z2;

		begin
			tests = tests + 1;

			if (out1 != out2) begin
				errors = errors + 1;
				$display("out test failed: %h != %h", out1, out2);
			end

			tests = tests + 1;

			if (z1 != z2) begin
				errors = errors + 1;
				$display("zero test failed: %d != %d", z1, z1);
			end

		end
	endtask

	// both ALU's will be tested, they should have identical results
	alu1 alu1(.ctl(ctl), .a(a), .b(b), .out(out1), .z(z1));
	alu2 alu2(.ctl(ctl), .a(a), .b(b), .out(out2), .z(z2));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		tests <= 0;
		errors <= 0;

		clk <= 1'b0;


		@(posedge clk);
		a <= 15;
		b <= 126;
		ctl <= CTL_SUB;
		t(out1, out2, z1, z2);

		@(posedge clk);
		a <= 15;
		b <= 126;
		ctl <= CTL_NOR;
		t(out1, out2, z1, z2);

		@(posedge clk);
		a <= 32'hffff1010;
		b <= 32'h0000ffff;
		ctl <= CTL_OR;
		t(out1, out2, z1, z2);

		@(posedge clk);
		a <= 100000;
		b <= 10001;
		ctl <= CTL_SLT;
		t(out1, out2, z1, z2);

		@(posedge clk);
		a <= 10001;
		b <= 100000;
		ctl <= CTL_SLT;
		t(out1, out2, z1, z2);

		@(posedge clk);
		a <= 1010100;
		b <= 100000;
		ctl <= CTL_XOR;
		t(out1, out2, z1, z2);

		for (i = 0; i <= 1517*10; i = i + 1517) begin
			for (j = 10100; j <= 10100 + 1135*10; j = j + 1135) begin

				a <= i;
				b <= j;

				ctl <= CTL_ADD;
				@(posedge clk);
				t(out1, out2, z1, z2);

				ctl <= CTL_AND;
				@(posedge clk);
				t(out1, out2, z1, z2);

				ctl <= CTL_NOR;
				@(posedge clk);
				t(out1, out2, z1, z2);

				ctl <= CTL_OR;
				@(posedge clk);
				t(out1, out2, z1, z2);

				ctl <= CTL_SLT;
				@(posedge clk);
				t(out1, out2, z1, z2);

				ctl <= CTL_SUB;
				@(posedge clk);
				t(out1, out2, z1, z2);

				ctl <= CTL_XOR;
				@(posedge clk);
				t(out1, out2, z1, z2);
			end
		end


		if (errors > 0)
			$display("%d tests out of %d failed.\n", errors, tests);
		else
			$display("All %d tests passed.\n", tests);

		$finish;
	end
endmodule
