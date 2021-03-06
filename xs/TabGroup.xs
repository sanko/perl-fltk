#include "include/FLTK_pm.h"

MODULE = FLTK::TabGroup               PACKAGE = FLTK::TabGroup

#ifndef DISABLE_TABGROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::TabGroup - For Making a 'Tabbed' Dialog Boxes

=head1 Description

This is the "file card tabs" interface to allow you to put lots and lots of
buttons and switches in a panel. This first appeared in NeXTStep, but is best
known from Windows control panesl. FLTK's version draws in a style more
reminiscent of NeXT or PageMaker, and avoids the confusing multiple-lines of
Windows by drawing overlapping tabs.

Each child widget is a card, and it's L<C<label()>|FLTK::Widget/"label"> is
printed on the card tab (including the label font and style). The
L<C<color()>|FLTK::Widget/"color"> of the child is used to color the tab as
well.

The size of the tabs is controlled by the bounding box of the children (there
should be some space between the children and the edge of this widget). If
there is a larger gap on the bottom than the top, the tabs are placed
"inverted" along the bottom.

Clicking the tab makes that child L<C<visible()>|FLTK::Widget/"visible"> and
hides all the other children. If the widget with the focus does not consume
them, the C<Ctrl+Tab> and C<Ctrl+Shift+Tab> keys will also switch tabs. The
user can also navigate the focus to the tabs and change them with the arrow
keys.

The L<C<callback()>|FLTK::Widget/"callback"> of the L<TabGroup|FLTK::TabGroup>
widget is called when the user changes the visible tab, and C<SHOW> and
C<HIDE> events are passed to the children.

=begin apidoc

=cut

#include <fltk/TabGroup.h>

=for apidoc ||FLTK::TabGroup * group|new|int x|int y|int w|int h|char * label = ''|bool begin = false|

Creates a new L<TabGroup|FLTK::TabGroup> widget using the given position,
size, and label string. Use L<C<add(widget)>|FLTK::Group/"add"> to add each
child. Each child is probably an L<FLTK::Group|FLTK::Group> widget containing
the actual widgets the user sees. The children should be sized to stay away
from the top or bottom edge of the L<FLTK::Tab|FLTK::Tab>s, which is where the
tabs are drawn.

=cut

#include "include/RectangleSubclass.h"

fltk::TabGroup *
fltk::TabGroup::new( int x, int y, int w, int h, const char * label = 0, bool begin = false )
    CODE:
        RETVAL = new RectangleSubclass<fltk::TabGroup>(CLASS,x,y,w,h,label,begin);
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::NamedStyle * style|default_style||

The default style has a gray L<C<color( )>|FLTK::Widget/"color"> and the
L<C<box( )>|FLTK::Widget/"box"> is set to C<THIN_UP_BOX>. The
L<C<box( )>|FLTK::Widget/"box"> is used to draw the edge around the cards,
including the top edge, but the tab itself is designed only to match
C<THIN_UP_BOX>. You can also use C<FLAT_BOX> and it will look correct if the
tabs fill the entire width of a window or parent box.

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::TabGroup::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=for apidoc ||int val|value||

Returns the index of the first L<C<visible( )>|FLTK::Widget/"visible"> child,
which is normally the one the user selected.

This will automatically force a single child to be
L<C<visible( )>|FLTK::Widget/"visible"> if more than one is, or if none are.
If more than one is visible all except the first is hidden. If none are, the
last one is made visible. The resulting visible child's index is returned.
This behavior allows new TabGroups to be created with all children visible,
and allows children to be deleted, moved to other groups, and
L<C<show( )>|FLTK::Widget/"show">/L<C<hide( )>|FLTK::Widget/"hide"> called on
them without the display ever looking wrong to the user.

If there are no children then C<-1> is returned.

=for apidoc |||value|int newval|

Switch so index C<$newval> is selected. If n is less than zero selects zero,
if C<$newval> is greater than the children, it selects the last one. Returns
true if this is a different child than last time. Does not do the
L<C<callback( )>|FLTK::Widget/"callback">.

=cut

