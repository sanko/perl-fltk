#include "include/FLTK_pm.h"

MODULE = FLTK::Browser               PACKAGE = FLTK::Browser

#ifndef DISABLE_BROWSER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Browser - Subclass of FLTK::Menu

=head1 Description

Displays a scrolling vertical list of text widgets, possibly with a
hierarchical arrangement, and lets the user select one of them.

The items may be created as child widgets (usually the same widgets as are
used to create menus: L<FLTK::Item|FLTK::Item> widgets, or
L<FLTK::ItemGroup|FLTK::ItemGroup> widgets to make a hierarchy).

All the functions used to add, remove, or modify items in the list are defined
by the base class L<FLTK::Menu|FLTK::Menu>. See that for much more
information. For a simple constant list you can populate the list by calling
C<browser->add("text of item")> once for each item.

See also:

=over 8

=item C<add()>

=item C<add_group()>

=item C<add_leaf()>

=back

You can also use an L<FLTK::List|FLTK::List> which allows you to control the
storage by dynamically creating a temporary "fake" widget for the browser to
use each time it wants to look at or draw an item. This is useful for creating
browsers with hundreds of thousands of items, or when the set of items changes
rapidly.

If you give the browser a callback you can find out what item was selected
with L<C<value()>|FLTK::Browser/"value">, the first item is zero (this is
different from older versions of fltk that started at C<1>!), and will be
negative if no item is selected. You can change the selected item with
L<C<value(new_value)>|FLTK::Browser/"value">.

The subclass L<FLTK::MultiBrowser|FLTK::MultiBrowser> lets the user select
more than one item at the same time.

The L<C<callback()>|FLTK::Widget/"callback"> is done when the user changes the
selected items or when they open/close parents. In addition, if the user
double-clicks a non-parent item, then it is "executed" which usually means
that the L<C<callback()>|FLTK::Widget/"callback"> on the item itself is run.
However, if no callback has been set on the item, the
L<C<callback()>|FLTK::Widget/"callback"> of this widget is called with the
L<C<user_data()>|FLTK::Widget/"user_data"> of the item.

You can control when callbacks are done with the
L<C<when()>|FLTK::Widget/"when"> method. The following values are useful, the
default value is C<FLTK::WHEN_CHANGED>.

=over 8

=item C<FLTK::WHEN_NEVER>

Callback is never done. L<C<changed()>|FLTK::Widget/"changed"> can be used to
see if the user has modified the browser.

=item C<FLTK::WHEN_CHANGED>

Callback is called on every change to each item as it happens. The method
L<C<item()>|GLFK::Group/"item">) will return the one that is being changed.
Notice that selecting large numbers in a mulit browser will produce large
numbers of callbacks.

=item C<FLTK::WHEN_RELEASE>

Callback is done when the user releases the mouse after some changes, and on
any keystroke that changes the item. For a multi browser you will only be able
to find out all the changes by scanning all the items in the callback.

=item C<FLTK::WHEN_RELEASE_ALWAYS>

Callback is done when the user releases the mouse even if the current item has
not changed, and on any arrow keystroke even when at the top or bottom of the
browser.

=item C<FLTK::WHEN_ENTER_KEY>

If you turn this on then the enter key is a shortcut and executes the current
item like double-click.

=back

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/Browser.h>

#include <fltk/Symbol.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::Browser self|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::Browser> object.

=cut


#include "include/RectangleSubclass.h"

fltk::Browser *
fltk::Browser::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Browser>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc |||layout||



=cut

void
fltk::Browser::layout ( )

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Browser::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;



=for apidoc E||int flag|IS_MULTI||

Means multiple selection can be achieved by user.

=for apidoc E||int flag|NORMAL||

Means a single selection can be achieved by user.

=for apidoc E||int flag|MULTI||

Means multiple selection can be achieved by user.

=for apidoc E||int flag|NO_COLUMN_SELECTED||

Means that no column has been selected by user.

=cut

=for hackers These are internal to Browser so we don't export them and don't
put them in the top level.

=cut

int
IS_MULTI ( )
    ALIAS:
        NORMAL             = 1
        MULTI              = 2
        NO_COLUMN_SELECTED = 3
    CODE:
        switch ( ix ) {
            case 0 : RETVAL = fltk::Browser::IS_MULTI;           break;
            case 1 : RETVAL = fltk::Browser::NORMAL;             break;
            case 2 : RETVAL = fltk::Browser::MULTI;              break;
            case 3 : RETVAL = fltk::Browser::NO_COLUMN_SELECTED; break;
        }
    OUTPUT:
        RETVAL

