# A stall and two forwards are required to
# avoid the problem.

lw $2, 20($10)
and $4, $2, $5
or $8, $2, $6
add $9, $4, $2
slt $10, $6, $7
