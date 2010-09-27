#include "include/FLTK_pm.h"

MODULE = FLTK::Monitor               PACKAGE = FLTK::Monitor

#ifndef DISABLE_MONITOR

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Monitor - Represents the entire viewing area

=head1 Description



=cut

#include <fltk/Monitor.h>

=for apidoc ||FLTK::Rectangle * rect|work||

Allows you to do C<$rect->work->x()>, etc.

=cut

fltk::Rectangle
fltk::Monitor::work( )
    CODE:
        RETVAL = THIS->work;
    OUTPUT:
        RETVAL

=for apidoc ||int depth|depth||



=cut

int
fltk::Monitor::depth( )

=for apidoc ||float x|dpi_x||



=for apidoc ||float y|dpi_y||



=for apidoc ||float y|dpi||

Same as L<C<dpi_y>|FLTK::Monitor/"dpi_y">.

=cut

float
fltk::Monitor::dpi_x( )

float
fltk::Monitor::dpi_y( )

float
fltk::Monitor::dpi( )

=for apidoc ||int count|list|AV * monitors|



=cut

int
fltk::Monitor::list( AV * monitors )
    INIT:
        fltk::Monitor ** _monitors;
        for ( int i = 0; i < av_len(monitors); i++ )
            _monitors[ i ] = (fltk::Monitor *)(av_fetch(monitors, i, 0));
    C_ARGS: ( const fltk::Monitor ** ) _monitors

=for apidoc ||FLTK::Monitor large|all||



=cut

fltk::Monitor
fltk::Monitor::all( )

=for apidoc ||FLTK::Monitor location|find|int x|int y|



=cut

fltk::Monitor
fltk::Monitor::find(int x, int y)

#endif // ifndef DISABLE_MONITOR

BOOT:
    isa("FLTK::Monitor", "FLTK::Rectangle");
