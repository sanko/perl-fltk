#include "include/FLTK_pm.h"

MODULE = FLTK::GlWindow               PACKAGE = FLTK::GlWindow

#ifndef DISABLE_GLWINDOW

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::GlWindow - ...exactly what you think it is

=head1 Description

Provides an area in which the L<C<draw()>|FLTK::Widget/"draw"> method can use
L<OpenGL|OpenGL> to draw. This widget sets things up so L<OpenGL|OpenGL>
works, and also keeps an L<OpenGL|OpenGL> "context" for that window, so that
changes to the lighting and projection may be reused between redraws.
L<GlWindow|GlWindow> also flushes the L<OpenGL|OpenGL> streams and swaps
buffers after L<C<draw()>|FLTK::Widget/"draw"> returns.

You B<must> provide an implementation for L<C<draw()>|FLTK::Widget/"draw">.
You can avoid reinitializing the viewport and lights and other things by
checking L<C<valid()>|FLTK::Widget/"valid"> at the start of
L<C<draw()>|FLTK::Widget/"draw"> and only doing the initialization if it is
false.

L<C<draw()>|FLTK::Widget/"draw"> can I<only> use L<OpenGL|OpenGL> calls. Do
not attempt to call any of the functions in L<FLTK::draw|FLTK::draw>, or X or
GDI32 or any other drawing api. Do not call L<C<glstart()>|FLTK::gl/"glstart">
or L<C<glfinish()>|FLTK::gl/"glfinish">.

=head2 Double Buffering

Normally double-buffering is enabled. You can disable it by chaning the
L<C<mode()>|/"mode"> to turn off the C<DOUBLE_BUFFER> bit.

If double-buffering is enabled, the back buffer is made current before
L<C<draw()>|FLTK::Widget/"draw"> is called, and the back and front buffers are
I<automatically> swapped after L<C<draw()>|FLTK::Widget/"draw"> is completed.

Some tricks using the front buffer require you to control the swapping. You
can call L<C<swap_buffers()>|/"swap_buffers"> to swap them (OpenGL does not
provide a portable function for this, so we provide it). But you will need to
turn off the auto-swap, you do this by adding the C<NO_AUTO_SWAP> bit to the
L<C<mode()>|/"mode">.

=head2 Overlays

The method L<C<draw_overlay()>|/"draw_overlay"> is a second drawing operation
that is put atop the main image. You can implement this, and call
L<C<redraw_overlay()>|/"redraw_overlay"> to indicate that the image in this
overlay has changed and that L<C<draw_overlay()>|/"draw_overlay"> must be
called.

Originally this was written to support hardware overlays, but FLTK emulated it
if the hardware was missing so programs were portable. FLTK 2.0 is not
normally compiled to support hardware overlays, but the emulation still
remains, so you can use these functions. Modern hardware typically has no
overlays, and besides it is fast enough that the original purpose of them is
moot.

By default the emulation is to call L<C<draw_overlay()>|/"draw_overlay"> after
L<C<draw()>|FLTK::Widget/"draw"> and before swapping the buffers, so the
overlay is just part of the normal image and does not blink. You can get some
of the advantages of overlay hardware by setting the C<GL_SWAP_TYPE>
environment variable, which will cause the front buffer to be used for the
L<C<draw_overlay()>|/"draw_overlay"> method, and not call
L<C<draw()>|FLTK::Widget/"draw"> each time the overlay changes. This will be
faster if L<C<draw()>|FLTK::Widget/"draw"> is very complex, but the overlay
will blink. C<GL_SWAP_TYPE> can be set to:

=over

=item C<USE_COPY> uses glCopyPixels to copy the back buffer to the front.

This should always work.

=item C<COPY> indicates that the L<C<swap_buffers()>|/"swap_buffers"> function
actually copies the back to the front buffer, rather than swapping them. If
your card does this (most do) then this is best.

=item C<NODAMAGE> indicates that behavior is like C<COPY> but I<nothing>
changes the back buffer, including overlapping it with another
L<OpenGL|OpenGL> window. This is true of software L<OpenGL|OpenGL> emulation,
and may be true of some modern cards with lots of memory.

=back

=begin apidoc

=for apidoc |G|FLTK::GlWindow win|new|int x|int y|int w|int h|char * label = ''|

The constructor sets the L<C<mode()>|/"mode"> to
C<RGB_COLOR | DEPTH_BUFFER | DOUBLE_BUFFER> which is probably all that is
needed for most 3D L<OpenGL|OpenGL> graphics.

=for apidoc |G|FLTK::GlWindow win|new|int w|int h|char * label = ''|

Same but placed by the OS.

=cut

