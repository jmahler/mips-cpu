#
# t0006-beq.asm
#
# Test branch if equal (beq) using different registers
# with equal values.
#

# load two different registers with equal values
addi $a1, $zero, 4
addi $a2, $zero, 4

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

beq $a1, $a2, skip1

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# if we skipped, this shouldn't be added
addi $a1, $a1, 2

skip1: add $zero, $zero, $zero

# do an add so we can see the value in the dump
# If beq worked it should be 4, not 6.
add $a1, $a1, $zero
