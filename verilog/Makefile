
OBJS = mux4to1 \
	   alu alu_tb \
	   PC \
	   IM \
	   PC_IM_tb \
	   binahex

all: $(OBJS)

%: %.v
	iverilog -g2005 -o$@ $<

alu_tb: alu

PC_IM_tb: PC IM

#PC_IM_tb.vcd: PC_IM_tb
#	./$<

binahex: binahex.c
	gcc -Wall $< -o $@

clean:
	-rm -f $(OBJS)
