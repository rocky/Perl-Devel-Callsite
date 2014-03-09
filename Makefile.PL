use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'     => 'Devel::Callsite',
    'LICENSE'  => 'perl',
    'clean' => {FILES => "*% *.bak"},
    'dist'     => { COMPRESS => 'gzip -f9', SUFFIX => '.gz' },
    'VERSION_FROM'  => 'Callsite.pm',

    META_MERGE => {
	resources => {
	    bugtracker => {
		web  => 'https://github.com/rocky/Perl-Devel-Callsite/issues',
           },
           repository => {
               type => 'git',
               url => 'git://github.com/rocky/Perl-Devel-Callsite.git',
               web => 'http://github.com/rocky/Pelr-Devel-Callsite',
           }
       }
    }
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
