#include "include/FLTK_pm.h"

MODULE = FLTK::PackedGroup               PACKAGE = FLTK::PackedGroup

#ifndef DISABLE_PACKEDGROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::PackedGroup - Group that packs all it's child widgets against the edges

=head1 Description

Resizes all the child widgets to be the full width and stacks them. All
widgets before the L<resizable()|FLTK::Group/"resizable"> (or all of them if
there is no L<resizable()|FLTK::Group/"resizable">) are pushed against the top
of this widget, all widgets after the L<resizable()|FLTK::Group/"resizable">
are pushed against the bottom, and the L<resizable()|FLTK::Group/"resizable">
fills the remaining space. Child widgets that have
L<vertical()|FLTK::Widget/"vertical"> true are pushed against the left/right
edge.

This is most useful for layout menu/toolbars and work areas in your main
window. You can get many layouts with this, except the top widgets always
extend to the right edge and the left widgets always extend to the bottom. To
change this, put the top or left widgets and resizable in a
L<PackedGroup|FLTK::PackedGroup> and nest that inside another one with the
bottom and right widgets.

A child widget can change it's size by calling
L<layout()|FLTK::Widget/"layout"> on itself and this will rearrange all other
widgets to accomodate the new height.

If resizable is not set, the L<PackedGroup|FLTK::PackedGroup> itself resizes
to surround the items, allowing it to be embedded in a surrounding
L<PackedGroup|FLTK::PackedGroup> or L<ScrollGroup|FLTK::ScrollGroup>. This
only works if all objects are horizontal or all are vertical.

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/PackedGroup.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=head1 Layout Types

These are the current schemes built into L<PackedGroup|FLTK::PackedGroup>.

=over

=item * C<FLTK::PackedGroup::NORMAL>

=item * C<FLTK::PackedGroup::ALL_CHILDREN_VERTICAL>

=back

Setting
L<C<$pg-E<gt>type(FLTK::PackedGroup::ALL_CHILDREN_VERTICAL)>|FLTK::Widget/"type">
will make it act like all the children have
L<vertical()|FLTK::Widget/"vertical"> set.

=cut

int
NORMAL( )
    CODE:
        RETVAL = fltk::PackedGroup::NORMAL;
    OUTPUT:
        RETVAL

int
ALL_CHILDREN_VERTICAL( )
    CODE:
        RETVAL = fltk::PackedGroup::ALL_CHILDREN_VERTICAL;
    OUTPUT:
        RETVAL

=begin apidoc

=for apidoc ||FLTK::PackedGroup group|new|int x|int y|int w|int h|char * label = ''|bool begin = false|

Creates a new L<PackedGroup|FLTK::PackedGroup>.

=cut

#include "include/WidgetSubclass.h"

void
fltk::PackedGroup::new( int x, int y, int w, int h, char * label = 0, bool begin = false )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::PackedGroup>(CLASS,x,y,w,h,label,begin);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc |||spacing|int s|

Set a fixed-size gap between all the children. This defaults to zero. If you
change this in an already-existing one, call
L<relayout()|FLTK::Widget/"relayout">.

=for apidoc ||int s|spacing||

Returns the fixed-size gap between all children.

=cut

int
fltk::PackedGroup::spacing( int s = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->spacing( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->spacing( s );

=for apidoc ||int l|margin_left||

Get the left margin for child widgets.

=for apidoc |||margin_left|int l|

Set the left margin for child widgets.

=cut

int
fltk::PackedGroup::margin_left( int l = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->margin_left( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->margin_left( l );

=for apidoc ||int r|margin_right||

Get the right margin for child widgets.

=for apidoc |||margin_right|int r|

Set the right margin for child widgets.

=cut

int
fltk::PackedGroup::margin_right( int r = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->margin_right( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->margin_right( r );

=for apidoc ||int t|margin_top||

Get the top margin for child widgets.

=for apidoc |||margin_top|int t|

Set the top margin for child widgets.

=cut

int
fltk::PackedGroup::margin_top( int t = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->margin_top( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->margin_top( t );

=for apidoc ||int b|margin_bottom||

Get the bottom margin for child widgets.

=for apidoc |||margin_bottom|int b|

Set the bottom margin for child widgets.

=cut

int
fltk::PackedGroup::margin_bottom( int b = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->margin_bottom( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->margin_bottom( b );

=for apidoc |||margin|int m|

Set the L<left|FLTK::PackedGroup/"margin_left">,
L<right|FLTK::PackedGroup/"margin_right">,
L<top|FLTK::PackedGroup/"margin_top">, and
L<bottom|FLTK::PackedGroup/"margin_bottom"> margins to the same value.

=cut

void
fltk::PackedGroup::margin( int m )

BOOT:
    isa("FLTK::PackedGroup", "FLTK::Group");

#endif // ifndef DISABLE_PACKEDGROUP
