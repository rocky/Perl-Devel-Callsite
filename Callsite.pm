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

  print context(), "\n"; # prints the interpreter context, an unsiged number
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

  print context(), "\n"; # prints the interpreter context, an unsigned number

=head1 DESCRIPTION

The I<callsite()> function returns the the OP address of the caller, a
number, one level up from where it was called. It's useful for
functions that need to uniquely know where they were called, such as
I<Every::every()>; see L<Every>. Or it can be used to L<pinpoint a
location with finer granularity than a line
number|http://www.perlmonks.com/?node_id=987268>. In conjunction with
an OP tree disassembly you can know exactly where the caller is
located in the Perl source.

The I<context()> function returns the interpreter context as a number.
This is a fairly unique number together with the call site.

=head1 HISTORY

Ben Morrow conceived this and posted it to perl5-porters. Ted Zlatanov
then turned it into a CPAN module which he maintained for the first 3
revisions.

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
