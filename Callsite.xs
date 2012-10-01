#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>


MODULE = Devel::Callsite	PACKAGE = Devel::Callsite

PROTOTYPES: Enable

UV
callsite()
    INIT:
#if PERL_VERSION > 8
	register PERL_CONTEXT *cx;
#endif
    CODE:
#if PERL_VERSION > 8
	cx = &cxstack[cxstack_ix];
	RETVAL = PTR2UV(cx->blk_sub.retop);
#else
	RETVAL = (UV)(PL_retstack[PL_retstack_ix - 1]);
#endif
    OUTPUT:
	RETVAL

UV
context()
    CODE:
	RETVAL = PTR2UV(PERL_GET_CONTEXT);
    OUTPUT:
	RETVAL
