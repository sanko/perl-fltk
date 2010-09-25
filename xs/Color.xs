#include "include/FLTK_pm.h"

MODULE = FLTK::Color               PACKAGE = FLTK::Color

#ifndef DISABLE_COLOR

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::Color - A color value (Wow, yeah, I know...)

=head1 Description

L<FLTK::Color|FLTK::Color> is a typedef for a 32-bit integer containing r,g,b
bytes and an "index" in the lowest byte (the I<first> byte on a
little-endian machine such as an x86).  For instance C<0xFF008000> is 255 red,
zero green, and 128 blue. If rgb are not zero then the low byte is ignored, or
may be treated as "alpha" by some code.

If the rgb is zero, the N is the color "index". This index is used to look up
an L<FLTK::Color|FLTK::Color> in an internal table of 255 colors shown here.
All the indexed colors may be changed by using
L<C<set_color_index()>|/"set_color_index">.  However FLTK uses the ones
between 32 and 255 and assummes they are not changed from their default
values.

A Color of zero (L<C<FLTK::NO_COLOR>|FLTK::Color/"NO_COLOR">) will draw black
but is ambiguous. It is returned as an error value or to indicate portions of
a L<Style|FLTK::Style> that should be inherited, and it is also used as the
default label color for everything so that changing color zero can be used by
the C<-fg> switch. You should use L<C<FLTK::BLACK>|FLTK::Color/"BLACK"> (56)
to get black.

=head1 Functions

Symbolic names for some of the indexed colors.

The 24-entry "gray ramp" is modified by
L<C<FLTK::set_background()>|FLTK/"set_background"> so that the color
C<FLTK::GRAY75> is the background color, and the others are a nice range from
black to a lighter version of the gray. These are used to draw box edges. The
gray levels are chosen to be evenly spaced, listed here is the actual 8-bit
and decimal gray level assigned by default.  Also listed here is the letter
used for L<FLTK::FrameBox|FLTK::FrameBox> and the old fltk1.1 names used for
these levels.

The remiander of the colormap is a C<5x8x5> color cube. This cube is used to
dither images on 8-bit screens X colormaps to reduce the number of colors
used.

=begin apidoc

=cut

#include <fltk/Color.h>

=for apidoc T[color]UE||int c|NO_COLOR||

Black, empty place holder in Style

=for apidoc T[color]UE||int c|FREE_COLOR|

Starting from index 16 is the FREE_COLOR area

=for apidoc T[color]UE||int c|NUM_FREE_COLOR|

Number of free color slots starting from index FREE_COLOR

=for apidoc T[color]UE||int c|GRAY00|

hex=00, dec=.00, framebox=A, fltk1 = GRAY0, GRAY_RAMP

=for apidoc T[color]UE||int c|GRAY05|

hex=0d, dec=.05, framebox=B

=for apidoc T[color]UE||int c|GRAY10|

hex=1a, dec=.10, framebox=C

=for apidoc T[color]UE||int c|GRAY15|

hex=27, dec=.15, framebox=D

=for apidoc T[color]UE||int c|GRAY20|

hex=34, dec=.20, framebox=E

=for apidoc T[color]UE||int c|GRAY25|

hex=41, dec=.25, framebox=F

=for apidoc T[color]UE||int c|GRAY30|

hex=4f, dec=.31, framebox=G

=for apidoc T[color]UE||int c|GRAY33|

hex=5c, dec=.36, framebox=H, fltk1 = DARK3

=for apidoc T[color]UE||int c|GRAY35|

hex=69, dec=.41, framebox=I

=for apidoc T[color]UE||int c|GRAY40|

hex=76, dec=.46, framebox=J (18%% gray card)

=for apidoc T[color]UE||int c|GRAY45|

hex=83, dec=.51, framebox=K

=for apidoc T[color]UE||int c|GRAY50|

hex=90, dec=.56, framebox=L

=for apidoc T[color]UE||int c|GRAY55|

hex=9e, dec=.62, framebox=M

=for apidoc T[color]UE||int c|GRAY60|

hex=ab, dec=.67, framebox=N, fltk1 = DARK2

=for apidoc T[color]UE||int c|GRAY65|

hex=b8, dec=.72, framebox=O

=for apidoc T[color]UE||int c|GRAY66||

hex=c5, dec=.77, framebox=P, fltk1 = DARK1, INACTIVE_COLOR

=for apidoc T[color]UE||int c|GRAY70||

