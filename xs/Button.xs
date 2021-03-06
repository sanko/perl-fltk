#include "include/FLTK_pm.h"

MODULE = FLTK::Button               PACKAGE = FLTK::Button

#ifndef DISABLE_BUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Button - Push button widget

=head1 Description

Buttons generate callbacks when they are clicked by the user. You control
exactly when and how by changing the values for
L<C<when()>|FLTK::Widget/"when">:

=over 8

=item C<FLTK::WHEN_NEVER>
The callback is not done, instead L<C<changed()>|FLTK::Widget/"changed"> is
turned on.

=item C<FLTK::WHEN_RELEASE>
This is the default, the callback is done after the user successfully clicks
the button (i.e. they let it go with the mouse still pointing at it), or when
a shortcut is typed.

=item C<FLTK::WHEN_CHANGED>
The callback is done each time the L<C<value()>|FLTK::Widget/"value"> changes
(when the user pushes and releases the button, and as the mouse is dragged
around in and out of the button).

=back

Buttons can also generate callbacks in response to C<FLTK::SHORTCUT> events.
The button can either have an explicit
L<C<shortcut()>|FLTK::Widget/"shortcut"> value or a letter shortcut can be
indicated in the L<C<label()>|FLTK::Widget/"label"> with an C<&> character
before it. For the label shortcut it does not matter if C<Alt> is held down,
but if you have an input field in the same window, the user will have to hold
down the C<Alt> key so that the input field does not eat the event first as an
C<FLTK::KEY> event.

=begin apidoc

=cut

#include <fltk/Button.h>

=for apidoc ||FLTK::Button * self|new|int x|int y|int w|int h|char * label = ''

Creates a new C<FLTK::Button> object. Obviously.

=cut

#include "include/RectangleSubclass.h"

fltk::Button *
fltk::Button::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Button>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc E||int flag|HIDDEN|

Back-comptability value to hide the button

=cut

int
HIDDEN ( )
    CODE:
        RETVAL = fltk::Button::HIDDEN;
    OUTPUT:
        RETVAL

=for apidoc |||value|bool val|

Change the L<C<value()>|/"value">. Redraws the button and returns true if the
new value is different. This is the same function as
L<C<Widget::state()>|FLTK::Widget/"state">. See also
L<C<Widget::set()>|FLTK::Widget/"set">,
L<C<Widget::clear()>|FLTK::Widget/"clear">, and
L<C<Widget::setonly()>|FLTK::Widget/"setonly">.

If you turn it on, a normal button will draw pushed-in, until the user clicks
it and releases it.

=for apidoc ||bool val|value|

The current value. C<true> means it is pushed down, C<false> means it is not
pushed down. The L<ToggleButton|FLTK::ToggleButton> subclass provides the
ability for the user to change this value permanently, otherwise it is just
temporary while the user is holding the button down.

This is the same as L<Widget::state()|FLTK::Widget/"state">.

=cut

bool
fltk::Button::value ( bool value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->value( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->value( value );

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Button::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=end apidoc

=head1 Subclassing C<FLTK::Button>

Blah, blah, blah...

=head2 C<draw( $glyph_width )>

This function provides a mess of back-compatabilty and Windows emulation to
subclasses of L<Button|FLTK::Button> to draw with. It will draw the button
according to the current state of being pushed and it's
L<C<state()>|FLTK::Widget/"state">. If non-zero is passed for C<GLYPH_WIDTH>
then the L<C<glyph()>|FLTK::Widget/"glyph"> is drawn in that space on the left
(or on the right if negative), and it assummes the glyph indicates the
L<C<state()>|FLTK::Widget/"state">, so the box is only used to indicate the
pushed state.

=cut

#INCLUDE: CheckButton.xsi

#INCLUDE: RepeatButton.xsi

#INCLUDE: ReturnButton.xsi

#endif // ifndef DISABLE_BUTTON

BOOT:
    isa("FLTK::Button", "FLTK::Widget");
