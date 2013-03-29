
#
# 03-operators
#
# Perform operations without creating data hazards
# which would require stalls or forwards to handle.
#

# use $a0 for the address of data memory
addi $a0, $zero, $zero

addi $a1, $zero, 3
addi $a2, $zero, 15792
addi $a3, $zero, 257

add $zero, $zero, $zero		# nop

sw $a1, 0($a0)
sw $a2, 4($a0)
sw $a3, 8($a0)

xor $t0, $a1, $a2
and $t1, $a1, $a2
or $t2, $a1, $a2
nor $t3, $a1, $a2

sw $t0, 12($a0)
sw $t1, 16($a0)
sw $t2, 20($a0)
sw $t3, 24($a0)

slt $t0, $a1, $a2
skip: add $zero, $zero, $zero

lw $t3, 8($a0)
lw $t2, 4($a0)
lw $t1, 0($a0)

add $zero, $zero, $zero

addi $t3, $t0, 12
xor $t2, $t2, $t2
add $t1, $t0, $t3

add $zero, $zero, $zero

xor $t3, $t3, $t1

add $zero, $zero, $zero

add $t3, $t3, $t1

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

addi $t3, $t3, 12
nor $t3, $t3, $t2

halt
