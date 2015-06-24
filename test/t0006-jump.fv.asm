
#
# Test the jump operation.
#

# start: $t0 = 1
addi $t0, $zero, 1

# should skip adding 256 to $t0
j skip1
addi $t0, $t0, 256
skip1:

# $t0 = 2
addi $t0, $t0, 1

# should skip adding 512 to $t0
j skip2
addi $t0, $t0, 512
skip2:

# $t0 = 3
addi $t0, $t0, 1
