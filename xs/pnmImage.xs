#include "include/FLTK_pm.h"

MODULE = FLTK::pnmImage               PACKAGE = FLTK::pnmImage

#ifndef DISABLE_PNMIMAGE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::pnmImage - PNM image support for the Fast Light Tool Kit

=head1 Description

PNM (Portable Any Map) is a raster image format and includes the PBM
(monochrome), PGM (gray-level) and PPM (RGB color) image formats. PNM's may be
stored in either ASCII or binary format.

=begin apidoc

=cut

#include <fltk/pnmImage.h>

=for apidoc ||FLTK::pnmImage * self|new|char * filename|

Creates a new L<FLTK::pnmImage|FLTK::pnmImage>.

=cut

fltk::pnmImage *
fltk::pnmImage::new( char * filename )

#endif // ifndef DISABLE_PNMIMAGE

BOOT:
    isa("FLTK::pnmImage", "FLTK::SharedImage");