hex=d2, dec=.82, framebox=Q

=for apidoc T[color]UE||int c|GRAY75||

hex=e0, dec=.88, framebox=R, fltk1 = GRAY, SELECTION_COLOR

=for apidoc T[color]UE||int c|GRAY80||

hex=e5, dec=.90, framebox=S

=for apidoc T[color]UE||int c|GRAY85||

hex=ea, dec=.92, framebox=T, fltk1 = LIGHT1

=for apidoc T[color]UE||int c|GRAY90||

hex=f4, dec=.96, framebox=V, fltk1 = LIGHT2

=for apidoc T[color]UE||int c|GRAY95||

hex=f9, dec=.98, framebox=W

=for apidoc T[color]UE||int c|GRAY99||

hex=ff, dec=1.0, framebox=X, fltk1 = LIGHT3

=for apidoc T[color]UE||int c|BLACK||

Corner of color cube

=for apidoc T[color]UE||int c|RED||

Corner of color cube

=for apidoc T[color]UE||int c|GREEN||

Corner of color cube

=for apidoc T[color]UE||int c|YELLOW||

Corner of color cube

=for apidoc T[color]UE||int c|BLUE||

Corner of color cube

=for apidoc T[color]UE||int c|MAGENTA||

Corner of color cube

=for apidoc T[color]UE||int c|CYAN||

Corner of color cube

=for apidoc T[color]UE||int c|WHITE||

Corner of color cube

=for apidoc T[color]UE||int c|DARK_RED||



=for apidoc T[color]UE||int c|DARK_GREEN||



=for apidoc T[color]UE||int c|DARK_YELLOW||



=for apidoc T[color]UE||int c|DARK_BLUE||



=for apidoc T[color]UE||int c|DARK_MAGENTA||



=for apidoc T[color]UE||int c|DARK_CYAN||



=for apidoc T[color]UE||int c|WINDOWS_BLUE||

Default selection_color

=cut

