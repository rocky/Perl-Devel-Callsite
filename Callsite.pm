package Devel::Callsite;
use 5.005;
use vars qw($VERSION);
use XSLoader;
use base qw(Exporter);
$VERSION = '0.07_01';
@EXPORT = qw/callsite context/;

XSLoader::load __PACKAGE__;

# Demo code
unless (caller) {
  my $site = sub { return callsite() };
  printf "OP location: 0x%x\n", $site->(); # prints caller OP location
  printf "OP location: 0x%x\n", $site->(); # prints a different OP location

  print context(), "\n"; # prints the interpreter context, an unsigned number
}

1;
__END__
=encoding utf8

=for comment
This file is shared by both README.pod and Callsite.pm after its __END__
It is also in the github wiki:
https://github.com/rocky/Perl-Devel-Callsite/wiki
where we can immediately see the results and others can contribute.

=begin html

<a href="https://travis-ci.org/rocky/Perl-Devel-Callsite"><img src="https://travis-ci.org/rocky/Perl-Devel-Callsite.png"></a>

=end html

=head1 NAME

Devel::Callsite - Get caller return OP address and Perl interpreter context

=head1 SYNOPSIS

  use Devel::Callsite;
  my $site = sub { return callsite() };
  printf "OP location: 0x%x\n", $site->(); # prints caller OP location
  printf "OP location: 0x%x\n", $site->(); # prints a different OP location


  sub foo { return callsite(1) };
  sub bar { foo() };
  # print this OP location even though it is 2 levels up the call chain.
  printf "OP location: 0x%x\n", bar();

  print context(), "\n"; # prints the interpreter context, an unsigned number

=head1 DESCRIPTION

=head2 callsite

    $callsite = callsite()
    $callsite = callsite($level)

This function returns the the OP address of the caller, a
number. It can take an optional integer specifying the number of
levels back to get the OP address. If no parameter is given, a value
of 0 is used which means to go up one level in the call chain. This
behavior is like the built-in function L<C<caller>|perlfunc/caller>.

This value is useful for functions that need to uniquely know where
they were called, such as C<Every::every()>; see L<Every>. Or it can
be used to L<pinpoint a location with finer granularity than a line
number|http://www.perlmonks.com/?node_id=987268>. In conjunction with
an OP tree disassembly you can know exactly where the caller is
located in the Perl source.

As of version 0.08, this function will return the expected call site for
functions called via C<DB::sub>. (Previously it returned a call site
inside the debugger.) If C<callsite> is called from package C<DB> in
list context, it will return two numbers. The first is the ordinary
return value; the second is the 'true' call site of the function in
question, which may be different if C<DB::sub> is in use.

=head2 context

    $context = context()

This function returns the interpreter context as a number. Using
C<callsite> alone to identify the call site is not reliable in programs
which may include multiple Perl interpreters, such as when using
ithreads. Combining C<callsite> with C<context> gives a unique location.

=head1 HISTORY

Ben Morrow conceived this and posted it to perl5-porters. Ted Zlatanov
then turned it into a CPAN module which he maintained for the first 3
revisions. Ben also added the level parameter to callsite.

It is currently maintained (or not) by Rocky Bernstein.

=head1 SEE ALSO

L<B::Concise> to disassemble the OP tree. L<Devel::Trepan> optionally
uses I<Devel::Callsite> to show you exactly where you are stopped
inside the debugger.

=head1 AUTHORS

Rocky Bernstein <rocky@cpan.org> (current maintainer)
Ted Zlatanov <tzz@lifelogs.com>
Ben Morrow

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2013 Rocky Bernstein <rocky@cpan.org>, Ted Zlatanov,
<tzz@lifelogs.com>, Ben Morrow

This program is distributed WITHOUT ANY WARRANTY, including but not
limited to the implied warranties of merchantability or fitness for a
particular purpose.

The program is free software. You may distribute it and/or modify it
under the terms of the GNU General Public License as published by the
Free Software Foundation (either version 2 or any later version) and
the Perl Artistic License as published by O’Reilly Media, Inc. Please
open the files named gpl-2.0.txt and Artistic for a copy of these
licenses.

=cut
