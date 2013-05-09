
OBJS =	reggy im im_slow im_cached regm control alu alu_control dm cpu

all: $(OBJS)

%: %.v
	iverilog -g2005 -o$@ $<

cpu: reggy im regm control alu alu_control dm

clean:
	-rm -f $(OBJS)
