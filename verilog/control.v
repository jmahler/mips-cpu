`ifndef _control
`define _control

`define BRANCH_BEQ 0
`define BRANCH_BNE 1

module control(
		input  wire	[5:0]	opcode,
		output wire 		regdst, memread, memtoreg,
		output wire [1:0]	branch,
		output wire [1:0]	aluop,
		output wire			memwrite, alusrc, regwrite);

	wire 		and1, and2, and3, and4, and5, and6;
	wire [5:0] 	oc;

	assign oc = opcode;

	assign and1 = ( oc[0] &  oc[1] & ~oc[2] & ~oc[3] & ~oc[4] &  oc[5]);
	assign and2 = (~oc[0] & ~oc[1] & ~oc[2] &  oc[3] & ~oc[4] & ~oc[5]);
	assign and3 = (~oc[0] & ~oc[1] &  oc[2] & ~oc[3] & ~oc[4] & ~oc[5]); // beq
	assign and4 = ( oc[0] &  oc[1] & ~oc[2] & ~oc[3] & ~oc[4] &  oc[5]);
	assign and5 = ( oc[0] &  oc[1] & ~oc[2] &  oc[3] & ~oc[4] &  oc[5]);
	assign and6 = ( oc[0] & ~oc[1] &  oc[2] & ~oc[3] & ~oc[4] & ~oc[5]); // bne

	assign regdst = ~(and1 | and2);

	assign branch[`BRANCH_BEQ] = and3;
	assign branch[`BRANCH_BNE] = and6;

	assign memread = and4;

	assign memtoreg = and4;

	assign aluop[0] = and3 | and6;
	assign aluop[1] = ~(and1 | and2 | and3 | and5 | and6);

	assign memwrite = and5;

	assign alusrc = and1 | and2 | and5;

	assign regwrite = ~(and3 | and5 | and6);
endmodule

`endif
