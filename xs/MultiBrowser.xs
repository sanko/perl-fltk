#include "include/FLTK_pm.h"

MODULE = FLTK::MultiBrowser               PACKAGE = FLTK::MultiBrowser

#ifndef DISABLE_MULTIBROWSER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::MultiBrowser - Browser that lets the user select more than one item at a time

=head1 Description

The L<FLTK::MultiBrowser|FLTK::MultiBrowser> class is a subclass of
L<FLTK::Browser|FLTK::Browser> which lets the user select any set of the
lines. Clicking on an item selects only that one. Ctrl+click toggles items
on/off. Shift+drag (or shift+arrows) will extend selections. Normally the call
ack is done when any item changes it's state, but you can change this with
L<C<when()>|FLTK::Widget/"when">.

See L<FLTK::Browser|FLTK::Browser> for methods to control the display and
"current item", and L<FLTK::Menu|FLTK::Menu> for methods to add and remove
lines from the browser.

The methods on L<FLTK::Browser|FLTK::Browser> for controlling the "value"
control which item has the keyboard focus in a multi-browser. You must use the
"select" methods described here to change what items are turned on:

=over

=item L<C<set_item_selected()>|FLTK::Browser/"set_item_selected">

=item L<C<select_only_this()>|FLTK::Browser/"select_only_this">

=item L<C<deselect()>|FLTK::Browser/"deselect">

=item L<C<select()>|FLTK::Browser/"select">

=item L<C<selected()>|FLTK::Browser/"selected">

=back

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/MultiBrowser.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc ||FLTK::MultiBrowser * self|new|int x|int y|int w|int h|char * label = ''|



=cut

#include "include/WidgetSubclass.h"

void
fltk::MultiBrowser::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::MultiBrowser>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_MULTIBROWSER

BOOT:
    isa("FLTK::MultiBrowser", "FLTK::Browser");
