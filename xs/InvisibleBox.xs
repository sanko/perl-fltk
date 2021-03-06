#include "include/FLTK_pm.h"

MODULE = FLTK::InvisibleBox               PACKAGE = FLTK::InvisibleBox

#ifndef DISABLE_INVISIBLEBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::InvisibleBox - Standard mime trap

=head1 Description

This is a box that is invisible due to not having a box. The label still
prints so it can be used to position labels. Also this is useful as a
L<C<resizable()>|FLTK::Widget/"resizable"> widget.

=cut

#include <fltk/InvisibleBox.h>

#include <fltk/Symbol.h>

=begin apidoc

=for apidoc ||FLTK::InvisibleBox * box|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::InvisibleBox> object. Obviously.

=for apidoc ||FLTK::InvisibleBox * box|new|int x|int y|int w|int h|char * label|FLTK::Box * box|

Creates a new C<FLTK::InvisibleBox> object based on an existing
L<Box|FLTK::Box>.

Note that the order of parameters is different than the same constructor in
FLTK's C++ API.

=cut

#include "include/RectangleSubclass.h"

fltk::InvisibleBox *
fltk::InvisibleBox::new( int x, int y, int w, int h, const char * label = 0, fltk::Box * box )
    CASE: ( items < 6 )
        CODE:
            RETVAL = new RectangleSubclass<fltk::InvisibleBox>(CLASS,x,y,w,h,label);
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = new RectangleSubclass<fltk::InvisibleBox>(CLASS,box,x,y,w,h,label);
        OUTPUT:
            RETVAL

#endif // ifndef DISABLE_INVISIBLEBOX

BOOT:
    isa("FLTK::InvisibleBox", "FLTK::Widget");
