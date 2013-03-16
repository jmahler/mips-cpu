
OBJS = mux4to1 \
	   alu \
	   alu_tb

all: $(OBJS)

%: %.v
	iverilog -o$@ $<

alu_tb: alu

clean:
	-rm -f $(OBJS)
