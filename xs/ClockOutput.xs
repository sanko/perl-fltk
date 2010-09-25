#include "include/FLTK_pm.h"

MODULE = FLTK::ClockOutput               PACKAGE = FLTK::ClockOutput

#ifndef DISABLE_CLOCKOUTPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::ClockOutput - Base class of FLTK::Clock

=head1 Description

Base class of L<C<Clock>|FLTK::Clock>, this one does not move, it just
displays whatever time  you set into it.

L<C<type()>|FLTK::Widget/"type"> may be set to C<SQUARE>, C<ROUND>, or
C<DIGITAL> (nyi).

=begin apidoc

=cut

#include <fltk/Clock.h>

=for apidoc ||FLTK::ClockOutput * self|new|int x|int y|int w|int h|char * label = ''|



=cut

void
fltk::ClockOutput::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::ClockOutput>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal( );
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=begin apidoc

=for apidoc et[clock]||int type|SQUARE||



=for apidoc et[clock]||int type|ANALOG||



=for apidoc et[clock]||int type|ROUND||



=for apidoc et[clock]||int type|DIGITAL||



=cut

BOOT:
    register_constant( "SQUARE", newSViv(fltk::ClockOutput::SQUARE));
    export_tag("SQUARE", "clock");
    register_constant( "ANALOG", newSViv(fltk::ClockOutput::ANALOG));
    export_tag("ANALOG", "clock");
    register_constant( "ROUND", newSViv(fltk::ClockOutput::ROUND));
    export_tag("ROUND", "clock");
    register_constant( "DIGITAL", newSViv(fltk::ClockOutput::DIGITAL));
    export_tag("DIGITAL", "clock");

=for apidoc |||value|unsigned long time|

Set the clock to a Unix timestamp. The value is passed through the
L<C<localtime()>|/"localtime"> function and used to get the hour, minute, and
second.

=for apidoc |||value|int hour|int minute|int second|

Set the hour, minute, and second to display. The hour is effectively taken
modulus 12 and the minute and second modulus 60 to figure out where to place
the hands. Redraw happens only if different.

Note that this does not set the L<C<value()>|/"value">; ...without the date,
it really can't.

=for apidoc ||int time|value||

Return the last Unix timestamp the clock was set to.

=cut

unsigned long
fltk::ClockOutput::value( unsigned long time = NO_INIT, int minute = NO_INIT, int second = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->value( );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->value( time );
            XSRETURN_EMPTY;
    CASE: items == 4
        CODE:
            THIS->value( time, minute, second );
            XSRETURN_EMPTY;

=for apidoc ||int h|hour||

Return the hour sent to the last call to L<C<value()>|/"value">.

=for apidoc ||int m|minute||

Return the minute sent to the last call to L<C<value()>|/"value">.

=for apidoc ||int s|second||

Return the second sent to the last call to L<C<value()>|/"value">.

=cut

int
fltk::ClockOutput::hour( )

int
fltk::ClockOutput::minute( )

int
fltk::ClockOutput::second( )

#INCLUDE: Clock.xsi

#endif // #ifndef DISABLE_CLOCKOUTPUT

BOOT:
    isa("FLTK::ClockOutput", "FLTK::Widget");
