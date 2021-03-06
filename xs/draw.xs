#include "include/FLTK_pm.h"

MODULE = FLTK::draw               PACKAGE = FLTK::draw

#ifndef DISABLE_DRAW

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::draw - The FLTK drawing library, used by all widgets to draw themselves

=head1 Description

The FLTK drawing library, used by all widgets to draw themselves.

These functions can only be called when FLTK is setup to draw things. This is
only true:

=over

=item * Inside the default L<C<Widget::draw()>|FLTK::Widget/"draw"> method.

=item * Inside the L<C<Symbol::draw()>|FLTK::Symbol/"draw"> function.

=item * After calling
L<C<Widget::make_current()>|FLTK::Widget/"make_current">, before calling
L<C<wait()>|FLTK/"wait"> or L<C<flush()>|FLTK/"flush">.

=back

Calling the drawing functions at other times produces undefined results,
including crashing.

=begin apidoc

=cut

#include <fltk/draw.h>

=for apidoc FT[gsave,draw]|||push_matrix|

Save the current transformation on a stack, so you can restore it with
L<C<pop_matrix()>|/"pop_matrix">.

FLTK provides an arbitrary 2-D affine transformation (rotation, scale, skew,
reflections, and translation). This is very similar to PostScript, PDF, SVG,
and Cairo.

Due to limited graphics capabilities of some systems, not all drawing
functions will be correctly transformed, except by the integer portion of the
translation. Don't rely on this as we may be fixing this without notice.

=for apidoc FT[gsave,draw]|||pop_matrix|

Put the transformation back to the way it was before the last
L<C<push_matrix()>|/"push_matrix">. Calling this without a matching
push_matrix will crash!

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
push_matrix( )
    CODE:
        fltk::push_matrix( );

void
pop_matrix( )
    CODE:
        fltk::pop_matrix( );