BOOT:
    register_constant( "NO_COLOR", newSViv( fltk::NO_COLOR ));
    export_tag("NO_COLOR", "color");
    register_constant( "FREE_COLOR", newSViv( fltk::FREE_COLOR ));
    export_tag("FREE_COLOR", "color");
    register_constant( "NUM_FREE_COLOR", newSViv( fltk::NUM_FREE_COLOR ));
    export_tag("NUM_FREE_COLOR", "color");
    register_constant( "GRAY00", newSViv( fltk::GRAY00 ));
    export_tag("GRAY00", "color");
    register_constant( "GRAY05", newSViv( fltk::GRAY05 ));
    export_tag("GRAY05", "color");
    register_constant( "GRAY10", newSViv( fltk::GRAY10 ));
    export_tag("GRAY10", "color");
    register_constant( "GRAY15", newSViv( fltk::GRAY15 ));
    export_tag("GRAY15", "color");
    register_constant( "GRAY20", newSViv( fltk::GRAY20 ));
    export_tag("GRAY20", "color");
    register_constant( "GRAY25", newSViv( fltk::GRAY25 ));
    export_tag("GRAY25", "color");
    register_constant( "GRAY30", newSViv( fltk::GRAY30 ));
    export_tag("GRAY30", "color");
    register_constant( "GRAY33", newSViv( fltk::GRAY33 ));
    export_tag("GRAY33", "color");
    register_constant( "GRAY35", newSViv( fltk::GRAY35 ));
    export_tag("GRAY35", "color");
    register_constant( "GRAY40", newSViv( fltk::GRAY40 ));
    export_tag("GRAY40", "color");
    register_constant( "GRAY45", newSViv( fltk::GRAY45 ));
    export_tag("GRAY45", "color");
    register_constant( "GRAY50", newSViv( fltk::GRAY50 ));
    export_tag("GRAY50", "color");
    register_constant( "GRAY55", newSViv( fltk::GRAY55 ));
    export_tag("GRAY55", "color");
    register_constant( "GRAY60", newSViv( fltk::GRAY60 ));
    export_tag("GRAY60", "color");
    register_constant( "GRAY65", newSViv( fltk::GRAY65 ));
    export_tag("GRAY65", "color");
    register_constant( "GRAY66", newSViv( fltk::GRAY66 ));
    export_tag("GRAY66", "color");
    register_constant( "GRAY70", newSViv( fltk::GRAY70 ));
    export_tag("GRAY70", "color");
    register_constant( "GRAY75", newSViv( fltk::GRAY75 ));
    export_tag("GRAY75", "color");
    register_constant( "GRAY80", newSViv( fltk::GRAY80 ));
    export_tag("GRAY80", "color");
    register_constant( "GRAY85", newSViv( fltk::GRAY85 ));
    export_tag("GRAY85", "color");
    register_constant( "GRAY90", newSViv( fltk::GRAY90 ));
    export_tag("GRAY90", "color");
    register_constant( "GRAY95", newSViv( fltk::GRAY95 ));
    export_tag("GRAY95", "color");
    register_constant( "GRAY99", newSViv( fltk::GRAY99 ));
    export_tag("GRAY99", "color");
    register_constant( "BLACK", newSViv( fltk::BLACK ));
    export_tag("BLACK", "color");
    register_constant( "RED", newSViv( fltk::RED ));
    export_tag("RED", "color");
    register_constant( "GREEN", newSViv( fltk::GREEN ));
    export_tag("GREEN", "color");
    register_constant( "YELLOW", newSViv( fltk::YELLOW ));
    export_tag("YELLOW", "color");
    register_constant( "BLUE", newSViv( fltk::BLUE ));
    export_tag("BLUE", "color");
    register_constant( "MAGENTA", newSViv( fltk::MAGENTA ));
    export_tag("MAGENTA", "color");
    register_constant( "CYAN", newSViv( fltk::CYAN ));
    export_tag("CYAN", "color");
    register_constant( "WHITE", newSViv( fltk::WHITE ));
    export_tag("WHITE", "color");
    register_constant( "DARK_RED", newSViv( fltk::DARK_RED ));
    export_tag("DARK_RED", "color");
    register_constant( "DARK_GREEN", newSViv( fltk::DARK_GREEN ));
    export_tag("DARK_GREEN", "color");
    register_constant( "DARK_YELLOW", newSViv( fltk::DARK_YELLOW ));
    export_tag("DARK_YELLOW", "color");
    register_constant( "DARK_BLUE", newSViv( fltk::DARK_BLUE ));
    export_tag("DARK_BLUE", "color");
    register_constant( "DARK_MAGENTA", newSViv( fltk::DARK_MAGENTA ));
    export_tag("DARK_MAGENTA", "color");
    register_constant( "DARK_CYAN", newSViv( fltk::DARK_CYAN ));
    export_tag("DARK_CYAN", "color");
    register_constant( "WINDOWS_BLUE", newSViv( fltk::WINDOWS_BLUE ));
    export_tag("WINDOWS_BLUE", "color");

=for apidoc T[color]||FLTK::Color c|color|char * name|

Turn a string into a color. If C<name> is C<undef>, this returns
L<C<NO_COLOR>|/"NO_COLOR">. Otherwise it returns
L<C<FLTK::parsecolor(name, strlen(name))>|FLTK/"parsecolor">.

=for apidoc T[color]||FLTK::Color c|color|int r|int g|int b|



=cut

MODULE = FLTK::Color               PACKAGE = FLTK

fltk::Color
color ( name = 0, g = NO_INIT, b = NO_INIT )
    CASE: items == 3
        int name
        int g
        int b
        CODE:
            RETVAL = fltk::color( name, g, b );
        OUTPUT:
            RETVAL
    CASE:
        char * name
        CODE:
            RETVAL = fltk::color( name );
        OUTPUT:
            RETVAL

BOOT:
    export_tag("color", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]||FLTK::Color color|parsecolor|char * name|int length|

Same as the other one.

=for apidoc T[color]||FLTK::Color color|parsecolor|char * name|

Turn the first C<n> bytes of C<name> into an FLTK color. This allows you to
parse a color out of the middle of a string.

Recognized values are:

=over

=item * "" turns into NO_COLOR

=item * "0"-"99" decimal fltk color number, only works for indexed color range

=item * "0xnnn" hex value of any fltk color number

=item * "rgb" or "#rgb" three hex digits for rgb

=item * "rrggbb" or "#rrggbb" 2 hex digits for each of rgb

=item * "rrggbbaa" or "#rrggbbaa" fltk color number in hex

=item * "rrrgggbbb" or "#rrrgggbbb" 3 hex digits for each of rgb

=item * "rrrrggggbbbb" or "#rrrrggggbbbb" 4 hex digits for each of rgb

=item * 17 "web safe colors" as defined by CSS 2.1

