# NAME

mips-cpu - A MIPS CPU written in Verilog

# DESCRIPTION

An implementation of a MIPS CPU written in Verilog.
This project is in very early stages and currently only
implements the most basic functionality of a MIPS CPU.

 - 32-bit MIPS processor

 - implemented in Verilog

 - 5 stage pipeline

 - static branch not taken branch predictor

 - branch detection in decode (stage 2)

 - supports stalls to avoid read after write (RAW) and other hazards

 - can forward from memory (stage 4) and write back (stage 5)
   to avoid stalls

Much of the design was inspired by the excellent book
"Computer Organization and Design" by David A. Patterson and
John L. Hennessy (4th ed. 2008).

This project also includes a full set of test benches.
These are invaluable as a quick check to verify that new changes
have not disrupted previously working functionality.

# AUTHOR

Jeremiah Mahler <jmmahler@gmail.com><br>
<https://plus.google.com/101159326398579740638/about>

# COPYRIGHT

Copyright &copy; 2013, Jeremiah Mahler.  All Rights Reserved.<br>
This project is free software and released under
the [GNU General Public License][gpl].

 [gpl]: http://www.gnu.org/licenses/gpl.html
