#include "include/FLTK_pm.h"

MODULE = FLTK::MultiImage               PACKAGE = FLTK::MultiImage

#ifndef DISABLE_MULTIIMAGE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::MultiImage - Image type that draws a different image depending on the flags

=head1 Description

A L<Symbol|FLTK::Symbol> containing pointers to a set of different
L<Symbol|FLTK::Symbol>s. The L<C<drawflags()>|FLTK::MultiImage/"drawflags">
are used to select which one to draw. This is most useful for making an image
for a button that is different depending on whether it is pushed in, the
current value is on, or when the mouse is over it.

The basic constructor takes the C<$image0> which is the image that is drawn if
no other image is used. You can then use L<C<add()>|FLTK::MultiImage/"add"> or
L<C<replace()>|FLTK::MultiImage/"replace"> to add pairs of images and flags.
These are searched and the last one where all it's flags are turned on is
used. There are also inline constructors so that a fully-populated
L<MultiImage|FLTK::MultiImage> with up to C<8> images can be declared inline.

Typical example:

    my $buttonImage = FLTK::MultiImage->new(
                          $OffImage,
        STATE,            $OnImage,
        INACTIVE_R,       $DimOffImage,
        INACTIVE_R|STATE, $DimOnImage,
        FOCUSED,          $FocusedOffImage,
        FOCUSED|STATE,    $FocusedOnImage,
        HIGHLIGHT,        $BrightOffImage,
        HIGHLIGHT|STATE,  $BrightOnImage,
        PUSHED,           $BrightPushedOffImage,
        PUSHED|STATE,     $BrightPushedOnImage
    );

In the above example, because the C<PUSHED> is later than the C<FOCUSED>, when
the user pushes the button and it has the focus they will see the pushed
image. If they were the other way around they would see the focused image and
not see any feedback from pushing the button. In addition, although the
highlight or focus should not turn on for an inactive widget, this will show
if it happens.

Also note that the number of images is less than C<2^n> where C<n> is the
number of flags you care about. This seems to be true of most hand-painted
image sets. The user probably does not care or is confused by showing the
focus or highlight state of a button they are pushing.

A fully-populated example like the above is not necessary, as the flags are
passed to the sub-images. If they respond to them (for instance drawing
differently depending on C<STATE>) then fewer images are necessary.

Useful flags are:

=over

=item C<INACTIVE_R>

=item C<STATE>

True for button that is turned on.

=item C<HIGHLIGHT>

True when the mouse is over widget or pushing it (you must also set
L<C<highlight_color()>|FLTK::Color/"highlight_color"> to non-zero or most
widgets will not redraw because they don't think they changed appearance).

=item C<PUSHED>

True if user is pushing button.

=item C<FOCUSED>

True if button has the keyboard focus.

=back

...import these with the C<:flags> tag.

=begin apidoc

=cut

#include <fltk/MultiImage.h>

=for apidoc ||FLTK::MultiImage * self|new||

For constructing list of L<MultiImage|FLTK::MultiImage>s using
L<C<set()>|FLTK::MultiImage/"set"> for post initialization.

=cut

fltk::MultiImage *
fltk::MultiImage::new( )

=for apidoc ||AV * xy|_measure||

It probably is useless for the images to be different sizes. However if they
are, C<$image0> (the first one passed to the constructor) is used to figure
out the size.

=cut

void
fltk::MultiImage::_measure( OUTLIST int x, OUTLIST int y )
    C_ARGS: x, y

=for apidoc |||_draw|FLTK::Rectangle * rect|

Select one of the images and draw it. The last image with all the flags
specified for it turned on will be drawn. If none of them match then
C<$image0> is drawn.

=cut

void
fltk::MultiImage::_draw( fltk::Rectangle * rect )
    C_ARGS: * rect

=for apidoc ||fltk::Symbol * image|current_image|

Return the image that will be drawn according to the current value of
L<C<drawflags()>|FLTK::MultiImage/"drawflags">. The B<last> image with all the
flags specified for it turned on will be drawn. If none of them match then
C<$image0> (the first one passed to the constructor) is returned.

=cut

const fltk::Symbol *
fltk::MultiImage::current_image( )

=for apidoc |||inset|FLTK::Rectangle * rect|

Calls the same image that L<C<_draw()>|FLTK::MultiImage/"_draw"> will call to
get the inset.

=cut

void
fltk::MultiImage::inset( fltk::Rectangle * rect )
    C_ARGS: * rect

=for apidoc ||bool does|fills_rectangle||

Returns the info from the first image given to the constructor.

=cut

bool
fltk::MultiImage::fills_rectangle( )

=for apidoc ||bool frame|is_frame||

Returns the info from the first image given to the constructor.

=cut

bool
fltk::MultiImage::is_frame( )

=for apidoc |||add|FLTK::Flags flags|FLTK::Symbol * image|

Makes it draw C<$image> if B<all> of the C<$flags> are turned on in
L<C<drawflags()>|FLTK::MultiImage/"drawflags">.

If C<$flags> is zero, this replaces the image0 that was provided to the
constructor. Otherwise, if any image with C<$flags> has already been
specified, it is replaced with this image. Otherwise a new pair of flags and
image is added to the end of the list.

=cut

void
fltk::MultiImage::add( fltk::Flags flags, fltk::Symbol * image )
    C_ARGS: flags, * image

=for apidoc |||release||

Destroys everything except C<image0>.

=cut

void
fltk::MultiImage::release( )

#endif // ifndef DISABLE_MULTIIMAGE

BOOT:
    isa("FLTK::MultiImage", "FLTK::Symbol");
