#include "include/FLTK_pm.h"

MODULE = FLTK::Slider               PACKAGE = FLTK::Slider

#ifndef DISABLE_SLIDER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.532006

=head1 NAME

FLTK::Slider - Slider value control

=head1 Description

This widget contains a sliding "knob" that controls a single floating-point
value. Moving the box all the way to the left or bottom sets it to the
L<C<minimum( )>|FLTK::Valuator/"minimum">, and to the top/right to the
L<C<maximum( )>|FLTK::Valuator/"maximum"> value. The
L<C<minimum( )>|FLTK::Valuator/"minimum"> may be greater than the
L<C<maximum( )>|FLTK::Valuator/"maximum"> in case you want the larger number
at the opposite end.

See L<Valuator|FLTK::Valuator> for how to set or get the value or handle
callbacks when the value changes.

The appearance of the base class may be changed in several ways:

Setting the L<C<box( )>|FLTK::Widget/"box"> to any value other than the
default of C<FLAT_BOX> will remove the "slot" and draw a box around the slider
and the tick marks. The L<C<color( )>|FLTK::Widget/"color"> (which defaults to
C<GRAY75>) is used to fill in the area behind the slider and tick marks.

You can use L<C<set_vertical( )>|FLTK::Slider/"set_vertical"> to make the
slider move up/down rather than horizontally.

The following bits may be or'd together and given to
L<C<type( )>|FLTK::Widget/"type">:

=over

=item * C<FLTK::Slider::TICK_ABOVE> : Put tick marks above the horizontal
slider.

=item * C<FLTK::Slider::TICK_LEFT> : Put tick marks to the left of a vertical
slider (same value as C<TICK_ABOVE>)

=item * C<FLTK::Slider::TICK_BELOW> : Put tick marks below the horizontal
slider.

=item * C<FLTK::Slider::TICK_RIGHT> : Put tick marks to the right of a
vertical slider (same value as C<TICK_BELOW>)

=item * C<FLTK::Slider::TICK_BOTH> : Put tick marks on both sides of the
slider.

=item * C<FLTK::Slider::LOG> : Use a logarithimic or power scale for the
slider.

=back

The tick marks are placed the L<C<slider_size( )>|FLTK::Slider/"slider_size">
or more apart (they are also no closer than the
L<C<step( )>|FLTK::Valuator/"step"> value). The color of the tick marks is
controlled by L<C<textcolor( )>|FLTK::Widget/"text_color">, and the font used
to draw the numbers is L<C<textfont( )>|FLTK::Widget/"textfont"> and
L<C<textsize( )>|FLTK::Widget/"textsize"> (which defaults to 8).

You can change the L<C<glyph( )>|FLTK::Widget/"glyph"> function to change how
the moving part is drawn. The L<C<drawflags( )>|FLTK::Widget/"drawflags">
determines what part of the slider is being drawn. The
L<ScrollBar|FLTK::ScrollBar> subclass turns on C<ALIGN_TOP/LEFT/RIGHT/BOTTOM>
to draw the buttons at the end (this is the same as
L<C<Widget::default_glyph( )>|FLTK::Widget/"default_glyph"> takes and the
default slider glyph just calls that). The moving part has bit 16 turned on,
unless this is a fill slider in which case bit 16 is off. You can check the
C<LAYOUT_VERTICAL> flag to see which direction the slider is going in.

"Log" sliders have a non-uniform scale. The scale is truly logarithmic if both
the L<C<minimum( )>|FLTK::Valuator/"minimum"> and the
L<C<maximum( )>|FLTK::Valuator/"maximum"> are non-zero and have the same sign.
Otherwise the slider position is the square root of the value (or
C<-sqrt(-value)> for negative values).

=begin apidoc

=cut

#include <fltk/Slider.h>

=for apidoc ||FLTK::Slider * self|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<FLTK::Slider|FLTK::Slider> widget.

=cut

#include "include/WidgetSubclass.h"

void
fltk::Scrollbar::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::Slider>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal( );
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=end apidoc

=head1 Values for C<type( )>

=over

=item * C<TICK_ABOVE>

Put tick marks above the horizontal slider.

=item * C<TICK_LEFT>

Put tick marks to the left of a vertical slider.

=item * C<TICK_BELOW>

