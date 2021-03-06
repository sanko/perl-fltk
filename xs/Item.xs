#include "include/FLTK_pm.h"

MODULE = FLTK::Item               PACKAGE = FLTK::Item

#ifndef DISABLE_ITEM

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Item - Widget designed to be a menu or browser item

=head1 Description

This widget is designed to be put into L<FLTK::Menu|FLTK::Menu> and
L<FLTK::Browser|FLTK::Browser> widgets and draw plain-text items. All events
are ignored, thus causing the menu and browser to set/clear the C<SELECTED>
flag on these widgets. If they are selected they draw in the
L<C<selection_color()>|FLTK/"selection_color">, otherwise in the
L<C<color()>|FLTK::Color/"color">.

=cut

#include <fltk/Item.h>

=begin apidoc

=for apidoc ||FLTK::Item self|new|char * label = ""|

Unlike other widgets the constructor does not take any dimensions, since it is
assummed the container widget will size this correctly.

=for apidoc ||FLTK::Item self|new|char * label|FLTK::Symbol image|

This constructor also sets the L<C<image()>|FLTK::Widget/"image">, useful for
a browser item.

=for apidoc ||FLTK::Item self|new|char * label|int shortcut|CV * callback = 0|SV * user_data = 0|FLTK::Flags flags = 0|

This constructor is provided to match the L<C<Menu::add()>|FLTK::Menu/"add">
function arguments. See L<C<Menu::add()>|FLTK::Menu/"add"> for more details.

=cut

#include "include/RectangleSubclass.h"

fltk::Item *
fltk::Item::new( char * label = 0, arg2 = NO_INIT, CV * callback = NO_INIT, SV * user_data = 0, fltk::Flags flags = 0 )
    CASE: ( items <= 2 )
        CODE:
            RETVAL = new RectangleSubclass<fltk::Item>(CLASS,label);
        OUTPUT:
            RETVAL
    CASE: ( items == 3 )
        CODE:
            fltk::Symbol * symbol;
            if (sv_isobject(ST(2)) && sv_derived_from( ST( 2 ), "FLTK::Symbol" ) )
                symbol = INT2PTR( fltk::Symbol *, SvIV( ( SV * ) SvRV( ST( 2 ) ) ) );
            else
                croak( "%s: %s is not of type %s",
                    GvNAME(CvGV(cv)), "symbol", "FLTK::Symbol" );
            RETVAL = new RectangleSubclass<fltk::Item>(CLASS,label,symbol);
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            int shortcut = (int) SvIV( ST( 2 ) );
            HV   * cb    = newHV( );
            hv_store( cb, "coderef",  7, newSVsv( ST(3) ),                  0 );
            hv_store( cb, "class",    5, newSVpv( CLASS, strlen( CLASS ) ), 0 );
            if ( items >= 5 )
                hv_store( cb, "args", 4, newSVsv( user_data ),              0 );
            RETVAL = new RectangleSubclass<fltk::Item>(CLASS,label,shortcut,
                                                        _cb_w,(void *)cb,flags);
        OUTPUT:
            RETVAL

=for apidoc |||set_style|FLTK::Style style|bool menubar|

Modify the parent of the L<C<Item::default_style>|FLTK::Item/"default_style">
to this style. If no style settings have been done to an Item, it will use the
textfont, textsize, textcolor, and possibly other settings inherited from this
style to draw itself. This is used by menus and browsers to cause all the
elements inside them to draw using their settings.

The C<menubar> flag causes it to mangle the style so that the buttonbox of
C<style> is used as the box, and the highlight_color is used as the
selection_color. This is done to replicate the rather inconsistent appearance
on Windows of menubars.

Use L<C<Item::clear_style()>|FLTK::Item/"clear_style"> to put this back so
that C<style> can be deleted. This is the same as setting it to
L<C<Widget::default_style>|FLTK::Widget/"default_style">.

=for apidoc |||set_style|FLTK::Widget * widget|bool menubar|

Use the style of this C<widget>.

=cut

void
fltk::Item::set_style( style, bool menubar )
    CASE: sv_isobject(ST(1)) && sv_derived_from(ST(1), "FLTK::Style")
        fltk::Style  * style
    CASE:
        fltk::Widget * style

=for apidoc |||clear_style||

Reset the style set by calling L<C<set_style( )>|FLTK::Item/"set_style">.

=cut

void
fltk::Item::clear_style( )

=for apidoc ||FLTK::NamedStyle * style|default_style||

The default style sets C<FLAT_BOX>. Changing this will mess up the appearance
of both menus and browsers. All the rest of the style is blank, and normally
it inherits from the current browser or menu, which should call
L<C<set_style()>|FLTK::Item/"set_style"> before drawing any items.

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Item::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

#INCLUDE: RadioItem.xsi

#endif // ifndef DISABLE_ITEM

BOOT:
    isa("FLTK::Item", "FLTK::Widget");
