#include "include/FLTK_pm.h"

MODULE = FLTK::FillDial               PACKAGE = FLTK::FillDial

#ifndef DISABLE_FILLDIAL

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::FillDial - Subclass of FLTK::Dial which draws a pie slice

=head1 Description

Dial but the constructor sets L<C<type()>|FLTK::Dial/"type"> to C<FILL>, so it
draws a pie slice.

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/FillDial.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::FillDial fd|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::FillDial> object.

=cut

#include "include/RectangleSubclass.h"

fltk::FillDial *
fltk::FillDial::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::FillDial>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_FILLDIAL

BOOT:
    isa("FLTK::FillDial", "FLTK::Dial");
