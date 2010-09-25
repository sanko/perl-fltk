#include "include/FLTK_pm.h"

MODULE = FLTK::Valuator               PACKAGE = FLTK::Valuator

#ifndef DISABLE_VALUATOR

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.531

=head1 NAME

FLTK::Valuator - Base class for sliders and all other one-value "knobs"

=head1 Description

Base class for sliders and all other one-value "knobs". The
L<FLTK::Valuator|FLTK::Valuator> class controls a single floating-point value
and provides a consistent interface to set the
L<C<value()>|FLTK::Valuator/"value">, L<C<range()>|FLTK::Valuator/"range">,
and L<C<step()>|FLTK::Valuator/"step">, and insures that callbacks are done
the same for every object.

Callbacks are done each time the user changes the value. So if they drag a
slider, the callback is done each time the slider handle moves to a new pixel.

For most subclasses you can call L<C<when()>|FLTK::Widget/"when"> to get some
other callback behaviors:

=over

=item * C<FLTK::WHEN_CHANGED>: this is the default, callback is done on any
change.

=item * C<FLTK::WHEN_RELEASE>: it will only do the callback when the user
moves the slider and then lets it go on a different value than it started.

=item * C<FLTK::WHEN_RELEASE_ALWAYS>: will do the callback when the user lets
go of the slider whether or not the value changed.

=item * C<FLTK::WHEN_NEVER>: do not do the callback, instead it will turn on
the L<C<changed()>|FLTK::Widget/"changed"> flag.

=back

=begin apidoc

=cut

#include <fltk/Valuator.h>

=for apidoc ||FLTK::Valuator * self|new|int x|int y|int w|int h|char * label = ''|

The constructor initializes:

=over

=item L<C<value(0.0)>|FLTK::Valuator/"value">

=item L<C<step(0)>|FLTK::Valuator/"step">

=item L<C<range(0,1)>|FLTK::Valuator/"range">

=item L<C<linesize(0)>|FLTK::Valuator/"linesize">

=back

=cut

#include "include/WidgetSubclass.h"

void
fltk::Valuator::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::Valuator>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||double val|value||

Returns the current value.

=for apidoc ||bool okay|value|double v|

Sets the current value, redrawing the widget if necessary by calling
L<C<value_damage()>|FLTK::Valuator/"value_damage">. I<The new value is stored
unchanged, even if it is outside the range or not a multiple of
L<C<step()>|FLTK::Valuator/"step">>. Returns true if the new value is
different.

=cut

