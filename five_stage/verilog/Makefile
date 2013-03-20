
OBJS =	pc pc_tb pc_tb.vcd

all: $(OBJS)

%: %.v
	iverilog -g2005 -o$@ $<

pc_tb: pc

pc_tb.vcd: pc_tb
	./$<

clean:
	-rm -f $(OBJS)
