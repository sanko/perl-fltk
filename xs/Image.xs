#include "include/FLTK_pm.h"

MODULE = FLTK::Image               PACKAGE = FLTK::Image

#ifndef DISABLE_IMAGE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Image - Basic image handling

=head1 Description

A rectangular buffer of pixels that can be efficiently drawn on the screen.
The L<C<draw()>|/"draw"> functions will copy (or "over" composite if there is
alpha in the L<C<pixeltype()>|/"pixeltype">) onto the output, transformed by
the current transform.

NOTE: If you already have a set of pixels sitting in your own memory,
L<C<drawimage()>|/"drawimage"> can draw it and is \e much easier to use. You
should use this class I<only> if you will be drawing the I<same> image
multiple times, with no changes to the pixels.

The buffer is created and filled in by setting the type of pixels with
L<C<setpixeltype()>|/"setpixeltype">, the size with
L<C<setsize()>|/"setsize">, and then calling L<C<buffer()>|/"buffer"> (note
that L<C<setpixels()>|/"setpixels"> calls L<C<buffer()>|/"buffer"> for you).
The initial buffer is filled with undefined contents.

The best way to put data into the buffer is to make one or more calls to
L<C<setpixels()>|/"setpixels">, to replace rectangular regions.

You can directly address the L<C<buffer()>|/"buffer"> to read and write the
pixels. The size of the buffer is in L<C<buffer_width()>|/"buffer_width"> and
L<C<buffer_height()>|/"buffer_height"> (this may be much larger than
L<C<width()>|/"width"> and L<C<height()>|/"height">) and the distance between
lines is in L<C<buffer_linedelta()>|/"buffer_linedelta">. If you change any
pixels you should call L<C<buffer_changed()>|/"buffer_changed"> before the
next L<C<draw()>|/"draw">.

Due to operating system limitations, L<C<buffer()>|/"buffer"> is usually not
an array of L<C<pixeltype()>|/"pixeltype"> pixels. Instead
L<C<setpixels()>|/"setpixels"> converts pixels into a type the operating
system can use. The type of pixels in the buffer is retured by
L<C<buffer_pixeltype()>|/"buffer_pixeltype">. This is really inconvienent, so
you can also call the method L<C<force_ARGB32()>|/"force_ARGB32">. This will
cause L<C<buffer_pixeltype()>|/"buffer_pixeltype"> to return C<ARGB32>, so you
can assume this at compile time. The implementation of L<Image|FLTK::Image>
may be less efficient (actually the overhead is zero on Windows and close to
zero on most other systems).

If L<C<buffer()>|/"buffer"> has not been called, L<C<draw()>|/"draw"> will
call the L<C<fetch()>|/"fetch"> virtual method. It should call
L<C<setpixeltype()>|/"setpixeltype">, L<C<setsize()>|/"setsize"> and
L<C<setpixels()>|/"setpixels">. This is used to defer reading image files or
decompressing data until needed. L<C<fetch()>|/"fetch"> will also restore the
buffer contents to the original values if you have written to the buffer. If
L<C<fetch()>|/"fetch"> does not allocate a buffer, L<C<draw()>|/"draw"> will
draw a solid rectangle in the current color.

Because L<Image|FLTK::Image> is a subclass of L<Symbol|FLTK::Symbol>, it may
be used as a L<C<Widget::image()>|FLTK::Widget/"image"> or as the
L<C<box()>|FLTK::Style/"box"> in a L<Style|FLTK::Style>. If you give it a name
it can be drawn with C<@name;> in a label. If resized, the
L<C<Symbol::_draw()>|FLTK::Symbol/"_draw"> method will use the
L<C<inset()>|/"inset"> call to decide on edge thicknesses and will dice the
image up into 9 individually-scaled pieces, which is very useful for GUI
buttons and background images (this is similar to how Flash draws buttons).

There are a number of subclasses such as L<jpgImage|FLTK::jpgImage> and
L<pngImage|FLTK::pngImage> that display compressed image data, either from
in-memory data buffers or from files.

=begin apidoc

=cut

#include <fltk/Image.h>

=for apidoc ||FLTK::Image self|new|char * name = ''|

The default constructor sets L<C<pixeltype()>|/"pixeltype"> to C<RGB32>
(0x00rrggbb) and L<C<width()>|/"width"> and L<C<height()>|/"height"> to 12.
This means that 12x12 square with the current color will be drawn if not able
to draw anything else.

The optional C<name> is passed to the L<Symbol|FLTK::Symbol/"new"> constructor
and allows the image to be drawn by putting C<@name;> into a label.

=cut

