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

All the tests are located in the `verilog/test/` directory and
are run using make files.

To run all the tests type `make test` from the `test/` director.

    $ cd verilog/test
    $ make test

Or, to run an individual test, `cd` to that specific directory
and run `make test`.

    $ cd verilog/test/01-no_hazard/
    $ make test

Each test works by generating an output file.  This file can then be
checked by comparing the differences to a known good output file.
Currently `diff` is used to do this, no differences indicate a
successfule test.

## Test Bench Design

The test benches are written in Verilog and the files are
named with a `_tb` at the end.  When the test bench is run
it uses $display statements to produce output which is saved
to a file (.out).  This output can then be diffed against the
.check file to see if it was correct.

Note that since many variables are output a design change could
create a difference which is not necessarily a failure.
In cases such as these this is a sign that the result should
be reviewed more closely (in a simulator) to verify that it
is correct.  And then a new .check can be generated from the
output.

# AUTHOR

Jeremiah Mahler <jmmahler@gmail.com><br>
<http://github.com/jmahler>

# COPYRIGHT

Copyright &copy; 2014, Jeremiah Mahler.  All Rights Reserved.<br>
This project is free software and released under
the [GNU General Public License][gpl].

 [gpl]: http://www.gnu.org/licenses/gpl.html