BOOT:
    export_tag("push_matrix", "gsave");
    export_tag("push_matrix", "draw");
    export_tag("pop_matrix", "gsave");
    export_tag("pop_matrix", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||scale|float x|

Scale the current transformation by multiplying it by

  x 0 0
  0 x 0
  0 0 1

=for apidoc FT[draw]|||scale|float x|float y|

Scale the current transformation by multiplying it by

  x 0 0
  0 y 0
  0 0 1

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
scale( float x, float y = NO_INIT )
    CASE: items == 1
        CODE:
            fltk::scale( x );
    CASE: items == 2
        CODE:
            fltk::scale( x, y );

BOOT:
    export_tag("scale", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||translate|double x|double y|

Translate the current transformation by multiplying it by

  1 0 0
  0 1 0
  x y 1

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
translate ( x, y )
    CASE: SvIOK(ST(0)) && SvIOK(ST(1))
        int x
        int y
        CODE:
            fltk::translate( (int) x, (int) y /* faster than the float version */ );
    CASE: (SvNOK(ST(0)) || SvIOK(ST(0))) && (SvNOK(ST(1)) || SvIOK(ST(1)))
        double x
        double y
        CODE:
            fltk::translate( (float) x, (float) y );
    CASE:
        CODE:
            Perl_croak(aTHX_ "Usage: %s(%s) # %s", "FLTK::translate", "x, y",
                "where 'x' and 'y' are both either floats or integers"
            );

BOOT:
    export_tag("translate", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||rotate|float d|

Rotate the current transformation counter-clockwise by C<d> degrees (not
radians!!). This is done by multiplying the matrix by:

  cos -sin 0
  sin  cos 0
  0     0  1

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
rotate( float d )
    CODE:
        fltk::rotate( d );

BOOT:
    export_tag("rotate", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||concat|float a|float b|float c|float d|float x|float y|

Multiply the current transformation by

  a b 0
  c d 0
  x y 1

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
concat( float a, float b, float c, float d, float x, float y )
    CODE:
        fltk::concat( a, b, c, d, x, y );

BOOT:
    export_tag("concat", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||load_identity||

Replace the current transform with the identity transform, which puts 0,0 in
the top-left corner of the window and each unit is 1 pixel in size.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
load_identity( )
    CODE:
        fltk::load_identity( );

BOOT:
    export_tag("load_identity", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||transform|float x|float y|

Replace C<float_x> and C<float_y> transformed into device coordinates.
Device-specific code can use this to draw things using the fltk transformation
matrix. If the backend is Cairo or another API that does transformations, this
may return C<x> and C<y> unchagned.

=for apidoc FT[draw]|||transform|int x|int y|

Replace C<int_x> and C<int_y> with the transformed coordinates, rounded to the
nearest integer.

=for apidoc FT[draw]|||transform|FLTK::Rectangle * from|FLTK::Rectangle * to|

Transform the rectangle C<rect_from> into device coordinates and put it into
C<rect_to>. This only works correctly for 90 degree rotations, for other
transforms this will produce an axis-aligned rectangle with the same area
(this is useful for inscribing circles, and is about the best that can be done
for device functions that don't handle rotation.

=for apidoc FT[draw]|||transform|float x|float y|itn w|int h|

Same as C<transform(FLTK::Rectangle-E<gt>new($x,$y,$w,$h), $rect_to)> but
replaces C<x, y, w, h> with the transformed rectangle. This may be faster as
it avoids the rectangle construction.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
transform ( x, y, int w = NO_INIT, int h = NO_INIT )
    CASE: (items == 4) && SvIOK(ST(0)) && SvIOK(ST(1))
        int x
        int y
        CODE:
            fltk::transform( x, y );
        OUTPUT:
            x
            y
    CASE: (items == 4) && SvIOK(ST(0)) && SvIOK(ST(1))
        int x
        int y
        CODE:
            fltk::transform( x, y, w, h );
        OUTPUT:
            x
            y
            w
            h
    CASE: (items == 2) && (SvNOK(ST(0)) || SvIOK(ST(0))) && (SvNOK(ST(1)) || SvIOK(ST(1)))
        float x
        float y
        CODE:
            fltk::transform( x, y );
        OUTPUT:
            x
            y
    CASE: items == 2 /* from, to */
        fltk::Rectangle * x
        fltk::Rectangle * y
        CODE:
            fltk::transform( * x, * y );
        OUTPUT:
            y

BOOT:
    export_tag("transform", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||transform_distance|float x|float y|

Replace C<x> and C<y> with the tranformed coordinates, ignoring
translation. This transforms a vector which is measuring a distance
between two positions, rather than a position.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
transform_distance( IN_OUTLIST float x, IN_OUTLIST float y)
    CODE:
        fltk::transform_distance( x, y );
    OUTPUT:
        x
        y

BOOT:
    export_tag("transform_distance", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||push_clip|FLTK::Rectangle * rect|

Pushes the I<intersection> of the current region and
L<Rectangle|FLTK::Rectangle> C<x> onto the clip stack.

=for apidoc FT[draw]|||push_clip|int x|int y|int w|int h|

Same as L<C<push_clip(FLTK::Rectangl-E<gt>new($x,$y,$r,$h))>|/"push_clip">
except faster as it avoids the construction of an intermediate rectangle
object.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
push_clip( x, int y = NO_INIT, int w = NO_INIT, int h = NO_INIT )
    CASE: items == 4 && SvIOK(ST(0))
        int x
        CODE:
            fltk::push_clip( x, y, w, h );
    CASE: items == 1
        fltk::Rectangle * x
        CODE:
            fltk::push_clip( * x );
    CASE:
        CODE:
            Perl_croak(aTHX_ "Usage: %s(%s)", "FLTK::push_clip", "x, [y, w, h]");

BOOT:
    export_tag("push_clip", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||clipout|FLTK::Rectangle * rectangle|

Remove C<rectangle> from the current clip region, thus making it a more
complex shape. This does not push the stack, it just replaces the top of it.

Some graphics backends (OpenGL and Cairo, at least) do not support
non-rectangular clip regions. This call does nothing on those.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
clipout( fltk::Rectangle * rectangle )
    CODE:
        fltk::clipout( * rectangle );

BOOT:
    export_tag("clipout", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||pop_clip||

Restore the previous clip region. You must call L<C<pop_clip()>|/"pop_clip">
exactly once for every time you call L<C<push_clip()>|/"push_clip">. If you
return to FLTK with the clip stack not empty unpredictable results occur.

=for apidoc FT[draw]|||push_no_clip||

Pushes an empty clip region on the stack so nothing will be clipped. This lets
you draw outside the current clip region. This should only be used to
temporarily ignore the clip region to draw into an offscreen area.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
pop_clip( )
    CODE:
        fltk::pop_clip( );

void
push_no_clip( )
    CODE:
        fltk::push_no_clip( );

BOOT:
    export_tag("pop_clip", "draw");
    export_tag("push_no_clip", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||bool inside|not_clipped|FLTK::Rectangle * rectangle|

Returns true if any or all of C<rectangle> is inside the clip region.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

bool
not_clipped( fltk::Rectangle * rectangle )
    CODE:
        RETVAL = fltk::not_clipped( * rectangle );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("not_clipped", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||int return|intersect_with_clip|FLTK::Rectangle * rectangle|

Intersect a L<C<transform()>|/"transform">'d rectangle with the current clip
region and change it to the smaller rectangle that surrounds (and probably
equals) this intersection area.

This can be used by device-specific drawing code to limit complex pixel
operations (like drawing images) to the smallest rectangle needed to update
the visible area.

Return values:

=over

=item 0 if it does not intersect, and W and H are set to zero

=item 1 if if the result is equal to the rectangle (i.e. it is entirely inside
or equal to the clip region)

=item 2 if it is partially clipped

=back

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

int
intersect_with_clip( fltk::Rectangle * rectangle )
    CODE:
        RETVAL = fltk::intersect_with_clip( * rectangle );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("intersect_with_clip", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||setcolor|FLTK::Color color|

Set the color for all subsequent drawing operations.

See L<C<setcolor_alpha()>|/"setcolor_alpha">.

=for apidoc FT[draw]|||setbgcolor|FLTK::Color color|

Set the "background" color. This is not used by the drawing functions, but
many box and image types will refer to it by calling
L<C<getbgcolor()>|/"getbgcolor">.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
setcolor( fltk::Color color )
    CODE:
        fltk::setcolor( color );

void
setbgcolor( fltk::Color color )
    CODE:
        fltk::setbgcolor( color );

BOOT:
    export_tag("setcolor", "draw");
    export_tag("setbgcolor", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||setcolor_alpha|FLTK::Color color|float alpha|

Sets the current rgb and alpha to draw in, on rendering systems that allow it.
If alpha is not supported this is the same as L<C<setcolor()>|/"setcolor">.
The color you pass should I<not> premultiplied by the alpha value, that would
be a different, nyi, call.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
setcolor_alpha( fltk::Color color, float alpha )
    CODE:
        fltk::setcolor_alpha( color, alpha );

BOOT:
    export_tag("setcolor_alpha", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||FLTK::Color color|getcolor||

Returns the last Color passed to L<C<setcolor()>|/"setcolor">.

=for apidoc FT[draw]||FLTK::Color color|getbgcolor||

Returns the last Color passed to L<C<setbgcolor()>|/"setbgcolor">. To actually
draw in the bg color, do this:

  my $saved = FLTK::getcolor();
  FLTK::setcolor(FLTK::getbgcolor());
  draw_stuff();
  FLTK::setcolor($saved);

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

fltk::Color
getcolor( )
    CODE:
        RETVAL = fltk::getcolor( );
    OUTPUT:
        RETVAL

fltk::Color
getbgcolor( )
    CODE:
        RETVAL = fltk::getbgcolor( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("getcolor", "draw");
    export_tag("getbgcolor", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||FLTK::Style style|drawstyle||

Return the last style sent to
L<C<drawstyle($style,$flags)>|/"drawstyle_style_flags_">. Some drawing
functions (such as glyphs) look in this for box types. If this has not been
called it is L<C<Widget::default_style>|FLTK::Widget/"default_style">.

=for apidoc FT[draw]|||drawstyle|FLTK::Style style|FLTK::Flags flags|

Draw using this style.  Set L<C<drawstyle()>|/"drawstyle"> to this,
L<C<drawflags()>|/"drawflags"> to C<flags>, calls L<C<setcolor()>|/"setcolor">
and L<C<setbgcolor()>|/"setbgcolor"> with appropriate colors for this style
and the given flags, and calls L<C<setfont()>|/"setfont">.  This is called by
the L<C<draw()>|/"draw"> methods on most fltk widgets. The calling Widget
picks what flags to pass to the Symbols so that when they call this they get
the correct colors for each part of the widget.

Flags that are understood:

=over

=item C<HIGHLIGHT>

If L<C<highlight_color()>|FLTK::Color/"highlight_color"> is non-zero, set bg
to L<C<highlight_color()>|FLTK::Color/"highlight_color"> and fg to
L<C<highlight_textcolor()>|/"highlight_textcolor">.

=item C<OUTPUT>

Normally L<C<color()>|FLTK::Color/"color">,
L<C<textcolor()>|FLTK::Color/"textcolor">, L<C<textfont()>|/"textfont">, and
L<C<textsize()>|/"textsize"> are used. If this flag is set
L<C<buttoncolor()>|/"buttoncolor">, L<C<labelcolor()>|/"labelcolor">,
L<C<labelfont()>|/"labelfont">, and L<C<labelsize()>|/"labelsize"> are used.
Widgets will set this true for any internal buttons, but false for the main
area.

=item C<INACTIVE_R>

Change the fg to a gray color.

=back

It then further modifies fg so that it contrasts with the bg.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

fltk::Style *
drawstyle( fltk::Style * style = NO_INIT, fltk::Flags flags = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = (fltk::Style *) fltk::drawstyle( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            fltk::drawstyle( style, flags );

BOOT:
    export_tag("drawstyle", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||setdrawflags|FLTK::Flags flags|



=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
setdrawflags( fltk::Flags flags )
    CODE:
        fltk::setdrawflags( flags );

BOOT:
    export_tag("setdrawflags", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||drawflags|FLTK::Flags flags|



=for apidoc FT[draw]||FLTK::Flags flags|drawflags||



=cut

MODULE = FLTK::draw               PACKAGE = FLTK

fltk::Flags
drawflags( fltk::Flags flags )
    CASE: items == 0
        CODE:
            RETVAL = fltk::drawflags( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = fltk::drawflags( flags );

BOOT:
    export_tag("drawflags", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||line_style|char * style|float width = 0|int dashes = ''|

Set how to draw lines (the "pen"). If you change this it is your
responsibility to set it back to the default with
L<C<line_style(0)>|/"line_style_">.

C<style> is a bitmask in which you 'or' the following values (imported with
C<draw> tag). If you don't specify a dash type you will get a solid line. If
you don't specify a cap or join type you will get a system-defined default of
whatever value is fastest.

=over

=item C<SOLID>

C<------->

=item C<DASH>

C<- - - ->

=item C<DOT>

C<·········>

=item C<DASHDOT>

C<- · - ·>

=item C<DASHDOTDOT>

C<- ·· - ··>

=item C<CAP_FLAT>

=item C<CAP_ROUND>

=item C<CAP_SQUARE>

extends past end point 1/2 line width

=item C<JOIN_MITER>

pointed

=item C<JOIN_ROUND>

=item C<JOIN_BEVEL>

flat

=back

C<width> is the number of pixels thick to draw the lines. Zero results in the
system-defined default, which on both X and Windows is somewhat different and
nicer than 1.

C<dashes> is a list of dash lengths, measured in pixels, if set then the dash
pattern in C<style> is ignored. The first location is how long to draw a solid
portion, the next is how long to draw the gap, then the solid, etc. It is
terminated with a zero-length entry. A null pointer or a zero-length array
results in a solid line. Odd array sizes are not supported and result in
undefined behavior. I<The dashes array is ignored on Windows 95/98.>

=for apidoc FT[draw]||int style|line_style||

Return the last value sent to
L<C<line_style($style,$width,$dashes)>|/"line_style">, indicating the cap and
join types and the built-in dash patterns.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

int
line_style( int style = NO_INIT , float width = 0, int dashes = NO_INIT, ...)
    CASE: items == 0
        CODE:
            RETVAL = fltk::line_style( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            char c_dashes[items - 2];
            for (int i = 2; i < items; i++ )
                c_dashes[i - 2] = (char) SvIV(ST(i));
            c_dashes[items - 2] = '\0';
            fltk::line_style( style, width, c_dashes );

BOOT:
    export_tag("line_style", "draw");
    register_constant( "SOLID", newSViv( fltk::SOLID ));
    export_tag("SOLID", "draw");
    register_constant( "DASH", newSViv( fltk::DASH ));
    export_tag("DASH", "draw");
    register_constant( "DOT", newSViv( fltk::DOT ));
    export_tag("DOT", "draw");
    register_constant( "DASHDOT", newSViv( fltk::DASHDOT ));
    export_tag("DASHDOT", "draw");
    register_constant( "DASHDOTDOT", newSViv( fltk::DASHDOTDOT ));
    export_tag("DASHDOTDOT", "draw");
    register_constant( "CAP_FLAT", newSViv( fltk::CAP_FLAT ));
    export_tag("CAP_FLAT", "draw");
    register_constant( "CAP_ROUND", newSViv( fltk::CAP_ROUND ));
    export_tag("CAP_ROUND", "draw");
    register_constant( "CAP_SQUARE", newSViv( fltk::CAP_SQUARE ));
    export_tag("CAP_SQUARE", "draw");
    register_constant( "JOIN_MITER", newSViv( fltk::JOIN_MITER ));
    export_tag("JOIN_MITER", "draw");
    register_constant( "JOIN_ROUND", newSViv( fltk::JOIN_ROUND ));
    export_tag("JOIN_ROUND", "draw");
    register_constant( "JOIN_BEVEL", newSViv( fltk::JOIN_BEVEL ));
    export_tag("JOIN_BEVEL", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||float width|line_width||

Return the last value for C<$width> sent to
L<C<line_style($style,$width, $dashes)>|/"line_style">.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

float
line_width( )
    CODE:
        RETVAL = fltk::line_width( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("line_width", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||AV * dashes|line_dashes||

Return the last value for C<$dashes> sent to
L<C<line_style($style,$width, $dashes)>|/"line_style">. Note this is only
useful for checking if it is NULL or not.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

AV *
line_dashes( )
    CODE:
        RETVAL = newAV( );
        sv_2mortal((SV*)RETVAL);
        const char * ret = fltk::line_dashes( );
        int i = 0;
        while ( ret[ i ] )
            av_push( RETVAL, newSViv( (int) ret[ i++ ] ) );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("line_dashes", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||newpath||

Clear the current "path". This is normally done by
L<C<fillpath()>|/"fillpath"> or any other drawing command.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
newpath( )
    CODE:
        fltk::newpath( );

BOOT:
    export_tag("newpath", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||addvertex|int x|int y|

Add a single vertex to the current path. (if the path is empty or a
L<C<closepath()>|/"closepath"> was done, this is equivalent to a "moveto" in
PostScript, otherwise it is equivalent to a "lineto").

This integer version is provided by the fltk libs because it is much faster
than the floating-point version. L<FLTK|FLTK> (the module) will "resolve"
which one you want to call.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
addvertex( x, y )
    CASE: SvIOK(ST(0)) && SvIOK(ST(1))
        int x
        int y
        CODE:
            fltk::addvertex( (int) x, (int) y /* faster than the float version */ );
    CASE: (SvNOK(ST(0)) || SvIOK(ST(0))) && (SvNOK(ST(1)) || SvIOK(ST(1)))
        double x
        double y
        CODE:
            fltk::addvertex( (float) x, (float) y );
    CASE:
        CODE:
            Perl_croak(aTHX_ "Usage: %s(%s) # %s", "FLTK::addvertex", "x, y",
                "where 'x' and 'y' are both either floats or integers"
            );

BOOT:
    export_tag("addvertex", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||addvertices|AV * xy1|AV * ...|AV * xy\d|

Add a whole set of vertices to the current path. This is much faster than
calling L<C<addvertex>|/"addvertex"> once for each point.

=for apidoc FT[draw]|||addvertices_transformed|AV * xy1|AV * ...|AV * xy\d|

Adds a whole set of vertcies that have been produced from values
returned by L<C<transform()>|/"transform">. This is how L<C<curve()>|/"curve">
and L<C<arc()>|/"arc"> are implemented.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
addvertices( AV * xy1, AV * xy2 = NO_INIT, ... )
    CODE:
        float array [items][2];
        int count = 0;
        for ( int i = 0; i < items; i++ ) {
            AV * xy = (AV*) SvRV(ST(i));
            if ( (xy == NULL) || (av_len(xy) != 1 ) )
                continue;
            if (
                    ((SvIOK(*av_fetch( xy, 0, false ))) || (SvNOK(*av_fetch( xy, 0, false )))) &&
                    ((SvIOK(*av_fetch( xy, 1, false ))) || (SvNOK(*av_fetch( xy, 1, false ))))
            ) {
                array[count][0] = SvNV(*av_fetch( xy, 0, false ));
                array[count][1] = SvNV(*av_fetch( xy, 1, false ));
                count++;
            }
        }
        if ( count ) {
            switch( ix ) {
                case 0: fltk::addvertices(count, array); break;
                case 1: fltk::addvertices_transformed(count, array); break;
            }
        }
        /* TODO: I'd like to say... return the number of vertices added or
                 something.*/
    ALIAS:
        addvertices_transformed = 1

BOOT:
    export_tag("addvertices", "draw");
    export_tag("addvertices_transformed", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||addcurve|float x0|float y0|float x1|float y1|float x2|float y2|float x3|float y3|

Add a series of points on a Bezier spline to the path. The curve ends (and two
of the points) are at C<x0,y0> and C<x3,y3>. The "handles" are at C<x1,y1> and
C<x2,y2>.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
addcurve( float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3 )
    CODE:
        fltk::addcurve( x0, y0, x1, y1, x2, y2, x3, y3 );

BOOT:
    export_tag("addcurve", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||addarc|float l|float t|float w|float h|float start|float end|

Add a series of points to the current path on the arc of an ellipse. The
ellipse in inscribed in the C<l,t,w,h> rectangle, and the C<start> and C<end>
angles are measured in degrees counter-clockwise from 3 o'clock, 45 points at
the upper-right corner of the rectangle. If end is less than start then it
draws the arc in a clockwise direction.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
addarc( float l, float t, float w, float h, float start, float end )
    CODE:
        fltk::addarc( l, t, w, h, start, end );

BOOT:
    export_tag("addarc", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||addpie|FLTK::Rectangle * rect|float start|float end|

Add a pie-shaped closed piece to the path, inscribed in the rectangle so if it
is stroked with the default line width it exactly fills the rectangle (this is
slightly smaller than L<<C<addarc()>|/"addarc"> will draw). If you want a full
circle use L<C<addchord()>|/"addchord">.

This tries to take advantage of the primitive calls provided by Xlib and
GDI32. Limitations are that you can only draw one per path, that rotated
coordinates don't work, and doing anything other than
L<C<fillpath()>|/"fillpath"> will produce unpredictable results.

See also L<C<addchord()>|/"addchord">.

=for apidoc FT[draw]|||addchord|FLTK::Rectangle * rect|float start|float end|

Add an isolated circular arc to the path. It is inscribed in the rectangle so
if it is stroked with the default line width it exactly fills the rectangle
(this is slightly smaller than L<C<addarc()>|/"addarc"> will draw). If the
angles are 0 and 360 a closed circle is added.

This tries to take advantage of the primitive calls provided by Xlib and
GDI32. Limitations are that you can only draw one, a rotated current transform
does not work.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
addpie( fltk::Rectangle * rect, float start, float end )
    CODE:
        switch( ix ) {
            case 0:   fltk::addpie( * rect, start, end ); break;
            case 1: fltk::addchord( * rect, start, end ); break;
        }
    ALIAS:
        addchord = 1

BOOT:
    export_tag("addpie", "draw");
    export_tag("addchord", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||closepath||

Similar to drawing another vertex back at the starting point, but fltk knows
the path is closed. The next L<C<addvertex()>|/"addvertex"> will start a new
disconnected part of the shape.

It is harmless to call L<C<closepath()>|/"closepath"> several times in a row,
or to call it before the first point. Sections with less than 3 points in them
will not draw anything when filled.

=for apidoc FT[draw]|||strokepath||

Draw a line between all the points in the path (see
L<C<line_style()>|/"line_style"> for ways to set the thicknesss and dot
pattern ofthe line), then clear the path.

=for apidoc FT[draw]|||fillpath||

Does L<C<closepath()>|/"closepath"> and then fill with the current color, and
then clear the path.

For portability, you should only draw polygons that appear the same whether
"even/odd" or "non-zero" winding rules are used to fill them. This mostly
means that holes should be drawn in the opposite direction of the outside.

Warning: result is somewhat different on X and Win32! Use
L<C<fillstrokepath()>|/"fillstrokepath"> to make matching shapes. In my
opinion X is correct, we may change the Win32 version to match in the future,
perhaps by making the current pen invisible?

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
closepath( )
    CODE:
        fltk::closepath( );

void
strokepath( )
    CODE:
        fltk::strokepath( );

void
fillpath( )
    CODE:
        fltk::fillpath( );

BOOT:
    export_tag("closepath", "draw");
    export_tag("strokepath", "draw");
    export_tag("fillpath", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||fillstrokepath|FLTK::Color * color|

Does L<C<fill()>|/"fill">, then sets the current color to linecolor and does
L<C<stroke>|/"stroke"> with the same closed path, and then clears the path.

This seems to produce very similar results on X and Win32. Also it takes
advantage of a single GDI32 call that does this and should be faster.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
fillstrokepath( fltk::Color color )
    CODE:
        fltk::fillstrokepath( color );

BOOT:
    export_tag("fillstrokepath", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||fillrect|int x|int y|int w|int h|

Fill the rectangle with the current color.

=for apidoc FT[draw]|||fillrect|FLTK::Rectnale * rectangle|

Fill the L<C<rectangle>|FLTK::Rectangle> with the current color.

=for apidoc FT[draw]|||strokerect|int x|int y|int w|int h|

Draw a line I<inside> this bounding box (currently correct only for
0-thickness lines).

=for apidoc FT[draw]|||strokerect|FLTK::Rectangle * rectangle|

Draw a line i<inside> this L<bounding box|FLTK::Rectangle> (currently correct
only for 0-thickness lines).

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
fillrect( x, int y = NO_INIT, int w = NO_INIT, int h = NO_INIT )
    CASE: items == 1
        fltk::Rectangle * x
        CODE:
            switch( ix ) {
                case 0:   fltk::fillrect( * x ); break;
                case 1: fltk::strokerect( * x ); break;
            }
    CASE: items == 4
        int x
        CODE:
            switch( ix ) {
                case 0:   fltk::fillrect( x, y, w, h ); break;
                case 1: fltk::strokerect( x, y, w, h ); break;
            }
    ALIAS:
        strokerect = 1

BOOT:
    export_tag("fillrect", "draw");
    export_tag("strokerect", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||drawline|double x0|double y0|double x1|double y1|

Draw a straight line between the two points.

If L<C<line_width()>|/"line_width"> is zero, this tries to draw as though a
1x1 square pen is moved between the first centers of pixels to the lower-right
of the start and end points. Thus if C<$y == $y1> this will fill a rectangle
with the corners C<$x,$y> and C<$x1+1,$y+1>. This may be 1 wider than you
expect, but is necessary for compatability with previous fltk versions (and is
due to the original X11 behavior).

If L<C<line_width()>|/"line_width"> is not zero then the results depend on the
back end. It also may not produce consistent results if the ctm is not an
integer translation or if the line is not horizontal or vertical.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
drawline( double x0, double y0, double x1, double y1 )
    CODE:
        if ( SvIOK(ST(0)) && SvIOK(ST(1)) && SvIOK(ST(2)) && SvIOK(ST(3)) )
            fltk::drawline( (int) x0, (int) y0, (int) x1, (int) y1 );
        else
            fltk::drawline( (float) x0, (float) y0, (float) x1, (float) y1 );

BOOT:
    export_tag("drawline", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||drawpoint|double x|double y|

Draw a dot at the given point. If L<C<line_width()>|/"line_width"> is zero
this is the single pixel containing C<$x,$y>, or the one to the lower-right if
C<$x> and C<$y> transform to integers. If L<C<line_width()>|/"line_width"> is
non-zero this is a dot drawn with the current pen and line caps (currently
draws nothing in some api's unless the L<C<line_style>|/"line_style"> has
C<CAP_ROUND>).

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
drawpoint( double x, double y)
    CODE:
        if ( SvIOK(ST(0)) && SvIOK(ST(1)) )
            fltk::drawpoint( (int) x, (int) y /* faster than the float version? */ );
        else
            fltk::drawpoint( (float) x, (float) y );

BOOT:
    export_tag("drawpoint", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||setfont|FLTK::Font * font|float size|

Set the current font and font scaling so the size is size pixels. The size is
unaffected by the current transformation matrix (you may be able to use
L<C<transform()>|/"transform"> to get the size to get a properly scaled font).

The size is given in pixels. Many pieces of software express sizes in "points"
(for mysterious reasons, since everything else is measured in pixels!). To
convert these point sizes to pixel sizes use the following code:

  my $monitor = FLTK::Monitor::all();
  my $pixels_per_point = $monitor->dpi_y() / 72.0;
  my $font_pixel_size  = $font_point_size * $pixels_per_point;

See the L<FLTK::Font|FLTK::Font> class for a description of what can be passed
as a font. For most uses one of the built-in constant fonts like C<HELVETICA>
can be used.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
setfont( fltk::Font * font, float size )
    CODE:
        fltk::setfont( font, size );

BOOT:
    export_tag("setfont", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||FLTK::Font font|getfont||

Returns the L<font|FLTK::Font> sent to the last L<C<setfont()>|/"setfont">.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

fltk::Font *
getfont( )
    CODE:
        RETVAL = fltk::getfont( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("getfont", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||double size|getsize||

Return the size sent to the last L<C<setfont()>|/"setfont">. You should use
this as a minimum line spacing (using
L<C<ascent()>|/"ascent">C<+>L<C<descent()>|/"descent"> will produce oddly
spaced lines for many fonts).

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

double
getsize( )
    CODE:
        RETVAL = fltk::getsize( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("getsize", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||double width|getwidth|char * text|

Return the width of a UTF-8 string drawn in the font set by the most recent
L<C<setfont()>|/"setfont">.

=for apidoc FT[draw]||double width|getwidth|char * text|int n = strlen( text)|

Return the width of the first C<n> bytes of this UTF-8 string drawn in the
font set by the most recent L<C<setfont()>|/"setfont">.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

double
getwidth( char * text, int n = strlen( text ) )
    CODE:
        RETVAL = fltk::getwidth( text, n );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("getwidth", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||double distance|getascent||

Return the distance from the baseline to the top of letters in the current
font.

=for apidoc FT[draw]||double distance|getdescent||

Return the distance from the baseline to the bottom of letters in the current
font.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

double
getascent( )
    CODE:
        RETVAL = fltk::getascent( );
    OUTPUT:
        RETVAL

double
getdescent( )
    CODE:
        RETVAL = fltk::getdescent( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("getascent", "draw");
    export_tag("getdescent", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||drawtext_transformed|char * text|int n|float x|float y|

Draw text starting at a point returned by L<C<transform()>|/"transform">. This
is needed for complex text layout when the current transform may not match the
transform being used by the font.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
drawtext_transformed( char * text, int n, float x, float y )
    CODE:
        fltk::drawtext_transformed( text, n, x, y );

BOOT:
    export_tag("drawtext_transformed", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||drawtext|char * text|FLTK::Rectangle * rect|FLTK::Flags flags|

This is the fancy string-drawing function that is used to draw all labels in
fltk. The string is formatted and aligned inside the passed rectangle. This
also:

=over

=item Breaks the text into lines at C<\n> characters. Word-wraps (if C<flags>
has C<ALIGN_WRAP> set) so the words fit in the columns.

=item Looks up C<@xyz;> sequeces to see if they are a L<Symbol|FLTK::Symbol>,
if so it prints that symbol instead. This is skipped if the flags has
C<RAW_LABEL> set.

=item Parses C<&x> combinations to produce Microsoft style underscores, unless
C<RAW_LABEL> flag is set.

=item Splits it at every C<\t> tab character and uses
L<C<column_widths()>|FLTK::Widget/"column_widths"> to set each section into a
column.

=back

=for apidoc FT[draw]|||drawtext|char * text|float x|float y|

Draw a string.

=for apidoc FT[draw]|||drawtext|char * text|float x|float y|int length|

Draw the first C<length> I<bytes> (not characters if utf8 is used) starting at
the given position.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
drawtext( char * text, x, y, int length = NO_INIT )
    CASE: items == 3 && sv_isobject(ST(1)) && sv_derived_from(ST(1), "FLTK::Rectangle")
        fltk::Rectangle * x
        fltk::Flags       y
        CODE:
            fltk::drawtext( text, * x, y );
    CASE: items == 3
        float x
        float y
        CODE:
            fltk::drawtext( text, x, y );
    CASE:
        float x
        float y
        CODE:
            fltk::drawtext( text, length, x, y /* Note order of arguments */ );

BOOT:
    export_tag("drawtext", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]||AV * wh|measure|char * string|FLTK::Flags flags = 0|

Measure the size of box necessary for L<C<drawtext()>|/"drawtext"> to draw the
given string inside of it. The C<flags> are used to set the alignment, though
this should not make a difference except for C<ALIGN_WRAP>. To correctly
measure wrap C<w> must be preset to the width you want to wrap at if
C<ALIGN_WRAP> is on in the flags! C<w> and C<h> are changed to the size of the
resulting box.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
measure( char * string, OUTLIST int w, OUTLIST int h, fltk::Flags flags = 0 )
    CODE:
        fltk::measure( string, w, h, flags );

BOOT:
    export_tag("measure", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||column_widths|int col1|int ...|int col\d|

Set where C<\t> characters go in label text formatter.

=for apidoc FT[draw]||AV * widths|column_widths||

Get where C<\t> characters go in label text formatter.

Okay, not really. This is useless. Thank the fltk authors.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

AV *
column_widths( ... )
    CASE: items != 0
        CODE:
            RETVAL = newAV( );
            sv_2mortal((SV*)RETVAL);
            int widths[ items ];
            for ( int i = 0; i < items; i++ )
                widths[ i ] = SvIV( ST( i ) );
            fltk::column_widths( widths );
        OUTPUT:
    CASE:
        CODE:
            RETVAL = newAV( );
            sv_2mortal((SV*)RETVAL);
            const int * ret = fltk::column_widths( );
            int i = 0;
            while ( ret[ i ] )
                av_push( RETVAL, newSViv( ret[ i++ ] ) );
        OUTPUT:
            RETVAL

BOOT:
    export_tag("column_widths", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw,image]|||drawimage|uchar * pointer|FLTK::PixelType type|FLTK::Rectangle * rect|int line_delta|

Draw a image (a rectangle of pixels) stored in your program's memory. The
current transformation (scale, rotate) is applied.

=over

=item C<pointer>

Points at the first byte of the top-left pixel.

=item C<type>

Describes how to interpret the bytes of each pixel.

=item C<rect>

The image is put in the top-left corner and the width and height declare how
many pixels the image has.

=item C<line_delta>

How much to add to C<pointer> to go 1 pixel down.

=back

By setting C<line_delta> to larger than C<depth($type)*$rect->w()> you can
crop a picture out of a larger buffer. You can also set it negative for images
that are stored with bottom-to-top in memory, notice that in this case
C<pointer> still points at the top-left pixel, which is at the C<end> of your
buffer minus one line_delta.

The X version of FLTK will L<C<abort()>|/"abort"> if the default visual is one
it cannot use for images. To avoid this call L<C<visual(fltk::RGB)>|/"visual">
at the start of your program.

=for apidoc FT[draw,image]|||drawimage|uchar * pointer|FLTK::PixelType type|FLTK::Rectangle * rect|

Same except C<$line_delta> is set to C<$rect->w() * depth($type)>, indicating
the rows are packed together one after another with no gap.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
drawimage( uchar * pointer, fltk::PixelType type, fltk::Rectangle * rect, int line_delta = NO_INIT )
    CASE: items == 3
        CODE:
            fltk::drawimage( pointer, type, * rect );
    CASE: items == 4
        CODE:
            fltk::drawimage( pointer, type, * rect, line_delta );

BOOT:
    export_tag("drawimage", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]|||readimage|uchar * pointer|FLTK::PixelType type|FLTK::Rectangle * rect|int line_delta|

Reads a 2-D image off the current drawing destination. The resulting data can
be passed to L<C<drawimage()>|/"drawimage"> or the 8-bit pixels examined or
stored by your program.

The return value is either C<pointer> or C<undef> if there is some problem
(such as an inability to read from the current output surface, or if the
rectangle is empty).

=over

=item C<pointer> points to the location to store the first byte of the
upper-left pixel of the image. The caller must allocate this buffer.

=item C<type> can be C<RGB> or C<RGBA> (possibly other types will be supported
in the future).

=item C<rect> indicates the position on the surface in the current
transformation to read from and the width and height of the resulting image.
What happens when the current transformation is rotated or scaled is
undefined. If the rectangle extends outside the current drawing surface, or
into areas obscured by overlapping windows, the result in those areas is
undefined.

=item C<line_delta> is how much to add to a pointer to advance from one pixel
to the one below it. Any bytes skipped over are left with undefined values in
them. Negative values can be used to store the image upside-down, however
C<pointer> should point to 1 line before the end of the buffer, as it still
points to the top-left pixel.

=back

=for apidoc FT[draw]|||readimage|uchar * pointer|FLTK::PixelType type|FLTK::Rectangle * rect|

Same except C<line_delta> is set to C<$rect->w() * depth($type)>.

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

const char *
readimage( uchar * pointer, fltk::PixelType type, fltk::Rectangle * rect, int line_delta = NO_INIT )
    CODE:
        if ( items == 3 )
            RETVAL = ( const char * ) fltk::readimage( pointer, type, * rect );
        else if ( items == 4 )
            RETVAL = ( const char * ) fltk::readimage( pointer, type, * rect, line_delta );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("readimage", "draw");

MODULE = FLTK::draw               PACKAGE = FLTK::draw

=for apidoc FT[draw]FHx|||scrollrect|FLTK::Rectangle * rect|int dx|int dy|CV * code|SV * data|

Move the contents of a rectangle by C<dx> and C<dy>. The area that was
previously outside the rectangle or obscured by other windows is then redrawn
by calling C<code> for each rectangle. I<This is a drawing function and can
only be called inside the L<C<draw()>|FLTK::Widget/"draw"> method of a
widget.>

If C<dx> and C<dy> are zero this returns without doing anything.

If C<dx> or C<dy> are larger than the rectangle then this just calls C<code>
for the entire rectangle. This is also done on systems (Quartz) that do not
support copying screen regions.

=end apidoc

=cut

MODULE = FLTK::draw               PACKAGE = FLTK

void
scrollrect( fltk::Rectangle * rect, int dx, int dy, CV * code, SV * data )
    CODE:
        croak( "FLTK::scrollrect( ... ) is incomplete" );
        /* TODO: */

BOOT:
    //export_tag("scrollrect", "draw"); /* TODO */

#endif // ifndef DISABLE_DRAW
