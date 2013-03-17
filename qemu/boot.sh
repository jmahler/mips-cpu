#!/bin/sh

qemu-system-mips -M malta -m 256M -kernel vmlinux-2.6.32-5-4kc-malta -hda debian_mips.qcow2 -append "root=/dev/sda1 console=ttyS0" -nographic
