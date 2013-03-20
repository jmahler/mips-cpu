`ifndef _alu_control
`define _alu_control

module alu_control(funct, aluop, alucnt);

	input wire [5:0] funct;
	input wire [1:0] aluop;
	output reg [3:0] alucnt;

	reg [5:0] _funct = 0;

	always @(*) begin
		case(funct)
			0:  _funct = 2;
			2:  _funct = 6;
			4:  _funct = 0;
			5:  _funct = 1;
			6:  _funct = 6'h0d;
			7:  _funct = 6'h0c;
			10: _funct = 7;
			default: _funct = 0;
		endcase
	end

	always @(*) begin
		case(aluop)
			0: alucnt = 2;
			1: alucnt = 6;
			2: alucnt = _funct;
			3: alucnt = 2;
			default: alucnt = 0;
		endcase
	end

endmodule

`endif
