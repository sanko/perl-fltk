#include "include/FLTK_pm.h"

MODULE = FLTK::ccValueBox               PACKAGE = FLTK::ccValueBox

#ifndef DISABLE_CCVALUEBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ccValueBox - Part of the FLTK::ColorChooser megawidget

=head1 Description



=cut

#include <fltk/ColorChooser.h>

=for apidoc ||FLTK::ccValueBox vb|new|int x|int y|int w|int h|



=cut

#include "include/RectangleSubclass.h"

fltk::ccValueBox *
fltk::ccValueBox::new( int x, int y, int w, int h )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ccValueBox>(CLASS,x,y,w,h);
    OUTPUT:
        RETVAL

#endif // #ifndef DISABLE_CCVALUEBOX

BOOT:
    isa("FLTK::ccValueBox", "FLTK::Widget");
