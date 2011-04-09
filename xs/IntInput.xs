#include "include/FLTK_pm.h"

MODULE = FLTK::IntInput               PACKAGE = FLTK::IntInput

#ifndef DISABLE_INTINPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::IntInput - Input box which accepts only numeric input

=head1 Description



=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/IntInput.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=begin apidoc

=for apidoc ||FLTK::IntInput int|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::IntInput> object. Obviously.

=cut

#include "include/RectangleSubclass.h"

fltk::IntInput *
fltk::IntInput::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::IntInput>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_INTINPUT

BOOT:
    isa("FLTK::IntInput", "FLTK::FloatInput");
