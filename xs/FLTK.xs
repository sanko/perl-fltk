#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "./ppport.pl"

#include <fltk/run.h>

#include <fltk/Widget.h>

void cb (fltk::Widget * widget, void * sub) {
    AV *cbargs = (AV *)sub;
    I32 alen = av_len(cbargs);
    CV *thecb = (CV *)SvRV(*av_fetch(cbargs, 0, 0));

    dSP;
    ENTER;
    SAVETMPS;

    PUSHMARK(sp);
    for(int i = 1; i <= alen; i++) {
        XPUSHs(*av_fetch(cbargs, i, 0));
    }

    PUTBACK;
    call_sv((SV*)thecb, G_DISCARD);

    FREETMPS;
    LEAVE;
}

using namespace fltk;

MODULE = FLTK               PACKAGE = FLTK

int
run()
    CODE:
        RETVAL = fltk::run();
    OUTPUT:
        RETVAL

int
check()
    CODE:
        RETVAL = fltk::check();
    OUTPUT:
        RETVAL

 # Top level
INCLUDE: FLTK_AssociationFunctor.xsi
INCLUDE: FLTK_Font.xsi




INCLUDE: FLTK_Rectangle.xsi
INCLUDE: FLTK_Style.xsi
 # INCLUDE: FLTK_Symbol.xsi

 # $Id: FLTK.xs a404412 2009-03-24 05:36:10Z sanko@cpan.org $
