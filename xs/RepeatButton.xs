#include "include/FLTK_pm.h"

MODULE = FLTK::RepeatButton               PACKAGE = FLTK::RepeatButton

#ifndef DISABLE_REPEATBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::RepeatButton - This button does it's callback repeatedly while the user
holds the button down.

=head1 Description

The callback is done when the user pushes the button down, and then after .5
second it is repeated 10 times a second, as long as the user is pointing at
the button and holding it down.

=begin apidoc

=cut

#include <fltk/RepeatButton.h>

=for apidoc ||FLTK::RepeatButton button|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::RepeatButton> object. Obviously.

=cut

#include "include/WidgetSubclass.h"

void
fltK::RepeatButton::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::RepeatButton>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // #ifndef DISABLE_REPEATBUTTON

BOOT:
    isa("FLTK::RepeatButton", "FLTK::Button");
