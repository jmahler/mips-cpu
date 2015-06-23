`ifndef _control
`define _control

`define BRANCH_BEQ 0
`define BRANCH_BNE 1

module control(
		input  wire	[5:0]	opcode,
		output reg [1:0]	branch,
		output reg [1:0]	aluop,
		output reg			memread, memwrite, memtoreg,
		output reg			regdst, regwrite, alusrc);

	always @(*) begin
		/* defaults */
		aluop[1:0]	<= 2'b10;
		alusrc		<= 1'b0;
		branch[1:0] <= 2'b00;
		memread		<= 1'b0;
		memtoreg	<= 1'b0;
		memwrite	<= 1'b0;
		regdst		<= 1'b1;
		regwrite	<= 1'b1;

		case (opcode)
			6'b100011: begin	/* lw */
				memread  <= 1'b1;
				regdst   <= 1'b0;
				memtoreg <= 1'b1;
				aluop[1] <= 1'b0;
				alusrc   <= 1'b1;
			end
			6'b001000: begin	/* addi */
				regdst   <= 1'b0;
				aluop[1] <= 1'b0;
				alusrc   <= 1'b1;
			end
			6'b000100: begin	/* beq */
				aluop[0]  <= 1'b1;
				aluop[1]  <= 1'b0;
				branch[0] <= 1'b1;
				regwrite  <= 1'b0;
			end
			6'b101011: begin	/* sw */
				memwrite <= 1'b1;
				aluop[1] <= 1'b0;
				alusrc   <= 1'b1;
				regwrite <= 1'b0;
			end
			6'b000101: begin	/* bne */
				aluop[0]  <= 1'b1;
				aluop[1]  <= 1'b0;
				branch[1] <= 1'b1;
				regwrite  <= 1'b0;
			end
			6'b000000: begin	/* add */
			end
		endcase
	end
endmodule

`endif