fltk::Image *
fltk::Image::new( ... )
    CASE: ( items == 1 || items == 2 )
        CODE:
            char *	name = 0;
            if ( items == 2 )
                name = (char *) SvPV_nolen( ST( 1 ) );
            RETVAL = new fltk::Image( name ); /* char * name = 0 */
        OUTPUT:
            RETVAL
    CASE: ( ( items == 3 || items == 4 ) )
        CODE:
            int w = (int) SvIV( ST( 1 ) );
            int h = (int) SvIV( ST( 2 ) );
            char * name = 0;
            if ( items == 4 )
                name = (char *) SvPV_nolen( ST( 3 ) );
            RETVAL = new fltk::Image( w, h, name ); /* int w, int h, char * name = 0 */
        OUTPUT:
            RETVAL
    CASE: ( ( items == 4 || items == 5 ) && sv_isobject( ST( 1 ) ) )
        CODE:
            if ( sv_derived_from(ST(1), "FLTK::PixelType")) { /* -- hand rolled -- */
                fltk::PixelType p = INT2PTR(fltk::PixelType,SvIV((SV*)SvRV(ST(1))));
                int    w    = (int) SvIV( ST( 2 ) );
                int    h    = (int) SvIV( ST( 3 ) );
                char * name = 0;
                if ( items == 5 )
                    name = (char *) SvPV_nolen( ST( 4 ) );
                RETVAL   = new fltk::Image( p, w, h, name ); /* PixelType p, int w, int h, const char* name=0 */
            }
        OUTPUT:
            RETVAL
    CASE: ( items == 5 ) && (sv_derived_from(ST( 2 ), "FLTK::PixelType")) /* TODO: untested */
        CODE:
            uchar *   d = (uchar *) SvPV_nolen( ST( 1 ) );
            fltk::PixelType p = INT2PTR(fltk::PixelType,SvIV((SV*)SvRV(ST(2))));
            int       w = (int) SvIV( ST( 3 ) );
            int       h = (int) SvIV( ST( 4 ) );
            RETVAL      = new fltk::Image( d, p, w, h ); /* const uchar* d, PixelType p, int w, int h */
        OUTPUT:
            RETVAL
    CASE: ( items == 6 ) && (sv_derived_from(ST( 2 ), "FLTK::PixelType")) /* TODO: untested */
        CODE:
            uchar *         d = (uchar *) SvPV_nolen( ST( 1 ) );
            fltk::PixelType p = INT2PTR(fltk::PixelType,SvIV((SV*)SvRV(ST(2))));
            int             w = (int) SvIV( ST( 3 ) );
            int             h = (int) SvIV( ST( 4 ) );
            int     linedelta = (int) SvIV( ST( 5 ) );
            RETVAL            = new fltk::Image( d, p, w, h, linedelta ); /* const uchar* d, PixelType p, int w, int h, int linedelta */
        OUTPUT:
            RETVAL

=for apidoc ||FLTK::PixelType type|pixeltype||

Returns the type of pixels that are put into the image with
L<C<setpixels()>|/"setpixels">. You can change this with
L<C<setpixeltype()>|/"setpixeltype">. It is possible the internal data is in a
different type, use L<C<buffer_pixeltype()>|/"buffer_pixeltype"> to find out
what that is.

=cut

fltk::PixelType
fltk::Image::pixeltype( )

=for apidoc ||int d|depth||

Same as L<C<FLTK::depth($img-E<gt>pixeltype())>|FLTK/"depth">, this returns
how many bytes each pixel takes in the buffer sent to
L<C<setpixels()>|/"setpixels">.

=for apidoc ||int w|width||

Return the width of the image in pixels. You can change this with
L<C<setsize()>|/"setsize">.

=for apidoc U||int width|w||

Same as L<C<width()>|/"width">.

=for apidoc ||int h|height||

Return the height of the image in pixels. You can change this with
<C<setsize()>|/"setsize">.

=for apidoc U||int height|h||

Same as L<C<height()>|/"height">.

=cut

int
fltk::Image::depth( )

int
fltk::Image::width( )
    ALIAS:
        w = 1

int
fltk::Image::height( )
    ALIAS:
        h = 1

=for apidoc |||setpixeltype|FLTK::PixelType pixeltype|

Change the stored pixeltype. If it is not compatable then the
L<Image|FLTK::Image> is destroyed.

=cut

void
fltk::Image::setpixeltype( fltk::PixelType pixeltype )

=for apidoc |||setsize|int w|int h|

Change the size of the stored image. If it is not compatable with the current
data size (generally if it is larger) then the L<Image|FLTK::Image> is
destroyed.

=cut

void
fltk::Image::setsize( int w, int h )

=for apidoc |||setpixels|uchar * data|FLTK::Rectangle rect|int linedelta|

