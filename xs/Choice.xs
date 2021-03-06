#include "include/FLTK_pm.h"

MODULE = FLTK::Choice               PACKAGE = FLTK::Choice

#ifndef DISABLE_CHOICE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Choice - Popup list of items that the user can choose one of

=head1 Description

Subclass of L<FLTK::Menu> that provides a button that pops up the menu, and
also displays the text of the most-recently selected menu item.

The appearance is designed to look like an "uneditable ComboBox" in Windows,
but it is somewhat different in that it does not contain a text editor, also
the menu pops up with the current item under the cursor, which is immensely
easier to use once you get used to it. This is the same UI as the Macintosh
and Motif, which called this an OptionButton.

The user can change the value by popping up the menu by clicking anywhere in
the widget and moving the cursor to a different item, or by typing up and down
arrow keys to cycle amoung the items. Typing the
L<C<FLTK::Widget::shortcut()>|FLTK::Widget/"shortcut"> of any of the items
will also change the value to that item.

If you set a L<C<shortcut()>|FLTK::Widget/"shortcut"> on this widget itself or
put C<&x> in the label, that shortcut will pop up the menu. The user can then
use arrow keys or the mouse to change the selected item.

When the user changes the L<C<value()>|/"value"> the callback is done.

If you wish to display text that is different than any of the menu items, you
may instead want an L<FLTK::PopupMenu>. It works identically but instead
displays an empty box with the label() inside it, you can then change the
L<C<label()>|/"label"> as needed.

If you want a "real" ComboBox where the user edits the text, this is a planned
addition to the L<FLTK::Input> widget. All text input will have menus of
possible replacements and completions. Not yet implemented, unfortunately.

=begin apidoc

=cut

#include <fltk/Choice.h>

=for apidoc ||FLTK::Choice * self|new|int x|int y|int w|int h|char * label = ''

The constructor makes the menu empty. See L<Menu|FLTK::Menu> and
L<StringList|FLTK::StringList> for information on how to set the menu to a
list of items.

=cut

#include "include/RectangleSubclass.h"

fltk::Choice *
fltk::Choice::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Choice>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Choice::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=for apidoc |||draw|

You can change the icon drawn on the right edge by setting
L<C<glyph()>|/"glyph"> to your own function that draws whatever you want.

=cut

#endif // ifndef DISABLE_CHOICE

BOOT:
    isa("FLTK::Choice", "FLTK::Menu");
