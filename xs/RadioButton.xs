#include "include/FLTK_pm.h"

MODULE = FLTK::RadioButton               PACKAGE = FLTK::RadioButton

#ifndef DISABLE_RADIOBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::RadioButton - Button with a circle indicator to it's left, turning it on
turns off all other radio buttons in the same Group

=head1 Description

This button turns the L<C<value( )>|FLTK::Widget/"value"> on when clicked, and
turns all other L<RadioButton|FLTK::RadioButton> widgets in the same group
off. It displays a round dot to show the user the current status.

You can control the color of the circle with
L<C<color( )>|FLTK::Widget/"color"> and the color of the dot with
L<C<textcolor( )>|FLTK::Widget/"textcolor">. You can make it draw different
colors when turned on by setting
L<C<selection_color( )>|FLTK::Widget/"selection_color"> and
L<C<selection_textcolor( )>|FLTK::Widget/"selection_textcolor"> on the widget
(these are ignored if set in an inherited
L<C<style( )>|FLTK::Widget/"style">).

If you want, you can make any other button act like a
L<RadioButton|FLTK::RadioButton> by doing
L<C<type(FLTK::Button::RADIO)>|FLTK::Widget/"type"> to it. Be sure to lay out
and decorate your interface so it is clear to the user that they are radio
buttons.

=begin apidoc

=cut

#include <fltk/RadioButton.h>

=for apidoc d||FLTK::RadioButton self|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::RadioButton> object.

=cut

#include "include/RectangleSubclass.h"

fltk::RadioButton *
fltk::RadioButton::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::RadioButton>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::RadioButton::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

#endif // ifndef DISABLE_RADIOBUTTON

BOOT:
    isa("FLTK::RadioButton", "FLTK::CheckButton");
