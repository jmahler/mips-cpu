
#
# 04-forward
#
# Operations which can be completed with no stalls
# using forwards.
#

# initialize variables
addi $2, $zero, 2
addi $3, $zero, 4
addi $4, $zero, 7
addi $5, $zero, 15

add $zero, $zero, $zero  # nop
add $zero, $zero, $zero
add $zero, $zero, $zero

# forward from memory to exec
add $6, $2, $3  # 0x6, 6
add $4, $6, $6  # 0xc, 12

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# forward from write back to exec
add $6, $2, $5  # 0x11, 17
add $10, $4, $5 # 0x1b, 27
add $4, $6, $6 # 0x22, 34

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

# both types of forwards
add $6, $2, $3  # 0x06, 6
add $6, $6, $6  # 0x0c, 12
add $4, $6, $6  # 0x18, 24
