#include "include/FLTK_pm.h"

MODULE = FLTK::NumericInput               PACKAGE = FLTK::NumericInput

#ifndef DISABLE_NUMERICINPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::NumericInput - One-line text input field for basic math and numeric expressions

=head1 Description

The L<NumericInput|FLTK::NumericInput> class is a subclass of
L<FLTK::Input|FLTK::Input> that redefines the up and down arrow keys to
increment and decrement the digit of the number to the right of the cursor.
This makes it very easy to edit numbers.

If you change L<C<when( )>|FLTK::Widget/"when"> to C<WHEN_ENTER_KEY>, the
callback is only done when the user hits the up/down arrow keys or when the
user types the C<Enter> key. This may be more useful than the default setting
of C<WHEN_CHANGED> which can make the callback happen when partially-edited
numbers are in the field.

This version lets the user type any text into the field. This is useful if you
run the text through an expression parser so the user can type in math
expressions. However if you want to limit the input to text that can be run
through C<strtol()> or C<strtod()> you should use the subclasses
L<IntInput|FLTK::IntInput> or L<FloatInput|FLTK::FloatInput>.

When you construct the widget the text starts out blank. You may want to set
it with L<C<value( 0 )>|FLTK::NumericInput/"value"> or something.

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/NumericInput.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::NumericInput input|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::NumericInput> object.

=cut

#include "include/RectangleSubclass.h"

fltk::NumericInput *
fltk::NumericInput::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::NumericInput>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc |||value|double val|

Correctly formats C<$val> and uses the result to set the string value.

=for apidoc ||char * val|value||

Returns the value. Duh.

=cut

char *
fltk::NumericInput::value( val = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = ( char * ) ( ( fltk::Input * ) THIS )->value( );
        OUTPUT:
            RETVAL
    CASE: ( items == 2 ) && ( SvIOK( ST( 1 ) ) )
        int val
        CODE:
            THIS->value( val );
    CASE: ( items == 2 ) && ( SvNOK( ST( 1 ) ) )
        double val
        CODE:
            THIS->value( val );

#INCLUDE: FloatInput.xsi

#endif // ifndef DISABLE_NUMERICINPUT

BOOT:
    isa("FLTK::NumericInput", "FLTK::Input");
