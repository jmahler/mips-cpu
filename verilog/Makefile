
OBJS = mux4to1 \
	   alu alu_tb \
	   pc \
	   im \
	   pc_im_tb \
	   binahex

all: $(OBJS)

%: %.v
	iverilog -g2005 -o$@ $<

alu_tb: alu

pc_im_tb: pc im

#pc_im_tb.vcd: pc_im_tb
#	./$<

binahex: binahex.c
	gcc -Wall $< -o $@

clean:
	-rm -f $(OBJS)
