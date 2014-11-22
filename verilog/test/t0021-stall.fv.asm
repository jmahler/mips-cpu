
#
# Operations which are dependent on the results of previous operations
# will require a stall or some other action to avoid a mis-calculation.
# 
# Perform these dependent operations and see if they work.
#

# initial values
addi $t0, $zero, 1
addi $t1, $zero, 5
addi $t2, $zero, 7

add $t0, $t0, $t1  # $t0 = 1 + 5 = 6
add $t1, $t0, $t1  # $t1 = 6 + 5 = 11
add $t2, $t1, $t0  # $t2 = 11 + 6 = 17
add $t0, $t2, $t1  # $t0 = 17 + 11 = 28

# $t0 = 28 (0x1c), $t1 = 11 (0x0b), $t2 = 17 (0x11)
