#include "include/FLTK_pm.h"

MODULE = FLTK::ShapedWindow               PACKAGE = FLTK::ShapedWindow

#ifndef DISABLE_SHAPEDWINDOW

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.532006

=head1 NAME

FLTK::ShapedWindow - Custom shaped window

=head1 Description

This window's shape is clipped to an area defined by the alpha from an
L<Image|FLTK::Image> object. Current implementation insists that this be an
L<FLTK::xbmImage|FLTK::xbmImage>, which limits you to 1-bit alpha which must
be supplied by the program. It should not be hard to modify this on newer
systems to accept an arbitrary L<Image|FLTK::Image>.

The layout and widgets inside are unaware of the mask shape, and most will act
as though the bounding box is available to them. Therefore this window type is
usally sublassed or occupied by a single widget.

If the window will be short-lived and does not have to move, you may be much
better off using a L<MenuWindow|FLTK::MenuWindow>. This is a normal window but
with no border and no pixels are changed unless you draw into them. Thus you
can get arbitrary shapes by the simple expediency of not drawing where it
should be "transparent".

The window borders and caption created by the window system are turned off by
default for a L<ShapedWindow|FLTK::ShapedWindow> object. They can be
re-enabled by calling L<C<Window::border( $set )>|FLTK::Window/"border">.

=begin apidoc

=cut

#include <fltk/ShapedWindow.h>

=for apidoc ||FLTK::ShapedWindow * self|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<FLTK::ShapedWindow|FLTK::ShapedWindow> widget.

=cut

#include "include/WidgetSubclass.h"

void
fltk::ShapedWindow::new( ... )
    PPCODE:
        void * RETVAL = NULL;
        char * label  = PL_origfilename;
        if ( items == 3 || items == 4 ) {
            int w = (int)SvIV(ST(1));
            int h = (int)SvIV(ST(2));
            if (items == 4) label = (char *)SvPV_nolen(ST(3));
            RETVAL = (void *) new WidgetSubclass<fltk::ShapedWindow>(CLASS,w,h,label);
        }
        else if (items == 5 || items == 6) {
            int x = (int)SvIV(ST(1));
            int y = (int)SvIV(ST(2));
            int w = (int)SvIV(ST(3));
            int h = (int)SvIV(ST(4));
            if (items == 6) label = (char *)SvPV_nolen(ST(5));
            RETVAL = (void *) new WidgetSubclass<fltk::ShapedWindow>(CLASS,x,y,w,h,label);
        }
        if (RETVAL != NULL) {
#ifdef WIN32
            ((fltk::Window *)RETVAL)->icon((char *)LoadIcon (dllInstance( ), "FLTK" ));
#endif // ifdef WIN32
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc |||shape|FLTK::xbmImage * img|

The alpha channel of the supplied image is used as the shape of the window. A
pointer to the image is stored, so it must remain in existence until
L<C<shape( )>|FLTK::ShapedWindow/"shape"> is called again or the
L<ShapedWindow|FLTK::ShapedWindow> is destroyed.

If you want your window to resize you should subclass and make a
C<layout( )> method that draws a new image and calls
L<C<shape( )>|FLTK::ShapedWindow/"shape">.

=cut

void
fltk::ShapedWindow::shape( fltk::xbmImage * img )

#endif // ifndef DISABLE_SHAPEDWINDOW

BOOT:
    isa( "FLTK::ShapedWindow", "FLTK::Window" );
