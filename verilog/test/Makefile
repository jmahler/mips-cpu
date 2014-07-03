
OBJS=$(shell ls t*.hex | sed -e 's/.hex//')
OUTS=$(shell ls t*.hex | sed -e 's/.hex/.out/')

all: build output check

build: $(OBJS)

output: build $(OUTS)

%: %.hex cpu_tb.v
	iverilog -DIM_DATA_FILE="\"$<\"" \
		-DNUM_IM_DATA=`wc -l $< | awk {'print $$1'}` \
		-DDUMP_FILE="\"$@.vcd\"" \
		-I../ -g2005 \
		-o $@ \
		cpu_tb.v

%.out: %
	./$< > $<.out

check:
	./check-diff.pl $(OUTS)

clean:
	-rm -f $(OBJS)
	-rm -f *.vcd
	-rm -f *.out