Put tick marks below the horizontal slider.

=item * C<TICK_RIGHT>

Put tick marks to the right of a vertical slider.

=item * C<TICK_BOTH>

Put tick marks on both sides of the slider.

=item * C<LOG>

Use a logarithimic or power scale for the slider.

=item * C<LINEAR>

TODO

=back

=cut

int
LINEAR ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::Slider::LINEAR;     break;
            case 1: RETVAL = fltk::Slider::TICK_ABOVE; break;
            case 2: RETVAL = fltk::Slider::TICK_LEFT;  break;
            case 3: RETVAL = fltk::Slider::TICK_BELOW; break;
            case 4: RETVAL = fltk::Slider::TICK_RIGHT; break;
            case 5: RETVAL = fltk::Slider::TICK_BOTH;  break;
            case 6: RETVAL = fltk::Slider::LOG;        break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        TICK_ABOVE = 1
         TICK_LEFT = 2
        TICK_BELOW = 3
        TICK_RIGHT = 4
         TICK_BOTH = 5
               LOG = 6

=begin apidoc

=for apidoc |||slider_size|int value|

Set the dimensions of the moving piece of slider. This is measured in pixels
in a direction parallel to the slider's movement. The default value is 12.

Setting L<C<slider_size( )>|FLTK::Slider/"slider_size"> to zero will make the
slider into a "fill" slider that draws a solid bar from the left/bottom to the
current value. This is useful for indicating progress or as a output
indicator.

=for apidoc |||tick_size|int value|

The slider is shrunk this many pixels from the widget's width so that the tick
marks are visible next to it. The default value is 4.

=cut

void
fltk::Slider::slider_size( int value )
    CODE:
        switch ( ix ) {
            case 0: THIS->slider_size( value ); break;
            case 1:   THIS->tick_size( value ); break;
        }
    ALIAS:
        tick_size = 1

=for apidoc ||int position|slider_position|double value|int w|

This is used by subclasses to draw the slider correctly. Return the location
of the left/top edge of a box of
L<C<slider_size( )>|FLTK::Slider/"slider_size"> would be if the slider is set
to C<$value> and can move in an area of C<$w> pixels. The
L<C<range( )>|FLTK::Slider/"range"> and L<C<log( )>|FLTK::Slider/"log">
settings are taken into account.

=cut

int
fltk::Slider::slider_position( double value, int w )

=for apidoc ||double position|position_value|int x|int w|

This is used by subclasses to handle events correctly:

Return the value if the left/top edge of a box of
L<C<slider_size( )>|FLTK::Slider/"slider_size"> is placed at C<$x> pixels from
the edge of an area of size C<$w> pixels. The
L<C<range( )>|FLTK::Slider/"range"> and L<C<log( )>|FLTK::Slider/"log">
settings are taken into account, and it also rounds the value to multiples of
L<C<step( )>|FLTK::Slider/"step">, using powers of 10 larger and multiples of
2 or 5 to get the steps close to 1 pixel so the user is presented with nice
numerical values.

=cut

double
fltk::Slider::position_value( int x, int w )

=for apidoc |||draw_ticks|FLTK::Rectangle * rect|int min_spacing|

Draw tick marks. These lines cross the passed rectangle perpendicular to the
slider direction. In the direction parallel to the slider direction the box
should have the same size as the area the slider moves in.

=cut

void
fltk::Slider::draw_ticks( fltk::Rectangle * rect, int min_spacing )
    C_ARGS: * rect, min_spacing

=end apidoc

=head1 Subclassing FLTK::Slider

If you plan on subclassing L<FLTK::Slider>, consider these notes...

=head2 C<draw( $rect, $flags, $slot )>

Subclasses can use this to redraw the moving part. Draw everything that is
inside the box, such as the tick marks, the moving slider, and the "slot". The
slot only drawn if C<$slot> is true. You should already have drawn the
background of the slider.

The default method is called if this does not return a true value.

=head2 C<handle( $event, $rect )>

This call is provied so subclasses can draw the moving part inside an
arbitrary rectangle.

The default method is called if this does not return a true value.

=cut

#INCLUDE: Scrollbar.xsi

#endif // ifndef DISABLE_SLIDER

BOOT:
    isa( "FLTK::Slider", "FLTK::Valuator" );
