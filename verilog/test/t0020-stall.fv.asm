
#
# Test whether operations which require a stall and
# forward work correctly.
#

# initial values
addi $t0, $zero, 5
addi $t1, $zero, 7
addi $t2, $zero, 9

# store words in memory
sw $t0, 0($zero)  # 5
sw $t1, 4($zero)  # 7

# read the memory and perform an operation
#   *** stall and forward required ***
lw $t2, 4($zero)	# 7
add $t3, $t0, $t2   # 5 + 7 = 12

# $t0 = 5, $t1 = 7, $t2 = 7, $t3 = 12 (0x0c)
