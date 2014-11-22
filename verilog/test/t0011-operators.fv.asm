
#
# Test some binary operators.
#

# initial values
addi $t0, $zero, 6  # (0110)
addi $t1, $zero, 11 # (1011)

# do some operations
xor $t2, $t0, $t1	#   0110 ^ 1011  = 1101
and $t3, $t0, $t1	#   0110 & 1011  = 0010
or  $t4, $t0, $t1	#   0110 | 1011  = 1111
nor $t5, $t0, $t1	# ~(0110 | 1011) = 0000

# $t0 = 6, $t1 = 11 (0xb), $t2 = 13 (0xd), $t3 = 2, $t4 = 15 (0xf), $t5 = 0
