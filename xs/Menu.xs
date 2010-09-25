#include "include/FLTK_pm.h"

MODULE = FLTK::Menu               PACKAGE = FLTK::Menu

#ifndef DISABLE_MENU

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::Menu - Utility functions for Menu type widgets

=head1 Description

The L<Menu|FLTK::Menu> base class is used by L<Browser|FLTK::Browser>,
L<Choice|FLTK::Choice>, L<MenuBar|FLTK::MenuBar>,
L<PopupMenu|FLTK::PopupMenu>, L<ComboBox|FLTK::ComboBox>, and other widgets.
It is simply a L<Group|FLTK::Group> and each item is a child
L<Widget|FLTK::Widget>, but it provides functions to select and identify one
of the widgets in the hierarchy below it and do that widget's callback
directly, and functions to create and add L<Item|FLTK::Item> and
L<ItemGroup|FLTK::ItemGroup> widgets to a hierarchy.

A L<Menu|FLTK::Menu> can take a pointer to a L<List|FLTK::List> object, which
allows the user program to dynamically provide the items as they are needed.
This is much easier than trying to maintain an array of
L<Widgets|FLTK::Widget> in parallel with your own data structures.

It also provides several convienence functions for creating, rearranging, and
deleting child L<Item|FLTK::Item> and L<ItemGroup|ItemGroup> widgets.

=cut

#include <fltk/Menu.h>
#include <fltk/Item.h>

=begin apidoc

=for apidoc ||FLTK::Menu * self|new|int x|int y|int w|int h|char * label = ''|bool begin = 0



=cut

#include "include/WidgetSubclass.h"

void
fltk::Menu::new( int x, int y, int w, int h, char * label = 0, bool begin = false )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::Menu>(CLASS,x,y,w,h,label,begin);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Menu::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=for apidoc ||FLTK::List * lst|list||

Returns the L<List|FLTK::List> that generates widgets for the menu.

=for apidoc |||list|FLTK::List * list||

Set the L<List|FLTK::List> that generates widgets for the menu. By default
this is a dummy L<List|FLTK::List> that returns the child widgets of the
L<Menu|FLTK::Menu>.

=cut

