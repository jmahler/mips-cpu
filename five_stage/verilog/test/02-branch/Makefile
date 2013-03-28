
#
# How to make the check file
#
#   $ ./main_tb > main_tb.check
#
# How to check using the check file
#   $ diff main_tb.out main_tb.check

OBJS =	main_tb main_tb.vcd

all: $(OBJS)

%: %.v
	iverilog -I../ -I../../ -g2005 -o$@ $<

main_tb.vcd: main_tb
	./$<

clean:
	-rm -f $(OBJS)
