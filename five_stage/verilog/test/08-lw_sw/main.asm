
#
# perform a bunch of operations in which
# the end result can be easily calculated.
#

add $zero, $zero, $zero

# init

addi $1, $zero, 3
addi $2, $zero, 12
addi $3, $zero, 37 # 0x25

addi $4, $zero, 3  # used for memory offset

sw $1, 16($zero)
sw $2, 20($zero)
sw $3, 24($zero)

# increment each of the numbers by 1
# [3 12 37] + 1 = [4 13 38]

lw $5, 16($zero)
addi $5, $5, 1
sw $5, 16($zero)

lw $5, 20($zero)
addi $5, $5, 1
sw $5, 20($zero)

lw $5, 24($zero)
addi $5, $5, 1
sw $5, 24($zero)

# increment each of the numbers by 1
# [4 13 38] + 1 = [5 14 39]

lw $5, 16($zero)
lw $6, 20($zero)
lw $7, 24($zero)

addi $5, $5, 1
addi $6, $6, 1
addi $7, $7, 1

sw $5, 16($zero)  # 5
sw $6, 20($zero)  # 14 (0xE)
sw $7, 24($zero)  # 39  (0x27)

# another increment
# [2 + 2, 6 + 6, 8] = [4 12 8]
# [5 + 5, 14 + 14, 39] = [10, 28, 39]

lw $5, 16($zero)  # 5
lw $6, 20($zero)  # 14 (0xE)

add $5, $5, $5  # 10 (0xA)
add $6, $6, $6  # 28 (0x1C)

sw $5, 16($zero)
sw $6, 20($zero)

# sum
# 10 + 28 + 39 = 77

lw $5, 16($zero)

addi $9, $zero, 4
lw $6, 16($9)

addi $10, $zero, 4

add $5, $5, $6

lw $7, 20($10)

add $7, $5, $7

addi $11, $zero, 24
sw $7, 0($11)

# finish

# should be 77 (0x4D) if all was correct
lw $12, 24($zero)

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

halt
