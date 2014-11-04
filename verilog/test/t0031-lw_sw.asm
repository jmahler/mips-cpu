
add $zero, $zero, $zero

addi $1, $zero, 1
addi $2, $zero, 5
addi $3, $zero, 4

sw $1, 0($zero)  # 1
sw $2, 4($zero)  # 5
sw $3, 8($zero)  # 4

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# lw, add
lw $4, 8($zero) # 4
add $5, $4, $4  # 8

				# stall, 8
lw $6, 8($zero) # 4
add $7, $4, $4  # X, 8
add $8, $6, $6  # 8

# lw, sw
lw $4, 8($zero) # 4
sw $4, 16($zero) # 4

lw $10, 16($zero) # 4

lw $5, 8($zero) # 4
add $7, $4, $4  # X, 8
sw $5, 16($zero) # 4

lw $10, 16($zero) # 4

# lw, sw, reg as memory offset
lw $8, 8($zero) # 4
sw $2, 16($8)  # 5 => 16 + 4 = 20

lw $10, 20($zero) # 5

lw $9, 8($zero) # 4
add $7, $4, $4  # X
sw $2, 20($9)  # 5 => 20 + 4 = 24

lw $11, 24($zero) # 5

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
