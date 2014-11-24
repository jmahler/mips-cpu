
#
# Test if jumps work correctly.
#

# initial values
addi $t0, $zero, 1

j skip1

# increment $t0 so it equals $t1
addi $t0, $t0, 256

skip1:

addi $t0, $t0, 1

j skip2

addi $t0, $t0, 512

skip2:

addi $t0, $t0, 1

# $t0 = 3
