use ExtUtils::MakeMaker;

WriteMakefile( 
    'NAME'     => 'Devel::Callsite',
    'clean' => {FILES => "*% *.bak"},
    'dist'     => { COMPRESS => 'gzip -f9', SUFFIX => '.gz' },
    'VERSION_FROM'  => 'Callsite.pm'
);

