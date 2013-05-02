
#
# 03-operators
#
# Perform operations without creating data hazards
# which would require stalls or forwards to handle.
#

# use $a0 for the address of data memory
addi $a0, $zero, $zero

addi $a1, $zero, 3
addi $a2, $zero, 15792
addi $a3, $zero, 257

add $zero, $zero, $zero		# nop

sw $a1, 0($a0)  # 3
sw $a2, 4($a0)  # 15792
sw $a3, 8($a0)  # 257

xor $t0, $a1, $a2  # (3 ^ 15792) = 0x3db3
and $t1, $a1, $a2  # (3 & 15792) = 0
or $t2, $a1, $a2   # (3 | 15792) = 0x3db3
nor $t3, $a1, $a2  # ~(3 | 15792) = ffffc24c

sw $t0, 12($a0)
sw $t1, 16($a0)
sw $t2, 20($a0)
sw $t3, 24($a0)

slt $t0, $a1, $a2  # 1
skip: add $zero, $zero, $zero

lw $t3, 8($a0)  # 257
lw $t2, 4($a0)  # 15792
lw $t1, 0($a0)  # 3

add $zero, $zero, $zero

addi $t3, $t0, 12  # 13, 0xd
xor $t2, $t2, $t2  # 15792 + 15792 = 0x7b60
add $t1, $t0, $t3  # 1 + 257 = 0x102

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

xor $t3, $t3, $t1 # (0xd ^ 0x102) = 0x10f

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

add $t3, $t3, $t1  # (0x10f + 0x102) = 0x211

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

addi $t3, $t3, 12  # 0x211 + 12 = 0x21d

add $zero, $zero, $zero
add $zero, $zero, $zero
add $zero, $zero, $zero

nor $t3, $t3, $t2  # 0xfff8482

halt
