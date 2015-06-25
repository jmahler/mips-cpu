`ifndef _alu_control
`define _alu_control

module alu_control(
		input wire [5:0] funct,
		input wire [1:0] aluop,
		output reg [3:0] aluctl);

	reg [3:0] _funct;

	always @(*) begin
		case(funct[3:0])
			4'd0:  _funct = 4'd2;	/* add */
			4'd2:  _funct = 4'd6;	/* sub */
			4'd5:  _funct = 4'd1;	/* or */
			4'd6:  _funct = 4'd13;	/* xor */
			4'd7:  _funct = 4'd12;	/* nor */
			4'd10: _funct = 4'd7;	/* slt */
			default: _funct = 4'd0;
		endcase
	end

	always @(*) begin
		case(aluop)
			2'd0: aluctl = 4'd2;	/* add */
			2'd1: aluctl = 4'd6;	/* sub */
			2'd2: aluctl = _funct;
			2'd3: aluctl = 4'd2;	/* add */
			default: aluctl = 0;
		endcase
	end

endmodule

`endif
