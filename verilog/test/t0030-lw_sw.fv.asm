
#
# Test the lw, and sw opertions.
#

addi $t0, $zero, 5
addi $t1, $zero, 9

sw $t0, 0($zero)	# 5
sw $t1, 4($zero)	# 9

lw $t0, 4($zero)	# 9
add $t0, $t0, $t1	# 9 + 9 = 18

# $t0 = 18 (0x12), $t1 = 9
