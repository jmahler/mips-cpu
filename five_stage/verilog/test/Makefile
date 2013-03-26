
OBJS =	pc_tb pc_tb.vcd

all: $(OBJS)

%: %.v
	iverilog -I../ -g2005 -o$@ $<

pc_tb.vcd: pc_tb
	./$<

clean:
	-rm -f $(OBJS)
