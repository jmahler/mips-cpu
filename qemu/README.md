
# Qemu

## VERSIONS

The following software versions were used for this install.
Other versions may work but this has not been verified.

  [Qemu][qemu] 1.1.2+dfsg-5  amd64

  [qemu]:http://www.qemu.org

  Debian Squeeze Netboot image, Malta install image

    http://ftp.de.debian.org/debian/dists/squeeze/main/installer-mips/current/images/malta/netboot/initrd.gz

  Debian Squeeze, Malta 2.6.32 kernel, 4kc processor

    http://ftp.de.debian.org/debian/dists/squeeze/main/installer-mips/current/images/malta/netboot/vmlinux-2.6.32-5-4kc-malta

## INSTALL

    $ apt-get install qemu

    $ mkdir mips-from-scratch

    $ cd mips-from-scratch/

    $ qemu-img create -f qcow2 debian_mips.qcow2 2G

    $ wget http://ftp.de.debian.org/debian/dists/squeeze/main/installer-mips/current/images/malta/netboot/initrd.gz

    $ wget http://ftp.de.debian.org/debian/dists/squeeze/main/installer-mips/current/images/malta/netboot/vmlinux-2.6.32-5-4kc-malta

Next the installer can be run.
The following options should be set.

  - For the filesystem type choose: ext2 or ext3.  Don't choose ext4.
    It might not be able to find the filesystem after reboot if ext4 is chosen.

Run the installer:

    $ qemu-system-mips -M malta -m 256M -kernel vmlinux-2.6.32-5-4kc-malta -initrd initrd.gz -hda debian_mips.qcow2 -append "console=ttyS0" -nographic

At the end there would be an error message about "continuing without a
bootloader".  This is OK, just ignore it and continue.
Qemu does not need a bootloader.

Once complete, terminate the installer.

    $ killall qemu-system-mips

### BOOTING

Then to boot the new system change the arguments by removing -initrd
and adding a "root=..." entry to -append.

    $ qemu-system-mips -M malta -m 256M -kernel vmlinux-2.6.32-5-4kc-malta -hda debian_mips.qcow2 -append "root=/dev/sda1 console=ttyS0" -nographic

### Other Useful Qemu Commands

To log to a file add

  -serial file:/tmp/qemu-output.log

    $ qemu-system-mips -M ?


  [gmplib.org]:http://gmplib.org/~tege/qemu.html

  [aurel32]:http://www.aurel32.net/info/debian_mips_qemu.php

# Gcc, As

With a simple CPU there is much less overhead than is required
with an operating system.  Gcc, or specifically 'as', will compile
the assembly along with all the additional code needed for the OS.

The assembly source of an object file can be displayed using objdump.

    $ objdump -D hello.o > hello.dasm
or
    $ objdump -d hello.o > hello.dasm

What is displayed should mostly correspond with the original source.
Minor additions, such as 'nop', might be present.

# AUTHOR

Jeremiah Mahler <jmmahler@gmail.com><br>

# COPYRIGHT

Copyright &copy; 2013, Jeremiah Mahler.  All Rights Reserved.<br>
This project is free software and released under
the [GNU General Public License][gpl].

  [gpl]: http://www.gnu.org/licenses/gpl.html

