
OBJS = pc_tb dm_tb

all: $(OBJS)

%: %.v
	iverilog -I../ -g2005 -o$@ $<

pc_tb.vcd: pc_tb
	./$<

dm_tb.vcd: dm_tb
	./$<

test:
	cd 01-no_hazard; make test
	cd 02-branch; make test
	cd 02-operators; make test
	cd 04-forward; make test
	cd 04-stall; make test
	cd 06-branch; make test
	cd 06-lw_sw_forward; make test
	cd 07-lw_sw; make test
	cd 08-lw_sw; make test

clean:
	-rm -f $(OBJS)
	cd 01-no_hazard; make clean
	cd 02-branch; make clean
	cd 02-operators; make clean
	cd 04-forward; make clean
	cd 04-stall; make clean
	cd 06-branch; make clean
	cd 06-lw_sw_forward; make clean
	cd 07-lw_sw; make clean
	cd 08-lw_sw; make clean
