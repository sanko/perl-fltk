#include "include/FLTK_pm.h"

MODULE = FLTK::Rectangle               PACKAGE = FLTK::Rectangle

#ifndef DISABLE_RECTANGLE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Rectangle - Base class for Widgets, Windows, Monitors, and just about everything else you can see

=head1 Description

TODO

=begin apidoc

=cut

#include <fltk/Rectangle.h>

=for apidoc ||FLTK::Rectangle * self|new||

This constructor does not put anything into the fields! You can either call
L<C<set( )>|FLTK::Rectangle/"set"> or just modify the
L<x|FLTK::Rectangle/"x">, L<y|FLTK::Rectangle/"y">, L<w|FLTK::Rectangle/"w">,
and L<h|FLTK::Rectangle/"h"> variables directly.

=for apidoc ||FLTK::Rectangle * self|new|int x|int y|int w|int h|

Constructor that sets L<C<x( )>|FLTK::Rectangle/"x">,
L<C<y( )>|FLTK::Rectangle/"y">, L<C<w( )>|FLTK::Rectangle/"w">, and
L<C<h( )>|FLTK::Rectangle/"h">.

=for apidoc ||FLTK::Rectangle * self|new|int w|int h|

Constructor that sets L<C<x( )>|FLTK::Rectangle/"x"> and
L<C<y( )>|FLTK::Rectangle/"y"> to zero, and sets
L<C<w( )>|FLTK::Rectangle/"w"> and L<C<h( )>|FLTK::Rectangle/"h">.

=for apidoc ||FLTK::Rectangle * clone|new|FLTK::Rectangle * original|

Copy constructor.

=for apidoc ||FLTK::Rectangle * clone|new|FLTK::Rectangle * original|int w|int h|int flags = 0|

Constructor that calls L<C<set( )>|FLTK::Rectangle/"set">.

=cut

#include "include/WidgetSubclass.h"

void
fltk::Rectangle::new( ... )
    PREINIT:
        void * RETVAL = NULL;
    PPCODE:
        if ( items == 1 )
            RETVAL = (void *) new WidgetSubclass<fltk::Rectangle>(CLASS);
        else if ( items == 5 && SvIOK(ST(1)) && SvIOK(ST(2)) && SvIOK(ST(3)) && SvIOK(ST(4)) )
            RETVAL = (void *) new WidgetSubclass<fltk::Rectangle>(CLASS,SvIV(ST(1)),SvIV(ST(2)),SvIV(ST(3)),SvIV(ST(4)));
        else if ( items == 3 && SvIOK(ST(1)) && SvIOK(ST(2)) )
            RETVAL = (void *) new WidgetSubclass<fltk::Rectangle>(CLASS,SvIV(ST(1)),SvIV(ST(2)));
        else if ( items == 2 ) {
            fltk::Rectangle * original;
            if (sv_isobject(ST(1)) && sv_derived_from(ST(1), "FLTK::Rectangle")) /* -- hand rolled -- */ //
                original = INT2PTR( fltk::Rectangle *, SvIV( ( SV * ) SvRV( ST(1) ) ) );
            else
                Perl_croak( aTHX_ "%s: %s is not of type %s",
                    "FLTK::Rectangle::new", "original", "FLTK::Rectangle" );
            RETVAL = (void *) new WidgetSubclass<fltk::Rectangle>(CLASS,*original);
        }
        else if ( ( ( items == 4 ) || ( items == 5 ) ) && SvIOK(ST(2)) && SvIOK(ST(3)) ) {
            fltk::Rectangle * original;
            int w = SvIV(ST(2));
            int h = SvIV(ST(3));
            int flags = 0;
            if ( items == 5 )
                flags = SvIV(ST(4));
            if (sv_isobject(ST(1)) && sv_derived_from(ST(1), "FLTK::Rectangle")) /* -- hand rolled -- */ //
                original = INT2PTR( fltk::Rectangle *, SvIV( ( SV * ) SvRV( ST(1) ) ) );
            else
                Perl_croak( aTHX_ "%s: %s is not of type %s",
                    "FLTK::Rectangle::new", "original", "FLTK::Rectangle" );
            RETVAL = (void *) new WidgetSubclass<fltk::Rectangle>(CLASS,*original,w,h,flags);
        }
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||bool can_has|contains|int x|int y|

True if rectangle contains the pixel who's upper-left corner is at C<$x, $y>.

=cut

bool
fltk::Rectangle::contains( int x, int y )

=for apidoc ||int x|x||

Left edge.

=for apidoc |||x|int value|

Move the rectangle so that the left edge is at C<$value>.

=for apidoc ||int y|y||

Top edge.

=for apidoc |||y|int value|

Move the rectangle so that the top edge is at C<$value>.

=for apidoc ||int w|w||

Distance between left and right edges.

=for apidoc |||w|int value|

Change L<C<w( )>|FLTK::Rectangle/"w"> by moving the right edge.
L<C<x( )>|FLTK::Rectangle/"x"> does not change.

=for apidoc ||int h|h||

Distance between top and bottom edges.

=for apidoc |||h|int value|

Change L<C<h( )>|FLTK::Rectangle/"h"> by moving the bottom edge.
L<C<y( )>|FLTK::Rectangle/"y"> does not change.

=cut

SV *
fltk::Rectangle::x( int value = NO_INIT )
    CODE:
        ST(0) = sv_newmortal();
        switch( ix ) {
            case 0: items==2?THIS->x(value):sv_setnv(ST(0),THIS->x()); break;
            case 1: items==2?THIS->y(value):sv_setnv(ST(0),THIS->y()); break;
            case 2: items==2?THIS->w(value):sv_setnv(ST(0),THIS->w()); break;
            case 3: items==2?THIS->h(value):sv_setnv(ST(0),THIS->h()); break;
        }
    ALIAS:
        y = 1
        w = 2
        h = 3

