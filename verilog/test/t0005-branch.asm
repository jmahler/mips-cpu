
#
# 02-branch
#
# Performs branches without creating data hazards
# which would require stalls or forwards to handle.
#

addi $a1, $zero, 4

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

beq $a1, $a1, skip1

# add nop's to compensate for the branch's
# inability to clear instructions already in
# the pipeline.
add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

addi $a1, $a1, 2

skip1: add $zero, $zero, $zero

# should still be 4
add $a1, $a1, $zero
