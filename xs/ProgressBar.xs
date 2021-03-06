#include "include/FLTK_pm.h"

MODULE = FLTK::ProgressBar               PACKAGE = FLTK::ProgressBar

#ifndef DISABLE_PROGRESSBAR

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ProgressBar - Widget meant to display progress of some operation

=head1 Description

L<ProgressBar|FLTK::ProgressBar> is an indicator with a bar that fills up and
text showing the job being done and expected time to go.
L<C<maximum( )>|FLTK::ProgressBar/"maximum"> and optionally
L<C<minimum( )>|FLTK::ProgressBar/"minimum"> values should be set, and for
each step of operation L<C<step( )>|FLTK::ProgressBar/"step"> should be
called.

=begin apidoc

=cut

#include <fltk/ProgressBar.h>

=for apidoc d||FLTK::ProgressBar self|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::ProgressBar> object.

=cut

#include "include/RectangleSubclass.h"

fltk::ProgressBar *
fltk::ProgressBar::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ProgressBar>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc |||range|double min|double max|double step = 1|

A shorthand for L<C<minimum( )>|FLTK::ProgressBar/"minimum">,
L<C<maximum( )>|FLTK::ProgressBar/"maximum">, and
L<C<step( )>|FLTK::ProgressBar/"step">.

=cut

void
fltk::ProgressBar::range( double min, double max, double step = 1 )

=for apidoc |||step|double step|

Increase bar length with given step and redraw widget. If value goes out of
L<C<minimum( )>|FLTK::ProgressBar/"minimum"> and
L<C<maximum( )>|FLTK::ProgressBar/"maximum"> bounds, it will be ignored.

=for apidoc ||double step|step||

Returns the bar length.

=cut

double
fltk::ProgressBar::step( double step = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->step( step );

=for apidoc |||minimum|double minimum|

Set minimal value for the progess widget.

=for apidoc ||double min|minimum||

Returns theminimal value for the progress widget.

=cut

double
fltk::ProgressBar::minimum( double minimum = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->minimum( minimum );

=for apidoc |||maximum|double maximum|

Set maximum value for the progess widget. It should represent operation
length.

=for apidoc ||double min|maximum||

Returns maximum value for the progress widget.

=cut

double
fltk::ProgressBar::maximum( double maximum = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->maximum( maximum );

=for apidoc |||position|double value|

Set position of bar in progress widget and redraw it. If C<$value> goes out of
L<C<minimum( )>|FLTK::ProgressBar/"minimum"> and
L<C<maximum( )>|FLTK::ProgressBar/"maximum"> bounds, it will be ignored.

=for apidoc ||double min|position||

Returns position value for the progress widget.

=cut

double
fltk::ProgressBar::position( double value = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->position( value );

=for apidoc |||showtext|bool show|

Shows completition percentage inside progress widget.

=for apidoc ||bool shown|showtext||

Returns wheather or not completion percentage is displayed inside progress
widget.

=cut

double
fltk::ProgressBar::showtext( bool show = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->showtext( show );

=for apidoc |||text_color|FLTK::Color color|

Changes the color of text hiddien/displayed by
L<C<showtext( )>|FLTK::ProgressBar/"showtext">.

=for apidoc ||FLTK::Color color|text_color||

Returns the color of text hiddien/displayed by
L<C<showtext( )>|FLTK::ProgressBar/"showtext">.

=cut

fltk::Color
fltk::ProgressBar::text_color( fltk::Color color = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->text_color( color );

BOOT:
    isa("FLTK::ProgressBar", "FLTK::Widget");

#endif // ifndef DISABLE_PROGRESSBAR
