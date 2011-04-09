#include "include/FLTK_pm.h"

MODULE = FLTK::ToggleButton               PACKAGE = FLTK::ToggleButton

#ifndef DISABLE_TOGGLEBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532007

=for git $Id$

=head1 NAME

FLTK::ToggleButton - Subclass of FLTK::Button which clicks on and off

=head1 Description

This subclass of L<FLTK::Button|FLTK::Button> toggles the
L<< C<state( )>|FLTK::Button/state >> on and off each release of a click
inside of it.

You can also convert a regular button into this by doing
L<<< C<< ...->type(FLTK::Button::TOGGLE) >>|FLTK::Button/"type" >>> to it.

=begin apidoc

=cut

#include <fltk/ToggleButton.h>

=for apidoc ||FLTK::ToggleButton * self|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<ToggleButton|FLTK::ToggleButton> widget using the given
position, size, and label string.

=cut

#include "include/RectangleSubclass.h"

fltk::ToggleButton *
fltk::ToggleButton::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ToggleButton>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

#endif // #ifndef DISABLE_TOGGLEBUTTON

BOOT:
    isa("FLTK::ToggleButton", "FLTK::Button");
