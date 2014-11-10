
OBJCOPY=mips-linux-gnu-objcopy
AS=mips-linux-gnu-as

OBJS=$(shell ls t*.asm | sed -e 's/.asm//')
OUTS=$(shell ls t*.asm | sed -e 's/.asm/.out/')
HEXS=$(shell ls t*.asm | sed -e 's/.asm/.hex/')

all: $(OBJS) $(OUTS) $(HEXS) check

bin2hex: bin2hex.c
	gcc -Wall $< -o $@

# assemble for mips32 with no optimization
%.elf: %.asm
	$(AS) -O0 -mips32 -o $@ $<

# extract just the .text section
%.text: %.elf
	$(OBJCOPY) -O binary --only-section=.text $< $@

%.hex: %.text bin2hex
	./bin2hex $< > $@

# build the simulation executable
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
	-rm -f t*.hex

