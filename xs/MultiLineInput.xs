#include "include/FLTK_pm.h"

MODULE = FLTK::MultiLineInput               PACKAGE = FLTK::MultiLineInput

#ifndef DISABLE_MULTILINEINPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::MultiLineInput - Editor for small number of lines of text

=head1 Description

Allows you to edit a C<small> number of lines of text. Does not have any
scrollbars. You may want a L<TextEditor|FLTK::TextEditor> instead, it is
designed for large amounts of text.

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/MultiLineInput.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::MultiLineInput input|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::MultiLineInput> object.

=cut

#include "include/RectangleSubclass.h"

fltk::MultiLineInput *
fltk::MultiLineInput::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::MultiLineInput>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_MULTILINEINPUT

BOOT:
    isa("FLTK::MultiLineInput", "FLTK::Input");
