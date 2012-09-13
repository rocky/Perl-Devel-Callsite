#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>


MODULE = Devel::Callsite	PACKAGE = Devel::Callsite

PROTOTYPES: Enable

IV
callsite()
    INIT:
#if PERL_VERSION > 8
	register PERL_CONTEXT *cx;
#endif
    CODE:
#if PERL_VERSION > 8
	cx = &cxstack[cxstack_ix];
	RETVAL = (IV)(cx->blk_sub.retop);
#else
	RETVAL = (IV)(PL_retstack[PL_retstack_ix - 1]);
#endif
    OUTPUT:
	RETVAL

IV
context()
    CODE:
	RETVAL = PTR2UV(Perl_get_context());
    OUTPUT:
	RETVAL
