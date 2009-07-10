#include <EXTERN.h>
#include <perl.h>
#define NO_XSLOCKS // XSUB.h will otherwise override various things we need
#include <XSUB.h>
#include "./ppport.pl"

#include <fltk/Widget.h>
using namespace fltk;

#define ENABLE_CALLBACKS  // Depends on weak refs... see FLTK::_cb_w
//#define ENABLE_DESTROY    // Introduce pointless bugs :D
//#define ENABLE_DEPRECATED // Depreciated widgets, etc.
#define USE_IMAGE 0
#define USE_GL    0
#define USE_GLUT  0
#define USE_CAIRO 0
#define USE_X     0 // TODO

=for apidoc H||FLTK|cb_w|fltk::Widget|CODE

This is the function called by FLTK whenever callbacks are triggered. See
L<FLTK::Widget::callback()>.

=cut

#ifndef SvWEAKREF           // Callbacks use weak references to the widget
#undef  ENABLE_CALLBACKS    // TODO: Explain this better :)
#endif // #ifndef SvWEAKREF

#include <fltk/Widget.h>
void _cb_w (fltk::Widget * WIDGET, void * CODE) {
#ifdef ENABLE_CALLBACKS
    AV *cbargs = (AV *) CODE;
    I32 alen = av_len(cbargs);
    SV *thecb = SvRV(*av_fetch(cbargs, 0, 0));
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK(sp);
    for(int i = 1; i <= alen; i++) { XPUSHs(*av_fetch(cbargs, i, 0)); }
            PUTBACK;
    call_sv((SV*) thecb, G_DISCARD|G_EVAL);
        FREETMPS;
    LEAVE;
#else // ifdef ENABLE_CALLBACKS
    warn( "Callbacks have been disabled. ...how'd you get here? ¬.¬ " );
#endif // ifdef ENABLE_CALLBACKS
}

/* Alright, let's get things started, shall we? */

MODULE = FLTK               PACKAGE = FLTK

INCLUDE: run.xsi

INCLUDE: Adjuster.xsi

INCLUDE: Button.xsi

INCLUDE: Group.xsi

INCLUDE: Widget.xsi

INCLUDE: Window.xsi


MODULE = FLTK               PACKAGE = FLTK

BOOT:
#ifndef ENABLE_CALLBACKS
    warn( "FLTK's callback system has been disabled %s.\n",
#ifndef SvWEAKREF
            "because weak references are not implemented in this release of perl"
#else  // #ifndef SvWEAKREF
            "manually"
#endif // #ifndef SvWEAKREF
    );
#endif



=pod

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

CPAN ID: SANKO

=head1 License and Legal

Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify
it under the terms of The Artistic License 2.0.  See the F<LICENSE>
file included with this distribution or
http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered
by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

=for git $Id$ for got=

=cut
