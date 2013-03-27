
#
# no hazards
#
# Data hazards which would require forwards and/or
# stalls have been avoid by adding nop's.
#

# use $s0 for the address of data memory
addi $s0, $zero, $zero

addi $t1, $zero, 3			# $t0 = 3
add $zero, $zero, $zero		# nop
add $zero, $zero, $zero		# nop
add $t2, $t1, $t1			# $t1 = 6

sw $t1, 0($s0)
add $zero, $zero, $zero		# nop
sw $t2, 4($s0)

lw $t3, 0($s0)				# ($t3 = 3)
lw $t4, 4($s0)				# ($t4 = 6)
add $zero, $zero, $zero		# nop
add $zero, $zero, $zero		# nop
slt $t0, $t3, $t4			# (3 < 6 -> true)

halt
