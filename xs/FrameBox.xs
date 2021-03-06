#include "include/FLTK_pm.h"

MODULE = FLTK::FrameBox               PACKAGE = FLTK::FrameBox

#ifndef DISABLE_FRAMEBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::FrameBox - Box drawing code for the Fast Light Tool Kit (FLTK)

=head1 Description

This box class interprets a small string stored in L<C<data()>|/"data"> to
indicate the gray shades to draw around the edge of the box and can be used to
draw simple bezels.

The box is drawn by calling L<C<drawframe()>|/"drawframe"> or
L<C<drawframe2()>|/"drawframe2"> if the string starts with a '2'.

The normal up box draws the pattern C<AAWWHHTT>

The normal down_ box draws the pattern C<WWHHPPAA>

The C<PUSHED> or C<STATE> flags will cause the pattern from
L<C<down_()>|/"down_"> to be used instead, allowing you to draw a different
bezel when pushed in.

The C<INVISIBLE> flag will not draw the interior, which can make many widgets
draw faster and with less blinking.

=begin apidoc

=cut

#include <fltk/Box.h>

=for apidoc ||FLTK::FrameBox * box|new|char * name|int x|int y|int w|int h|char * pattern|FLTK::Box * down = 0|

Constructor where you give the thickness of the borders used by
L<C<inset()>|/"inset">.

=cut

#include "include/RectangleSubclass.h"

fltk::FrameBox *
fltk::FrameBox::new( char * name, int x, int y, int w, int h, char * pattern, fltk::Box * down = 0  )
    CODE:
        RETVAL = new RectangleSubclass<fltk::FrameBox>(CLASS,name,x,y,w,h,pattern,down);
    OUTPUT:
        RETVAL

=for apidoc ||char * string|data||



=for apidoc |||data|char * string|



=cut

const char *
fltk::FrameBox::data( char * string = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->data( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->data( string );


=for apidoc |||_draw|FLTK::Rectangle * rect|



=cut

void
fltk::FrameBox::_draw( fltk::Rectangle * rect )
    C_ARGS: * rect

=for apidoc |||inset|FLTK::Rectangle * rect|



=cut

void
fltk::FrameBox::inset( fltk::Rectangle * rect )
    C_ARGS: * rect

=for apidoc ||bool does_it|fills_rectangle||



=for apidoc ||bool is_it|is_frame||


=end apidoc

=cut

bool
fltk::FrameBox::fills_rectangle(  )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->fills_rectangle( ); break;
            case 1: RETVAL = THIS->is_frame( ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        is_frame = 1

#endif // #ifndef DISABLE_FRAMEBOX

BOOT:
    isa("FLTK::FrameBox", "FLTK::Box");
