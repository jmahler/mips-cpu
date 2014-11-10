
addi $5, $zero, 5
addi $2, $zero, 7
addi $3, $zero, 0

add $zero, $zero, $zero		# nop
add $zero, $zero, $zero
add $zero, $zero, $zero

sw $5, 0($zero)  # 5
sw $2, 4($zero)  # 7

add $zero, $zero, $zero		# nop
add $zero, $zero, $zero
add $zero, $zero, $zero

# stall and forward required
lw $3, 4($zero)  # 7
add $4, $5, $3   # 12
