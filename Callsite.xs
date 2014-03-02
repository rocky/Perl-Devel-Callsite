#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#ifndef caller_cx
/* this should be in ppport.h */

#  define caller_cx(c, p) MY_caller_cx(aTHX_ c, p)
#  define dopoptosub_at(c, s) MY_dopoptosub_at(aTHX_ c, s)
#  define dopoptosub(s) dopoptosub_at(cxstack, s)

static I32
MY_dopoptosub_at(pTHX_ const PERL_CONTEXT *cxstk, I32 startingblock)
{
    I32 i;

    for (i = startingblock; i >= 0; i--) {
	register const PERL_CONTEXT * const cx = &cxstk[i];
	switch (CxTYPE(cx)) {
	default:
	    continue;
	case CXt_EVAL:
	case CXt_SUB:
	case CXt_FORMAT:
	    return i;
	}
    }
    return i;
}

const PERL_CONTEXT *
MY_caller_cx(pTHX_ I32 count, const PERL_CONTEXT **dbcxp)
{
    register I32 cxix = dopoptosub(cxstack_ix);
    register const PERL_CONTEXT *cx;
    register const PERL_CONTEXT *ccstack = cxstack;
    const PERL_SI *top_si = PL_curstackinfo;

    for (;;) {
	/* we may be in a higher stacklevel, so dig down deeper */
	while (cxix < 0 && top_si->si_type != PERLSI_MAIN) {
	    top_si = top_si->si_prev;
	    ccstack = top_si->si_cxstack;
	    cxix = dopoptosub_at(ccstack, top_si->si_cxix);
	}
	if (cxix < 0)
	    return NULL;
	/* caller() should not report the automatic calls to &DB::sub */
	if (PL_DBsub && GvCV(PL_DBsub) && cxix >= 0 &&
		ccstack[cxix].blk_sub.cv == GvCV(PL_DBsub))
	    count++;
	if (!count--)
	    break;
	cxix = dopoptosub_at(ccstack, cxix - 1);
    }

    cx = &ccstack[cxix];
    if (dbcxp) *dbcxp = cx;

    if (CxTYPE(cx) == CXt_SUB || CxTYPE(cx) == CXt_FORMAT) {
        const I32 dbcxix = dopoptosub_at(ccstack, cxix - 1);
	/* We expect that ccstack[dbcxix] is CXt_SUB, anyway, the
	   field below is defined for any cx. */
	/* caller() should not report the automatic calls to &DB::sub */
	if (PL_DBsub && GvCV(PL_DBsub) && dbcxix >= 0 && ccstack[dbcxix].blk_sub.cv == GvCV(PL_DBsub))
	    cx = &ccstack[dbcxix];
    }

    return cx;
}

#endif

MODULE = Devel::Callsite	PACKAGE = Devel::Callsite

PROTOTYPES: Enable

UV
callsite(level = 0)
        I32 level
    INIT:
	const register PERL_CONTEXT *cx;
    CODE:
        cx = caller_cx(level, 0);
#if PERL_VERSION > 8
	RETVAL = PTR2UV(cx->blk_sub.retop);
#else
	RETVAL = (UV)(PL_retstack[cx->blk_oldretsp - 1]);
#endif
    OUTPUT:
	RETVAL

UV
context()
    CODE:
	RETVAL = PTR2UV(PERL_GET_CONTEXT);
    OUTPUT:
	RETVAL
