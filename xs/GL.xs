#include "include/FLTK_pm.h"

MODULE = FLTK::GL               PACKAGE = FLTK::GL

#ifndef DISABLE_GL

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::GL - Portable OpenGL

=head1 Description



=begin apidoc

=cut

#include <fltk/gl.h>

=for apidoc T[gl]|G||glstart|||



=for apidoc T[gl]|G||glfinish|||



=cut

MODULE = FLTK::GL               PACKAGE = FLTK

void
glstart( )
    CODE:
        fltk::glstart( );

void
glfinish( )
    CODE:
        fltk::glfinish( );

BOOT:
    export_tag("glstart",  "gl");
    export_tag("glfinish", "gl");

MODULE = FLTK::GL               PACKAGE = FLTK::GL

=for apidoc T[gl]|G||glsetcolor|FLTK::Color color|



=cut

MODULE = FLTK::GL               PACKAGE = FLTK

void
glsetcolor( fltk::Color color )
    CODE:
        fltk::glsetcolor( color );

BOOT:
    export_tag("glsetcolor", "gl");

MODULE = FLTK::GL               PACKAGE = FLTK::GL

=for apidoc T[gl]|G||glstrokerect|int x|int y|int w|int h|



=for apidoc T[gl]|G||glfillrect|int x|int y|int w|int h|



=cut

MODULE = FLTK::GL               PACKAGE = FLTK

void
glstrokerect( int x, int y, int w, int h )
    CODE:
        fltk::glstrokerect( x, y, w, h );

void
glfillrect ( int x, int y, int w, int h )
    CODE:
        fltk::glfillrect ( x, y, w, h );

BOOT:
    export_tag("glstrokerect", "gl");
    export_tag("glfillrect",   "gl");

MODULE = FLTK::GL               PACKAGE = FLTK::GL

=for apidoc T[gl]|G||glsetfont|FLTK::Font * font|float size|



=cut

MODULE = FLTK::GL               PACKAGE = FLTK

void
glsetfont( fltk::Font * f, float size )
    CODE:
        fltk::glsetfont( f, size );

BOOT:
    export_tag("glsetfont", "gl");

MODULE = FLTK::GL               PACKAGE = FLTK::GL

=for apidoc T[gl]|G||glgetascent||



=for apidoc T[gl]|G||glgetdescent||



=cut

MODULE = FLTK::GL               PACKAGE = FLTK

float
glgetascent( )
    CODE:
        RETVAL = fltk::glgetascent( );
    OUTPUT:
        RETVAL

float
glgetdescent( )
    CODE:
        RETVAL = fltk::glgetdescent( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("glgetascent",  "gl");
    export_tag("glgetdescent", "gl");

MODULE = FLTK::GL               PACKAGE = FLTK::GL

=for apidoc T[gl]|G|float width|glgetwidth|char * string|



=for apidoc T[gl]|G|float width|glgetwidth|char * string|int length|



=cut

MODULE = FLTK::GL               PACKAGE = FLTK

float
glgetwidth( char * string, int length = NO_INIT )
    CODE:
        if ( items == 1 )
            RETVAL = fltk::glgetwidth( string );
        else
            RETVAL = fltk::glgetwidth( string, length );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("glgetwidth", "gl");

MODULE = FLTK::GL               PACKAGE = FLTK::GL

=for apidoc T[gl]|G||gldrawtext||||



=end apidoc

=cut

MODULE = FLTK::GL               PACKAGE = FLTK

void
gldrawtext( char * string, float x = NO_INIT, float y = NO_INIT, float z = 0 )
    CODE:
        if ( items == 1 )
            fltk::gldrawtext( string /* NOTE: n (length) is not supported */ );
        else if ( items >= 3 )
            fltk::gldrawtext( string, /* NOTE: n (length) is not supported */ x, y, z );

BOOT:
    export_tag("gldrawtext", "gl");

MODULE = FLTK::GL               PACKAGE = FLTK::GL

=for apidoc T[gl]|G||gldrawimage|uchar * data|int x|int y|int w|int h|int d = 3|int ld = 0|



=cut

MODULE = FLTK::GL               PACKAGE = FLTK

void
gldrawimage( uchar * data, int x, int y, int w, int h, int d = 3, int ld = 0 )
    CODE:
        fltk::gldrawimage( data, x, y, w, h, d, ld );

BOOT:
    export_tag("gldrawimage", "gl");

#endif // ifndef DISABLE_GL
