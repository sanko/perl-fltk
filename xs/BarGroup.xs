#include "include/FLTK_pm.h"

MODULE = FLTK::BarGroup               PACKAGE = FLTK::BarGroup

#ifndef DISABLE_BARGROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::BarGroup - A closable strip typically used as a container for toolbars

=head1 Description

The L<BarGroup|FLTK::BarGroup> is a closable strip that can be put in the
edges of a L<Pack|FLTK::Pack>, usually it contains toolbars or buttons.

Based on Frametab V2 contributed by Curtis Edwards (curt1@trilec.com)

=begin apidoc

=cut

#include <fltk/BarGroup.h>

=for apidoc ||FLTK::BarGroup self|new|int x|int y|int w|int h|char * label = ''|bool begin = 0|

Creates a new C<FLTK::BarGroup> object.

=cut

#include "include/WidgetSubclass.h"

void
fltk::BarGroup::new ( int x, int y, int w, int h, char * label = 0, bool begin = false )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::BarGroup>(CLASS,x,y,w,h,label,begin);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::BarGroup::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=for apidoc |||layout||



=cut

void
fltk::BarGroup::layout( )

=for apidoc ||bool is_it|opened||



=for apidoc ||bool is_it|opened|bool value|



=cut

bool
fltk::BarGroup::opened( bool value = NO_INIT )
    CASE: items == 1
        C_ARGS:
     CASE:
        C_ARGS: value

=for apidoc ||bool is_open|open||



=for apidoc ||bool is_closed|close||


=cut

bool
fltk::BarGroup::open( )

bool
fltk::BarGroup::close( )

=for apidoc ||int size|glyph_size||



=for apidoc |||glyph_size|int size|



=end apidoc

=cut

int
fltk::BarGroup::glyph_size( int value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->glyph_size( );
    CASE:
        CODE:
            THIS->glyph_size( value );

#endif // ifndef DISABLE_BARGROUP

BOOT:
    isa("FLTK::BarGroup", "FLTK::Group");
