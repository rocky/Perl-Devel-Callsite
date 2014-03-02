#!/usr/bin/env perl
use strict; use warnings;
my $threads;
BEGIN { $threads = eval "use threads; 1" }

use Test::More tests => 11 + ($threads ? 2 : 0);

eval { require Devel::Callsite };
ok(!$@, "loading module");
eval { import Devel::Callsite };
ok(!$@, "running import");
my ($callsite1, $callsite2);
my $site = sub { ${shift()} = callsite();};
$site->(\$callsite1);
$site->(\$callsite2);
ok($callsite1, "Valid first call");
ok($callsite2, "Valid second call");
ok($callsite1 != $callsite2, "Two separate calls");

sub foo { callsite(1) }
sub bar { callsite(), foo(), callsite(0) }

my @nest = bar();
is $nest[1], $nest[0], "Nested callsite";
is $nest[2], $nest[0], "Callsite defaults to level 0";

sub doloop { for (1) { callsite(1) } }
sub loop { 
    my $x;
    for (1) { $x = doloop() }
    callsite(), doloop(), $x 
}

my @loop = loop();
is $nest[1], $nest[0], "Nested callsite inside loop";
is $nest[2], $nest[0], "Callsite inside two loops";

sub deep1 { callsite(3) }
sub deep2 { deep1 }
sub deep3 { deep2 }
sub deep { callsite(), deep3() }

my @deep = deep();
is $deep[1], $deep[0], "Deeply nested callsite";

if ($threads) {
    my $parent = context();
    ok($parent > 0, "Valid context in initial thread");

    # quoted to avoid a warning on 5.6
    my $child = "threads"->new(sub { context() })->join;
    ok($child > 0, "Valid context in child thread");

    ok($parent != $child, "Parent and child contexts are different");
}
else {
    ok(context() > 0, "Valid context call");
}
