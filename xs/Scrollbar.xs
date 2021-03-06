#include "include/FLTK_pm.h"

MODULE = FLTK::Scrollbar               PACKAGE = FLTK::Scrollbar

#ifndef DISABLE_SCROLLBAR

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.532006

=head1 NAME

FLTK::Scrollbar - Controls an integer position of a window of a given size
inside a data set of a given total size

=head1 Description

The L<Scrollbar|FLTK::Scrollbar> widget displays a slider with arrow buttons
at the ends of the scrollbar. Clicking on the arrows move up/left and
down/right by L<C<linesize( )>|FLTK::Widget/"linesize">. If the scrollbar has
the keyboard focus the arrows move by
L<C<linesize( )>|FLTK::Widget/"linesize">, and vertical scrollbars take Page
Up/Down (they move by the page size minus
L<C<linesize( )>|FLTK::Widget/"linesize">) and Home/End (they jump to the top
or bottom). Often a widget that takes focus such as the browser will just send
keystrokes to the scrollbar directly to get it to move in response.

=begin apidoc

=cut

#include <fltk/Scrollbar.h>

=for apidoc ||FLTK::Scrollbar * self|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<FLTK::Scrollbar|FLTK::Scrollbar> widget.

=cut

#include "include/RectangleSubclass.h"

fltk::Scrollbar *
fltk::Scrollbar::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Scrollbar>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::NamedStyle * style|default_style||



=for apidoc |||default_style|FLTK::NamedStyle * new_style|



=cut

fltk::NamedStyle *
fltk::Scrollbar::default_style( fltk::NamedStyle * new_style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = new_style;

=for apidoc ||int value|value||

Return the current position of the scrollbar as an integer.

L<Scrollbars|FLTK::Scrollbar> have L<C<step( 1 )>|FLTK::Valuator/"step">
preset (they always return integers). If desired you can set the
L<C<step( )>|FLTK::Valuator/"step"> to non-integer values. You will then have
to use casts to get at the floating-point versions of
L<C<value( )>|FLTK::Valuator/"value"> from the L<Slider|FLTK::Slider>
base class.

=for apidoc ||bool set|value|int position|

Set the current position of the scrollbar.

=for apidoc ||bool set|value|int position|int size|ing top|int total|

Set the current position, the range, the pagesize, and the
L<C<slider_size( )>|FLTK::Scrollbar/"slider_size"> all at once in a useful
way.

Parameters include...

=over

=item * C<position> is the position in the data of the first pixel in the
window

=item * C<size> is the size of the window

=item * C<top> is the position of the top of your data (typically zero)

=item * C<total> is the total size of your data

=back

=cut

int
fltk::Scrollbar::value( int position = NO_INIT, int size = NO_INIT, int top = NO_INIT, int total = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        C_ARGS: position
    CASE: items == 5
        C_ARGS: position, size, top, total

=for apidoc ||int size|pagesize||


=for apidoc |||pagesize|int size|

How much the pageup/down keys and clicking in the empty area move by. If you
call L<C<value( )>|FLTK::Scrollbar/"value"> this is set to 1
L<C<linesize( )>|FLTK::Scrollbar/"linesize"> less than the window.

=cut

int
fltk::Scrollbar::pagesize( int size = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->pagesize( size );

#endif // ifndef DISABLE_SCROLLBAR

BOOT:
    isa( "FLTK::Scrollbar", "FLTK::Slider" );
