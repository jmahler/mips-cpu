
OBJCOPY=mips-linux-gnu-objcopy
AS=mips-linux-gnu-as
GCC=mips-linux-gnu-gcc

OBJS  = $(shell ls t*.asm | sed -e 's/.asm//')
OBJS += $(shell ls t*.c | sed -e 's/.c//')

OUTS  = $(shell ls t*.asm | sed -e 's/.asm/.out/')
#OUTS  = $(shell ls t*.c | sed -e 's/.c/.out/')

HEXS  = $(shell ls t*.asm | sed -e 's/.asm/.hex/')
HEXS += $(shell ls t*.c | sed -e 's/.c/.hex/')

all: $(OBJS) $(ELFS) $(OUTS) $(HEXS) check

bin2hex: bin2hex.c
	gcc -Wall $< -o $@

# prevent Make from removing these intermediate files
.PRECIOUS: %.elf %.text

# To get a dump of the assembly code:
#mips-linux-gnu-objdump --section=.text -D <file>.elf

# cancel implicit rule for .c -> (exe)
%: %.c

%.elf: %.c
	$(GCC) -O0 -mips32 -nostdlib -ffreestanding -o $@ $<

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
		-DDEBUG_CPU_STAGES="1" \
		-I../ -g2005 \
		-o $@ \
		cpu_tb.v

%.fv: %.fv.hex cpu_tb.v
	iverilog -DIM_DATA_FILE="\"$<\"" \
		-DNUM_IM_DATA=`wc -l $< | awk {'print $$1'}` \
		-DDUMP_FILE="\"$@.vcd\"" \
		-DDEBUG_CPU_REG="1" \
		-I../ -g2005 \
		-o $@ \
		cpu_tb.v

%.out: %
	./$< > $<.out

%.fv.out: %.fv
	./$< | tail -n 1 > $<.out

check:
	./check-diff.pl $(OUTS)

clean:
	-rm -f $(OBJS)
	-rm -f *.vcd
	-rm -f *.out
	-rm -f t*.hex
	-rm -f *.elf
	-rm -f *.text
