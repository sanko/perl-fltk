#include "include/FLTK_pm.h"

MODULE = FLTK::HelpDialog               PACKAGE = FLTK::HelpDialog

#ifndef DISABLE_HELPDIALOG

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::HelpDialog - Help dialog with basic HTML viewing capabilities

=head1 Description

Uses L<HelpView|FLTK::HelpView> to display basic HTML in a standard dialog.

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/HelpDialog.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc ||FLTK::HelpDialog hd|new||

Creates a new L<HelpDialog|FLTK::HelpDialog>.

=cut

fltk::HelpDialog *
fltk::HelpDialog::new( )

=for apidoc |||destroy||

Destroy the L<HelpDialog|FLTK::HelpDialog>.

=cut

void
fltk::HelpDialog::destroy( )
    CODE:
        delete THIS;
        sv_setsv(ST(0), &PL_sv_undef);

=for apidoc ||int h|h||

Returns the vertical size of the help dialog.

=for apidoc ||int w|w||

Returns the horizontal size of the help dialog.

=for apidoc ||int x|x||

Returns the position of the help dialog.

=for apidoc ||int y|y||

Returns the position of the help dialog.

=cut

int
fltk::HelpDialog::h( )

int
fltk::HelpDialog::w( )

int
fltk::HelpDialog::x( )

int
fltk::HelpDialog::y( )

=for apidoc |||hide||

Hides the L<HelpDialog|FLTK::HelpDialog>.

=for apidoc |||show||

Shows the main L<HelpDialog|FLTK::HelpDialog>'s L<window|FLTK::Window>.

=cut

void
fltk::HelpDialog::hide( )

void
fltk::HelpDialog::show( )

=for apidoc |||load|char * filename|

Load the specified HTML file into the L<HelpView|FLTK::HelpView>.

=cut

void
fltk::HelpDialog::load( char * filename )

=for apidoc |||position|int x|int y|

Move the L<HelpDialog|FLTK::HelpDialog> to a new position.

=cut

void
fltk::HelpDialog::position( int x, int y )

=for apidoc |||resize|int x|int y|int w|int h|

Set the screen position and size of the L<HelpDialog|FLTK::HelpDialog> of the
dialog.

=cut

void
fltk::HelpDialog::resize( int x, int y, int w, int h )

=for apidoc |||textsize|int size|

Sets the default text size for the help view.

=for apidoc ||int size|textsize||

Gets the default text size for the help view.

=cut

uchar
fltk::HelpDialog::textsize( uchar size = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->textsize( size );

=for apidoc |||topline|char * string|

Sets the top line in the L<HelpView|FLTK::HelpView> widget to the named line.

=for apidoc |||topline|int index||

Sets the top line in the L<HelpView|FLTK::HelpView> widget to the I<index>th line.

=cut

void
fltk::HelpDialog::topline( line )
    CASE: SvIOK( ST(1) )
        int line
    CASE:
        char * line

=for apidoc |||value|char * string|

Sets the current buffer to the string provided and reformats the text.

=for apidoc ||char * string|value||

Returns the current buffer.

=cut

const char *
fltk::HelpDialog::value( char * string = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->value( string );

=for apidoc ||int visible|visible||

Returns C<1> if the L<HelpDialog|FLTK::HelpDialog> window is visible.

=cut

int
fltk::HelpDialog::visible( )

#endif // ifndef DISABLE_HELPDIALOG
