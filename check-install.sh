#!/bin/sh

#
# NAME
#
# check-install.sh
#
# DESCRIPTION
#
# Run this script to check if the system has all the required
# programs installed.
#
#   Checking for required programs...
#     mips-linux-gnu-objcopy
#     mips-linux-gnu-as
#     iverilog
#   Please install the missing programs and retry.
#   

error=0

echo "Checking for required programs..."

if ! which "gcc" >/dev/null ; then
	echo "  gcc"
	error=1
fi

if ! which "mips-linux-gnu-objcopy" >/dev/null ; then
	echo "  mips-linux-gnu-objcopy"
	error=1
fi

if ! which "mips-linux-gnu-as" >/dev/null ; then
	echo "  mips-linux-gnu-as"
	error=1
fi

if ! which "mips-linux-gnu-gcc" >/dev/null ; then
	echo "  gcc-mips-linux-gnu"
	echo "    dpkg --add-architecture mips"
	echo "    apt-get install gcc-mips-linux-gnu"
	error=1
fi

if ! which "iverilog" >/dev/null ; then
	echo "  iverilog"
	error=1
fi

if [ "$error" -ne 0 ]; then
	echo "Please install the missing programs and retry."
else
	echo "System looks ready"
fi
