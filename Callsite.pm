package Devel::Callsite;
use 5.005;
use vars qw($VERSION);
require DynaLoader;
use base qw(DynaLoader Exporter);
$VERSION = '0.06_01';
@EXPORT = qw/callsite context/;

bootstrap Devel::Callsite;

# Demo code
unless (caller) { 
  my $site = sub { return callsite() };
  printf "OP location: 0x%x\n", $site->(); # prints caller OP location
  printf "OP location: 0x%x\n", $site->(); # prints a different OP location

  print context(), "\n"; # prints the interpreter context, an unsiged number
}

1;
__END__
=for comment
This file is shared by both README.pod and Callsite.pm after its __END__
It is also in the github wiki:
https://github.com/rocky/Perl-Devel-Callsite/wiki
where we can immediately see the results and others can contribute.

=for comment
=head1 NAME

Devel::Callsite - Get caller return OP address and Perl interpreter context

=head1 SYNOPSIS

  use Devel::Callsite;
  my $site = sub { return callsite() };
  printf "OP location: 0x%x\n", $site->(); # prints caller OP location
  printf "OP location: 0x%x\n", $site->(); # prints a different OP location

  print context(), "\n"; # prints the interpreter context, a unsigned number

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

=cut
