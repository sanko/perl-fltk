#include "include/FLTK_pm.h"

MODULE = FLTK::MultiLineOutput               PACKAGE = FLTK::MultiLineOutput

#ifndef DISABLE_MULTILINEOUTPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::MultiLineOutput - Small text display without scrollbars

=head1 Description

Displays a multi-line sequence of text, the user can select text and copy it
to other programs. Does not have any scrollbars.

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/MultiLineOutput.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::MultiLineOutput input|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::MultiLineOutput> object.

=cut

#include "include/WidgetSubclass.h"

void
fltk::MultiLineOutput::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::MultiLineOutput>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_MULTILINEOUTPUT

BOOT:
    isa("FLTK::MultiLineOutput", "FLTK::Output");