Replace the given rectangle of L<C<buffer()>|/"buffer"> with the supplied
data, which must be in the L<C<pixeltype()>|/"pixeltype">. C<linedelta> is the
distance between each row of pixels in C<data>. The rectangle is assummed to
fit inside the L<C<width()>|/"width"> and L<C<height()>|/"height">.

=for apidoc |||setpixels|uchar * data|FLTK::Rectangle rect|

Figures out the linedelta for you as C<$image->depth() * $rect->w()>.

=for apidoc |||setpixels|uchar * data|int y|

Same as
L<C<$image-E<gt>setpixels($data, FLTK::Rectangle-E<gt>new(0, $y, $image-E<gt>width(), 1))>|/"setpixels">,
sets one entire row of pixels.

=cut

void
fltk::Image::setpixels( uchar * data, rect, int linedelta = NO_INIT )
    CASE: items == 3 && SvIOK( ST( 2 ) )
        int rect
        C_ARGS: data, rect
    CASE: items == 3
        fltk::Rectangle * rect
        C_ARGS: data, * rect
    CASE: items == 4
        fltk::Rectangle * rect
        C_ARGS: data, * rect, linedelta

=for apidoc ||char * data|linebuffer|int y|

Return a pointer to a buffer that you can write up to L<C<width()>|/"width">
pixels in L<C<pixeltype()>|/"pixeltype"> to and then call
L<C<setpixels($buffer, $y)>|/"setpixels"> with. This can avoid doing any
copying of the data if the internal format and L<C<pixeltype()>|/"pixeltype">
are compatable, because it will return a pointer directly into the buffer and
setpixels will detect this and do nothing.

=cut

char *
fltk::Image::linebuffer( int y )
    CODE:
        RETVAL = (char *) THIS->linebuffer( y ); /* XXX - ParseXS can't cast uchar* as char* ...ugh. */
    OUTPUT:
        RETVAL

=for apidoc |||setimage|uchar * source|FLTK::PixelType pixeltype|int w|int h|int linedelta|

This is equivalent to...

  $image->setsize( $w, $h );
  $image->setpixeltype( $p );
  $image->setpixels( $source, FLTK::Rectangle->new( $w, $h ), $iamge->linedelta );

...except, if possible, C<source> is used as L<C<buffer()>|/"buffer">
(throwing away the current data!). This will happen if the C<pixeltype> and
C<linedelta> are of types that it can handle unchanged and if the image memory
does not need to be allocated by the system.

=for apidoc |||setimage|uchar * source|FLTK::PixelType pixeltype|int w|int h|

Figures out C<$linedelta> for you as C<$w * $image-E<gt>depth($p)>.

=cut

void
fltk::Image::setimage( uchar * source, fltk::PixelType pixeltype, int w, int h, int linedelta = NO_INIT )
    CASE: items == 5
        C_ARGS: source, pixeltype, w, h
    CASE: items == 6
        C_ARGS: source, pixeltype, w, h, linedelta

=for apidoc ||char * data|buffer||

Creates (if necessary) and returns a pointer to the internal pixel buffer.
This is probably going to be shared memory with the graphics system, it may
have a different pixeltype, size, and linedelta than the
L<C<Image>|FLTK::Image>. If you are able to figure out the type you can read
and write the pixels directly.

=cut

char *
fltk::Image::buffer( )
    CODE:
        RETVAL = (char *) THIS->buffer( ); /* XXX - ParseXS can't cast uchar* as char* ...ugh. */
    OUTPUT:
        RETVAL

=for apidoc |||set_forceARGB32||

It pretty much does this already except for mono.

=for apidoc |||clear_forceARGB32||


=cut

void
fltk::Image::set_forceARGB32( )

void
fltk::Image::clear_forceARGB32( )

=for apidoc ||bool ret|forceARGB32||



=cut

bool
fltk::Image::forceARGB32( )

=for apidoc ||FLTK::PixelType pt|buffer_pixeltype||

Return the type of pixels stored in L<C<buffer()>|/"buffer">. Likely to be
C<ARGB32>. On older (non-XRender) X system the types 1 and 2 indicate 1 and
2-byte data, but there is no api to figure out anything more about this data.

=cut

fltk::PixelType
fltk::Image::buffer_pixeltype( )

=for apidoc ||int depth|buffer_depth||

Returns the number of bytes per pixel stored in L<C<buffer()>|/"buffer">. This
is the same as L<C<depth(buffer_pixeltype())>|FLTK/"depth">.

=for apidoc ||int width|buffer_width||

Return the width in pixels of L<C<buffer()>|/"buffer">.

=for apidoc ||int height|buffer_height||

Return the height in pixels of L<C<buffer()>|/"buffer">;

=for apidoc ||int distance|buffer_linedelta||

Return the distance between each row of pixels in L<C<buffer()>|/"buffer">.

=cut

int
fltk::Image::buffer_depth( )

