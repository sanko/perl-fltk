#include "include/FLTK_pm.h"

MODULE = FLTK::FloatInput               PACKAGE = FLTK::FloatInput

#ifndef DISABLE_FLOATINPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::FloatInput - Subclass of FLTK::NumericInput

=head1 Description

A subclass of L<NumericInput|FLTK::NumericInput> that only allows the user to
type floating point numbers (sign, digits, decimal point, more digits, 'E' or
'e', sign, digits), or hex constants that start with "0x". This is done by
overriding the replace() method. Besides editing the text the user can use the
up/down arrow keys to change the digits.

You may want a L<ValueInput|FLTK::ValueInput> widget instead. It has up/down
buttons (what is called a "Spinner" in some toolkits).

If you change L<C<when()>|FLTK::Widget/"when"> to C<WHEN_ENTER_KEY>, the
callback is only done when the user hits the up/down arrow keys or when the
user types the Enter key. This may be more useful than the default setting of
C<WHEN_CHANGED> which can make the callback happen when partially-edited
numbers are in the field.

The L<C<type()>|FLTK::Widget/"type"> can either be either
C<FLTK::FloatInput::FLOAT> or C<FLTK::FloatInput::INT>. Setting it to C<INT>
makes this act like the L<IntInput|FLTK::IntInput> subclass.

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/FloatInput.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::FloatInput input|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::FloatInput> object.

=cut

#include "include/WidgetSubclass.h"

void
fltk::FloatInput::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::FloatInput>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||int int|ivalue||

Convert the string to an integer, using C<int(strtol())>.

=for apidoc ||long long|lvalue()||

Convert the string to a long using C<strtol()>.

=for apidoc ||double float|fvalue()||

Convert the string to a double using C<strtod()>.

=cut

int
fltk::FloatInput::ivalue( )

long
fltk::FloatInput::lvalue( )

double
fltk::FloatInput::fvalue( )

 # I want these under FLTK::FloatInput's namespace

int
FLOAT ( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = fltk::FloatInput::FLOAT; break;
            case 1: RETVAL = fltk::FloatInput::INT;   break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        INT = 1

#endif // ifndef DISABLE_FLOATINPUT

BOOT:
    isa("FLTK::FloatInput", "FLTK::NumericInput");
