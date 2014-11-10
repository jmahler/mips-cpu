
# data hazards
#
# Previous operations place answer in $2 which
# later operations depend on.
#

sub $2, $10, $3
and $12, $2, $5  # depends on $2 from sub
or $13, $6, $2
add $14, $2, $2
sw $15, 100($2)
