#include "include/FLTK_pm.h"

MODULE = FLTK::Group               PACKAGE = FLTK::Group

#ifndef DISABLE_GROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532007

=for git $Id$

=head1 NAME

FLTK::Group - Base class for all container widgets

=head1 Description

The L<FLTK::Group|FLTK::Group> class is the FLTK container widget. It
maintains an array of child widgets. These children can themselves be any
widget including L<FLTK::Group|FLTK::Group>, nesting groups allows much more
control over layout and resize behavior. Nested groups are also necessary to
group radio buttons together.

By default L<FLTK::Group|FLTK::Group> preserves the positions and sizes of all
it's children, they do not move no matter what sizes or other children are
added or removed.

Setting L<C<resizable()>|FLTK::Group/"resizable"> will change the layout
behavior so that it responds to resizing by moving or resizing the children to
fit. See below for details.

You may want to use an L<FLTK::Pack|FLTK::Pack> or a
L<FLTK::Scroll|FLTK::Scroll> to get other common layout behavior that can
respond to changes in the sizes of child widgets.

The most-used subclass of L<FLTK::Group|FLTK::Group> is
L<FLTK::Window|FLTK::Window>, all the rules about resizing apply to windows.
Setting L<C<resizable()>|FLTK::Group/"resizable"> on a window will allow the
user to resize it. If you want different behavior (such as from
L<FLTK::Pack|FLTK::Pack>) for your window you should make the window have that
as a single resizable child that fills it.

L<FLTK::Menu|FLTK::Menu> is a subclass and thus all menus and browsers are
groups and the items in them are widgets.

=begin apidoc

=cut

#include <fltk/Group.h>

#include <fltk/Widget.h>

=for apidoc ||FLTK::Group grp|new|int x|int y|int w|int h|char * label = ''|bool begin = false|

Creates a new C<FLTK::Group> widget using the given position, size, and label
string. The default boxtype is C<NO_BOX>.

=cut

#include "include/RectangleSubclass.h"

fltk::Group *
fltk::Group::new( int x, int y, int w, int h, char * label = 0, bool begin = false )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Group>(CLASS,x,y,w,h,label,begin);
    OUTPUT:
        RETVAL

=for apidoc ||int kids|children||

Returns how many child widgets the group has.

=cut

int
fltk::Group::children( )

=for apidoc ||FLTK::Widget kid|child|int index|

Returns a child, C<index E<gt>= 0 && index E<lt> children()>. B<Range
checking is done internally!>

=cut

fltk::Widget *
fltk::Group::child( int index )
    PREINIT:
        const char * CLASS;
    CODE:
        if ( index < THIS->children( ) ) {
            RETVAL = THIS->child( index );
            CLASS = (( RectangleSubclass<fltk::Widget> * ) RETVAL)->bless_class( );
        }
    OUTPUT:
        RETVAL

=for apidoc |||begin||

Sets the current group so you can build the widget tree by just constructing
the widgets. L<C<begin()>|/"begin"> is exactly the same as
L<C<$W-E<gt>current($W)>|/"current">.

B<Don't forget to L<C<end()>|/"end"> the group or window!>

=for apidoc |||end||

Exactly the same as L<C<$W-E<gt>current($W-E<gt>parent())>|/"current">. Any
new widgets added to the widget tree will be added to the parent of the group.

=cut

void
fltk::Group::begin( )

void
fltk::Group::end( )

=for apidoc ||FLTK::Group group|current|||

Returns the group being currently built. The L<Widget|FLTK::Widget>
constructor automatically does C<current()-E<gt>add($widget)> if this is not
undef. To prevent new widgets from being added to a group, call
L<C<FLTK::Group::current(0)>|FLTK::Group/"current">.

=for apidoc |||current|FLTK::Group * group|

Sets the group being currently built.

=cut

fltk::Group *
fltk::Group::current( fltk::Group * group = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->current( group );

=for apidoc ||int index|find|FLTK::Widget widget|

Searches the children for C<widget>, returns the index of C<widget> or of a
parent of C<widget> that is a L<C<child()>|/"child"> of this. Returns
L<C<children()>|/"children"> if the widget is undef or not found.

=for apidoc NA||FLTK::Widget * widget|add|FLTK::Widget * widget|

The widget is removed from its current group (if any) and then added to the
end of this group.

=cut

int
fltk::Group::find ( fltk::Widget * widget )

void
fltk::Group::add ( RectangleSubclass<fltk::Widget> * widget )
    PPCODE:
        THIS->add( widget );
        EXTEND(SP, 1); PUSHs(ST(1)); // Do this so we don't have to rebless

=for apidoc NA||FLTK::Widget * widget|insert|FLTK::Widget * widget|int index|

Inserts C<widget> in the <index>th position of this group's stack.

=for apidoc NA||FLTK::Widget * widget|insert|FLTK::Widget * widget|FLTK::Widget * before|

This does L<C<$G-E<gt>insert($widget, $G-E<gt>find($beforethis))>|/"insert">.
This will append the widget if C<$beforethis> is not in the group.

=cut

void
fltk::Group::insert( fltk::Widget * widget, before )
    CASE: SvIOK( ST(2) )
        int before
        C_ARGS: * widget, before
    POSTCALL:
        if (widget != NULL) {
            EXTEND(SP, 1); PUSHs(ST(1)); // Do this so we don't have to rebless
        }
    CASE:
        fltk::Widget * before
        C_ARGS: * widget, before
    POSTCALL:
        if (widget != NULL) {
            EXTEND(SP, 1); PUSHs(ST(1)); // Do this so we don't have to rebless
        }

=for apidoc |||remove|int index|

Remove the C<index>th widget from the group.

=for apidoc |||remove|FLTK::Widget widget|

Removes a C<widget> from the group. This does nothing if the widget is not
currently a child of this group.

=cut

void
fltk::Group::remove( widget )
    CASE: SvIOK( ST(1) )
        int widget
    CASE:
        fltk::Widget * widget

=for apidoc |||remove_all||

Removes all widgets from the group. B<This does not call the destructor on the
child widget.>

See L<C<clear())>|/"clear">

