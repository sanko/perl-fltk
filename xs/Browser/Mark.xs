#include "../include/FLTK_pm.h"

MODULE = FLTK::Browser::Mark               PACKAGE = FLTK::Browser::Mark

#ifndef DISABLE_BROWSER_MARK

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Browser::Mark - Subclass of FLTK::Menu

=head1 Description

TODO

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/Browser.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc ||FLTK::Browser::Mark self|new||



=for apidoc ||FLTK::Browser::Mark self|new|FLTK::Browser::Mark to_clone|



=cut

fltk::Browser::Mark *
fltk::Browser::Mark::new( fltk::Browser::Mark * mark = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = new fltk::Browser::Mark( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = new fltk::Browser::Mark( * mark );
        OUTPUT:
            RETVAL

=for apidoc |||destroy||

Destroy the mark.

=cut

void
fltk::Browser::Mark::destroy( )
    CODE:
        delete THIS;
        sv_setsv(ST(0), &PL_sv_undef);

=for apidoc ||int result|compare|FLTK::Browser::Mark * mark2|

Returns...

=over

=item ...C<-2> or less if this is before C<mark2>

=item ...C<-1> if this is a parent of C<mark2>

=item ...C<0> if this is equal to C<mark2>

=item ...C<1> if this is a child of C<mark2>

=item ...C<2> or greater if this is after C<mark2>

=back

=cut

int
fltk::Browser::Mark::compare( fltk::Browser::Mark * mark2 )
    C_ARGS: * mark2

=for apidoc |||unset||



=cut

void
fltk::Browser::Mark::unset( )

=for apidoc ||bool set|is_set||



=cut

bool
fltk::Browser::Mark::is_set( )

#endif // ifndef DISABLE_BROWSER_MARK
