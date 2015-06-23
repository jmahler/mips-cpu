# NAME

mips-cpu - A MIPS CPU written in Verilog

# DESCRIPTION

An implementation of a MIPS CPU written in Verilog.  This project is in
very early stages and currently only implements the most basic
functionality of a MIPS CPU.

 - 32-bit MIPS processor

 - implemented in Verilog

 - 5 stage pipeline

 - static branch not taken branch predictor

 - branch detection in decode (stage 2)

 - supports stalls to avoid read after write (RAW) and other hazards

 - can forward from memory (stage 4) and write back (stage 5)
   to avoid stalls

Much of the design was inspired by the book "Computer Organization and
Design" by David A. Patterson and John L. Hennessy (4th ed. 2008).

This project also includes a full set of test benches.  These are
invaluable as a quick check to verify that new changes have not
disrupted previously working functionality.

# REQUIREMENTS

This project requires a Verilog simulator, such as [Icarus][iverilog],
the Gcc compiler, and a Gcc MIPS cross compiler.  To check if your
system has the required programs installed run the `check-install.sh`
script.

    $ ./check-install.sh
    Checking for required programs...
      mips-linux-gnu-objcopy
      mips-linux-gnu-as
      iverilog
    Please install the missing programs and retry.

  [iverilog]: http://iverilog.icarus.com

# RUNNING TEST BENCHES

The tests are located in the `verilog/test/` directory.  Everything is
built and run using the `make` command.

    make

There are two parts to each test: the Verilog code, and the assembly
code.  The Verilog code uses a generic CPU test bench (`cpu_tb.v`) from
which a specific test is built using a specific assembled .hex file.
The .hex file is produced by assembling the .asm file using the Gcc MIPS
cross compiler and converting it to ASCII hex suitable for use with
Verilog.  Then the Verilog code, using a simulator such as
[Icarus Verilog][iverilog], can be run to execute the assembly
instructions and produce a dump of its output (.out).  Finally, the
output file (.out) can be diffed against a known good output file
(.check) to see if there are any differences.

For more information about these steps refer the Makefile in `verilog/test/`.

# AUTHOR

Jeremiah Mahler <jmmahler@gmail.com><br>
<http://github.com/jmahler>

# COPYRIGHT

Copyright &copy; 2015, Jeremiah Mahler.  All Rights Reserved.<br>
This project is free software and released under
the [GNU General Public License][gpl].

 [gpl]: http://www.gnu.org/licenses/gpl.html
