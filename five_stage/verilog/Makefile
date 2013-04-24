
OBJS =	pc im regm alu dm control alu_control \
		stage1_if stage2_id stage3_ex stage4_mem stage5_wb \
		cpu \
		reggy

all: $(OBJS)

%: %.v
	iverilog -g2005 -o$@ $<

stage1_if: im

stage2_id: regm control

stage3_ex: alu alu_control

stage4_mem: dm

cpu: stage1_if stage2_id stage3_ex stage4_mem stage5_wb

clean:
	-rm -f $(OBJS)