=cut

void
fltk::Group::remove_all( )

=for apidoc NA||FLTK::Widget * widget_b|replace|int index|FLTK::Widget * widget_b|

Remove the C<index>th widget and inserts C<widget_b> in its place.

=for apidoc NA||FLTK::Widget * widget_b|replace|FLTK::Widget * widget|FLTK::Widget * widget_b|

Remove the C<widget> and inserts C<widget_b> in its place.

=cut

void
fltk::Group::replace( widget, fltk::Widget * widget_b )
    CASE: SvIOK( ST(1) )
        int widget
        C_ARGS:   widget, * widget_b
        POSTCALL:
            if (widget_b != NULL) {
                EXTEND(SP, 1); PUSHs(ST(2)); // Do this so we don't have to rebless
            }
    CASE:
        fltk::Widget * widget
        C_ARGS: * widget, * widget_b
        POSTCALL:
            if (widget_b != NULL) {
                EXTEND(SP, 1); PUSHs(ST(2)); // Do this so we don't have to rebless
            }

=for apidoc |||swap|int indexA|int indexB|

Swaps the C<indexA>th widget with the C<indexB>th widget.

=cut

void
fltk::Group::swap( int indexA, int indexB )

=for apidoc |||clear||

Deletes all children from the group and makes it empty. B<This calls the
destructor on all the children.>

See L<C<remove_all()>|/"remove_all">

=cut

void
fltk::Group::clear( )

=for apidoc |||resizable|FLTK::Widget * widget|

Sets the resizing widget.

=for apidoc ||FLTK::Widget * elastic|resizable||

The resizable widget defines the resizing box for the group. When the group is
resized it calculates a new size and position for all of its children. Widgets
that are horizontally or vertically inside the dimensions of the box are
scaled to the new size. Widgets outside the box are moved.

The resizable may be set to the group itself, in which case all the contents
are resized. If the resizable is undef (the default) then all widgets remain a
fixed size and distance from the top-left corner.

It is possible to achieve any type of resize behavior by using an
L<InvisibleBox|FLTK::InvisibleBox> as the resizable and/or by using a
hierarchy of child L<Group|FLTK::Group>'s.

=cut

fltk::Widget *
fltk::Group::resizable( fltk::Widget * widget = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->resizable( * widget );

=for apidoc |||add_resizable|FLTK::Widget * widget|

L<Adds|/"add"> a C<widget> and sets it as the L<resizer|/"resizable"> in one
fell swoop.

=cut

void
fltk::Group::add_resizable( fltk::Widget * widget )
    C_ARGS: * widget

=for apidoc |||init_sizes||

Indicate that all the remembered child sizes should be reinitialized.

The group remembers the initial size of itself and all it's children, so that
the layout can be restored even if the group is resized so that some children
go to zero or negative sizes.

This can produce unwanted behavior if you try to rearrange the child widgets
yourself, as the next resize will put them right back where they were
initially. Call this to make it forget all the saved sizes and reinitialize
them during the next L<C<layout()>|/"layout">.

This is automatically done when any child is added or removed.

=cut

void
fltk::Group::init_sizes( )

=for apidoc |||focus_index|int index|

The index of the widget that contains the focus. You can initialize this
before the group is displayed. Changing it while it is displayed does not
work, use L<C<$widget-E<gt>take_focus()>|FLTK::Widget/"take_focus"> instead.

For some subclasses such as L<TabGroup|FLTK::TabGroup>, a negative number
indicates that the group itself has the focus. In most cases any illegal value
means it will search for any widget that accepts focus.

This is also used by L<Menu|FLTK::Menu> to locate the item selected by the
user. See L<C<Menu::get_item()>|FLTK::Menu/"get_item">.

=for apidoc ||int index|focus_index||

Returns the index of the widget currently having focus.

=cut

int
fltk::Group::focus_index( int index = NO_INIT )
    CASE: items ==  1
        C_ARGS:
    CASE:
        CODE:
            THIS->focus_index( index );

=for apidoc |||set_focus|FLTK::Widget * widget|

Same as L<C<focus_index( $index )>|/"focus_index_index">.

=cut

void
fltk::Group::set_focus( fltk::Widget * widget )

=for apidoc ||int key|navigation_key||

Turn Tab into Right or Left for keyboard navigation.

=cut

int
fltk::Group::navigation_key( )

=for apidoc d|||fix_old_positions||

If this is a L<Group|FLTK::Group> and not a L<Window|FLTK::Window>, subtract
L<C<x()>|FLTK::Widget/"x"> and L<C<y()>|FLTK::Widget/"y"> from the position of
all children. This will fix the positions of widgets created for fltk1.1 that
are inside a group.

=cut

void
fltk::Group::fix_old_positions(  )

=for apidoc ||FLTK::Flags flags|resize_align||



=for apidoc |||resize_align|FLTK::Flags flags||



=cut

fltk::Flags
fltk::Group::resize_align( fltk::Flags flags = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->resize_align( flags );

#INCLUDE: Menu.xsi

#INCLUDE: PackedGroup.xsi

#INCLUDE: ScrollGroup.xsi

#INCLUDE: TabGroup.xsi

#INCLUDE: TextDisplay.xsi

#INCLUDE: Window.xsi

#endif // ifndef DISABLE_GROUP

BOOT:
    isa("FLTK::Group", "FLTK::Widget");
