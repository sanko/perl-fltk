#include "include/FLTK_pm.h"

MODULE = FLTK::FlatBox               PACKAGE = FLTK::FlatBox

#ifndef DISABLE_FLATBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::FlatBox - Box drawing code for the Fast Light Tool Kit (FLTK)

=head1 Description

Draws a rectangle filled with L<C<getbgcolor()>|/"getbgcolor">. This is a
useful base class for some box types.

=begin apidoc

=cut

#include <fltk/Box.h>

=for apidoc ||FLTK::FlatBox box|new|char * name|

Creates a new C<FLTK::FlatBox> object.


=cut

#include "include/WidgetSubclass.h"

void
fltk::FlatBox::new( char * name )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::FlatBox>(CLASS,name);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc |||_draw|FLTK::Rectangle * rect|



=cut

void
fltk::FlatBox::_draw( fltk::Rectangle * rect )
    C_ARGS: * rect

=for apidoc ||bool eh|fills_rectangle||



=for apidoc ||bool eh|is_frame||



=cut

bool
fltk::FlatBox::fills_rectangle(  )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->fills_rectangle( ); break;
            case 1: RETVAL = THIS->is_frame( ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        is_frame = 1

#INCLUDE: HighlightBox.xsi

#endif // #ifndef DISABLE_FLATBOX

BOOT:
    isa("FLTK::FlatBox", "FLTK::Box");
