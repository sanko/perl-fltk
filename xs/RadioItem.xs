#include "include/FLTK_pm.h"

MODULE = FLTK::RadioItem               PACKAGE = FLTK::RadioItem

#ifndef DISABLE_RADIOITEM

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::RadioItem - This widget makes a radio item in a popup or pulldown Menu

=head1 Description

This widget makes a radio item in a popup or pulldown L<Menu|FLTK::Menu>. Its
behavior in a L<Browser|FLTK::Browser> or L<MultiBrowser|FLTK::MultiBrowser>
is that it changes its status on multiple clicks (e.g. double click).

=begin apidoc

=cut

#include <fltk/RadioItem.h>

=for apidoc ||FLTK::RadioItem self|new|char * label = ""|

Unlike other widgets the constructor does not take any dimensions, since it is
assummed the container widget will size this correctly.

=for apidoc ||FLTK::RadioItem self|new|char * label|int shortcut|CV * callback = 0|SV * user_data = 0|FLTK::Flags flags = 0|

This constructor is provided to match the L<C<Menu::add()>|FLTK::Menu/"add">
function arguments. See L<C<Menu::add()>|FLTK::Menu/"add"> for more details.

=cut

#include "include/WidgetSubclass.h"

void
fltk::RadioItem::new( char * label = 0, arg2 = NO_INIT, CV * callback = NO_INIT, SV * user_data = 0, fltk::Flags flags = 0 )
    PPCODE:
        void * RETVAL = NULL;
        if ( items <= 2 )
            RETVAL = ( void * ) new WidgetSubclass<fltk::RadioItem>(CLASS,label);
        else {
            int shortcut = (int) SvIV( ST( 2 ) );
            HV   * cb    = newHV( );
            hv_store( cb, "coderef",  7, newSVsv( ST(3) ),                  0 );
            hv_store( cb, "class",    5, newSVpv( CLASS, strlen( CLASS ) ), 0 );
            if ( items >= 5 )
                hv_store( cb, "args", 4, newSVsv( user_data ),              0 );
            RETVAL = (void *) new WidgetSubclass<fltk::RadioItem>(CLASS,label,
                                            shortcut,_cb_w,(void *)cb,flags);
        }
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_RADIOITEM

BOOT:
    isa("FLTK::RadioItem", "FLTK::Item");