double
fltk::Valuator::value( double v = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->value( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = THIS->value ( v ); // !boobs
        OUTPUT:
            RETVAL

=for apidoc |||set_value|double value|

Sets the current value but does not call
L<C<value_damage( )>|FLTK::Valuator/"value_damage">.

=for apidoc |||maximum|double value|

Sets the maximum value for the valuator. For most subclasses the user cannot
move the value outside the C<minimum( )..maximum( )> range if it starts inside
this range.

These values should be multiples of the L<C<step( )>|FLTK::Valuator/"step"> to
avoid ambiguity and possible implementation changes.

For most subclasses, the minimum may be greater than the maximum. This has the
effect of "reversing" the object so the larger values are in the opposite
direction. This also switches which end of the filled sliders is filled.

You probably need to L<C<redraw()>|FLTK::Valuator/"redraw"> the widget after
changing the range.

=for apidoc |||minimum|double value|

Sets the minimum value for the valuator.

=for apidoc |||step|double value|

Set the step value. As the user moves the mouse the value is rounded to a
multiple of this. Values that are sufficently close to C<1/N> (where C<N> is
an integer) are detected and assummed to be exactly C<1/N>, so C<step(.00001)>
will work as wanted.

If this is zero (the default) then all rounding is disabled. This results in
the smoothest controller movement but this is not recommended if you want to
present the resulting numbers to the user as text, because they will have
useless extra digits of precision.

For some widgets like L<Roller|FLTK::Roller>, this is also the distance the
value moves when the user drags the mouse C<1> pixel. In these cases if
L<C<step()>|FLTK::Valuator/"step"> is zero then it acts like it is C<.01>.

Negative values for L<C<step()>|FLTK::Valuator/"step"> produce undocumented
results.

=cut

void
fltk::Valuator::set_value( double value )
    CODE:
        switch( ix ) {
            case 0: THIS->set_value(value);   break;
            case 1: THIS->maximum(value);     break;
            case 2: THIS->minimum(value);     break;
            case 3: THIS->step(value);        break;
        }
    ALIAS:
            maximum = 1
            minimum = 2
               step = 3

=for apidoc |||range|double min|double max|

Sets both the L<C<minimum()>|FLTK::Valuator/"minimum"> and
L<C<maximum()>|FLTK::Valuator/"maximum">.

=cut

void
fltk::Valuator::range( double min, double max )

=for apidoc |||linesize|double value|

Set the value returned by L<C<linesize()>|FLTK::Valuator/"linesize">, or
restore the default behavior by setting this to zero. Values less than zero or
between zero and the L<C<step()>|FLTK::Valuator/"step"> value produce
undefined results.

=for apidoc ||double value|linesize||

Return the value set for L<C<linesize()>|FLTK::Valuator/"linesize">, or the
calculated value if L<C<linesize()>|FLTK::Valuator/"linesize"> is zero.

The linesize is the amount the valuator moves in response to an arrow key, or
the user clicking an up/down button, or a click of the mouse wheel. If this
has not been set, this will return the maximum of
L<C<step()>|FLTK::Valuator/"step"> and C<1/50> of the range.

=cut

double
fltk::Valuator::linesize( double value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->linesize();
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->linesize(value);

=for apidoc ||double prev|previous_value||

Value saved when L<C<handle_push( )>|FLTK::Valuator/"handle_push"> was last
called.

=cut

double
fltk::Valuator::previous_value( )

=end apidoc

=head1 Subclassing FLTK::Valuator

Should you require a subclass of L<Valuator|FLTK::Valuator>, here are a few
notes to get you started.

=head2 C<handle( )>

The base class C<handle( )> accepts C<FOCUS> and recognizes a number of
keystrokes that adjust the value. Your subclass can call this to get these
keystrokes, it can also do it's own keystroke handling if it wants.

=over

=item * DownKey, LeftKey: move 1
L<C<linesize()>|FLTK::Valuator/"linesize"> toward
L<C<minimum()>|FLTK::Valuator/"minimum">

=item * (Ctrl|Shift|Alt|Meta)+DownKey, LeftKey: move 10
L<C<linesize()>|FLTK::Valuator/"linesize"> toward
L<C<minimum()>|FLTK::Valuator/"minimum">

=item * UpKey, RightKey: move 1 L<C<linesize()>|FLTK::Valuator/"linesize">
toward L<C<minimum()>|FLTK::Valuator/"minimum">

=item * (Ctrl|Shift|Alt|Meta)+UpKey, RightKey: move 10
L<C<linesize()>|FLTK::Valuator/"linesize"> toward
L<C<minimum()>|FLTK::Valuator/"minimum">

=item * HomeKey: set to L<C<minimum()>|FLTK::Valuator/"minimum">

=item * EndKey: set to L<C<maximum()>|FLTK::Valuator/"maximum">

=item * Mousewheel: For normal valuators, each click is
L<C<linesize()>|FLTK::Valuator/"linesize">,
L<Style::wheel_scroll_lines|FLTK::Style/"wheel_scroll_lines"> is ignored.
However L<Scrollbar|FLTK::Scrollbar> does use
L<Style::wheel_scroll_lines|FLTK::Style/"wheel_scroll_lines">.

=back

=head2 C<format( $buffer )>

C<format( )> prints the current value into the passed buffer as a
user-readable and editable string. Returns the number of bytes (not counting
the terminating C<\0>) written to the buffer. Calling code can assumme that
the written string is never longer than 20 characters.

This is used by subclasses that let the user edit the value in a textfield.
Since this is a virtual function, you can override this in a subclass of those
and change how the numbers are displayed.

The default version prints enough digits for the current
L<C<step()>|FLTK::Valuator/"step"> value. If
L<C<step()>|FLTK::Valuator/"step"> is zero it does a C<%%g> format. If step
is an integer it does C<%%d> format. Otherwise it does a C<%.nf> format where
C<n> is enough digits to show the step, maximum of 8.

=head2 C<value_damage( )>

Subclasses must implement this. It is called whenever the
L<C<value()>|FLTK::Valuator/"value"> changes. They must call
L<C<redraw()>|FLTK::Widget/"redraw"> if necessary.

=head2 C<handle_push( )>

Subclasses should call this when the user starts to change the value.

=head2 C<handle_drag( $value )>

Subclasses should call this as the user moves the value. The passed number is
an arbitrary-precision value you want to set it to, this function clamps it to
the range (if L<C<previous_value()>|FLTK::Valuator/"previous_value"> is in
range) and rounds it to the nearest multiple of
L<C<step()>|FLTK::Valuator/"step">, and then stores it into
L<C<value()>|FLTK::Widget/"value">. It then does the
L<C<callback()>|FLTK::Widget/"callback"> if necessary.

=head2 C<handle_release( )>

Subclasses should call this when the user stops moving the value. It may call
the callback.

=cut

#INCLUDE: Dial.xsi

#INCLUDE: Slider.xsi

#INCLUDE: ValueInput.xsi

#endif // ifndef DISABLE_VALUATOR

BOOT:
    isa( "FLTK::Valuator", "FLTK::Widget" );
