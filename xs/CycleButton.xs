#include "include/FLTK_pm.h"

MODULE = FLTK::CycleButton               PACKAGE = FLTK::CycleButton

#ifndef DISABLE_CYCLEBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::CycleButton - Popup list of items that the user can choose one of

=head1 Description

This widget lets the user select one of a set of choices by clicking on it.
Each click cycles to the next choice. Holding down any shift key or using the
middle or right mouse button cycles backwards.

Notice that the number of items can be 2. In this case this widget serves the
common purpose of a "toggle" button that shows the current on/off state by
changing it's label.

This is a subclass of L<Menu|FLTK::Menu>. The possible states are defined by
using L<C<Menu::add()>|FLTK::Menu/"add"> or other methods that define the menu
items. You can also put a different callback on each item. Or you can replace
this widget's callback with your own and use
L<C<value()>|FLTK::Widget/"value"> to get the index of the current setting.
Items that are not L<C<visible()>|FLTK::Widget/"visible"> or are not
L<C<active()>|FLTK::Widget/"active"> are skipped by the cycling.

If you set L<C<buttonbox()>|/"buttonbox"> to C<NO_BOX> then you must define
your items to draw identical-sized and fully opaque images, so that drawing
one completely obscures any other one. This was done to avoid blinking when
drawing "artistic" user interfaces where all the entire button is an image.

=cut

=begin apidoc

=cut

#include <fltk/CycleButton.h>

=for apidoc ||FLTK::CycleButton self|new|int x|int y|int w|int h|char * label = ''

Creates a new C<FLTK::CycleButton> object. Obviously.

=cut

#include "include/WidgetSubclass.h"

void
fltk::CycleButton::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::CycleButton>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal( );
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_CYCLEBUTTON

BOOT:
    isa("FLTK::CycleButton", "FLTK::Menu");
