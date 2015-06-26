
`include "cla_adder_4bit.v"

module cla_adder_4bit_tb;

	integer i = 0;

	reg clk;

	reg [3:0] a, b;
	wire [3:0] s;
	wire c;

	cla_adder_4bit add0(.a(a), .b(b), .c_in(1'b0), .s(s), .c_out(c));

	always begin
		clk <= ~clk;
		#5;
	end

	initial begin
		$dumpfile("cla_adder_4bit_tb.vcd");
		$dumpvars(0, cla_adder_4bit_tb);

		clk <= 1'b0;

		a <= 4'd7;
		b <= 4'd6;
		@(posedge clk);

		a <= 4'd7;
		b <= 4'd8;
		@(posedge clk);

		a <= 4'd8;
		b <= 4'd8;
		@(posedge clk);

		a <= 4'd15;
		b <= 4'd8;
		@(posedge clk);

		for (i = 0; i < 3; i = i + 1) begin
			@(posedge clk);
		end

		$finish;
	end

endmodule
