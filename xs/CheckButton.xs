#include "include/FLTK_pm.h"

MODULE = FLTK::CheckButton               PACKAGE = FLTK::CheckButton

#ifndef DISABLE_CHECKBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::CheckButton - Push button widget

=head1 Description

This button turns the L<C<value()>|FLTK::Button/"value"> on and off each
release of a click inside of it, and displays a checkmark to the user.

You can control the color of the checkbox with
L<C<color()>|FLTK::Widget/"color"> and the color of the checkmark with
L<C<textcolor()>|FLTK::Widget/"textcolor">. You can make it draw different
colors when turned on by setting
L<C<selection_color()>|FLTK::Widget/"selection_color"> and
L<C<selection_textcolor()>|FLTK::Widget/"selection_textcolor"> on the widget
(these are ignored if set in an inherited L<C<style()>|/"style">).

=begin apidoc

=cut

#include <fltk/CheckButton.h>

=for apidoc ||FLTK::CheckButton self|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::CheckButton> object. Obviously.

=cut

#include "include/RectangleSubclass.h"

fltk::CheckButton *
fltk::CheckButton::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::CheckButton>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::CheckButton::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

#INCLUDE: RadioButton.xsi

#endif // ifndef DISABLE_CHECKBUTTON

BOOT:
    isa("FLTK::CheckButton", "FLTK::Button");
