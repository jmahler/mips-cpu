
OBJS =	pc pc_tb pc_tb.vcd \
		im \
		regm \
		alu \
		dm \
		control alu_control \
		five_stage_mips

all: $(OBJS)

%: %.v
	iverilog -g2005 -o$@ $<

pc_tb: pc

pc_tb.vcd: pc_tb
	./$<

clean:
	-rm -f $(OBJS)
