
my $threads;
BEGIN { $threads = eval "use threads; 1" }

use Test::More tests => 25 + ($threads ? 2 : 0);

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

sub foo { callsite(1) }
sub bar { callsite(), foo(), callsite(0) }

my @nest = bar();
is $nest[1], $nest[0], "Nested callsite";
is $nest[2], $nest[0], "Callsite defaults to level 0";

my @toofar = callsite(1);
is @toofar, 0, "Going too far returns empty list";

my $toofar = callsite(1);
ok !defined $toofar, "Going too far returns undef";

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

our $db_called = 0;
BEGIN {   
    package DB;
    no strict "refs";
    # DB::sub must be defined in a BEGIN block with $^P = 1 or 5.6
    # doesn't start using it properly. (Why I'm making this work on 5.6
    # I'm not entirely sure, but there we are.)
    local $^P = 1;
    sub sub { $db_called++; &$sub; }
    sub db3 { Devel::Callsite::callsite(1) }
}

sub db1 { callsite(1) }
sub db2 { 
    BEGIN { $^P = 1 }
    my @db = (callsite(), db1());
    BEGIN { $^P = 0 }
    callsite(), @db, db1();
}

$db_called = 0;
my @db = db2();
is $db_called, 2, "Sanity check (DB::sub was called)";
is $db[1], $db[0], "Calls with DB::sub";
is $db[2], $db[0], "Nested calls with DB::sub";
is $db[3], $db[0], "Nested calls with and without DB::sub";

sub db4 { callsite(), DB::db3() }

$db_called = 0;
my @db4 = db4();
is $db_called, 0, "Sanity check (DB::sub was not called)";
is @db4, 3, "Call from DB returns 2 values";
is $db4[1], $db4[0], "First value is the same (no DB::sub)";
is $db4[2], $db4[0], "Second value is the same (no DB::sub)";

$db_called = 0;
BEGIN { $^P = 1 }
my @db5 = db4();
BEGIN { $^P = 0 }
is $db_called, 1, "Sanity check (DB::sub was called)";
is @db5, 3, "Call from DB with DB::sub returns 2 values";
is $db5[1], $db5[0], "First value is the same (with DB::sub)";
isnt $db5[2], $db5[0], "Second value is different (with DB::sub)";

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
