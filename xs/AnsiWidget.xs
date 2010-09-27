#include "include/FLTK_pm.h"

MODULE = FLTK::AnsiWidget               PACKAGE = FLTK::AnsiWidget

#ifndef DISABLE_ANSIWIDGET

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::AnsiWidget - Displays ANSI escape codes

=head1 Description

Displays ANSI escape codes.

Escape sequences start with the characters C<ESC> (ASCII 27d/1Bh/033o) and
C<[> (left bracket). This sequence is called CSI for "Control Sequence
Introducer".

=head2 Supported control codes:

=over

=item C<\t>

tab (20 px)

=item C<\a>

beep

=item C<\r>

return

=item C<\n>

next line

=item C<\xC>

clear screen

=item C<\e[K>

clear to end of line

=item C<\e[0m>

reset all attributes to their defaults

=item C<\e[1m>

set bold on

=item C<\e[4m>

set underline on

=item C<\e[7m>

reverse video

=item C<\e[21m>

set bold off

=item C<\e[24m>

set underline off

=item C<\e[27m>

set reverse off

=back

=head1 See Also

For more information about ANSI code see:

=over

=item * http://en.wikipedia.org/wiki/ANSI_escape_code

=item * http://www.uv.tietgen.dk/staff/mlha/PC/Soft/Prog/BAS/VB/Function.html

=back

=begin apidoc

=cut

#include <fltk/AnsiWidget.h>

=for apidoc ||FLTK::AnsiWidget self|new|int x|int y|int w|int h|int defsize|

Creates a new C<FLTK::AnsiWidget> object.

=cut

#include "include/WidgetSubclass.h"

void
AnsiWidget::new( int x, int y, int w, int h, int defsize )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<AnsiWidget>(CLASS,x,y,w,h,defsize);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal( );
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc |||layout||



=cut

void
AnsiWidget::layout( )

=for apidoc |||clearScreen||

Clear the offscreen buffer.

=for apidoc |||beep||

Create audible beep sound.

=cut

void
AnsiWidget::clearScreen ( )
    CODE:
        switch ( ix ) {
            case 0: THIS->clearScreen( );
            case 1: THIS->beep( );
        }
    ALIAS:
        beep = 1

=for apidoc |||print|char * str|

Prints the contents of the given string onto the backbuffer.

=cut

void
AnsiWidget::print( const char * str )

=for apidoc |||drawLine|int x1|int y1|int x2|int y2|

Draw a line onto the offscreen buffer.

=for apidoc |||drawRectFilled|int x1|int y1|int x2|int y2|

Draw a filled rectangle onto the offscreen buffer.

=for apidoc |||drawRect|int x1|int y1|int x2|int y2|

Draw a rectangle onto the offscreen buffer.

=cut

void
AnsiWidget::drawLine( int x1, int y1, int x2, int y2 )
    CODE:
        switch( ix ) {
            case 0: THIS->drawLine( x1, y1, x2, y2); break;
            case 1: THIS->drawRectFilled( x1, y1, x2, y2); break;
            case 2: THIS->drawRect( x1, y1, x2, y2); break;
        }
    ALIAS:
        drawRectFilled = 1
        drawRect = 2

=for apidoc |||drawImage|FLTK::Image * img|int x|int y|int sx|int sy|int w|int h|

Draws the given image onto the offscreen buffer.

=cut

void
AnsiWidget::drawImage( fltk::Image * img, int x, int y, int sx, int sy, int w, int h )


=for apidoc |||saveImage|char * filename|int x|int y|int w|int h|

Save the offscreen buffer to the given filename.

=cut

void
AnsiWidget::saveImage( char * filename, int x, int y, int w, int h )

=for apidoc |||setTextColor|long fore|long back|

Sets the current text drawing color.

=cut

void
AnsiWidget::setTextColor( long fore, long back )

=for apidoc |||setColor|long color|

Sets the current drawing color.

=cut

void
AnsiWidget::setColor( long color )

=for apidoc ||int x|getX||



=for apidoc ||int y|getY|



=for apidoc ||int w|getWidth|



=for apidoc ||int h|getHeight|



=cut

int
AnsiWidget::getX ( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->getX( ); break;
            case 1: RETVAL = THIS->getY( ); break;
            case 2: RETVAL = THIS->getWidth( );  break;
            case 3: RETVAL = THIS->getHeight( ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
             getY = 1
         getWidth = 2
        getHeight = 3

=for apidoc |||setPixel|int x|int y|int color|

Sets the pixel to the given color at the given C<X, Y> location.

=cut

void
AnsiWidget::setPixel( int X, int Y, int color )

=for apidoc ||int color|getPixel|int x|int y|

Returns the color of the pixel at the given C<x, y> location.

=cut

int
AnsiWidget::getPixel ( int x, int y )

=for apidoc |||setXY|int x|int y|



=cut

void
AnsiWidget::setXY( int x, int y )

=for apidoc ||int width|textWidth|char * string

Returns the width in pixels using the current font setting.

=cut

int
AnsiWidget::textWidth( char * string )

=for apidoc ||int height|textHeight|

Returns the height in pixels using the current font setting.

=cut

int
AnsiWidget::textHeight( )

=for apidoc |||setFontSize|double i|



=cut

void
AnsiWidget::setFontSize( double i )

=for apidoc ||int size|getFontSize|



=cut

int
AnsiWidget::getFontSize( )

=for apidoc ||FLTK::Color color|ansiToFltk|long color|

Converts ANSI colors to FLTK colors.

=end apidoc

=cut

fltk::Color
AnsiWidget::ansiToFltk( long color )

#endif // ifndef DISABLE_ANSIWIDGET

BOOT:
    isa("FLTK::AnsiWidget", "FLTK::Widget");
