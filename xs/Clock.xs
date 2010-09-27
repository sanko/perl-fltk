#include "include/FLTK_pm.h"

MODULE = FLTK::Clock               PACKAGE = FLTK::Clock

#ifndef DISABLE_CLOCK

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Clock - Clock widget for the Fast Light Tool Kit

=head1 Description

This widget provides a round analog clock display and is provided for Forms
compatibility. It installs a 1-second timeout callback using
L<C<FLTK::add_timeout()>|FLTK/"add_timeout">.

The L<C<color()>|FLTK::Color/"color"> fills the background. The
L<C<selectioncolor()>|FLTK::color/"selectioncolor"> (which defaults to
C<GRAY85>) fills the hands. The L<C<textcolor()>|FLTK::color/"textcolor"> is
used to color in the tick marks and outline the hands.

L<C<type()>|FLTK::Widget/"type"> may be set to C<SQUARE>, C<ROUND>, or
C<DIGITAL>). See the base class L<ClockOutput|FLTK::ClockOutput> for some
other methods.

=head1 Design credits

Original clock display written by Paul Haeberli at SGI.

Modifications by Mark Overmars for Forms

Further changes by Bill Spitzak for fltk

=cut

#include <fltk/Clock.h>

=begin apidoc

=for apidoc ||FLTK::Clock * self|new|int x|int y|int w|int h|char * label = ''|



=cut

void
fltk::Clock::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::Clock>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

#endif // ifndef DISABLE_CLOCK

BOOT:
    isa("FLTK::Clock", "FLTK::ClockOutput");
