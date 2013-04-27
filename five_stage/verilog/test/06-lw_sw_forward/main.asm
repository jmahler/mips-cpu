
addi $1, $zero, 1
addi $2, $zero, 5
addi $3, $zero, 7

add $zero, $zero, $zero		# nop
add $zero, $zero, $zero
add $zero, $zero, $zero

sw $1, 0($zero)  # 1
sw $2, 4($zero)  # 5
sw $3, 8($zero)  # 7

add $zero, $zero, $zero		# nop
add $zero, $zero, $zero
add $zero, $zero, $zero

# stall and forward required
lw $3, 4($zero)  # 5
sw $3, 12($zero) # 5

add $zero, $zero, $zero		# nop
add $zero, $zero, $zero
add $zero, $zero, $zero

lw $4, 12($zero)  # 5

halt
