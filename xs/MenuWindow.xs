#include "include/FLTK_pm.h"

MODULE = FLTK::MenuWindow               PACKAGE = FLTK::MenuWindow

#ifndef DISABLE_MENUWINDOW

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::MenuWindow - Temporary, unmovable popup window

=head1 Description

This is the window type used by L<Menu|FLTK::Menu> to make the pop-ups, and
for tooltip popups. It will send special information to the window server to
indicate that the windows are temporary, won't move, and should not have any
decorations.

On X this turns on C<override_redirect> and save-under and thus avoids the
window manager.

=cut

#include <fltk/MenuWindow.h>

=begin apidoc

=for apidoc ||FLTK::MenuWindow * self|new|int x|int y|int w|int h|char * label = ''|



=for apidoc ||FLTK::MenuWindow * self|new|int w|int h|char * label = ''|



=cut

#include "include/WidgetSubclass.h"

void
fltk::MenuWindow::new( int x, int y, w = 0, int h = 0, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        if ( items <= 4 ) {
            if ( items == 4 )
                label = SvPV_nolen( ST( 3 ) );
            RETVAL = ( void * ) new WidgetSubclass<fltk::MenuWindow>(CLASS,x,y,label);
        }
        else {
            int w = (int)SvIV(ST(3));
            RETVAL = (void *) new WidgetSubclass<fltk::MenuWindow>(CLASS,x,y,w,h,label);
        }
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||FLTK::NamedStyle * style|default_style||||

The default style sets L<C<box()>|FLTK::Widget/"box"> to C<UP_BOX>. This box
is used around all popup menus.

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::MenuWindow::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=for apidoc ||int can_haz_overlay|overlay||



=cut

int
fltk::MenuWindow::overlay( )

=for apidoc |||set_overlay||

Undoes L<C<clear_overlay()>|FLTK::MenuWindow/"clear_overlay">.

=cut

void
fltk::MenuWindow::set_overlay( )

=for apidoc |||clear_overlay||

Tells FLTK to not try to use the overlay hardware planes. This is disabled
except on Irix. On Irix you will have to call this if you want to draw colored
images in the popup.

=cut

void
fltk::MenuWindow::clear_overlay( )

#endif // ifndef DISABLE_MENUWINDOW

BOOT:
    isa("FLTK::MenuWindow", "FLTK::Window");
