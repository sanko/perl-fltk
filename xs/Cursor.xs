#include "include/FLTK_pm.h"

MODULE = FLTK::Cursor               PACKAGE = FLTK::Cursor

#ifndef DISABLE_CURSOR

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Cursor - Mouse cursor support for the Fast Light Tool Kit

=head1 Description

L<C<Cursor>|FLTK::Cursor> is an opaque system-dependent class. Currently you
can only use the built-in cursors but a method to turn an L<Image|FLTK::Image>
into a L<C<Cursor>|FLTK::Cursor> will be added in the future.

To display a cursor, call L<C<Widget::cursor()>|FLTK::Widget/"cursor">.

Built-in cursors may be imported with the C<cursor> tag and are...

=over

=item C<CURSOR_DEFAULT>

the default cursor, usually an arrow.

=item C<CURSOR_ARROW>

up-left arrow pointer

=item C<CURSOR_CROSS>

crosshairs

=item C<CURSOR_WAIT>

watch or hourglass

=item C<CURSOR_INSERT>

I-beam

=item C<CURSOR_HAND>

hand / pointing finger

=item C<CURSOR_HELP>

question mark

=item C<CURSOR_MOVE>

4-pointed arrow

=item C<CURSOR_NS>

up/down arrow

=item C<CURSOR_WE>

left/right arrow

=item C<CURSOR_NWSE>

diagonal arrow

=item C<CURSOR_NESW>

diagonal arrow

=item C<CURSOR_NO>

circle with slash

=item C<CURSOR_NONE>

invisible

=back

=begin apidoc

=cut

#include <fltk/Cursor.h>

=for apidoc ||FLTK::Cursor c|cursor|FLTK::Image * image|int x|int y|



=cut

MODULE = FLTK::Cursor               PACKAGE = FLTK

fltk::Cursor *
cursor( fltk::Image * image, int x, int y )

fltk::Cursor *
CURSOR_DEFAULT( )
    CODE:
        RETVAL = fltk::CURSOR_DEFAULT;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_DEFAULT", "cursor" );

fltk::Cursor *
CURSOR_ARROW( )
    CODE:
        RETVAL = fltk::CURSOR_ARROW;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_ARROW",   "cursor" );

fltk::Cursor *
CURSOR_CROSS( )
    CODE:
        RETVAL = fltk::CURSOR_CROSS;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_CROSS",   "cursor" );

fltk::Cursor *
CURSOR_WAIT( )
    CODE:
        RETVAL = fltk::CURSOR_DEFAULT;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_WAIT",    "cursor" );

fltk::Cursor *
CURSOR_INSERT( )
    CODE:
        RETVAL = fltk::CURSOR_INSERT;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_INSERT",  "cursor" );

fltk::Cursor *
CURSOR_HAND( )
    CODE:
        RETVAL = fltk::CURSOR_HAND;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_HAND",    "cursor" );

fltk::Cursor *
CURSOR_HELP( )
    CODE:
        RETVAL = fltk::CURSOR_DEFAULT;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_HELP", "cursor" );

fltk::Cursor *
CURSOR_MOVE( )
    CODE:
        RETVAL = fltk::CURSOR_MOVE;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_MOVE", "cursor" );

fltk::Cursor *
CURSOR_NS( )
    CODE:
        RETVAL = fltk::CURSOR_NS;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_NS", "cursor" );

fltk::Cursor *
CURSOR_WE( )
    CODE:
        RETVAL = fltk::CURSOR_WE;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_WE", "cursor" );

fltk::Cursor *
CURSOR_NWSE( )
    CODE:
        RETVAL = fltk::CURSOR_NWSE;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_NWSE", "cursor" );

fltk::Cursor *
CURSOR_NESW( )
    CODE:
        RETVAL = fltk::CURSOR_NESW;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_NESW", "cursor" );

fltk::Cursor *
CURSOR_NO( )
    CODE:
        RETVAL = fltk::CURSOR_NO;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_NO", "cursor" );

fltk::Cursor *
CURSOR_NONE( )
    CODE:
        RETVAL = fltk::CURSOR_NONE;
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "CURSOR_NONE", "cursor" );

#ifndef DISABLE_WIDGET

MODULE = FLTK::Cursor               PACKAGE = FLTK::Widget

=for apidoc |||cursor|FLTK::Cursor * c|

Change the cursor being displayed on the screen. A widget should do this in
response to C<ENTER> and C<MOVE> events. FLTK will change it back to
C<CURSOR_DEFAULT> if the mouse is moved outside this widget, unless another
widget calls this.

=for hackers TODO On X you can mess with the colors by setting the Color
variables C<fl_cursor_fg> and C<fl_cursor_bg> to the colors you want, before
calling this.

=cut

void
fltk::Widget::cursor ( fltk::Cursor * c )

#endif // #ifndef DISABLE_WIDGET

MODULE = FLTK::Cursor               PACKAGE = FLTK::Cursor

#endif // #ifndef DISABLE_CURSOR

BOOT:
    isa("FLTK::Cursor", "FLTK::Image");
