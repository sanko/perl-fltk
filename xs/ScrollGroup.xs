#include "include/FLTK_pm.h"

MODULE = FLTK::ScrollGroup               PACKAGE = FLTK::ScrollGroup

#ifndef DISABLE_SCROLLGROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.532006

=head1 NAME

FLTK::ScrollGroup - Group that adds scrollbars so you can scroll around the
area

=head1 Description

This container widget lets you maneuver around a set of widgets much larger
than your window. If the child widgets are larger than the size of this object
then scrollbars will appear so that you can scroll over to them.

The default L<C<type( )>|FLTK::Widget/"type"> will just scroll a whole
arrangement of widgets and never resize them. This is useful if you just want
to get a big control panel into a smaller window. The bounding box of the
widgets are the area it can scroll, this will remove any borders, if you want
the borders preserved put some invisible widgets there as placeholders.

This can be used to pan around a large drawing by making a single child widget
"canvas". This child widget should be of your own class, with a C<draw( )>
method that draws everything. The scrolling is done by changing the
L<C<x( )>|FLTK::Rectangle/"x"> and L<C<y( )>|FLTK::Rectangle/"y"> of the
widget and drawing it with the fltk clip region set to the newly exposed
rectangles. You can speed things up by using C<FLTK::not_clipped( )> or
C<FLTK::intersect_with_clip( )> to detect and skip the clipped portions of the
drawing.

By default you can scroll in both directions, and the scrollbars disappear if
the data will fit in the area of the scroll. L<C<type( )>|FLTK::Widget/"type">
can change this:

=over

=item * C<HORIZONTAL> resize vertically but scroll horizontally

=item * C<VERTICAL> resize horizontally but scroll vertically

=item * C<BOTH> this is the default

=item * C<HORIZONTAL_ALWAYS> resize vertically but always show horizontal
scrollbar

=item * C<VERTICAL_ALWAYS> resize horizontally but always show vertical
scrollbar

=item * C<BOTH_ALWAYS> always show both scrollbars

=back

If you use C<HORIZONTAL> or C<VERTICAL> you must initally position and size
your child widgets as though the scrollbar is off (ie fill the
L<C<box( )>|FLTK::Widget/"box"> width entirely if
L<C<type( )>|FLTK::Widget/"type"> is C<VERTICAL>). The first time
L<C<layout( )>|FLTK::Widget/"layout"> is called it will resize the widgets to
fit inside the scrollbars.

It is very useful to put a single L<PackedGroup|FLTK::PackedGroup> child into
a C<VERTICAL> L<ScrollGroup|FLTK::ScrollGroup>.

Also note that L<C<scrollbar_align( )>|FLTK::ScrollGroup/"scrollbar_align"> (a
L<Style|FLTK::Style> parameter) can put the scrollbars on different sides of
the widget.

Currently you cannot use L<Window|FLTK::Window> or any subclass (including
L<GlWindow|FLTK::GlWindow>) as a child of this. The clipping is not conveyed
to the operating system's window and it will draw over the scrollbars and
neighboring objects.

=begin apidoc

=cut

#include <fltk/ScrollGroup.h>

=for apidoc ||FLTK::ScrollGroup * self|new|int x|int y|int w|int h|char * label = ''|bool begin = false|

Creates a new L<FLTK::ScrollGroup|FLTK::ScrollGroup> widget.

=cut

#include "include/RectangleSubclass.h"

fltk::ScrollGroup *
fltk::ScrollGroup::new( int x, int y, int w, int h, const char * label = 0, bool begin = false )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ScrollGroup>(CLASS,x,y,w,h,label,begin);
    OUTPUT:
        RETVAL

int
HORIZONTAL( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = fltk::ScrollGroup::HORIZONTAL;        break;
            case 1: RETVAL = fltk::ScrollGroup::VERTICAL;          break;
            case 2: RETVAL = fltk::ScrollGroup::BOTH;              break;
            case 3: RETVAL = fltk::ScrollGroup::ALWAYS_ON;         break;
            case 4: RETVAL = fltk::ScrollGroup::HORIZONTAL_ALWAYS; break;
            case 5: RETVAL = fltk::ScrollGroup::VERTICAL_ALWAYS;   break;
            case 6: RETVAL = fltk::ScrollGroup::BOTH_ALWAYS;       break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
                 VERTICAL = 1
                     BOTH = 2
                ALWAYS_ON = 3
        HORIZONTAL_ALWAYS = 4
          VERTICAL_ALWAYS = 5
              BOTH_ALWAYS = 6

=for apidoc |||bbox|FLTK::Rectangle * rect|

Set the rectangle to the scrolling area (in the
L<ScrollGroup|FLTK::ScrollGroup>'s coordinate system). This removes the border
of the L<C<box( )>|FLTK::Widget/"box"> and the space needed for any visible
scrollbars.

=cut

void
fltk::ScrollGroup::bbox( fltk::Rectangle * rect )
    C_ARGS: * rect

=for apidoc |||enable_drag_scroll|bool enable|



=cut

void
fltk::ScrollGroup::enable_drag_scroll( bool enable )

=for apidoc ||int x|xposition||



=for apidoc ||int y|yposition||



=cut

int
fltk::ScrollGroup::xposition( )

int
fltk::ScrollGroup::yposition( )

=for apidoc |||scrollTo|int x|int y|



=cut

void
fltk::ScrollGroup::scrollTo( int x, int y )

#endif // ifndef DISABLE_SCROLLGROUP

BOOT:
    isa( "FLTK::ScrollGroup", "FLTK::Group" );