=for apidoc ||int r|r||

Returns C<L<x( )|FLTK::Rectangle/"x"> + L<w( )|FLTK::Rectangle/"w">>, the
right edge of the rectangle.

=for apidoc ||int b|b||

Returns C<L<y( )|FLTK::Rectangle/"y"> + L<h( )|FLTK::Rectangle/"h">>, the
bottom edge of the rectangle.

=cut

int
fltk::Rectangle::r( )

int
fltk::Rectangle::b( )

=for apidoc |||set_x|int v|

Change L<C<x( )>|FLTK::Rectangle/"x"> without changing
L<C<r( )>|FLTK::Rectangle/"r">, by changing the width.

=for apidoc |||set_y|int v|

Change L<C<y( )>|FLTK::Rectangle/"y"> without changing
L<C<b( )>|FLTK::Rectangle/"b">, by changing the height.

=for apidoc |||set_r|int v|

Change L<C<r( )>|FLTK::Rectangle/"r"> without changing
L<C<x( )>|FLTK::Rectangle/"x">, by changing the width.

=for apidoc |||set_b|int v|

Change L<C<b( )>|FLTK::Rectangle/"b"> without changing
L<C<y( )>|FLTK::Rectangle/"y">, by changing the height.

=cut

void
fltk::Rectangle::set_x( int v )

void
fltk::Rectangle::set_y( int v )

void
fltk::Rectangle::set_r( int v )

void
fltk::Rectangle::set_b( int v )

=for apidoc |||set|int x|int y|int w|int h|

Set L<C<x( )>|FLTK::Rectangle/"x">, L<C<y( )>|FLTK::Rectangle/"y">,
L<C<w( )>|FLTK::Rectangle/"w">, L<C<h( )>|FLTK::Rectangle/"h"> all at once.

=for apidoc |||set|FLTK::Rectangle * rect|int w|int h|int flags = 0|

Sets L<x|FLTK::Rectangle/"x">, L<y|FLTK::Rectangle/"y">,
L<w|FLTK::Rectangle/"w">, L<h|FLTK::Rectangle/"h"> so that's it's centered or
aligned (if C<$flags != 0>) inside the source C<$rect>.

=cut

void
fltk::Rectangle::set( x, int y, int w, int h = 0 )
    CASE: items == 5 && !sv_isobject(ST(1))
        int x
        C_ARGS: x, y, w, h
    CASE:
        fltk::Rectangle * x
        C_ARGS: *x, y, w, h

=for apidoc |||move_x|int d|

Add C<$d> to L<C<x( )>|FLTK::Rectangle/"x"> without changing
L<C<r( )>|FLTK::Rectangle/"r"> (it reduces
L<C<w( )>|FLTK::Rectangle/"w"> by C<$d>).

=for apidoc |||move_y|int d|

Add C<$d> to L<C<y( )>|FLTK::Rectangle/"y"> without changing
L<C<b( )>|FLTK::Rectangle/"b"> (it reduces
L<C<h( )>|FLTK::Rectangle/"h"> by C<$d>).

=for apidoc |||move_r|int d|

Add C<$d> to L<C<r( )>|FLTK::Rectangle/"r"> and
L<C<w( )>|FLTK::Rectangle/"w">.

=for apidoc |||move_b|int d|

Add C<$d> to L<C<b( )>|FLTK::Rectangle/"b"> and
L<C<h( )>|FLTK::Rectangle/"h">.

=cut

void
fltk::Rectangle::move_x( int d )

void
fltk::Rectangle::move_y( int y )

void
fltk::Rectangle::move_r( int d )

void
fltk::Rectangle::move_b( int d )

=for apidoc |||inset|int d|

Move all edges in by C<$d>. See also L<Symbol::inset( )|FLTK::Symbol/"inset">.

=cut

void
fltk::Rectangle::inset( int d )

=for apidoc |||move|int x|int y|

Move entire rectangle by given distance in C<$x> and C<$y>.

=cut

void
fltk::Rectangle::move( int x, int y )

=for apidoc ||bool empty|empty||

True if L<C<w( )>|FLTK::Rectangle/"w"> or L<C<h( )>|FLTK::Rectangle/"h"> are
less or equal to zero.

=for apidoc ||bool not_empty|not_empty||

Not exactly the same as L<C<!empty()>|FLTK::Rectangle/"empty">. Returns true
if L<C<w( )>|FLTK::Rectangle/"w"> and L<C<h( )>|FLTK::Rectangle/"h"> are
B<both> greater than zero.

=cut

bool
fltk::Rectangle::empty( )

bool
fltk::Rectangle::not_empty( )

=for apidoc ||int x|center_x||

Integer center position. Rounded to the left if L<C<w( )>|FLTK::Rectangle/"w">
is odd.

=for apidoc ||int y|center_y||

Integer center position. Rounded to lower y if L<C<h( )>|FLTK::Rectangle/"h">
is odd.

=cut

int
fltk::Rectangle::center_x( )

int
fltk::Rectangle::center_y( )

=for apidoc ||int baseline|baseline_y||

Where to put baseline to center current font nicely.

=cut

int
fltk::Rectangle::baseline_y( )

=for apidoc |||merge|FLTK::Rectangle * r|



=for apidoc |||intersect|FLTK::Rectangle * r|



=cut

void
fltk::Rectangle::merge( fltk::Rectangle * r )
    C_ARGS: * r

void
fltk::Rectangle::intersect( fltk::Rectangle * r )
    C_ARGS: * r

#INCLUDE: Monitor.xsi

#INCLUDE: Widget.xsi

#endif // ifndef DISABLE_RECTANGLE
