
addi $1, $zero, 1
addi $2, $zero, 3

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

beq $2, $2, skip

# this instruction should be skipped
addi $2, $2, 5

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

skip: add $zero, $1, $1

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# $2 should still be 3
addi $2, $2, 0
