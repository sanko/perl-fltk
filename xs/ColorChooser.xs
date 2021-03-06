#include "include/FLTK_pm.h"

MODULE = FLTK::ColorChooser               PACKAGE = FLTK::ColorChooser

#ifndef DISABLE_COLORCHOOSER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ColorChooser - Color chooser for the Fast Light Tool Kit

=head1 Description

The color chooser object and the color chooser popup.  The popup is just a
window containing a single color chooser and some boxes to indicate the
current and cancelled color.

=begin apidoc

=cut

#include <fltk/ColorChooser.h>

=for apidoc ||FLTK::ColorChooser self|new|int x|int y|int w|int h|char * label = ''|



=cut

#include "include/RectangleSubclass.h"

fltk::ColorChooser *
fltk::ColorChooser::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ColorChooser>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||double hue|h||



=for apidoc ||double saturation|s||



=for apidoc ||double v|v||



=for apidoc ||double red|r||



=for apidoc ||double green|g||



=for apidoc ||double blue|b||



=cut

double
fltk::ColorChooser::h( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = THIS->h( ); break;
            case 1: RETVAL = THIS->s( ); break;
            case 2: RETVAL = THIS->v( ); break;
            case 3: RETVAL = THIS->r( ); break;
            case 4: RETVAL = THIS->g( ); break;
            case 5: RETVAL = THIS->b( ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        s = 1
        v = 2
        r = 3
        g = 4
        b = 5

=for apidoc ||bool no_val|no_value||



=for apidoc ||bool no_val|no_value|bool value|



=cut

bool
fltk::ColorChooser::no_value ( bool value = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        OUTPUT:
            RETVAL

=for apidoc ||FLTK::Color color|value||



=for apidoc ||bool val|value|FLTK::Color color|



=cut

int
fltk::ColorChooser::value( fltk::Color color = NO_INIT )
    PPCODE:
        if ( items == 1 ) {
            fltk::Color RETVAL = THIS->value( );
            XSprePUSH; PUSHi((IV)RETVAL);
        }
        else if ( items == 2 ) {
            bool RETVAL = THIS->value( color );
            ST(0) = boolSV(RETVAL);
            sv_2mortal(ST(0));
        }
        XSRETURN(1);

=for apidoc ||bool set|hsv|float h|float s|float v|



=cut

bool
fltk::ColorChooser::hsv( float h, float s, float v )

=for apidoc ||bool set|rgb|float r|float g|float b|



=cut

bool
fltk::ColorChooser::rgb( float r, float g, float b )

=for apidoc ||double alpha|a||



=for apidoc ||bool set|a|float alpha|



=cut

double
fltk::ColorChooser::a( float a = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        C_ARGS: a

=for apidoc |||hide_a||



=for apidoc |||hide_no_value||



=cut

void
fltk::ColorChooser::hide_a( )
    CODE:
        switch( ix ) {
            case 0: THIS->hide_a( );        break;
            case 1: THIS->hide_no_value( ); break;
        }
    ALIAS:
        hide_no_value = 1

=for apidoc ||AV * rbg|hsv2rgb|float h|float s|float v|



=cut

void
fltk::ColorChooser::hsv2rgb( float h, float s, float v, OUTLIST float r, OUTLIST float g, OUTLIST float b )
    C_ARGS: h, s, v, r, g, b

=for apidoc ||AV * hsv|rgb2hsv|float r|float g|float b|



=cut

void
fltk::ColorChooser::rgb2hsv( float r, float g, float b, OUTLIST float h, OUTLIST float s, OUTLIST float v )
    C_ARGS: r, g, b, h, s, v

=for apidoc |||layout||



=cut

void
fltk::ColorChooser::layout( )

=for apidoc ||bool okay|color_chooser|char * name|float r|float g|float b|

L<C<FLTK::color_chooser()>|/"color_chooser"> pops up a window to let the user
pick an arbitrary RGB color. They can pick the hue and saturation in the "hue
box" on the left (hold down C<CTRL> to just change the saturation), and the
brighness using the vertical slider. Or they can type the 8-bit numbers into
the RGB L<FLTK::ValueInput|FLTK::ValueInput> fields, or drag the mouse across
them to adjust them. The pull-down menu lets the user set the input fields to
show RGB, HSV, or 8-bit RGB (0 to 255).

This returns non-zero if the user picks ok, and updates the RGB values. If the
user picks cancel or closes the window this returns zero and leaves RGB
unchanged.

This version takes and returns numbers in the 0-1 range.

If you which to embed a color chooser into another control panel, use an
L<FLTK::ColorChooser|FLTK::ColorChooser/"new"> object.

=for apidoc ||bool okay|color_chooser|char * name|float r|float g|float b|float a|

Same but user can also select an alpha value. Currently the color chips do not
remember or set the alpha!

=for apidoc ||bool okay|color_chooser|char * name|FLTK::Color color|

Same but it takes and returns an L<FLTK::Color|FLTK::Color> number. No alpha.

=cut

bool
color_chooser ( const char * name, r, g = 0, b = 0, a = 0 )
    CASE: items == 2
        fltk::Color r;
        CODE:
            RETVAL = fltk::color_chooser( name, r );
        OUTPUT:
            RETVAL
            r
    CASE: items == 4 && SvPOK(ST(1)) && SvPOK(ST(2)) && SvPOK(ST(3))
        uchar r;
        uchar g;
        uchar b;
        CODE:
            RETVAL = fltk::color_chooser( name, r, g, b );
        OUTPUT:
            RETVAL
            r
            g
            b
    CASE: items == 5 && SvPOK(ST(1)) && SvPOK(ST(2)) && SvPOK(ST(3)) && SvPOK(ST(4))
        uchar r;
        uchar g;
        uchar b;
        uchar a;
        CODE:
            RETVAL = fltk::color_chooser( name, r, g, b, a );
        OUTPUT:
            RETVAL
            r
            g
            b
            a
    CASE: items == 4 && SvNOK(ST(1)) && SvNOK(ST(2)) && SvNOK(ST(3))
        float r;
        float g;
        float b;
        CODE:
            RETVAL = fltk::color_chooser( name, r, g, b );
        OUTPUT:
            RETVAL
            r
            g
            b
    CASE: items == 5 && SvNOK(ST(1)) && SvNOK(ST(2)) && SvNOK(ST(3)) && SvNOK(ST(4))
        float r;
        float g;
        float b;
        float a;
        CODE:
            RETVAL = fltk::color_chooser( name, r, g, b, a );
        OUTPUT:
            RETVAL
            r
            g
            b
            a

#endif // #ifndef DISABLE_COLORCHOOSER

BOOT:
    isa("FLTK::ColorChooser", "FLTK::Group");
