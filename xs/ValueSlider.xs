#include "include/FLTK_pm.h"

MODULE = FLTK::ValueSlider               PACKAGE = FLTK::ValueSlider

#ifndef DISABLE_VALUESLIDER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.532007

=head1 NAME

FLTK::ValueSlider - Slider and FloatInput combo widget

=head1 Description

Controls a single floating point value through a combination of a
L<FloatInput|FLTK::FloatInput> and a L<Slider|FLTK::Slider>.

As this is a subclass of L<Slider|FLTK::Slider>, all slider methods work, for
setting the slider size, tick marks, etc.

The user can type a new value into the input area. If
L<< C<step( )>|FLTK::Slider/"step" >> is greater or equal to C<1.0> an
L<IntInput|FLTK::IntInput> is used, this prevents the user from typing
anything other than digits. If L<< C<step( )>|FLTK::Slider/"step" >> is less
than one, the user can type floating point values with decimal points and
exponents.

The user can type B<any> value they want into the text field, I<<< including
ones outside the L<< C<range( )>|/"range" >> or non-multiples of the
L<< C<step( )>|FLTK::Slider/"step" >> >>>. If you want to prevent this, make
the callback function reset the value to a legal one.

By default the callback is done when the user moves the slider, when they use
up/down keys to change the number in the text, or if they edit the text, when
they hit the C<Enter> key or they click on another widget or put the focus on
another widget. Changing L<< C<when( )>|FLTK::Widget/"when" >>
to C<FLTK::WHEN_CHANGED> will make it do the callback on every edit of the
text.

You can get at the input field by using the public "input" instance variable.
For instance you can clobber the text to a word with
C<< $value_input->input->static_text('word') >>. You can also set the size of
it (call L<< C<layout( )>|/"layout" >> first).

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/ValueSlider.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc ||FLTK::ValueSlider * self|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<FLTK::ValueSlider|FLTK::ValueSlider> widget.

=cut

#include "include/RectangleSubclass.h"

fltk::ValueSlider *
fltk::ValueSlider::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ValueSlider>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=end apidoc

=cut

#endif // ifndef DISABLE_VALUESLIDER

BOOT:
    isa( "FLTK::ValueSlider", "FLTK::Slider" );