int
fltk::TabGroup::value( int newval = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->value( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            RETVAL = THIS->value( newval );

=for apidoc ||int index|which|int event_x|int event_y|

Returns the child index that would be selected by a click at the given mouse
position. Returns C<-1> if the mouse position is not in a tab.

=cut

int
fltk::TabGroup::which( int event_x, int event_y )

=for apidoc ||FLTK::Widget * child|selected_child||

Returns C<$tabgroup->child($tabgroup->value())> or an undefined value if no
children exist.

=for apidoc ||bool new|selected_child|FLTK::Widget * newval|

Switches to this child widget, or to a child that
L<C<contains( )>|FLTK::Widget/"contians"> this widget. Returns true if this is
a different selection than before. Does not do the
L<C<callback( )>|FLTK::Widget/"callback">. If the widget is null or not a
descendent of this, the last child is selected.

=cut

void
fltk::TabGroup::selected_child( fltk::Widget * newval = NO_INIT )
    PPCODE:
        if ( items == 1 ) {
            void * RETVAL = NULL;
            RETVAL = (void *) THIS->selected_child( );
            if (RETVAL != NULL) {
                ST(0) = sv_newmortal();
                sv_setref_pv(ST(0), "FLTK::Widget", RETVAL); /* -- hand rolled -- */
            }
        }
        else if( items == 2 ) {
            bool RETVAL = THIS->selected_child( newval );
            ST(0) = boolSV(RETVAL);
            sv_2mortal(ST(0));
        }
        XSRETURN(1);

=for apidoc |||set_draw_outline|bool draw_outline|



=cut

void
fltk::TabGroup::set_draw_outline( bool draw_outline )

=for apidoc |||pager|FLTK::TabGroupPager * value|

Sets the pager to a L<TabGroup|FLTK::TabGroup>. By design, pager is B<never>
undefined.

=for apidoc ||FLTK::TabGroupPager * pager|pager||


=cut

fltk::TabGroupPager *
fltk::TabGroup::pager( fltk::TabGroupPager * value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->pager( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->pager( value );

=for apidoc |||default_pager|FLTK::TabGroupPager * value|

Sets the default pager for future L<TabGroup|FLTK::TabGroup>s. By design, the
defualt pager is never undefined.

=for apidoc |||default_pager|int value|

Sets the default pager from the built-in ones.

The current built-in pagers are...

=over

=item Menu
Displays two left and right buttons and provides 'prev page' and 'next page'
functionality. This is the new default.

Pass C<0> for this type.

=item Shrink
Tabs outside the rectangle are shrunken to very small slice to fit. This is
the original default.

Pass C<1> for this type.

=back

=cut

void
fltk::TabGroup::default_pager( value )
    CASE: SvIOK(ST(1))
        int value
        C_ARGS: value
    CASE:
        fltk::TabGroupPager * value
        C_ARGS: value

=for apidoc ||int height|tab_height||

Returns the space needed for tabs. Negative values will place tabs on the
bottom.

=cut

int
fltk::TabGroup::tab_height( )

=for apidoc ||int index, AV * position, AV * width|tab_positions||

Returns the index of the selected item, the left edges of each tab (plus a
fake left edge for a tab past the right-hand one). These positions are
actually of the left edge of the slope. They are either seperated by the
correct distance or by C<$tabgroup->pager->slope( )> or by zero.

Return value is the index of the selected item.

=cut

AV *
fltk::TabGroup::tab_positions( )
    CODE:
        int children = THIS->children();
        int p[ children - 1 ], w[ children - 1 ], index, i;
        AV * _position = newAV( ); //sv_2mortal((SV*)_position );
        AV * _width    = newAV( ); //sv_2mortal((SV*)_width );
        RETVAL = newAV( ); sv_2mortal((SV*)RETVAL);
        index  = THIS->tab_positions( p, w );
        for ( i = 0; i <= children; i++ ) {
            av_push( _position, newSViv( (int) p[ i ] ) );
            av_push( _width,    newSViv( (int) w[ i ] ) );
        }
        av_push( RETVAL, newSViv( index ) );
        av_push( RETVAL, (SV*) _position );
        av_push( RETVAL, (SV*) _width );
    OUTPUT:
        RETVAL

=for apidoc |||draw_tab|int x1|int x2|int W|int H|FLTK::Widget * o|int sel = 0|


=cut

void
fltk::TabGroup::draw_tab( int x1, int x2, int W, int H, fltk::Widget * o, int sel = 0 )

=for apidoc |||draw_tab_background||


=cut

void
fltk::TabGroup::draw_tab_background( )

#endif // #ifndef DISABLE_TABGROUP

BOOT:
    isa("FLTK::TabGroup", "FLTK::Group");
