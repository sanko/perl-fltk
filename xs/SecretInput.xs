#include "include/FLTK_pm.h"

MODULE = FLTK::SecretInput               PACKAGE = FLTK::SecretInput

#ifndef DISABLE_SECRETINPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.532006

=head1 NAME

FLTK::SecretInput - Password field

=head1 Description

One-line text input field that draws asterisks instead of the letters. It also
prevents the user from cutting or copying the text and then pasting it
somewhere.

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/SecretInput.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc ||FLTK::SecretInput * self|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<FLTK::SecretInput|FLTK::SecretInput> widget.

=cut

#include "include/RectangleSubclass.h"

fltk::SecretInput *
fltk::SecretInput::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::SecretInput>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_SECRETINPUT

BOOT:
    isa( "FLTK::SecretInput", "FLTK::Input" );
