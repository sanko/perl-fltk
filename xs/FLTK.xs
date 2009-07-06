#include <fltk/run.h>
#include <fltk/Window.h>

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>
#include "./ppport.pl"

using namespace fltk;

#define ALLOW_CALLBACKS  1
#define ALLOW_DESTROY    0 // Introduce pointless bugs :D
#define ALLOW_DEPRECATED 0 // Depreciated widgets, etc.
#define USE_IMAGE 0
#define USE_GL    0
#define USE_GLUT  0
#define USE_CAIRO 0
#define USE_X     0 // TODO

=for apidoc H||FLTK|cb_w|fltk::Widget|CODE

This is the function called by FLTK whenever callbacks are triggered. See
L<FLTK::Widget::callback()>.

=cut

void cb_w (fltk::Widget * WIDGET, void * CODE) {
#if ALLOW_CALLBACKS
    AV *cbargs = (AV *)CODE;
    I32 alen = av_len(cbargs);
    CV *thecb = (CV *)SvRV(*av_fetch(cbargs, 0, 0));
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK(sp);
    for(int i = 1; i <= alen; i++) { XPUSHs(*av_fetch(cbargs, i, 0)); }
            PUTBACK;
    call_sv((SV*)thecb, G_DISCARD);
        FREETMPS;
    LEAVE;
#else
    warn( "Callbacks have been disabled. ¬.¬ " );
#endif
}


/* Alright, let's get things started, shall we? */

MODULE = FLTK               PACKAGE = FLTK

void
run ()

INCLUDE: Button.xsi

INCLUDE: Group.xsi

INCLUDE: Window.xsi

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
