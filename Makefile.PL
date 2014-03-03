use ExtUtils::MakeMaker;

WriteMakefile( 
    'NAME'     => 'Devel::Callsite',
    'clean' => {FILES => "*% *.bak ppport.h"},
    'dist'     => { COMPRESS => 'gzip -f9', SUFFIX => '.gz' },
    'VERSION_FROM'  => 'Callsite.pm',
    PREREQ_PM   => {
        "Test::More"    => "0",
        "Devel::PPPort" => "3.00",
    },
);

sub MY::postamble { <<'MAKE' }
$(BASEEXT)$(OBJ_EXT): ppport.h

ppport.h:
	$(PERL) -MDevel::PPPort -eDevel::PPPort::WriteFile

MAKE
