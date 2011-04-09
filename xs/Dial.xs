#include "include/FLTK_pm.h"

MODULE = FLTK::Dial               PACKAGE = FLTK::Dial

#ifndef DISABLE_DIAL

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Dial - Rotating value control

=head1 Description

The L<FLTK::Dial|FLTK::Dial> widget provides a circular dial to control a
single floating point value.

Use type() to change how it draws:

=over

=item L<C<NORMAL>|/"NORMAL">
Draws a normal dial with a knob.

=item L<C<LINE>|/"LINE">
Draws a dial with a line.

=item L<C<FILL>|/"FILL">
Draws a dial with a filled arc.

=back

You can change the L<C<box()>|FLTK::Widget/"box"> from the default of
C<OVAL_BOX> to draw different borders. The L<C<box()>|FLTK::Widget/"box"> is
filled with L<C<color()>|FLTK::color/"color">, the moving part is filled with
L<C<selection_color()>|FLTK::color/"selection_color">, and the border around
the moving part is set by L<C<textcolor()>|FLTK::color/"textcolor">.

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/Dial.h>

=begin apidoc

=for apidoc d||FLTK::Dial dial|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::Dial> object.

=cut

#include "include/RectangleSubclass.h"

fltk::Dial *
fltk::Dial::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Dial>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||int a1|angle1||

See L<C<angles()>|/"angles">.

=for apidoc ||int a1|angle1|int a|

See L<C<angles()>|/"angles">.

=cut

short
fltk::Dial::angle1( short a = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->angle1( a );

=for apidoc ||int a2|angle2||

See L<C<angles()>|/"angles">.

=for apidoc ||int a2|angle2|int b|

See L<C<angles()>|/"angles">.

=cut

short
fltk::Dial::angle2( short b = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->angle2( b );

=for apidoc |||angles|short a|short b|

Sets the angles used for the minimum and maximum values. The default values
are C<45> and C<315> (C<0> degrees is straight down and the angles progress
clockwise). Normally C<ANGLE1> is less than C<ANGLE2>, but if you reverse them
the dial moves counter-clockwise.

=cut

void
fltk::Dial::angles( short a, short b )

int
NORMAL( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = fltk::Dial::NORMAL; break;
            case 1: RETVAL = fltk::Dial::LINE;   break;
            case 2: RETVAL = fltk::Dial::FILL;   break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        LINE = 1
        FILL = 2

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

#INCLUDE: FillDial.xsi

#INCLUDE: LineDial.xsi

#endif // ifndef DISABLE_DIAL

BOOT:
    isa("FLTK::Dial", "FLTK::Valuator");
