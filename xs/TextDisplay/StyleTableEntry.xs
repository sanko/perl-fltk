#include "../include/FLTK_pm.h"

MODULE = FLTK::TextDisplay::StyleTableEntry               PACKAGE = FLTK::TextDisplay::StyleTableEntry

#ifndef DISABLE_TEXTDISPLAY_STYLETABLEENTRY

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::TextDisplay::StyleTableEntry -

=head1 Description

TODO

=begin apidoc

=cut

#include <fltk/TextDisplay.h>

=for apidoc ||FLTK::TextDisplay::StyleTableEntry self|new||


=cut

fltk::TextDisplay::StyleTableEntry *
fltk::TextDisplay::StyleTableEntry::new( )

=for apidoc |||destroy||

Destroy the object.

=cut

void
fltk::TextDisplay::StyleTableEntry::destroy( )
    CODE:
        delete THIS;
        sv_setsv(ST(0), &PL_sv_undef);

=for apidoc |||color|FLTK::Color color|



=for apidoc ||FLTK::Color color|color||



=cut

fltk::Color
fltk::TextDisplay::StyleTableEntry::color( fltk::Color color = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->color = color;
        OUTPUT:
    CASE:
        CODE:
            RETVAL = THIS->color;
        OUTPUT:
            RETVAL

=for apidoc |||font|FLTK::Font * color|



=for apidoc ||FLTK::Font * font|font||



=cut

fltk::Font *
fltk::TextDisplay::StyleTableEntry::font( fltk::Font * font = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->font = font;
        OUTPUT:
    CASE:
        CODE:
            RETVAL = THIS->font;
        OUTPUT:
            RETVAL

=for apidoc |||size|double size|



=for apidoc ||double size|size||



=cut

double
fltk::TextDisplay::StyleTableEntry::size( double size = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->size = size;
        OUTPUT:
    CASE:
        CODE:
            RETVAL = THIS->size;
        OUTPUT:
            RETVAL

=for apidoc |||attr|unsigned attr|



=for apidoc ||unsigned attr|attr||



=cut

unsigned
fltk::TextDisplay::StyleTableEntry::attr( unsigned attr = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->attr = attr;
        OUTPUT:
    CASE:
        CODE:
            RETVAL = THIS->attr;
        OUTPUT:
            RETVAL

#endif // ifndef DISABLE_TEXTDISPLAY_STYLETABLEENTRY
