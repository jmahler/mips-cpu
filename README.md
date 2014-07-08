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

This code has been tested under Debian Linux using the
[Icarus Verilog][iverilog] compiler version 0.9.6.

  [iverilog]: http://iverilog.icarus.com

# RUNNING TEST BENCHES

The tests are located in the `verilog/test/` directory.  They are built
and run with the `make` command.

    make

The tests work by using a generic CPU test bench (`cpu_tb.v`).  The
specific test is built for the particular compiled assembly file (.hex).
Then this executable can be run to produce the output results.  And a
diff can be taken of the output (.out) compared to known good output
(.check).  The `check-diff.pl` script is included which will check all
the diffs and provide a summary of those that passed and failed.  All
these steps are performed as part of the `make` command.

# AUTHOR

Jeremiah Mahler <jmmahler@gmail.com><br>
<http://github.com/jmahler>

# COPYRIGHT

Copyright &copy; 2014, Jeremiah Mahler.  All Rights Reserved.<br>
This project is free software and released under
the [GNU General Public License][gpl].

 [gpl]: http://www.gnu.org/licenses/gpl.html
