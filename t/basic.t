
my $threads;
BEGIN { $threads = eval "use threads; 1" }

use Test::Simple tests => $threads ? 8 : 6;

eval { require Devel::Callsite };
ok(!$@, "loading module");
eval { import Devel::Callsite };
ok(!$@, "running import");
my $site = sub { ${shift()} = callsite();};
$site->(\$callsite1);
$site->(\$callsite2);
ok($callsite1, "Valid first call");
ok($callsite2, "Valid second call");
ok($callsite1 != $callsite2, "Two separate calls");

if ($threads) {
    my $parent = context();
    ok($parent > 0, "Valid context in initial thread");

    my $child = threads->new(sub { context() })->join;
    ok($child > 0, "Valid context in child thread");

    ok($parent != $child, "Parent and child contexts are different");
}
else {
    ok(context() > 0, "Valid context call");
}
