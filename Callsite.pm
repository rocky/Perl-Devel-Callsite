package Devel::Callsite;
use 5.005;
use vars qw($VERSION);
require DynaLoader;
use base qw(DynaLoader Exporter);
$VERSION = '0.04_01';
@EXPORT = qw/callsite context/;

bootstrap Devel::Callsite;

1;
__END__

=head1 NAME

Devel::Callsite - Get current callsite and interpreter context

=head1 SYNOPSIS

  use Devel::Callsite;
  sub $site { return callsite() };
  print $site->(), "\n"; # prints one number
  print $site->(), "\n"; # prints a different number

  print context(), "\n"; # prints the interpreter context, a number

=head1 DESCRIPTION

The callsite() function returns the callsite (a number) one level up
from where it was called.  See the tests for an example.  It's useful
for functions that need to uniquely know where they were called, such
as Every::every() (see CPAN for that module).

The context() function returns the interpreter context as a number.
This is a fairly unique number together with the call site.

=head1 HISTORY

Written by Ben Morrow on perl5-porters.  CPAN-ified by Ted Zlatanov.

=head1 AUTHOR

Ben Morrow <ben@morrow.me.uk>
Ted Zlatanov <tzz@lifelogs.com>

=cut

