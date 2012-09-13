package Devel::Callsite;
use 5.005;
use vars qw($VERSION);
require DynaLoader;
use base qw(DynaLoader Exporter);
$VERSION = '0.02';
@EXPORT = qw/callsite/;

bootstrap Devel::Callsite;

1;
__END__

=head1 NAME

Devel::Callsite - Get current callsite

=head1 SYNOPSIS

  use Devel::Callsite;
  sub $site { return callsite() };
  print $site->(), "\n"; # prints one number
  print $site->(), "\n"; # prints a different number

=head1 DESCRIPTION

This function returns the callsite (a number) one level up from where
it was called.  See the tests for an example.  It's useful for
functions that need to uniquely know where they were called, such as
Every::every() (see CPAN for that module).

=head1 HISTORY

Written by Ben Morrow on perl5-porters.  CPAN-ified by Ted Zlatanov.

=head1 AUTHOR

Ben Morrow <ben@morrow.me.uk>
Ted Zlatanov <tzz@lifelogs.com>

=cut

