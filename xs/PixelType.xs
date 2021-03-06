#include "include/FLTK_pm.h"

MODULE = FLTK::PixelType               PACKAGE = FLTK::PixelType

#ifndef DISABLE_PIXELTYPE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::PixelType - Describes how colors are stored in a pixel

=head1 Description

Enumeration describing how colors are stored in an array of bytes that is a
pixel. This is used as an argument for L<drawimage()|FLTK::Image/"drawimage">,
L<readimage()|FLTK::Image/"readimage">, and L<FLTK::Image|FLTK::Image>.

Notice that the order of the bytes in memory of ARGB32 or RGB32 is C<a,r,g,b>
on a little-endian machine and C<b,g,r,a> on a big-endian machine. Due to the
use of these types by Windows, this is often the fastest form of data, if you
have a choice. To convert an L<FLTK::Color|FLTK::Color> to RGB32, shift it
right by 8 (for ARGB32 shift the alpha left 24 and or it in).

More types may be added in the future. The set is as minimal as possible while
still covering the types I have actually encountered.

=cut

#include <fltk/PixelType.h>

=head1 PixelTypes

These are the currently supported types:

=over

=item * C<MASK>

1 byte os inverted mask, filled with current color

=item * C<MONO>

1 byte of gray scale

=item * C<RGBx>

bytes in C<r,g,b,a,r,g,b,a...> order, C<a> byte is ignored

=item * C<RGB>

bytes in C<r,g,b,r,g,b...> order

=item * C<RGBA>

bytes in C<r,g,b,a,r,g,b,a...> order

=item * C<RGB32>

32-bit words containing C<0xaarrggbb> (aa is ignored)

=item * C<ARGB32>

32-bit words containing C<0xaarrggbb>

=item * C<RGBM>

Unpremultiplied bytes in C<r,g,b,a> order. Not yet implemented, acts like
RGBA.

=item * C<MRGB32>

Unpremultiplied <0xaarrggbb>. Not yet implemented, acts like ARGB32.

=back

=cut

fltk::PixelType
MASK( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::MASK;   break;
            case 1: RETVAL = fltk::MONO;   break;
            case 2: RETVAL = fltk::RGBx;   break;
            case 3: RETVAL = fltk::RGB;    break;
            case 4: RETVAL = fltk::RGBA;   break;
            case 5: RETVAL = fltk::RGB32;  break;
            case 6: RETVAL = fltk::ARGB32; break;
            case 7: RETVAL = fltk::RGBM;   break;
            case 8: RETVAL = fltk::MRGB32; break;
        }
    OUTPUT: RETVAL
    ALIAS:
          MONO = 1
          RGBx = 2
           RGB = 3
          RGBA = 4
         RGB32 = 5
        ARGB32 = 6
          RGBM = 7
        MRGB32 = 8

=begin apidoc

=for apidoc T[pixeltype]F||int d|depth|FLTK::PixelType type|

Turn a L<PixelType|FLTK::PixelType> into the number of bytes needed to hold a
pixel.

=cut

int
depth( fltk::PixelType type )

#endif // ifndef DISABLE_PIXELTYPE

BOOT:
    export_tag("depth", "pixeltype");
