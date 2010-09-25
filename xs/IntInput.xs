#include "include/FLTK_pm.h"

MODULE = FLTK::IntInput               PACKAGE = FLTK::IntInput

#ifndef DISABLE_INTINPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

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

#include "include/WidgetSubclass.h"

void
IntInput::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::IntInput>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_INTINPUT

BOOT:
    isa("FLTK::IntInput", "FLTK::FloatInput");
