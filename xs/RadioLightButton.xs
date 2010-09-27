#include "include/FLTK_pm.h"

MODULE = FLTK::RadioLightButton               PACKAGE = FLTK::RadioLightButton

#ifndef DISABLE_RADIOLIGHTBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::RadioLightButton - LightButton that toggles off all others in the group when turned on

=head1 Description

LightButton that toggles off all others in the group when turned on.

=begin apidoc

=cut

#include <fltk/RadioLightButton.h>

=for apidoc ||FLTK::RadioLightButton button|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::RadioLightButton> object. Obviously.

=cut

#include "include/WidgetSubclass.h"

void
fltK::RadioLightButton::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::RadioLightButton>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // #ifndef DISABLE_RADIOLIGHTBUTTON

BOOT:
    isa("FLTK::RadioLightButton", "FLTK::LightButton");
