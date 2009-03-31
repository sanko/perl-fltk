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

 #
 # Copyright (C) 2009 by Sanko Robinson <sanko@cpan.org>
 #
 # This program is free software; you can redistribute it and/or modify it
 # under the terms of The Artistic License 2.0.  See the LICENSE file
 # included with this distribution or
 # http://www.perlfoundation.org/artistic_license_2_0.  For
 # clarification, see http://www.perlfoundation.org/artistic_2_0_notes.
 #
 # When separated from the distribution, all POD documentation is covered by
 # the Creative Commons Attribution-Share Alike 3.0 License.  See
 # http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
 # clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.
 #
 # $Id$
 #

