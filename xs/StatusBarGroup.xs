#include "include/FLTK_pm.h"

MODULE = FLTK::StatusBarGroup               PACKAGE = FLTK::StatusBarGroup

#ifndef DISABLE_STATUSBARGROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2010, 2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::StatusBarGroup - Create and handle a StatusBar with minimum effort

=head1 Description

The L<FLTK::StatusBarGroup|FLTK::StatusBarGroup> is strip that can be put in
the bottom edge of a L<FLTK::Pack|FLTK::Pack> usually it contains a status
bar.

It features automatic positioning and resizing adapting to parent
L<FLTK::Group|FLTK::Group>/L<FLTK::Window|FLTK::Window>.

Only height matters when constructing a
L<FLTK::StatusBarGroup|FLTK::StatusBar>.

You can use the L<< C<set( )>|FLTK::StatusBarGroup/set >> API's to easily
print formatted text at one of the three standard position: C<left>,
C<center>, L<right>.

You can also setup an optional custom box to the incorporated texts with child
C<_box()>, by default C<FLAT_BOX> is used.

Here's some typical code you can use to create a status bar:

    my $status_bar = FLTK::StatusBarGroup->new();
    $status_bar->child_box(THIN_DOWN_BOX, FLTK::StatusBarGroup::SBAR_RIGHT());

    # ... more code ...
    # sets a right-aligned formatted text :
    $status_bar->set('8 items', FLTK::StatusBarGroup::SBAR_RIGHT());

    # sets a centered text:
    $status_bar->set('Hi', FLTK::StatusBarGroup::SBAR_CENTER());

    # ... more code ...
    # undef or 0-len text removes the text box:
    $status_bar->set('', FLTK::StatusBarGroup::SBAR_CENTER());

=begin apidoc

=cut

#include <fltk/StatusBarGroup.h>

=for apidoc ||FLTK::StatusBarGroup * group|new|int x|int y|int w|int h|char * label = ''|bool begin = false|

Constructor. C<x>, C<y>, and C<w> are ignored.

=for apidoc ||FLTK::StatusBarGroup * group|new|int height = 24|

Constructor.

=cut

#include "include/WidgetSubclass.h"

void
fltk::StatusBarGroup::new( int x = 24, int y = NO_INIT, int w = NO_INIT, int h = NO_INIT, char * label = 0, bool begin = false )
    PPCODE:
        void * RETVAL = NULL;
        if ( items <= 2 ) {
            RETVAL = (void *) new WidgetSubclass<fltk::StatusBarGroup>(CLASS,x);
        }
        else {
            RETVAL = (void *) new WidgetSubclass<fltk::StatusBarGroup>(CLASS,x,y,w,h,label,begin);
        }
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc |||child_box|fltk::Box * b|

Set a default box to all texts inside the status bar.

=for apidoc |||child_box|fltk::Box * b|FLTK::StatusBarGroup::Position pos

Set a default box to text a particular posiiton inside the statusbar.

=cut

void
fltk::StatusBarGroup::child_box( fltk::Box * b, fltk::StatusBarGroup::Position pos = NO_INIT )
    CASE: items == 2
        C_ARGS: b
    CASE:
        C_ARGS: b, pos

=for apidoc |||set|const char * t|FLTK::StatusBarGroup::Position pos = SBAR_RIGHT|

Set a simple string in the statusbar at a given position alignment spec.

=cut

void
fltk::StatusBarGroup::set( const char * t, fltk::StatusBarGroup::Position pos = fltk::StatusBarGroup::SBAR_RIGHT )

BOOT:
    register_constant("FLTK::StatusBarGroup", "SBAR_LEFT",   newSViv( fltk::StatusBarGroup::SBAR_LEFT   ));
    register_constant("FLTK::StatusBarGroup", "SBAR_CENTER", newSViv( fltk::StatusBarGroup::SBAR_CENTER ));
    register_constant("FLTK::StatusBarGroup", "SBAR_RIGHT",  newSViv( fltk::StatusBarGroup::SBAR_RIGHT  ));

#endif // #ifndef DISABLE_STATUSBARGROUP

BOOT:
    isa("FLTK::StatusBarGroup", "FLTK::Group");
