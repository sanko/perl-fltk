#include "include/FLTK_pm.h"

MODULE = FLTK::LightButton               PACKAGE = FLTK::LightButton

#ifndef DISABLE_LIGHTBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::LightButton - Forms/XForms/Flame style button with indicator light on left

=head1 Description

This button turns the L<C<value()>|FLTK::Widget/"value"> on and off each
release of a click inside of it, and displays a light to show the user this.
This style was designed for the original Forms library and has been copied
into Discreet products and many other pieces of software that originated with
SGI machines.

When off the light is L<C<color()>|FLTK::Widget/"color">, when on the light is
L<C<selection_color()>|FLTK::Widget/"selection_color">.

=begin apidoc

=cut

#include <fltk/LightButton.h>

=for apidoc ||FLTK::LightButton button|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::LightButton> object. Obviously.

=cut

#include "include/RectangleSubclass.h"

fltk::LightButton *
fltk::LightButton::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::LightButton>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::NamedStyle * style|default_style||



=for apidoc |||default_style|FLTK::NamedStyle * new_style|



=cut

fltk::NamedStyle *
fltk::LightButton::default_style( fltk::NamedStyle * new_style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = new_style;

#INCLUDE: RadioLightButton.xsi

#endif // #ifndef DISABLE_LIGHTBUTTON

BOOT:
    isa("FLTK::LightButton", "FLTK::CheckButton");
