#include "include/FLTK_pm.h"

MODULE = FLTK::PopupMenu               PACKAGE = FLTK::PopupMenu

#ifndef DISABLE_POPUPMENU

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::PopupMenu - Group that packs all it's child widgets against the edges

=head1 Description

This subclass pops up a menu in response to a user click. The menu is popped
up positioned so that the mouse is pointing at the last-selected item, even if
it in a nested submenu (To turn off this behaivor do
L<C<value(-1)>|FLTK::Widget/"value"> after each item is selected).

Normally, any mouse button will pop up a menu and it is lined up above the
button, or below it when there is no previous selected value as shown in the
picture.

However a L<PopupMenu|FLTK::PopupMenu> can also have
L<C<type( )>|FLTK::Widget/"type"> set to C<POPUP1>, C<POPUP2>, C<POPUP12>,
C<POPUP3>, C<POPUP13>, C<POPUP23>, or C<POPUP123>. It then becomes invisible
and ignores all mouse buttons other than the ones named in the popup type. You
can then resize it to cover another widget (or many widgets) so that pressing
that button pops up the menu.

The menu will also pop up in response to shortcuts indicated by the
L<C<shortcut( )>|FLTK::Widget/"shortcut"> or by putting C<&x> in the
C<L<label( )>|FLTK::Widget/"label">.

Typing the L<shortcut|FLTK::Widget/"shortcut"> of any menu items will cause it
to be picked. The callback will be done but there will be no visible effect to
the widget.

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/PopupMenu.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

int
NORMAL( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = fltk::PopupMenu::NORMAL;   break;
            case 1: RETVAL = fltk::PopupMenu::POPUP1;   break;
            case 2: RETVAL = fltk::PopupMenu::POPUP2;   break;
            case 3: RETVAL = fltk::PopupMenu::POPUP12;  break;
            case 4: RETVAL = fltk::PopupMenu::POPUP3;   break;
            case 5: RETVAL = fltk::PopupMenu::POPUP13;  break;
            case 6: RETVAL = fltk::PopupMenu::POPUP23;  break;
            case 7: RETVAL = fltk::PopupMenu::POPUP123; break;
        }
    OUTPUT: RETVAL
    ALIAS:
          POPUP1 = 1
          POPUP2 = 2
         POPUP12 = 3
          POPUP3 = 4
         POPUP13 = 5
         POPUP23 = 6
        POPUP123 = 7

=begin apidoc

=for apidoc ||FLTK::PopupMenu mnu|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<PopupMenu|FLTK::PopupMenu>.

=cut

#include "include/WidgetSubclass.h"

void
fltk::PopupMenu::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::PopupMenu>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||int value|popup||

Wrapper for L<Menu::popup( )>|FLTK::Menu/"popup">.

For C<NORMAL>, L<PopupMenus|FLTK::PopupMenu> this places the menu over the
widget. For C<POPUP> ones it uses the mouse position and sets the "title" to
the L<C<label( )>|FLTK::Widget/"label"> if it is defined.

=cut

int
fltk::PopupMenu::popup( )

=end apidoc

=head1 Notes

The little down-arrow indicator can be replaced by setting a new
L<C<glyph( )>|FLTK::Widget/"glyph"> function and making it draw whatever you
want. If you don't want any glyph at all it is probably easiest to subclass
and replace L<C<draw( )>|FLTK::Widget/"draw"> with your own function.

=cut

#endif // ifndef DISABLE_POPUPMENU

BOOT:
    isa("FLTK::PopupMenu", "FLTK::Menu");
