#include "include/FLTK_pm.h"

MODULE = FLTK::ccHueBox               PACKAGE = FLTK::ccHueBox

#ifndef DISABLE_CCHUEBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::ccHueBox - Part of the FLTK::ColorChooser megawidget

=head1 Description



=cut

#include <fltk/ColorChooser.h>

=for apidoc ||FLTK::ccHueBox hb|new|int x|int y|int w|int h|



=cut

#include "include/WidgetSubclass.h"

void
fltk::ccHueBox::new( int x, int y, int w, int h )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::ccHueBox>(CLASS,x,y,w,h);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // #ifndef DISABLE_CCHUEBOX

BOOT:
    isa("FLTK::ccHueBox", "FLTK::Widget");
