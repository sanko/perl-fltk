#include "include/FLTK_pm.h"

MODULE = FLTK::ccHueBox               PACKAGE = FLTK::ccHueBox

#ifndef DISABLE_CCHUEBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ccHueBox - Part of the FLTK::ColorChooser megawidget

=head1 Description



=cut

#include <fltk/ColorChooser.h>

=for apidoc ||FLTK::ccHueBox hb|new|int x|int y|int w|int h|



=cut

#include "include/RectangleSubclass.h"

fltk::ccHueBox *
fltk::ccHueBox::new( int x, int y, int w, int h )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ccHueBox>(CLASS,x,y,w,h);
    OUTPUT:
        RETVAL

#endif // #ifndef DISABLE_CCHUEBOX

BOOT:
    isa("FLTK::ccHueBox", "FLTK::Widget");
