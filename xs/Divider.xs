#include "include/FLTK_pm.h"

MODULE = FLTK::Divider               PACKAGE = FLTK::Divider

#ifndef DISABLE_DIVIDER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::Divider - Widget to draw a divider line in a menu

=head1 Description

This widget is designed to go into L<Menu|FLTK::Menu> and
L<Browser|FLTK::Browser> widgets and draw an inset horizontal line across
them. It has the C<OUTPUT> flag set so the user cannot choose it.

=head2 Notes for subclassing

C<FLTK::Divider->handle()> must C<always> return C<0>. Items do not accept
I<any> events. Any results of clicking on them is handled by the parent
L<Menu|FLTK::Menu> or L<Browser|FLTK::Browser>.

=cut

#include <fltk/Divider.h>

=for apidoc d||FLTK::Divider div|new||

Unlike other widgets the constructor does not take any dimensions, since it is
assummed the container widget will size this correctly.

=cut

#include "include/WidgetSubclass.h"

void
Divider::new( )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::Divider>(CLASS);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_DIVIDER

BOOT:
    isa("FLTK::Divider", "FLTK::Widget");