=item * If FLTK is compiled to use X11, then XParseColor() is tried

=item * all other strings return NO_COLOR.

=back

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

fltk::Color
parsecolor ( char * name, unsigned length = strlen(name) )
    CODE:
        RETVAL = fltk::parsecolor( name, length );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("parsecolor", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]||FLTK::Color color|lerp|FLTK::Color color1|FLTK::Color color2|float weight|

Return C<(1-weight)*color1 + weight*color2>. C<weight> is clamped to the 0-1
range before use.

=for hackers Found in F<src/setcolor.cxx>

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

fltk::Color
lerp ( fltk::Color color1, fltk::Color color2, float weight )
    CODE:
        RETVAL = fltk::lerp( color1, color2, weight );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("lerp", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]||FLTK::Color color|inactive|FLTK::Color fore|FLTK::Color back|

Same as L<C<lerp(fg, bg, .5)>|/"lerp">, it grays out the color.

=for apidoc T[color]||FLTK::Color color|inactive|FLTK::Color fore|

Same as L<C<lerp(fg, getbgcolor(), .5)>|/"lerp">. This is for
back-compatability only?

=for hackers Found in F<src/setcolor.cxx>

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

fltk::Color
inactive ( fltk::Color fore, fltk::Color back = NO_INIT )
    CASE: items == 2
        CODE:
            RETVAL = fltk::inactive( fore, back );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = fltk::inactive( fore );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("inactive", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]||FLTK::Color color|contrast|FLTK::Color fg|FLTK::Color bg|

Returns C<fg> if fltk decides it can be seen well when drawn against a C<bg>.
Otherwise it returns either L<C<FLTK::BLACK>|FLTK/"BLACK"> or
L<C<fltk::WHITE>|FLTK/"WHITE">.

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

fltk::Color
contrast ( fltk::Color fore, fltk::Color back )
    CODE:
        RETVAL = fltk::contrast( fore, back );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("contrast", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]||AV * rgb|split_color|FLTK::Color color|

Set C<r,g,b> to the 8-bit components of this color. If it is an indexed color
they are looked up in the table, otherwise they are simply copied out of the
color number.

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

void
split_color ( fltk::Color color )
    PPCODE:
        {   unsigned char	r;
            unsigned char	g;
            unsigned char	b;
            fltk::split_color(color, r, g, b);
            XSprePUSH;	EXTEND(SP,3);
            PUSHs(sv_newmortal());
            sv_setuv(ST(0), (UV)r);
            PUSHs(sv_newmortal());
            sv_setuv(ST(1), (UV)g);
            PUSHs(sv_newmortal());
            sv_setuv(ST(2), (UV)b);
        }
        XSRETURN(3);

BOOT:
    export_tag("split_color", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]|||set_color_index|FLTK::Color index|FLTK::Color color|

Set one of the indexed colors to the given rgb color. C<index> must be in the
range 0-255, and C<color> must be a non-indexed rgb color.

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

void
set_color_index ( fltk::Color index, fltk::Color color )
    CODE:
        fltk::set_color_index( index, color );

BOOT:
    export_tag("set_color_index", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]|||get_color_index|FLTK::Color color|

Return the rgb form of C<color>. If it is an indexed color that entry is
returned. If it is an rgb color it is returned unchanged.

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

fltk::Color
get_color_index ( fltk::Color color )
    CODE:
        RETVAL = fltk::get_color_index( color );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("get_color_index", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]|||set_background|FLTK::Color color|

C<FLTK::GRAY75> is replaced with the passed color, and all the other
C<FLTK::GRAY*> colors are replaced with a color ramp (or sometimes a straight
line) so that using them for highlighted edges of raised buttons looks
correct.

=for hackers Found in F<src/Style.cxx>

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

void
set_background ( fltk::Color color )
    CODE:
        fltk::set_background( color );

BOOT:
    export_tag("set_background", "color");

MODULE = FLTK::Color               PACKAGE = FLTK::Color

=for apidoc T[color]||FLTK::Color color|nearest_index|FLTK::Color color|

Find an indexed color in the range 56-127 that is closest to this color. If
this is an indexed color it is returned unchanged.

=cut

MODULE = FLTK::Color               PACKAGE = FLTK

fltk::Color
nearest_index ( fltk::Color color )
    CODE:
        RETVAL = fltk::nearest_index( color );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("nearest_index", "color");

#endif // #ifndef DISABLE_COLOR
