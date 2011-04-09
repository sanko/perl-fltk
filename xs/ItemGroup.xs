#include "include/FLTK_pm.h"

MODULE = FLTK::ItemGroup               PACKAGE = FLTK::ItemGroup

#ifndef DISABLE_ITEMGROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ItemGroup - Widget designed to be a nested list in a menu or browser

=head1 Description

This widget describes a set of items that are to be put inside a
L<FLTK::Menu|FLTK::Menu> or L<FLTK::Browser|FLTK::Browser> widget. It
indicates the title of a submenu, or a level of hierarchy in the browser. Any
child widgets are the items in that submenu, or the items under this parent in
the browser.

If this widget is told to draw, it draws just like L<FLTK::Item|FLTK::Item>
draws. See that for more details. The triangle indicating a submenu is not
drawn by this, it is drawn by the parent menu.

Because this is an L<FLTK::Menu|FLTK::Menu> subclass, you can also call
L<C<popup()>|FLTK::Menu/"popup"> and L<C<add()>|FLTK::Menu/"add"> and other
methods to manipulate the items inside it.

In a L<Browser|FLTK::Browser>, the L<C<value()>|FLTK::Browser/"value">
indicates if the widget is open or not. In a
L<C<MultiBrowser>|FLTK::MultiBrowser>, the
L<C<selected()>|FLTK::MultiBrowser/"selected"> indicates if the widget is
currently selected.

=cut

#include <fltk/ItemGroup.h>

=begin apidoc

=for apidoc ||FLTK::ItemGroup group|new|char * label = ''|bool begin = false|

Unlike other widgets the constructor does not take any dimensions since it is
assummed the container widget will size this correctly.

=for apidoc ||FLTK::ItemGroup group|new|char * label|FLTK::Symbol symbol|bool begin = false|

This constructor also sets L<C<image()>|FLTK::Widget/"image">.

=cut

#include "include/RectangleSubclass.h"

fltk::ItemGroup *
fltk::ItemGroup::new( char * label = 0, ... )
    CASE: ( items <= 3 && ! sv_isobject(ST(2)) )
        CODE:
            bool begin;
            begin = (bool)SvTRUE(ST(2));
            RETVAL = new RectangleSubclass<fltk::ItemGroup>(CLASS,label,begin);
        OUTPUT:
            RETVAL
    CASE: ( items == 3 || items == 4 )
        CODE:
            fltk::Symbol * symbol;
            bool           begin;
            if (sv_isobject(ST(2)) && sv_derived_from(ST(2), "FLTK::Symbol"))
                symbol = INT2PTR( fltk::Symbol *, SvIV( ( SV * ) SvRV( ST(2) ) ) );
            else
                croak( "%s: %s is not of type %s", GvNAME(CvGV(cv)), "symbol",
                                                            "FLTK::Symbol" );
            begin = (bool)SvTRUE(ST(4));
            RETVAL = new RectangleSubclass<fltk::ItemGroup>(CLASS,label,symbol,begin);
        OUTPUT:
            RETVAL

#endif // ifndef DISABLE_ITEMGROUP

BOOT:
    isa("FLTK::ItemGroup", "FLTK::Menu");
