#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "./ppport.pl"

#include <fltk/Widget.h>

void cb (fltk::Widget * widget, void * sub) {
    AV *cbargs = (AV *)sub;
    I32 alen = av_len(cbargs);
    CV *thecb = (CV *)SvRV(*av_fetch(cbargs, 0, 0));

    dSP;
    ENTER;
    SAVETMPS;

    PUSHMARK(sp);

    //warn("alen == %d", alen);

    for(int i = 1; i <= alen; i++) {
        //warn ( "arg %d : %s", i, av_fetch(cbargs, i, 0) );
        XPUSHs(*av_fetch(cbargs, i, 0));
    }

    PUTBACK;
    call_sv((SV*)thecb, G_DISCARD);

    FREETMPS;
    LEAVE;
}

using namespace fltk;

MODULE = FLTK               PACKAGE = FLTK

INCLUDE: FLTK_ask.xsi
INCLUDE: FLTK_styles.xsi



INCLUDE: FLTK_color.xsi

#include <fltk/run.h>


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

 # $Id: FLTK.xs 43c1956 2009-03-24 16:25:46Z sanko@cpan.org $
