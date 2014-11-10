
#
# 02-operators
#
# Perform operations without creating data hazards
# which would require stalls or forwards to handle.
#

addi $11, $zero, 1
addi $2, $zero, 3
addi $3, $zero, 5
addi $4, $zero, 7

add $zero, $zero, $zero		# nop
add $zero, $zero, $zero
add $zero, $zero, $zero

xor $5, $11, $2
and $6, $11, $2
or  $7, $11, $2
nor $8, $11, $2
slt $9, $11, $2  # 1
add $10, $11, $2
