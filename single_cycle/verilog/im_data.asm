# Simple tests that don't calculate
# anything useful.

add $0, $0, $0  # nop

# initialize to zero
add $s0, $zero, $zero  # starting memory address

# create some numbers and
# store them in memory
addi $t0, $zero, 1
sw $t0, 0($s0)

addi $t0, $zero, 2
sw $t0, 4($s0)

addi $t0, $zero, 4
sw $t0, 8($s0)

# get them back out of memory
lw $t1, 0($s0)
lw $t2, 4($s0)
lw $t3, 8($s0)

slt $t0, $t1, $t2
beq $zero, $t0, done
done: add $0, $0, $0  # nop

# try the logic operations
xor $t2, $t3, $t4
and $t2, $t3, $t4
or $t2, $t3, $t4
nor $t2, $t3, $t4