int
fltk::Image::buffer_width( )

int
fltk::Image::buffer_height( )

int
fltk::Image::buffer_linedelta( )

=for apidoc |||buffer_changed|||

Call this if you modify the contents of L<C<buffer()>|/"buffer">. On some
systems the memory is not actually shared with the window system, and this
will cause L<C<draw()>|/"draw"> to copy the buffer to the system's memory.
L<C<setpixels()>|/"setpixels"> calls this for you.

=cut

void
fltk::Image::buffer_changed( )

=for apidoc |||destroy||

Destroys the L<C<buffer()>|/"buffer"> and any related system structures.

=cut

void
fltk::Image::destroy( )
    CODE:
        delete THIS;
        sv_setsv(ST(0), &PL_sv_undef);

=for apidoc |||draw|int x|int y|

Does L<C<measure()>|/"measure"> and then
C<$image-E<gt>draw(FLTK::Rectangle-E<gt>new( 0, 0, $w, $h), FLTK::Rectangle-E<gt>new( ( $x, $y, $w, $h ) )>.
Thus the top-left corner is placed at C<$x, $y> and no scaling (other than due
to the current transformation) is done.

=for apidoc |||draw|FLTK::Rectangle rect|

Resizes the image to fit in the rectangle. This is what is called if the image
is used as a label or box type.

If the destination rectangle is not the same size, L<C<inset()>|/"inset"> is
used to figure out the edge thicknesses. The image is then diced into 9
rectangles in a 3x3 grid by the insets, and each piece is scaled individually.
This is very useful for scaling paintings of buttons. Note that if the insets
are zero (the default) then the whole image is scaled as one piece. If you
want, L<C<inset()>|/"inset"> can return different thicknesses depending on the
size, producing very interesting scaling.

It is possible this will use L<C<drawflags(INACTIVE)>|/"drawflags"> to gray
out the image in a system-specific way.

=for apidoc |||draw|FLTK::Rectangle from|FLTK::Rectangle destination|

Draws the subrectangle C<from> of the image, transformed to fill the rectangle
C<destination> (as transformed by the CTM). If the image has an alpha channel,
an "over" operation is done.

Due to lame graphics systems, this is not fully operational on all systems:

=over

=item * X11 without XRender extension: no transformations are done, the image
is centered in the output area.


=item * X11 with XRender: rotations fill the bounding box of the destination
rectangle, drawing extra triangular areas outside the source rectangle.
Somewhat bad filtering when making images smaller. xbmImage does
not transform.

=item * Windows: Only scaling, no rotations. Bad filtering.
L<xbmImage|FLTK::xbmImage> does not do any transformations.

=item * OS/X: works well in all cases.

=back

=cut

void
fltk::Image::draw( from, destination = NO_INIT )
    CASE: items == 2
        fltk::Rectangle * from
        C_ARGS: * from
    CASE: (items == 3) && SvIOK( ST( 1 ) ) && SvIOK( ST( 2 ) )
        int from
        int destination
        C_ARGS: from, destination
    CASE: items == 3
        fltk::Rectangle * from
        fltk::Rectangle * destination
        C_ARGS: * from, * destination

=for apidoc ||bool filled|fills_rectangle||

Returns true if hte pixeltype does not support alpha.

=cut

bool
fltk::Image::fills_rectangle( )

=for apidoc |||fetch_if_needed||

Call L<C<fetch()>|/"fetch"> if it has not been called or if
L<C<refetch()>|/"refetch"> was called.

=cut

void
fltk::Image::fetch_if_needed( )

=for apidoc |||refetch||

Cause L<C<fetch()>|/"fetch"> to be called again. This is useful for a file
image if the file name or contents have changed.

=cut

void
fltk::Image::refetch( )

=for apidoc ||unsigned long bytes|mem_used||

Returns how much memory the image is using for L<C<buffer()>|/"buffer"> and
for any other structures it created. Returns zero if L<C<buffer()>|/"buffer">
has not been called.

=cut

unsigned long
fltk::Image::mem_used( )

=for apidoc ||unsigned long bytes|total_mem_used||

Sum of all L<C<mem_used()>|/"mem_used"> calls to all L<C<Images>|FLTK::Image>.
This is used by L<SharedImage|FLTK::SharedImage> to decide when to clear out
cached images.

=cut

unsigned long
fltk::Image::total_mem_used( )

=for apidoc |||make_current||

See L<GSave|FLTK::GSave>.

=cut

void
fltk::Image::make_current( )

=end apidoc

=head1 See Also

=over

=item L<drawimage()|FLTK::draw/"drawimage">

=back

=cut

#INCLUDE: xpmImage.xsi

#endif // ifndef DISABLE_IMAGE

BOOT:
    isa("FLTK::Image", "FLTK::Symbol");
