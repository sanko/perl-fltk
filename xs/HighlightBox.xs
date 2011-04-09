#include "include/FLTK_pm.h"

MODULE = FLTK::HighlightBox               PACKAGE = FLTK::HighlightBox

#ifndef DISABLE_HIGHLIGHTBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::HighlightBox - Draw a box only when highlighted or selected

=head1 Description

Draws nothing normally, this can draw as any other box (passed to the
constructor) when C<HIGHLIGHT>, C<STATE>, or C<PUSHED> is turned on in the
flags. This can be used to make frames appear when the mouse points at widgets
or when the widget is turned on.

=begin apidoc

=cut

#include <fltk/Box.h>

=for apidoc ||FLTK::HighlightBox * box|new|char * name|FLTK::Box * box|

Creates a new C<FLTK::HighlightBox> object.

=cut

fltk::HighlightBox *
fltk::HighlightBox::new( char * name, fltk::Box * down )
    CODE:
        RETVAL = new RectangleSubclass<fltk::HighlightBox>(CLASS,name,down);
    OUTPUT:
        RETVAL

=for apidoc |||_draw|FLTK::Rectangle * rect|



=cut

void
fltk::HighlightBox::_draw( fltk::Rectangle * rect )
    C_ARGS: * rect

=for apidoc ||bool eh|fills_rectangle|



=for apidoc ||bool eh|is_frame|


=end apidoc

=cut

bool
fltk::HighlightBox::fills_rectangle( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->fills_rectangle( ); break;
            case 1: RETVAL = THIS->is_frame( ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        is_frame = 1

#endif // #ifndef DISABLE_HIGHLIGHTBOX

BOOT:
    isa("FLTK::HighlightBox", "FLTK::FlatBox");
