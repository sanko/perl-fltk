#include "include/FLTK_pm.h"

MODULE = FLTK::HelpView               PACKAGE = FLTK::HelpView

#ifndef DISABLE_HELPVIEW

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::HelpView - Basic HTML viewer

=head1 Description

Most HTML 2.0 elements are supported, as well as a primitive implementation of
tables. GIF, JPEG, and PNG images are displayed inline.

=head1 Subclassing

Note that L<C<HelpView>|FLTK::HelpView> may not be subclassed like every other
widget in FLTK because fltk::HelpView::draw( ) and
fltk::HelpView::handle( ... ) are private. If I subclass them, I lose basic
functionality because I cannot access those functions from a child class.

This is a "bug" and I'll report it when I have the time.

=begin apidoc

=cut

#include <fltk/HelpView.h>

=for apidoc ||FLTK::HelpView hv|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<HelpView|FLTK::HelpView>.

=cut

fltk::HelpView *
fltk::HelpView::new( int x, int y, int w, int h, char * label = 0 )

=for apidoc ||char * dir|directory||



=for apidoc ||char * file|filename||



=cut

const char *
fltk::HelpView::directory ( )

const char *
fltk::HelpView::filename( )

=for apidoc ||int result|load|char * filename|

Load the specified file. Returns C<0> on success and C<-1> on error

=cut

int
fltk::HelpView::load( char * filename )

=for apidoc ||int pixels|size||



=cut

int
fltk::HelpView::size( )

=for apidoc |||textcolor|FLTK::Color color|



=for apidoc ||FLTK::Color color|textcolor||



=cut

fltk::Color
fltk::HelpView::textcolor( fltk::Color color = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->textcolor( color );

=for apidoc |||textfont|FLTK::Font * font|



=for apidoc ||FLTK::Font * font|textfont||



=cut

fltk::Font *
fltk::HelpView::textfont( fltk::Font * font = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->textfont( font );

=for apidoc |||textsize|int size|



=for apidoc ||int size|textsize||



=cut

int
fltk::HelpView::textsize( int size = NO_INIT )
        CASE: items == 1
            C_ARGS:
        CASE:
            CODE:
                THIS->textsize( size );

=for apidoc ||char * str|title||



=cut

const char *
fltk::HelpView::title( )

=for apidoc |||topline|char * string|

Sets the top line to the named line.

=for apidoc |||topline|int index|

Sets the top line to the I<index>th line.

=for apidoc ||int num|topline|||

Retusn the index of the current top line.

=cut

int
fltk::HelpView::topline( line = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: SvIOK( ST(1) )
        int line
        CODE:
            THIS->topline( line );
    CASE:
        char * line
        CODE:
            THIS->topline( line );

=for apidoc |||leftline|int col|

Set the left position.

=for apidoc ||int col|leftline||

Get the left position.

=cut

int
fltk::HelpView::leftline( int col = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->leftline( col );

=for apidoc |||value|char * string|

Set the help text directly.

=for apidoc ||char * string|value||

Get the current help text.

=cut

const char *
fltk::HelpView::value( char * value = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->value( value );

=for apidoc ||int ok|find|char * string|int start = 0|

Find the specified string in the current help text. This is a plain text
search.

Returns C<0> on success. Returns C<-1> on failure.

=cut

int
fltk::HelpView::find( char * string, int start = 0 )

#endif // ifndef DISABLE_HELPVIEW

BOOT:
    isa("FLTK::HelpView", "FLTK::Group");
