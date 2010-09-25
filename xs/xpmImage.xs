#include "include/FLTK_pm.h"

MODULE = FLTK::xpmImage               PACKAGE = FLTK::xpmImage

#ifndef DISABLE_XPMIMAGE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.531

=for git $Id$

=head1 NAME

FLTK::xpmImage - Image subclass that draws the data from an xpm format file

=head1 Description

Draws inline XPM data. This is a text-based 256-color image format designed
for X11 and still very useful for making small icons, since the data can be
easily inserted into your source code.

FLTK recognizes a few extensions to the xpm color map:

=over

=item * Setting the number of colors negative means the second line in the
array is a "compressed" colormap, which is 4 bytes per color of
C<character,r,g,b>.

=item * If all colors are grays and there is no transparent index, it instead
makes a MASK image, where black draws the current color and white is
transparent, and all other grays are partially transparent. This allows you to
put antialiased glyphs into images.

=back

=begin apidoc

=cut

#include <fltk/xpmImage.h>

=for apidoc ||FLTK::xpmImage * self|new|char * ...|

Creates a new L<FLTK::xpmImage|FLTK::xpmImage>.

=cut

fltk::xpmImage *
fltk::xpmImage::new( ... )
    PREINIT:
        char ** data;
        int i;
    INIT:
        data = new char * [ items - 1 ];
        for ( i = 1; i < items; i++ )
            data[ i - 1 ] = SvPV_nolen( ST( i ) );
    C_ARGS: ( const char ** ) data
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_XPMIMAGE

BOOT:
    isa("FLTK::xpmImage", "FLTK::Image");