=for apidoc E||int linepos|NOSCROLL||

Argument to L<C<make_item_visible()>|/"make_item_visible">.

Moves as little as possible so item is visible.

=for apidoc E||int linepos|TOP||

Position current item to top

=for apidoc E||int linepos|MIDDLE||

Position current item to middle

=for apidoc E||int linepos|BOTTOM||

Position current item to bottom

=cut

=for hackers These are internal to Browser so we don't export them and don't
put them in the top level.

=cut

fltk::Browser::linepos
NOSCROLL ( )
    CODE:
        switch ( ix ) {
            case 0 : RETVAL = fltk::Browser::NOSCROLL; break;
            case 1 : RETVAL = fltk::Browser::TOP;      break;
            case 2 : RETVAL = fltk::Browser::MIDDLE;   break;
            case 3 : RETVAL = fltk::Browser::BOTTOM;   break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
           TOP = 1
        MIDDLE = 2
        BOTTOM = 3

=for apidoc ||int w|width||

The width of the longest item in the browser, measured in pixels. If this is
changed (by adding or deleting items or opening or closing a parent item) then
L<C<layout()>|/"layout"> must be called before this is correct.

=for apidoc ||int h|height||

The height of all the visible items in the browser, measured in pixels. If
this is changed (by adding or deleting items or opening or closing a parent
item) then L<C<layout()>|/"layout"> must be called before this is correct.

=for apidoc ||int w|box_width||

The width of the display area of the browser in pixels, this is L<C<w()>|/"w">
minus the edges of the L<C<box()>|/"box"> minus the width of the vertical
scrollbar, if visible. If this is changed (by resizing the widget, adding or
deleting items or opening or closing a parent item such that the scrollbar
visibility changes) then L<C<layout()>|/"layout"> must be called before this
is correct.

=for apidoc ||int h|box_height||

The height of the display area of the browser in pixels, this is
L<C<h()>|/"h"> minus the edges of the L<C<box()>|/"box"> minus the height of
the horizontal scrollbar, if visible. If this is changed (by resizing the
widget, adding or deleting items or opening or closing a parent item such that
the scrollbar visibility changes) then L<C<layout()>|/"layout"> must be called
before this is correct.

=cut

int
fltk::Browser::width( )
    CODE:
        switch( ix ) {
            case 0: RETVAL =      THIS->width(); break;
            case 1: RETVAL =     THIS->height(); break;
            case 2: RETVAL =  THIS->box_width(); break;
            case 3: RETVAL = THIS->box_height(); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
            height = 1
         box_width = 2
        box_height = 3

=for apidoc ||int x|xposition||


=for apidoc |||xposition|int x|

Set the horizontal scrolling position, measured in pixels. Zero is the normal
position where the left edge of the child widgets is visible.

=for apidoc ||int y|yposition||


=for apidoc |||yposition|int y|

Set the vertical scrolling position, measured in pixels. Zero means the top of
the first item is visible. Positive numbers scroll the display up.

=cut

int
fltk::Browser::xposition( int x = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->xposition(); break;
                case 1: RETVAL = THIS->yposition(); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->xposition( x ); break;
                case 1: THIS->yposition( x ); break;
            }
    ALIAS:
        yposition = 1

=for apidoc ||bool is_it|indented||



=for apidoc |||indented|bool value||

Turn this on to for space to be reserved for open/close boxes drawn to the
left of top-level items. You usually want this for a hierarchial browser. This
should be off for a flat browser, or to emulate Windows Explorer where "my
computer" does not have an open/close to the left of it. The default value is
false.

=cut

bool
fltk::Browser::indented( bool value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->indented( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->indented( value );

=for apidoc ||FLTK::Scrollbar v_sb|scrollbar||



=for apidoc ||FLTK::Scrollbar h_sb|hscrollbar||



=cut

fltk::Scrollbar *
fltk::Browser::scrollbar ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = &(THIS->scrollbar);  break;
            case 1: RETVAL = &(THIS->hscrollbar); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        hscrollbar = 1

=for apidoc ||FLTK::Widget top|goto_top||

Because of the hierarchial structure it is difficult to identify an item in
the browser. Instead of passing an identifier to all the calls that can modify
an item, the browser provides several calls to set L<C<item()>|/"item"> based
on various rules, and then calls to modify the current L<C<item()>|/"item">.

This call sets L<C<item()>|/"item"> to the very first visible widget in the
browser. It returns the widget for that item, or null if the browser is empty.

If you have invisible items in the browser you should use
L<C<goto_index(0)>|/"goto_index"> if you want to go to the first item even if
it is invisible.

=for apidoc ||FLTK::Widget focus|goto_focus||

Sets the L<C<item()>|/"item"> to the "focus" (the item with the dotted square
in an L<FLTK::MultiBrowser|FLTK::MultiBrowser>, and the selected item in a
normal L<FLTK::Browser|FLTK::Browser>.

=for apidoc ||FLTK::Widget next|next||

Move the current item to the next item. If if is a parent it moves to the
first child. If not a parent, it moves to the next child of it's parent. If it
is the last child it moves to the parent's brother. Repeatedly calling this
will visit every child of the browser. This returns the widget. If the current
widget is the last one this returns C<undef>, but the current widget remains
on the last one.

The L<C<current_position()>|/"current_position"> is NOT set by this! It cannot
be calculated efficiently and would slow down the use of this function for
visiting all items.

=for apidoc ||FLTK::Widget next|next_visible||

Move forward to the next visible item (what down-arrow does). This does not
move and returns C<undef> if we are at the bottom.

=for apidoc ||FLTK::Widget prev|previous_visible||

Move backward to previous visible item: This does not move and returns
C<undef> if we are at the top.

=cut

fltk::Widget *
fltk::Browser::goto_top( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = THIS->goto_top(); break;
            case 1: RETVAL = THIS->goto_focus(); break;
            case 2: RETVAL = THIS->next(); break;
            case 3: RETVAL = THIS->next_visible(); break;
            case 4: RETVAL = THIS->previous_visible(); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
              goto_focus = 1
                    next = 2
            next_visible = 3
        previous_visible = 4

=for apidoc ||FLTK::Widget current|goto_position|int y|

Set the current L<C<item()>|/"item"> to the last one who's top is at or before
C<Y> pixels from the top.

=cut

fltk::Widget *
fltk::Browser::goto_position( int y )
    CODE:
        THIS->goto_position( y );
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::Widget current|goto_index|int index|int level|

Go to a nested item. indexes must contain C<level+1> index numbers. The first
number indicates the top-level item number, the second indicates the child
number of that parent, and so on. This sets the current L<C<item()>|/"item">
to the given item and also returns it. If the values are out of range then
C<undef> is returned.

A negative number in C<indexes[0]> will make it go into a special no-item
state where L<C<select_only_this()>|/"select_only_this"> will do
L<C<deselect()>|/"deselect">.

=for apidoc ||FLTK::Widget current|goto_index|int index|

Go to the C<index>'th item in the top level. If C<index> is out of range,
C<undef> is returned.

=for apidoc ||FLTK::Widget current|goto_index|int index|int level|int deep|int deeper|int deepest|

Go to an item at any level up to 5. Negative numbers indicate that no more
levels should be looked at.

=cut

fltk::Widget *
fltk::Browser::goto_index( int index, int level = NO_INIT, int deep = -1, int deeper = -1, int deepest = -1 )
    CASE: items == 2
        CODE:
            RETVAL = THIS->goto_index( index );
        OUTPUT:
            RETVAL
    CASE: items == 3
        CODE:
            RETVAL = THIS->goto_index( index, level );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = THIS->goto_index( index, level, deep, deeper, deepest );
        OUTPUT:
            RETVAL

=for apidoc ||FLTK::Widget current|goto_mark|FLTK::Browser::Mark * mark|

Set current item to a particular mark.

=cut

fltk::Widget *
fltk::Browser::goto_mark( fltk::Browser::Mark * mark )
    CODE:
        RETVAL = THIS->goto_mark( * mark );
    OUTPUT:
        RETVAL

=for apidoc ||bool position|at_mark|FLTK::Browser::Mark * mark|



=cut

bool
fltk::Browser::at_mark ( fltk::Browser::Mark * mark )
    CODE:
        RETVAL = THIS->at_mark( * mark );
    OUTPUT:
        RETVAL

=for apidoc ||int difference|compare_to_mark|FLTK::Browser::Mark * mark|



=cut

int
fltk::Browser::compare_to_mark( fltk::Browser::Mark * mark )
    CODE:
        RETVAL = THIS->compare_to_mark( * mark );
    OUTPUT:
        RETVAL

=for apidoc ||bool is_visible|item_is_visible||

Return true if the item would be visible to the user if the browser was
scrolled to the correct location. This means that the C<FLTK::INVISIBLE> flag
is not set on it, and all parents of it are open and visible as well.

=for apidoc ||bool is_parent|item_is_parent||

Return true if the current item is a parent. Notice that it may have zero
children.

=for apidoc ||bool is_open|item_is_open||

If L<C<item_is_parent()>|/"item_is_parent"> is true, return true if this item
is open. If this is not a parent the result is undefined.

=for apidoc ||bool focused|set_focus||

Change the focus (the selected item, or in an
L<FLTK::MultiBrowser|FLTK::MultiBrowser> the item that has a dotted box around
it, to the current item. This calls
L<C<make_item_visible()>|/"make_item_visible">.

=cut

bool
fltk::Browser::item_is_visible()
    CODE:
        switch ( ix ) {
            case 0: RETVAL = THIS->item_is_visible(); break;
            case 1: RETVAL = THIS->item_is_parent();  break;
            case 2: RETVAL = THIS->item_is_open();    break;
            case 3: RETVAL = THIS->set_focus();       break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        item_is_parent = 1
          item_is_open = 2
             set_focus = 3

=for apidoc ||int h|item_h||

The item height.

=cut

int
fltk::Browser::item_h( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = THIS->item_h(); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:

=for apidoc |||set_mark|FLTK::Browser::Mark * destination|



=for apidoc |||set_mark_to_focus|FLTK::Browser::Mark * destination|



=cut

void
fltk::Browser::set_mark( fltk::Browser::Mark * destination )
    CODE:
        switch ( ix ) {
            case 0: THIS->set_mark( * destination ); break;
            case 1: THIS->set_mark_to_focus( * destination ); break;
        }
    ALIAS:
        set_mark_to_focus = 1

=for apidoc ||bool okay|select|FLTK::Widget * widget|int value|int do_callback|

This is for use by the L<MultiBrowser|FLTK::MultiBrowser> subclass. Select or
deselect an item in parameter, optionally execute a callback (calls
L<C<set_item_selected()>|/"set_item_selected">). This method changes item
position in the tree.

=for apidoc x||bool okay|select|int item|bool value = true|

Same as goto_index(item),set_item_selected(value), to change the selected
state of an item in a non-hierarchial MultiBrowser. If C<item> is out of range
nothing happens.

Note: This is an FLTK 1.0 emulation method.

=cut

bool
fltk::Browser::select( item, value, int do_callback = 0 )
    CASE: sv_isobject(ST(1)) /* Hopefully, it's FLTK::Widget based */
        fltk::Widget * item;
        int value;
        CODE:
            RETVAL = THIS->select( item, value, do_callback );
    CASE:
        int item
        bool value = true;
        CODE:
            RETVAL = THIS->select( item, value );

=for apidoc ||bool okay|set_item_selected|bool value = true|int do_callback = 0|

This is for use by the L<MultiBrowser|FLTK::MultiBrowser> subclass. Turn the
C<FLTK::SELECTED> flag on or off in the current item (use
L<C<goto_index()>|/"goto_index"> to set the current item before calling this).

If this is not a L<MultiBrowser|FLTK::MultiBrowser>, this does
L<C<select_only_this()>|/"select_only_this"> if C<value> is true, and
L<C<deselect()>|/"deselect"> if \a value is false.

If C<do_callback> has some bits that are also in L<C<when()>|/"when"> then the
callback is done for each item that changes selected state.

=cut

bool
fltk::Browser::set_item_selected( bool value = true, int do_callback = 0 )

=for apidoc ||bool okay|select_only_this|int do_callback = 0|

Make the given item be the current one. For the
L<MultiBrowser|FLTK::MultiBrowser> subclass this will turn off selection of
all other items and turn it on for this one and also set the focus here. If
the selection changes and C<when()&do_callback> is non-zero, the callback is
done.

For the multibrowser, the callback is done for each item that changes, whether
it turns on or off.

=for apidoc ||bool okay|deselect|int do_callback = 0|

Turn off selection of all items in the browser. For the normal (not
L<Multi|FLTK::MultiBrowser>) L<Browser|FLTK::Browser>, this puts it in a
special state where nothing is highlighted and L<C<index(0)>|/"index"> returns
C<-1>. The user cannot get it into this state with the GUI.

For a L<MultiBrowser|FLTK::MultiBrowser> the user can get this state by
C<ctrl+click>ing the selected items off.

If C<do_callback> has some bits that are also in L<C<when()>|/"when"> then the
callback is done for each item that changes selected state.

=cut

bool
fltk::Browser::select_only_this( int do_callback = 0 )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->select_only_this( do_callback ); break;
            case 1: RETVAL = THIS->deselect( do_callback ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        deselect = 1

=for apidoc ||bool okay|make_item_visible|FLTK::Browser::linepos where|

This makes the current item visible to the user.

First it turns off the C<FLTK::INVISIBLE> flag on the current item, and turns
off the C<FLTK::INVISIBLE> flag and opens (turning on the C<FLTK::STATE> flag)
all parent items. These flag changes cause
L<C<flags_changed()>|/"flags_changed"> to be called on any
L<FLTK::List|FLTK::List> that you have assigned to the browser.

The browser is then scrolled by calling L<C<yposition()>|/"yposition"> so the
item is visible. The optional argument tells how to scroll. If not specified
(or the default value of L<FLTK::Browser::NOSCROLL|FLTK::Browser/NOSCROLL> is
given) then the browser is scrolled as little as possible to show the item. If
it is L<C<FLTK::Browser::TOP>FLTK::Browser|"TOP"> then the item is put at the
top of the browser. If it is
L<C<FLTK::Browser::MIDDLE>|FLTK::Browser/"MIDDLE"> then the item is centered
vertically in the browser. If it is
L<C<FLTK::Browser::BOTTOM>|FLTK::Browser/"BOTTOM"> then the item is put at the
bottom of the browser.

This does nothing if the current item is C<undef>.

=cut

bool
fltk::Browser::make_item_visible( fltk::Browser::linepos where )

=for apidoc |||damage_item|FLTK::Browser::Mark * mark|

Set item referenced by this mark as being damaged.

=for apidoc |||damage_item||

Tell the browser to redraw the current item. Do this if you know it has
changed appearance. This is better than redrawing the entire browser because
it will blink a lot less.

=cut

void
fltk::Browser::damage_item ( fltk::Browser::Mark * mark = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->damage_item( );
    CASE:
        CODE:
            THIS->damage_item( * mark );

=for apidoc ||bool okay|set_item_opened|bool value|

If the current item is a parent, set the open state (the
L<FLTK::STATE|FLTK/"STATE"> flags) to the given value and redraw the browser
correctly. Returns C<true> if the state was actually changed, returns C<false>
if it was already in that state.

=for apidoc ||bool okay|set_item_visible|bool value|

Turn off or on the LC<FLTK::INVISIBLE>|FLTK/"INVISIBLE"> flag on the given
item and redraw the browser if necessary. Returns C<true> if the state was
actually changed, returns C<false> if it was already in that state.

=cut

bool
fltk::Browser::set_item_opened ( bool value )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = THIS->set_item_opened( value );
            case 1: RETVAL = THIS->set_item_visible( value );
        }
    OUTPUT:
        RETVAL
    ALIAS:
        set_item_visible = 1

=for apidoc ||int level|current_level||

Return the nesting level of the current item (how many parents it has).

=for apidoc ||int y|current_position||

Return the C<y> position, in pixels, of the top edge of the current item. You
may also want the height, which is in L<C<item_h()>|/"item_h">.

=for apidoc ||int level|focus_level||

Return the nesting level of the focus (how many parents it has). The focus is
the selected item the user sees.

=for apidoc ||int y|focus_position||

Return the C<y> position, in pixels, of the top edge of the focus item. You
may also want the height, which is in L<C<goto_focus()>|/"goto_focus">C<; >
L<C<item_h()>|/"item_h">.

=for apidoc ||int col|selected_column||

Returns the currently selected column.

=cut

int
fltk::Browser::current_level ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = THIS->current_level( );    break;
            case 1: RETVAL = THIS->current_position( ); break;
            case 2: RETVAL = THIS->focus_level( );      break;
            case 3: RETVAL = THIS->focus_position( );   break;
            case 4: RETVAL = THIS->selected_column( );  break;
            case 5: RETVAL = THIS->nheader( );          break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        current_position = 1
             focus_level = 2
          focus_positoin = 3
         selected_column = 4
                 nheader = 5

=for apidoc ||AV * indexes|current_index||

Return an array of C<L<current_level()|/"current_level">+1> indexes saying
which child at each level includes the current item.

=for apidoc ||AV * indexes|focus_index||

Return an array of L<C<focus_level()>|/"focus_level">C<+1> indexes saying
which child at each level includes the focus.

=cut

AV *
fltk::Browser::current_index ( )
    CODE:
        RETVAL = newAV( );
        sv_2mortal((SV*)RETVAL);
        const int * ret;
        switch( ix ) {
            case 0: ret = THIS->current_index( ); break;
            case 1: ret = THIS->focus_index( );   break;
        }
        int i = 0;
        while ( ret[ i ] )
            av_push( RETVAL, newSViv( ret[ i++ ] ) );
    OUTPUT:
        RETVAL
    ALIAS:
        focus_index = 1

=for apidoc ||AV * widths|column_widths||



=for apidoc |||column_widths|int col1|int ...|int col\d|

Sets the horizontal locations that each C<'\t'> character in an item should
start printing text at. These are measured from the left edge of the browser,
including any area for the open/close + glyphs.

You can define flexible column by setting column width to -1. If you have
flexible column in browser, all columns are resized to match width of the
browser, by resizing flexible column.

X<zero width column list termination>
Note that a zero (C<0>) will terminate the list of columns.

=over

=item Example 1

  @widths   = [ 100, 100, 100 ];

Make three columns, total width of columns is 300 pixels. Columns are
resizable, but total width is kept always.

=item Example 2

  @widths = [ 100, 100, -1 ];

Make three columns, total width of columns is always width of the browser.
Columns are resizable, third column is flexible and will take remaining space
left.

=item Example 3

  @widths = [ 250, 250, 0, 400 ];

Make two columns, total width of columns is 500 pixels. Columns are resizable,
but total width is kept always.

=back

=cut

AV *
fltk::Browser::column_widths ( int col1 = NO_INIT, ... )
    CASE: items == 1
        CODE:
            RETVAL = newAV( );
            sv_2mortal((SV*)RETVAL);
            const int * ret = THIS->column_widths( );
            int i = 0;
            if ( ret )
                while ( ret[ i ] )
                    av_push( RETVAL, newSViv( ret[ i++ ] ) );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            int args[ items - 1 ];
            for ( int n = 1; n < items; n++ )
                args[ n - 1 ] = (int) SvIV( ST( n ) );
            args[ items - 1 ] = 0;
            THIS->column_widths( args );

=for apidoc ||AV * labels|column_labels||

Get the list of labels at the top of browser.

=for apidoc |||column_labels|char * col1|char * ...|char * col\d|

Set the list of labels to put at the top of the browser. The initial sizes of
them are set with L<C<column_widths()>|/"column_widths">. Items in the browser
can print into the correct columns by putting C<\t> characters into their
text. Or they can look at L<C<FLTK::column_widths()>|FLTK/"column_widths"> to
find the settings from their L<C<draw()>|/"draw"> methods.

=cut

AV *
fltk::Browser::column_labels ( char * col1 = NO_INIT, ... )
    CASE: items == 1
        CODE:
            RETVAL = newAV( );
            sv_2mortal((SV*)RETVAL);
            const char ** ret = THIS->column_labels( );
            int i = 0;
            if ( ret )
                while ( ret[ i ] )
                    av_push( RETVAL, newSVpv( ret[ i++ ], 0 ) );
        OUTPUT:
            RETVAL
    CASE: items > 1
        CODE:
            char ** labels = new char * [ items - 1 ];
            for ( int n = 0; n < items - 1; n++ )
                labels[ n ] = (char *) SvPV_nolen( ST( n + 1 ) );
            labels[items - 1] = 0;
            THIS->column_labels( (const char **) labels );

=for apidoc ||int column|set_column_start|int column|int x|



=cut

int
fltk::Browser::set_column_start ( int column, int x )

=for apidoc ||FLTK::Widget * element|header|int column|

Returns the L<Widget|FLTK::Widget> in C<column>, starting from index C<0>. If
C<column>'th column is invalid, C<undef> is returned.

=cut

fltk::Widget *
fltk::Browser::header( int column )

=for apidoc |||value|int val|

Same as C<goto_index(val);set_focus();>, to change the current item in a
non-hierarchial browser.

=for apidoc ||int val|value||

Returns C<focus_index(val)[0]>, to get the current item in a non-hierarchial
browser.

=cut

int
fltk::Browser::value( int val = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->value( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->value( val );

=for apidoc x||bool selected|selected|int line|

Does C<goto_index(line),item_selected()> to return the selection state of an
item in a non-hierarchial MultiBrowser. If C<line> is out of range it returns
false.

Note: This is an FLTK 1.0 emulation method.

=cut

bool
fltk::Browser::selected( int line )

=for apidoc ||int line|topline||

Convenience function for non-hierarchial browsers. Returns the index if the
top-level item that is at the top of the scrolling window.

=for apidoc |||topline|int line|

Convenience function for non-hierarchial browsers. Make the indexed item
visible and scroll to put it at the top of the browser.

=cut

int
fltk::Browser::topline( int line = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->topline( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->topline( line );

=for apidoc |||bottomline|int line|

Convenience function for non-hierarchial browsers. Make the indexed item
visible and scroll to put it at the bottom of the browser.

=for apidoc |||middleline|int line|

Convenience function for non-hierarchial browsers. Make the indexed item
visible and scroll to put it in the middle of the browser if it is not already
visible (passes C<NO_SCROLL> to
L<C<make_item_visible()>|/"make_item_visible">.

=cut

void
fltk::Browser::bottomline ( int line )
    CODE:
        switch( ix ) {
            case 0: THIS->bottomline ( line ); break;
            case 1: THIS->middleline ( line ); break;
        }
    ALIAS:
        middleline = 1

=for apidoc ||bool visible|displayed|int line|

Convenience function for non-hierarchial browsers. Make the indexed item
visible and scroll to put it at the bottom of the browser.

=cut

bool
fltk::Browser::displayed( int line )

=for apidoc ||bool visible|display|int line|bool value = true|

Convenience function for non-hierarchial browsers. Make the indexed item be
L<C<visible()>|/"visible"> and scroll the browser so it can be seen by the
user.

=cut

bool
fltk::Browser::display( int line, bool value = true )

=for apidoc ||bool display|display_lines||

Accessor (get) method which returns a true value if lines should be displayed,
or a false value otherwize.

=for apidoc |||display_lines|bool display|

Accessor (set) method which is used to set the value of the C<displaylines_>
member. If you set C<display> to a false value, it will mean that you do not
want lines of the tree to be displayed.

=cut

bool
fltk::Browser::display_lines ( bool display = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->display_lines( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->display_lines( display );

=for apidoc ||int total|load|char * filename|



=cut

int
fltk::Browser::load( char * filename )

=for apidoc ||int total|multi||



=cut

int
fltk::Browser::multi( )

=for apidoc ||FLTK::Symbol l_symbol|leaf_symbol||

Returns the default value for L<C<image()>|/"image"> on each item that is not
a parent of other items. If the item has no L<C<image()>|/"image"> then this
one is used for it.

=for apidoc |||leaf_symbol|FLTK::Symbol * symbol|

Sets a default value for L<C<image()>|/"image"> on each item that is not a
parent of other items. If the item has no L<C<image()>|/"image"> then this one
is used for it.

=for apidoc ||FLTK::Symbol g_symbol|group_symbol||

Returns the default value for L<C<image()>|/"image"> on each item that is a
hierarchy parent. If the parent item has no L<C<image()>|/"image"> then this
one is used for it.

=for apidoc |||group_symbol|FLTK::Symbol * symbol|

Sets a default value for L<C<image()>|/"image"> on each item that is a
hierarchy parent. If the parent item has no L<C<image()>|/"image"> then this
one is used for it.

=cut

fltk::Symbol *
fltk::Browser::leaf_symbol( fltk::Symbol * symbol = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = (fltk::Symbol *) THIS->leaf_symbol( );  break;
                case 1: RETVAL = (fltk::Symbol *) THIS->group_symbol( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->leaf_symbol( symbol );  break;
                case 1: THIS->group_symbol( symbol ); break;
            }
    ALIAS:
        group_symbol = 1

#INCLUDE: Browser/Mark.xsi

#INCLUDE: MultiBrowser.xsi

#endif // ifndef DISABLE_BROWSER

BOOT:
    isa("FLTK::Browser", "FLTK::Menu");
