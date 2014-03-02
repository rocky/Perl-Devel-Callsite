use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'     => 'Devel::Callsite',
    'clean' => {FILES => "*% *.bak"},
    'dist'     => { COMPRESS => 'gzip -f9', SUFFIX => '.gz' },
    'VERSION_FROM'  => 'Callsite.pm'
);

# Here's how to add custom targets...
sub MY::postamble {
    # Add a
    return <<'MAKE_FRAG';
.PHONY: check
#: Same as make test
check: test
MAKE_FRAG
}