fltk::List *
fltk::Menu::list( fltk::List * list = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->list();
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->list( list );

=for apidoc ||int total|children|AV * indexes|int level|

Calls
L<$self-E<gt>list()-E<gt>child($self, $indexes, $level)>|FLTK::Menu/"list">.
If an L<FLTK::List|FLTK::List> is used, the returned widget may be a temporary
data structure and may be overwritten by another call to
L<C<child( )>|FLTK::List/"child"> in this I<or any other L<Menu|FLTK::Menu>!>

=for apidoc ||int total|children|int index|

Returns the number of children of some child. Same as
L<C<children([$i], 1)>|FLTK::Menu/"children_indexes_level_">.

=for apidoc ||int total|children||

Returns the number of children at the top level. Same as C<children(0,0)>.

I<This overrides the method of the same name on L<FLTK::Group|FLTK::Group>>.
This is so that an L<FLTK::List|FLTK::List> can be used. However if no
L<FLTK::List|FLTK::List> is specified the action is identical to
L<C<FLTK::Group::children( )>|FLTK::Group/"children">.

=cut

int
fltk::Menu::children( index = NO_INIT, int level  = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        int index
        C_ARGS: index
    CASE: items == 3
        AV * index
        INIT:
            int * indexes;
            for ( int i = 0; i < av_len( index ); i++ )
                indexes[ i ] = SvIV( * av_fetch(index, i, 0));
        C_ARGS: indexes, level

=for apidoc ||FLTK::Widget kid|child|AV * indexes|int level|

! Calls list()->child(this, indexes, level).
If an fltk::List is used, the returned widget may be a temporary data
structure and may be overwritten by another call to child() in this
<i>or any other Menu</i>!

=for apidoc ||FLTK::Widget kid|child|int index|

Returns the given top-level child. Same as
L<C<child($index, 0)>|FLTK::Menu/"child_indexes_level_">.

I<This overrides the method of the same name on L<FLTK::Group|FLTK::Group>>.
This is so that an L<FLTK::List|FLTK::List> can be used. However if no
L<FLTK::List|FLTK::List> is specified the action is identical to
L<C<FLTK::Group::child( $index )>|FLTK::Group/"child_index_">.

=cut

fltk::Widget *
fltk::Menu::child( index = NO_INIT, int level  = NO_INIT )
    CASE: items == 2
        int index
        C_ARGS: index
    CASE: items == 3
        AV * index
        INIT:
            int * indexes;
            for ( int i = 0; i < av_len( index ); i++ )
                indexes[ i ] = SvIV( * av_fetch(index, i, 0));
        C_ARGS: indexes, level

=for apidoc ||FLTK::Widget * current|item|||

The "current item". In callbacks, this is the item the user clicked on.
Otherwise you probably can't make any assumptions about it's value.

L<C<Browser::goto_index()>|FLTK::Browser/"goto_index"> sets this to the
current item.

Since this may be the result of calling L<C<child()>|FLTK::Menu/"child"> the
returned structure may be short-lived if an L<FLTK::List|FLTK::List> is used.


=for apidoc ||FLTK::Widget * item|item|FLTK::Widget * value||

You can set L<C<item()>|FLTK::Menu/"item_"> with the second call, useful for
outwitting the callback. This does not produce any visible change for the
user.

=cut

void *
fltk::Menu::item( fltk::Widget * value = NO_INIT )
    PREINIT:
        const char * _class;
    PPCODE:
        if ( items == 1 ) {
            _class = (( WidgetSubclass<fltk::Widget> * ) RETVAL)->bless_class( );
            if (RETVAL != NULL) {
                ST(0) = sv_newmortal( );
                sv_setref_pv(ST(0), _class ? _class : "FLTK::Widget", RETVAL); /* -- hand rolled -- */
                XSRETURN(1);
            }
        }
        else
            THIS->item( value );

=for apidoc ||bool changed|set_item|AV * indexes|int level|

Remembers a currently selected item in a hierarchy by setting the
L<C<focus_index()>|FLTK::Group/"focus_index"> of each group to point to the
next one. The widget can then be recovered with
L<C<get_item()>|FLTK::Menu/"get_item">. A
L<C<redraw(DAMAGE_VALUE)>|FLTK::Widget/"redraw"> is done so pulldown menus
redraw their display.

=cut

bool
fltk::Menu::set_item( AV * index, int level )
    CODE:
        int * indexes;
        for ( int i = 0; i < av_len( index ); i++ )
            indexes[ i ] = SvIV( * av_fetch(index, i, 0));
        RETVAL = THIS->set_item( indexes, level );
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::Widget * item|get_item||

Sets and returns L<C<item()>|FLTK::Menu/"item"> based on the
L<C<focus_index()>|FLTK::Group/"focus_index"> in this and each child group,
thus restoring the value saved with L<C<set_item()>|FLTK::Menu/"set_item">.

This either returns a non-group node, or child group that has an illegal
L<C<Group::focus_index()>|FLTK::Group/"focus_index">, or undef if this
L<C<focus_index()>|FLTK::Group/"focus_index"> is illegal.

If an L<FLTK::List|FLTK::List> is used this will probably only go to the first
child and not descend any further.

=cut

fltk::Widget *
fltk::Menu::get_item( )

=for apidoc ||int index|value||

Same as L<C<FLTK::Group::focus_index>|FLTK::Group/"focus_index">.

=for apidoc ||bool changed|value|int index||

Convienence function to do L<C<set_item()>|FLTK::Menu/"set_item"> when there
is only one level of hierarchy. In this case you can consider the menu items
to be indexes starting at zero.

=cut

int
fltk::Menu::value( int index = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        C_ARGS: index

=for apidoc |||layout_in|FLTK::Widget * widget|AV * indexes|int level

Resize the widget to contain the menu items that are the children of the item
indicated by indexes and level (use 0 for the immediate children).

If the widget has L<C<vertical()>|FLTK::Widget/"vertical"> true the menu items
are laid out one above the other, as is usally done in the pull-down menu
below a menubar. L<C<w()>|FLTK::Widget/"w"> is set to the widest item, and
L<C<h()>|FLTK::Widget/"h"> to the sum of all the heights.

If the widget has L<C<horizontal()>|FLTK::Widget/"horizontal"> true then the
items are laid out in rows, wrapping only when L<C<w()>|FLTK::Widget/"w"> is
exceeded. L<C<w()>|FLTK::Widget/"w"> is changed only if it is too small to
contain the smallest item. L<C<h()>|FLTK::Widget/"h"> is set to the total
height of all the rows.

The L<C<box()>|FLTK::Menu/"box">, L<C<leading()>|FLTK::Menu/"leading">,
L<C<textfont()>|FLTK::Menu/"textfont">,
L<C<textsize()>|FLTK::Menu/"textsize">, and perhaps other style attributes of
the widget are used when figuring out the total size and the size of each
item.

=cut

void
fltk::Menu::layout_in( fltk::Widget * widget, AV * indexes, int level )
    CODE:
        int * _indexes;
        for ( int i = 0; i < av_len( indexes ); i++ )
            _indexes[ i ] = SvIV( * av_fetch(indexes, i, 0));
        THIS->layout_in( widget, _indexes, level );

=for apidoc |||draw_in|FLTK::Widget * widget|AV * indexes|int level|int selected|int drawn_selected

Draw the menu items inside the widget.

The widget's L<C<box()>|FLTK::Menu/"box"> is drawn and the items are laid out
exactly the same as for L<C<layout()>|FLTK::Menu/"layout">.

If C<$selected> is greater or equal to zero then that item is drawn in a
selected manner.

If C<$widget->damage()==DAMAGE_CHILD> then it is assummed that only the items
indicated by C<$selected> and C<$drawn_selected> need to be redrawn. This is
used for minimal update to move the selection from one item to the next.

=cut

void
fltk::Menu::draw_in( fltk::Widget * widget, AV * indexes, int level, int selected, int drawn_selected )
    INIT:
        int * _indexes;
        for ( int i = 0; i < av_len( indexes ); i++ )
            _indexes[ i ] = SvIV( * av_fetch(indexes, i, 0));
    C_ARGS: widget, _indexes, level, selected, drawn_selected

=for apidoc ||int index|find_selected|FLTK::Widget * widget|AV * indexes|int level|int mx|int my|

Return the index of the item that is under the location C<$mx, $my> in the
given widget, if the L<C<draw()>|FLTK::Widget/"draw"> method had been used to
draw the items into the widget.

=cut

int
fltk::Menu::find_selected( fltk::Widget * widget, AV * indexes, int level, int mx, int my )
    INIT:
        int * _indexes;
        for ( int i = 0; i < av_len( indexes ); i++ )
            _indexes[ i ] = SvIV( * av_fetch(indexes, i, 0));
    C_ARGS: widget, _indexes, level, mx, my

=for apidoc ||FLTK::Rectangle location|get_location|FLTK::Widget * widget|AV * indexes|int level|int index|

Return the bounding box of the given item inside the widget, if the
L<C<draw()>|FLTK::Widget/"draw"> method had been used to draw the items into
the widget.

=cut

fltk::Rectangle
fltk::Menu::get_location( fltk::Widget * widget, AV * indexes, int level, int index )
    INIT:
        int * _indexes;
        for ( int i = 0; i < av_len( indexes ); i++ )
            _indexes[ i ] = SvIV( * av_fetch(indexes, i, 0) );
    C_ARGS: widget, _indexes, level, index

=for apidoc ||int selected|popup|FLTK::Rectangle rect|char * title = ''|bool menubar = false

Create and display a pop-up menu (or hierarchy of menus) showing the
children of this L<Menu|FLTK::Menu>, then wait until the user picks an item or
dismisses the menu. If the user picks an item then
L<C<execute()>|FLTK::Menu/"execute"> is called for it and true is returned.
False is returned if the user cancels the menu.

If there is a selected item in the menu (as determined by
L<C<get_item()>|FLTK::Menu/"get_item">) then submenus are opened and all of
them are positioned intitially so the mouse cursor is pointing at the selected
item. This is incredibly useful and one of the main features of fltk that is
missing from other toolkits.

C<rect> describes a rectangle (C<$x, $y, $w, $h>) that the current menu item
should be centered over, and the menu is widened horizontally to C<$w> if it
is narrower. The coordinates are measured relative to the widget whose
L<C<handle()>|FLTK::Widget/"handle"> method is being executed now.

C<$title> is a widget (usually an L<FLTK::Item|FLTK::Item>) that is used to
make a title atop the menu, in the style of SGI's popup menus. You cannot use
a L<List|FLTK::List> child, as the drawing of the menu may navigate that list
to other children, overwriting the original widget.

C<$menubar> is for internal use by menubars and should be left false.

=cut

int
fltk::Menu::popup( fltk::Rectangle * rect, char * title = 0, bool menubar = false )
    C_ARGS: * rect, title, menubar

=for apidoc ||int handled|handle_shortcut||

Respond to the current C<FLTK::SHORTCUT> or C<FLTK::KEY> event by finding a
menu item it matches and calling L<C<execute()>|FLTK::MenuItem/"execute"> on
it. True is returned if a menu item is found, false if none.
L<Items|FLTK::MenuItem> are searched for a matching
L<C<shortcut()>|FLTK::Menu/"shortcut"> value. C<&x> shortcuts are ignored,
they are used only for navigating when the menu is visible.

If you use a List, only the top-most level items are searched for shortcuts.
Recursion is done only if the children are L<Group|FLTK::Group> widgets, and
then only the actual children of that L<Group|FLTK::Group> (not any
L<List|FLTK::List> it may contain if it is another L<Menu|FLTK::Menu>) are
searched. This is necessary because some L<Lists|FLTK::List> are infinite in
size, and usually they don't have shortcuts anyway.

This will return invisible (but active) items, even though it is impossible to
select these items with the gui. This is done so that more than one shortcut
for an action may be given by putting multiple copies of the item in, where
only the first is visible.

=cut

int
fltk::Menu::handle_shortcut( )

=for apidoc |||default_callback|FLTK::Widget widget|SV * data|

The default callback for L<Menu|FLTK::Menu> calls
L<C<item()->do_callback()>|FLTK::Widget/"do_callback"> but if
L<C<user_data()>|FLTK::Widget/"user_data"> is not null it is used instead of
the item's L<C<user_data()>|FLTK::Widget/"user_data">.

=cut

void
fltk::Menu::default_callback( fltk::Widget * widget, SV * data )
    C_ARGS: widget, (void *) data

=for apidoc |||execute|FLTK::Widget * widget|

Calls L<C<do_callback()>|FLTK::Widget/"do_callback">. First it sets
L<C<item()>|FLTK::Menu/"item"> to the given widget, so the callback code can
see it.

Notice that this calls the callback on the L<Menu|FLTK::Menu> widget itself,
not on the menu item. However the default callback for Menu widget does
L<C<item()->do_callback()>|FLTK::Widget/"do_callback"> so by default the
callback for each menu item is done.

Callbacks for items can be disabled, so
L<C<item()->when(WHEN_NEVER)>|FLTK::Widget/"when"> will disable it for named
item, but calling L<C<when(WHEN_NEVER)>|FLTK::Widget/"when"> with menu
instance will disable callbacks for all menu items (but not for the menu
itself).

=cut

void
fltk::Menu::do_callback( fltk::Widget * widget )

=for apidoc |||global||

Make the shortcuts for this menu work no matter what window has the focus when
you type it (as long as L<C<FLTK::modal()>|FLTK/"modal"> is off). This is done
by using L<C<FLTK::add_handler()>|FLTK/"add_handler">. This
L<FLTK::Menu|FLTK::Menu> widget does not have to be visible (ie the window it
is in can be hidden, or it does not have to be put in a window at all).

Currently there can be only one L<C<global()>|FLTK::Menu/"global"> menu.
Setting a new one will replace the old one. There is no way to remove the
L<C<global()>|FLTK::Menu/"global"> setting, and you cannot destroy the
L<Menu|FLTK::Menu>!

This should probably also put the items on the the Mac menubar.

=cut

void
fltk::Menu::global( )

=for apidoc ||FLTK::Widget * item|char * label|

Returns the item with the given label.

This searches both the top level for an exact match, and splits the label at
'/' to find an item in a hierarchy. Thus it matches the strings passed to both
the long and short forms of L<C<add()>|FLTK::Menu/"add">.

If the item is found, a pointer to it is returned, otherwise undef is
returned.

=cut

fltk::Widget *
fltk::Menu::find( char * label )
    C_ARGS: ( const char * ) label

=for apidoc |||remove|char * label|

Does L<C<$menu->find( $label )>|FLTK::Menu/"find"> and then deletes that
widget.

=for apidoc |||remove|int index|

Deletes the C<$index>th widget.

=for apidoc |||remove|FLTK::Widget * widget|

Deletes C<$widget>.

=cut

void
fltk::Menu::remove( widget )
    CASE: SvIOK( ST(1) )
        int widget
    CASE: sv_isobject(ST(1))
        fltk::Widget * widget
    C_ARGS: SvPOK( ST(1) )
        char * widget
        C_ARGS: ( const char * ) widget

=for apidoc ||FLTK::Widget * item|add|char * label|unsigned shortcut = 0|CV * callback = 0|SV * data = NO_INIT|int flags = 0|

Split label at C</> characters and add a hierachial L<Item|FLTK::Item>.

Adds new items and hierarchy to a L<Menu|FLTK::Menu> or
L<Browser|FLTK::Browser>.

=over

=item C<$label>

The label is split at C</> characters to automatically produce
submenus. The submenus are created if they do not exist yet, and a new
L<Item|FLTK::Item> widget is added to the end of it.

A trailing C</> can be used to create an empty submenu (useful for forcing a
certain ordering of menus before you know what items are in them).

Backslashes in the string "quote" the next character, which allows you to put
forward slashes into a menu item.

=item C<$shortcut>

C<0> for no shortcut, C<FLTK::CTRL | ord 'a'> for C<Ctrl-a>,
etc.

=item C<$callback>

Function to call when item picked. If undef, the callback for
the L<Menu|FLTK::Menu> widget itself is called.

=item C<data>

Second argument passed to the callback.

=item C<flags>

Useful flags are:

=over

=item C<INACTIVE> makes the item grayed out and unpickable

=item C<INVISIBLE> makes it not visible to the user, as though it was not
there. This is most useful for making extra shortcuts that do the same thing.

=item C<RAW_LABEL> stops it from interpreting C<&> and C<@> characters in the
label.

=back

Import these with the L<C<:flags>|FLTK::Flags> label.

=back

Returns a pointer to the new L<Item|FLTK::Item>. You can further modify it to
get results that can't be gotten from these function arguments.

=for apidoc ||FLTK::Widget * item|add|char * label|SV * data||

Create a new L<Item|FLTK::Item> and add it to the top-level of the hierarchy.

Unlike the L<C<add()>|FLTK::Menu/"add"> with more arguments, this one does
*not* split the label at C</> characters. The label is used unchanged.

=for apidoc |||add|FLTK::Widget widget|

Add a widget to the menu.

=cut

fltk::Widget *
fltk::Menu::add( label, shortcut = 0, CV * callback = NO_INIT, SV * data = NO_INIT, int flags = 0 )
    CASE: items == 2 && sv_isobject(ST(1))
        fltk::Widget * label
        CODE:
            THIS->add( label );
    CASE: items == 3
        char * label
        SV * shortcut
        C_ARGS: ( const char * ) label, ( void * ) shortcut
    CASE:
        char * label
        unsigned shortcut
        PREINIT:
            const char * _class;
        INIT:
            HV * cb = newHV( );
            if ( items > 3 )
                hv_store( cb , "coderef",  7, newSVsv( ST(3) ),            0 );
            _class = (( WidgetSubclass<fltk::Item> * ) RETVAL)->bless_class( );
            _class = _class ? _class : "FLTK::Item";
            hv_store( cb , "class",    5, newSVpv( _class, strlen(_class) ), 0 );
            if ( items > 4 )
                hv_store( cb , "args", 4, newSVsv( data ),             0 );
        C_ARGS: ( const char * ) label, shortcut, _cb_w, ( void * ) cb, flags

=for apidoc ||FLTK::Widget * widget|replace|char * label|unsigned shortcut|CV * callback|SV * data|int flags|

Split label at C</> characters and add or replace a hierachial
L<Item|FLTK::Item>.

Same rules as L<C<add()>|FLTK::Menu/"add"> except if the item already exists
it is changed to this new data, instead of a second item with the same label
being created.

If the C<$label> has any C<@> or C<&> commands in any portion, that portion is
relabelled, thus you can use this to change the appearance of existing menu
items. However if the new label does not have any such commands, the label
remains as before, with any older C<@>-commands.

=for apidoc ||FLTK::Widget * widget|replace|char * label|SV * shortcut|

Create or replace an L<Item|FLTK::Item> at the top-level of the hierarchy.

The top level is searched for an item that matches the given label. If found
it's data is changed to the passed data, if not found a new Item is created
and added at the end.

=for apidoc |||replace|int index|FLTK::Widget widget|

Replace the C<$index>th item with C<$widget>.

=for apidoc |||replace|FLTK::Widget old|FLTK::Widget new|

Replace the C<$old> widget with the C<$new> widget.

=cut

fltk::Widget *
fltk::Menu::replace( label, shortcut = 0, CV * callback, SV * data = NO_INIT, int flags = 0 )
    CASE: ( ( items == 3 ) && ( sv_isobject(ST(1)) ) && ( sv_isobject(ST(2)) ) )
        int            label
        fltk::Widget * shortcut
        CODE:
            THIS->replace( label, * shortcut );
    CASE: ( ( items == 3 ) && ( sv_isobject(ST(2)) ) )
        fltk::Widget * label
        fltk::Widget * shortcut
        CODE:
            THIS->replace( * label, * shortcut );
    CASE: items <= 3
        char * label
        SV * shortcut
        C_ARGS: ( const char * ) label, ( void * ) shortcut
    CASE:
        char * label
        unsigned shortcut
        PREINIT:
            const char * _class;
        INIT:
            HV * cb = newHV( );
            hv_store( cb , "coderef",  7, newSVsv( ST(3) ),            0 );
            _class = (( WidgetSubclass<fltk::Item> * ) RETVAL)->bless_class( );
            _class = _class ? _class : "FLTK::Item";
            hv_store( cb , "class",    5, newSVpv( _class, strlen(_class) ), 0 );
            if ( items > 4 )
                hv_store( cb , "args", 4, newSVsv( data ),             0 );
        C_ARGS: ( const char * ) label, shortcut, _cb_w, ( void * ) cb, flags

=for apidoc ||FLTK::Widget * item|insert|int index|char * label|unsigned shortcut|CV * callback|SV * args = NO_INIT|int flags = 0

Split label at C</> characters and add a hierachial Item.

Same rules as L<C<add()>|FLTK::Menu/"add"> except the item is inserted at
C<$index> of the final menu. Use 0 to put it at the start. Any number larger
or equal to the current item count adds the new item to the end.

=for apidoc ||FLTK::Widget * item|insert|int index|char * label|SV * data|

Create a new L<Item|FLTK::Item> and add it to the top-level of the hierarchy.

Unlike the L<C<insert()>|FLTK::Menu/"insert"> with more arguments, this one
does B<not> split the label at C</> characters. The label is used unchanged.

=for apidoc |||insert|FLTK::Widget widget|int index|

Insert a widget into the menu.

=cut

fltk::Widget *
fltk::Menu::insert( index, label, shortcut = 0, CV * callback, SV * data = NO_INIT, int flags = 0 )
    CASE: ( ( items == 3 ) && ( sv_isobject(ST(1)) ) )
        fltk::Widget * index
        int            label
        CODE:
            THIS->insert( * index, label );
    CASE: items < 5
        int    index
        char * label
        SV   * shortcut
        C_ARGS: index, ( const char *) label, ( void * ) shortcut
    CASE:
        int        index
        char     * label
        unsigned   shortcut
        PREINIT:
            const char * _class;
        INIT:
            HV * cb = newHV( );
            hv_store( cb , "coderef",  7, newSVsv( ST(4) ),            0 );
            _class = (( WidgetSubclass<fltk::Item> * ) RETVAL)->bless_class( );
            _class = _class ? _class : "FLTK::Item";
            hv_store( cb , "class",    5, newSVpv( _class, strlen(_class) ), 0 );
            if ( items > 5 )
                hv_store( cb , "args", 4, newSVsv( data ),             0 );
        C_ARGS: index, ( const char * ) label, shortcut, _cb_w, ( void * ) cb, flags

=for apidoc ||FLTK::Group * newgroup|add_group|char * label|FLTK::Group * parent = NO_INIT|SV * data = NO_INIT|

Add a parent widget to a (possibly) lower level of the hierarchy, such as
returned by L<C<add_group()>|FLTK::Menu/"add_group">.

=cut

fltk::Group *
fltk::Menu::add_group( char * label, fltk::Group * parent = 0, SV * data = NO_INIT )
    C_ARGS: ( const char * ) label, parent, ( void * ) data

=for apidoc ||FLTK::Widget * widget|add_leaf|char * label|FLTK::Group * parent = NO_INIT|SV * data = NO_INIT|

Add a non-parent widget to a (possibly) lower level of the
hierarchy, such as returned by add_group(). If parent is null
or this then this is the same as add(label,data).

=cut

fltk::Widget *
fltk::Menu::add_leaf( char * label, fltk::Group * parent = NO_INIT, SV * data = NO_INIT )
    C_ARGS: ( const char * ) label, parent, ( void * ) data

=for apidoc ||FLTK::Widget * last|add_many|char * string|

This is a Forms (and SGI GL library) compatable add function, it adds many
menu items, with C<|> seperating the menu items, and tab seperating the menu
item names from an optional shortcut string.

=cut

fltk::Widget *
fltk::Menu::add_many( char * string )
    C_ARGS: ( const char * ) string

#INCLUDE: MenuBar.xsi

#INCLUDE: PopupMenu.xsi

#endif // ifndef DISABLE_MENU

BOOT:
    isa("FLTK::Menu", "FLTK::Group");
