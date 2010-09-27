#include "include/FLTK_pm.h"

MODULE = FLTK::Box               PACKAGE = FLTK::Box

#ifndef DISABLE_BOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Box - Define your own values for L<C<box()>|FLTK::Widget/"box"> on a
widget by making one of these

=head1 Description



=cut

#include <fltk/Box.h>

=for apidoc |||_draw|FLTK::Rectangle * rect|



=cut

void
fltk::Box::_draw( fltk::Rectangle * rect )
    C_ARGS: * rect

#ifndef DISABLE_DEPRECATED

=for apidoc T[box]|||drawframe|char * s|int x|int y|int w|int h|

Draw a spiral, useful as a box edge, starting with the bottom edge and going
in a counter-clockwise direction, from the outside in toward the center. The
string is interpreted to get a gray shade: A is black, X is white, and all
other letters are 24 possible steps of gray shade, and R is the normal
background color of C<GRAY75>. A leading '2' makes it start with the top edge,
which will reverse exactly which pixels are drawn in the corner.

Emulates the fltk1 C<fl_frame2()> function.

=for apidoc T[box]|||drawframe2|char * s|int x|int y|int w|int h|

Draw a spiral similar to L<C<drawframe()>|/"drawframe">, but starts with the
top edge and goes counter-clockwise.

Emulates the fltk1 C<fl_frame()> function.

=cut

MODULE = FLTK::Box               PACKAGE = FLTK

void
drawframe( char * s, int x, int y, int w, int h )
    CODE:
        fltk::drawframe( s, x, y, w, h );

void
drawframe2( char * s, int x, int y, int w, int h )
    CODE:
        fltk::drawframe2( s, x, y, w, h );


BOOT:
    export_tag("drawframe", "box");
    export_tag("drawframe2", "box");

MODULE = FLTK::Box               PACKAGE = FLTK::Box

#endif // #ifndef DISABLE_DEPRECATED

=for apidoc T[box]F||FLTK::Box down|DOWN_BOX||

Inset box in fltk's standard theme.

=for apidoc T[box]F||FLTK::Box flat|FLAT_BOX||

Draws a flat rectangle of L<C<getbgcolor()>|/"getbgcolor">.

=for apidoc T[box]F||FLTK::Box none|NO_BOX||

Draws nothing.

Can be used as a box to make the background of a widget invisible. Also some
widgets check specifically for this and change their behavior or drawing
methods.

=for apidoc T[box]F||FLTK::Box up|UP_BOX||

Up button in fltk's standard theme.

=for apidoc T[box]F||FLTK::Box down|THIN_DOWN_BOX||

1-pixel-thick inset box.

=for apidoc T[box]F||FLTK::Box up|THIN_UP_BOX||

1-pixel-thick raised box.

=for apidoc T[box]F||FLTK::Box box|ENGRAVED_BOX||

2-pixel thick engraved line around edge.

=for apidoc T[box]F||FLTK::Box box|EMBOSSED_BOX||

2-pixel thick raised line around edge.

=for apidoc T[box]F||FLTK::Box box|BORDER_BOX||

1-pixel thick gray line around rectangle.

=for apidoc T[box]F||FLTK::Box box|HIGHLIGHT_UP_BOX||

Draws nothing normally, and as L<C<THIN_UP_BOX>|/"THIN_UP_BOX"> when the mouse
pointer points at it or the value of the widget is turned on.

=for apidoc T[box]F||FLTK::Box box|HIGHLIGHT_DOWN_BOX||

Draws nothing normally, and as L<C<THIN_DOWN_BOX>|/"THIN_DOWN_BOX"> when the
mouse pointer points at it or the value of the widget is turned on.

=cut

MODULE = FLTK::Box               PACKAGE = FLTK

fltk::Box *
DOWN_BOX( )
    CODE:
        RETVAL = fltk::DOWN_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "DOWN_BOX", "box" );

fltk::Box *
FLAT_BOX( )
    CODE:
        RETVAL = fltk::FLAT_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "FLAT_BOX", "box" );

fltk::Box *
NO_BOX( )
    CODE:
        RETVAL = fltk::NO_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "NO_BOX", "box" );

fltk::Box *
UP_BOX( )
    CODE:
        RETVAL = fltk::UP_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "UP_BOX", "box" );

fltk::Box *
THIN_DOWN_BOX( )
    CODE:
        RETVAL = fltk::THIN_DOWN_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "THIN_DOWN_BOX", "box" );

fltk::Box *
THIN_UP_BOX( )
    CODE:
        RETVAL = fltk::THIN_UP_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "THIN_UP_BOX", "box" );

fltk::Box *
ENGRAVED_BOX( )
    CODE:
        RETVAL = fltk::ENGRAVED_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "ENGRAVED_BOX", "box" );

fltk::Box *
EMBOSSED_BOX( )
    CODE:
        RETVAL = fltk::EMBOSSED_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "EMBOSSED_BOX", "box" );

fltk::Box *
BORDER_BOX( )
    CODE:
        RETVAL = fltk::BORDER_BOX;
    OUTPUT:
        RETVAL


BOOT:
    export_tag( "BORDER_BOX", "box" );

fltk::Box *
HIGHLIGHT_UP_BOX( )
    CODE:
        RETVAL = fltk::HIGHLIGHT_UP_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "HIGHLIGHT_UP_BOX", "box" );

fltk::Box *
HIGHLIGHT_DOWN_BOX( )
    CODE:
        RETVAL = fltk::HIGHLIGHT_DOWN_BOX;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "HIGHLIGHT_DOWN_BOX", "box" );

MODULE = FLTK::Box               PACKAGE = FLTK::Box

#INCLUDE: FrameBox.xsi

#INCLUDE: FlatBox.xsi

#endif // ifndef DISABLE_BOX

BOOT:
    isa("FLTK::Box", "FLTK::Symbol");
