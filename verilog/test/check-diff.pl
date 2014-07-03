#!/usr/bin/perl
use strict;

=head1

Given a set of output files, this will run a diff against the .check
file.  If they are the same the test passes, otherwise it fails.

  ./check-diff.pl t0001-no_hazard.out t0005-branch.out

=cut

my %test_info = (
	passed => 0,
	failed => 0,
);

foreach my $check_file_out (@ARGV) {
	my $check_file_check = $check_file_out;
	$check_file_check =~ s/\.out$/.check/;

	my $test_name = $check_file_out;
	$test_name =~ s/\.out$//;

	my $res = system("diff $check_file_out $check_file_check 1>/dev/null 2>&1");

	if ($res) {
		print STDERR "test '$test_name' failed\n";
		$test_info{'failed'}++;
	} else {
		$test_info{'passed'}++;
	}
}

$test_info{'total'} = $test_info{'passed'} + $test_info{'failed'};

print $test_info{'total'} . " tests run, " . $test_info{'passed'} .
		" passed, " . $test_info{'failed'} . " failed.\n";

