#include "include/FLTK_pm.h"

MODULE = FLTK::FillSlider               PACKAGE = FLTK::FillSlider

#ifndef DISABLE_FILLSLIDER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::FillSlider - Subclass of FLTK::Slider

=head1 Description

Vertical L<Slider|FLTK::Slider> that is filled from the end like a progress
bar.

=cut

#include <fltk/FillSlider.h>

=for apidoc d||FLTK::FillSlider fslider|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::FillSlider> object.

=cut

#include "include/WidgetSubclass.h"

void
FillSlider::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::FillSlider>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_FILLSLIDER

BOOT:
    isa("FLTK::FillSlider", "FLTK::Slider");
