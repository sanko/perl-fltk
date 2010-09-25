#include "include/FLTK_pm.h"

MODULE = FLTK::ValueInput               PACKAGE = FLTK::ValueInput

#ifndef DISABLE_VALUEINPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.531

=for git $Id$

=head1 NAME

FLTK::ValueInput - Text field for inputing a floating-point number

=head1 Description

Controls a single floating point value through a combination of a
L<FLTK::FloatInput|FLTK::FloatInput> and two up/down buttons. Other toolkits
call this a "Spin Box".

Clicking the buttons increments/decrements by the
L<C<linesize( )>|FLTK::Valuator/"linesize">. Holding down any shift key and
clicking increments/decrements by the
L<C<pagesize( )>|FLTK::Valuator/"pagesize">.

The user can type a new value into the input area. If
L<C<step( )>|FLTK::Valuator/"step"> is greater or equal to C<1.0> an
L<FLTK::IntInput|FLTK::IntInput> is used, this prevents the user from typing
anything other than digits. If L<C<step( )>|FLTK::Valuator/"step"> is less
than one then the user can type floating point values with decimal points and
exponents.

The user can type I<any> value they want into the text field, I<including ones
outside the L<C<range( )>|FLTK::Valuator/"range"> or non-multiples of the
L<C<step( )>|FLTK::Valuator/"step">>. If you want to prevent this, make the
callback function reset the value to a legal one.

By default the callback is done when the user moves the slider, when they use
up/down keys to change the number in the text, or if they edit the text, when
they hit the Enter key or they click on another widget or put the focus on
another widget. Changing L<C<when()>|FLTK::Widget/"when"> to
C<FLTK::WHEN_CHANGED> will make it do the callback on every edit of the text.

You can get at the input field by using the public "input" instance variable.
For instance you can clobber the text to a word with
C<$value_input-E<gt>input-C<gt>static_text('word')>.

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/ValueInput.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc ||FLTK::ValueInput * input|new|int x|int y|int w|int h|char * label = ''|



=cut

void
fltk::ValueInput::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::ValueInput>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_VALUEINPUT

BOOT:
    isa( "FLTK::ValueInput" , "FLTK::Valuator");
