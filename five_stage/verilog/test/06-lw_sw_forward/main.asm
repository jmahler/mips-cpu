
add $zero, $zero, $zero		# nop

addi $1, $zero, 1
addi $2, $zero, 5
addi $3, $zero, 4

sw $1, 0($zero)  # 1
sw $2, 4($zero)  # 5
sw $3, 8($zero)  # 4

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

lw $4, 4($zero)  # 5
sw $4, 12($zero) # 5

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# should be 5
lw $4, 12($zero)

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

lw $5, 4($zero)  # 5
add $6, $5, $5   # 10

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

lw $6, 8($zero)  # 4
sw $2, 12($6)  # 5 -> address 12 + 4 = 16

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# should be 5
lw $7, 16($zero)

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

halt
