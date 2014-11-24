
#
# Test if jumps work correctly.
#

# initial values
addi $t0, $zero, 1

j skip_add

# increment $t0 so it equals $t1
addi $t0, $t0, 256

skip_add:

# $t0 = 1
