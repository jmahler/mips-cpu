
OBJS =	mux4to1 \
		alu alu_tb \
		pc \
		im \
		dm dm_tb dm_tb.vcd \
		pc_im_tb pc_im_tb.vcd \
		binahex \
		alu_control alu_control_tb \
		control \
		regm \
		single_mips single_mips_tb.vcd

all: $(OBJS)

%: %.v
	iverilog -g2005 -o$@ $<

alu_tb: alu

single_mips: alu pc im dm alu_control control regm

single_mips_tb: single_mips

dm_tb: dm

single_mips_tb.vcd: single_mips_tb
	./$<

pc_im_tb.vcd: pc_im_tb
	./$<

dm_tb.vcd: dm_tb
	./$<

binahex: binahex.c
	gcc -Wall $< -o $@

clean:
	-rm -f $(OBJS)
