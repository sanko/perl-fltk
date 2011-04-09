#include "include/FLTK_pm.h"

MODULE = FLTK::ccCellBox               PACKAGE = FLTK::ccCellBox

#ifndef DISABLE_CCCELLBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ccCellBox - Part of the FLTK::ColorChooser megawidget

=head1 Description



=cut

#include <fltk/ColorChooser.h>

=for apidoc ||FLTK::ccCellBox cb|new|int x|int y|int w|int h|



=cut

#include "include/RectangleSubclass.h"

fltk::ccCellBox *
fltk::ccCellBox::new( int x, int y, int w, int h )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ccCellBox>(CLASS,x,y,w,h);
    OUTPUT:
        RETVAL

#endif // #ifndef DISABLE_CCCELLBOX

BOOT:
    isa("FLTK::ccCellBox", "FLTK::Widget");
