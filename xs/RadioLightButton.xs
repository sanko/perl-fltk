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

#include "include/RectangleSubclass.h"

fltk::RadioLightButton *
fltK::RadioLightButton::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::RadioLightButton>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

#endif // #ifndef DISABLE_RADIOLIGHTBUTTON

BOOT:
    isa("FLTK::RadioLightButton", "FLTK::LightButton");