#include <fltk/GlWindow.h>
#include "include/GlWindowSubclass.h"
#ifdef WIN32 // the following is needed for the window icon (WIN32 only)
#include <windows.h>
#include <fltk/x.h>
#endif // ifdef WIN32

void
fltk::GlWindow::new(package, ...)
    PPCODE:
        void * RETVAL = NULL;
        char * label  = PL_origfilename;
        if ( items == 3 || items == 4 ) {
            int w = (int)SvIV(ST(1));
            int h = (int)SvIV(ST(2));
            if (items == 4) label = (char *)SvPV_nolen(ST(3));
            RETVAL = (void *) new WidgetSubclass<fltk::GlWindow>(CLASS,w,h,label);
        }
        else if (items == 5 || items == 6) {
            int x = (int)SvIV(ST(1));
            int y = (int)SvIV(ST(2));
            int w = (int)SvIV(ST(3));
            int h = (int)SvIV(ST(4));
            if (items == 6) label = (char *)SvPV_nolen(ST(5));
            RETVAL = (void *) new WidgetSubclass<fltk::GlWindow>(CLASS,x,y,w,h,label);
        }
        if (RETVAL != NULL) {
#ifdef WIN32
            ((fltk::Window *)RETVAL)->icon((char *)LoadIcon (dllInstance(), "FLTK" ));
#endif // ifdef WIN32
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc |G|char okay|valid||

This flag is turned off on a new window or if the window is ever resized or
the context is changed. It is turned on after L<C<draw()>|FLTK::Widget/"draw">
is called. L<C<draw()>|FLTK::Widget/"draw"> can use this to skip initializing
the viewport, lights, or other pieces of the context.

  package My_GlWindow_Subclass;
  sub draw {
    my ($self) = @_;
    if (!$self->valid()) {
        glViewport( 0, 0, $self->w(), $self->h() );
        glFrustum(...);
        glLight(...);
        glEnable(...);
        # ...other initialization...
    }
    #... draw your geometry here ...
  }

=for apidoc |G||valid|char is_it||



=cut

char
fltk::GlWindow::valid( char is_it = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->valid( is_it );

=for apidoc |G||invalidate||

Turn off L<C<valid()>|FLTK::Widget/"valid">.

=cut

void
fltk::GlWindow::invalidate( )

=for apidoc |G|int caps|mode||



=for apidoc |G|bool can|mode|int newmode|

Set or change the L<OpenGL|OpenGL> capabilites of the window. The value can be
any of the symbols from L<FLTK::visual|FLTK::visual> OR'd together:

=over

=item C<INDEXED_COLOR> indicates that a colormapped visual is ok. This call
will normally fail if a TrueColor visual cannot be found.

=item C<RGB_COLOR> this value is zero and may be passed to indicate that
C<INDEXED_COLOR> is I<not> wanted.

=item C<RGB24_COLOR> indicates that the visual must have at least 8 bits of
red, green, and blue (Windows calls this "millions of colors").

=item C<DOUBLE_BUFFER> indicates that double buffering is wanted.

=item C<SINGLE_BUFFER> is zero and can be used to indicate that double
buffering is \a not wanted.

=item C<ACCUM_BUFFER> makes the accumulation buffer work

=item C<ALPHA_BUFFER> makes an alpha buffer

=item C<DEPTH_BUFFER> makes a depth/Z buffer

=item C<STENCIL_BUFFER> makes a stencil buffer

=item C<MULTISAMPLE> makes it multi-sample antialias if possible (X only)

=item C<STEREO> stereo if possible

=item C<NO_AUTO_SWAP> disables the automatic call to
L<C<swap_buffers()>|/"swap_buffers"> after L<C<draw()>|FLTK::Widget/"draw">.

=item C<NO_ERASE_OVERLAY> if overlay hardware is used, don't call glClear
before calling L<C<draw_overlay()>|/"draw_overlay">.

=back

If the desired combination cannot be done, FLTK will try turning off
C<MULTISAMPLE> and C<STERERO>. If this also fails then attempts to create the
context will cause L<C<error()>|FLTK/"error"> to be called, aborting the
program. Use L<C<can_do()>|/"can_do"> to check for this and try other
combinations.

You can change the mode while the window is displayed. This is most useful for
turning double-buffering on and off. Under X this will cause the old X window
to be destroyed and a new one to be created. If this is a top-level window
this will unfortunately also cause the window to blink, raise to the top, and
be de-iconized, and the ID will change, possibly breaking other code. It is
best to make the GL window a child of another window if you wish to do this!

=cut

int
fltk::GlWindow::mode( int newmode = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        C_ARGS: newmode

=for apidoc |G|bool can|can_do||

Returns true if the hardware supports the current value of
L<C<mode()>|/"mode">. If false, attempts to show or draw this window will
cause an L<C<error()>|FLTK/"error">.

=for apidoc |G|bool can|can_do|int mode|

Returns true if the hardware supports C<mode>, see L<C<mode()>|/"mode"> for
the meaning of the bits.

=cut

bool
fltk::GlWindow::can_do( int mode = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        C_ARGS: mode

=for apidoc |G|FLTK::GLContext glc|context||

Return the current L<OpenGL|OpenGL> context object being used by this window,
or C<0> if there is none.

=for apidoc |G||context|FLTK::GLContext glc|bool destroy_flag = false|

Set the L<OpenGL|OpenGL> context object to use to draw this window.

This is a system-dependent structure (HGLRC on Windows, GLXContext on X, and
AGLContext (may change) on OS/X), but it is portable to copy the context from
one window to another. You can also set it to C<undef>, which will force FLTK
to recreate the context the next time L<C<make_current()>|/"make_current"> is
called, this is useful for getting around bugs in L<OpenGL|OpenGL>
implementations.

C<destroy_flag> indicates that the context belongs to this window and should
be destroyed by it when no longer needed. It will be destroyed when the window
is destroyed, or when the L<C<mode()>|/"mode"> is changed, or if the context
is changed to a new value with this call.

=cut

fltk::GLContext
fltk::GlWindow::context( fltk::GLContext glc = NO_INIT, bool destroy_flag = false )
    CASE: items == 1
        CODE:
            RETVAL = THIS->context( );
            if ( ! RETVAL )
                XSRETURN_UNDEF;
    CASE:
        CODE:
            THIS->context( glc, destroy_flag );
            XSRETURN_UNDEF;

=for apidoc |G||make_current||

Selects the L<OpenGL|OpenGL> context for the widget, creating it if necessary.
It is called automatically prior to the L<C<draw()>|FLTK::Widget/"draw">
method being called. You can call it in L<C<handle()>|/"handle"> to set things
up to do L<OpenGL|OpenGL> hit detection, or call it other times to do
incremental update of the window.

=for apidoc |G||swap_buffers||

Swap the front and back buffers of this window (or copy the back buffer to the
front, possibly clearing or garbaging the back one, depending on your
L<OpenGL|OpenGL> implementation.

This is called automatically after L<C<draw()>|FLTK::Widget/"draw"> unless the
C<NO_AUTO_SWAP> flag is set in the L<C<mode()>|/"mode">.

=for apidoc |G||ortho||

Set the projection so C<0, 0> is in the lower left of the window and each
pixel is 1 unit wide/tall. If you are drawing 2D images, your
L<C<draw()>|FLTK::Widget/"draw"> method may want to call this when
L<C<valid()>|FLTK::Widget/"valid"> is false.

=cut

void
fltk::GlWindow::make_current( )

void
fltk::GlWindow::swap_buffers( )

void
fltk::GlWindow::ortho( )

=for apidoc |G|bool overlay|can_do_overlay||

Return true if the hardware supports L<OpenGL|OpenGL> overlay planes, and
L<the fltk2 libs|Alien::FLTK2> have been compiled to use them. If true,
L<C<draw_overlay()>|/"draw_overlay"> will be called with L<OpenGL|OpenGL>
setup to draw these overlay planes, and
L<C<redraw_overlay()>|/"redraw_overlay"> will not cause the main
L<C<draw()>|FLTK::Widget/"draw"> to be called.

=cut

bool
fltk::GlWindow::can_do_overlay( )

=for apidoc |G||redraw_overlay||

Causes L<C<draw_overlay()>|/"draw_overlay"> to be called at a later time.
Initially the overlay is clear, if you want the window to display something in
the overlay when it first appears, you must call this immediately after you
L<C<show()>|/"show"> your window.

=for apidoc |G||hide_overlay||



=for apidoc |G||make_overlay_current||

Selects the L<OpenGL|OpenGL> context for the widget's overlay. This can be
used to do incremental L<OpenGL|OpenGL> drawing into the overlay. If hardware
overlay is not supported, this sets things to draw into the front buffer,
which is probably not good enough emulation to be usable.

=cut

void
fltk::GlWindow::redraw_overlay( )

void
fltk::GlWindow::hide_overlay( )

void
fltk::GlWindow::make_overlay_current( )

=for apidoc |G||destroy||

Besides getting rid of the window, this will destroy the L<context|/"context">
if it belongs to the window.

=end apidoc

=head1 Subclassing FLTK::GlWindow

TODO

=over

=item C<create( )>



=item C<flush( )>



=back

=cut

#endif // ifndef DISABLE_GLWINDOW

BOOT:
    isa("FLTK::GlWindow", "FLTK::Window");
