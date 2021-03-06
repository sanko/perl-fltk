#include "include/FLTK_pm.h"

=for apidoc H|||_cb_f|const char * file|

This is the callback for file_chooser(...) and dir_chooser(...). It expects a
single C<const char *> parameter which should be the filename. When triggered,
the code ref handed to file_chooser_callback( CV * ) is called.

=cut

SV * file_chooser_cb;

void _cb_f (const char * file) { // Callback for file_chooser
    dTHX;
    if ( ! SvOK( file_chooser_cb ) ) return;
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    XPUSHs( newSVpv( file, strlen( file ) ) );
            PUTBACK;
    call_sv( file_chooser_cb, G_DISCARD );
        FREETMPS;
    LEAVE;
}

MODULE = FLTK::file_chooser               PACKAGE = FLTK::file_chooser

#ifndef DISABLE_FILE_CHOOSER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::file_chooser - File chooser widget for the Fast Light Tool Kit

=head1 Description



=begin apidoc

=cut

#include <fltk/file_chooser.h>

=for apidoc T[dialog,default]F||char * directory|dir_chooser|char * message|char * directory|int relative = 0|

Show a file chooser dialog and pick a directory.

Expected parameters include the C<$message> in the titlebar, the initially
selected C<$directory>, and a boolean value which decides whether the returned
value is relative (true) or absolute (false).

=for apidoc T[dialog,default]F||char * file|file_chooser|char * message|char * pattern|char * filename|int relative = 0|

Pops up the file chooser, waits for the user to pick a file or Cancel, and
then returns that filename or undef if Cancel is chosen.

C<$message> is a string used to title the window.

C<$pattern> is used to limit the files listed in a directory to those matching
the pattern. This matching is done by C<filename_match( )>. Use undef to show
all files.

C<$filename> is a default folder/filename to fill in the chooser with. If this
ends with a '/' then this is a default folder and no file is preselected.

If C<$filename> is undef, then the last filename that was choosen is used,
unless the C<$pattern> changes, in which case only the last directory is used.
The first time the file chooser is called this defaults to a blank string.

The returned value points at a static buffer that is only good until the next
time the L<C<file_chooser( )>|FLTK::file_chooser/"dialog"> is called.

=cut

MODULE = FLTK::file_chooser               PACKAGE = FLTK

const char *
dir_chooser( char * message, char * directory, int relative = 0 )
    CODE:
        RETVAL = fltk::dir_chooser( message, directory, relative );
    OUTPUT:
        RETVAL


BOOT:
    export_tag("dir_chooser", "dialog");
    export_tag("dir_chooser", "default");

const char *
file_chooser( char * message, char * pattern, char * filename, int relative = 0 )
    CODE:
        RETVAL = fltk::file_chooser( message, pattern, filename, relative );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("alert", "dialog");
    export_tag("alert", "default");

MODULE = FLTK::file_chooser               PACKAGE = FLTK::file_chooser

=for apidoc T[dialog]F|||file_chooser_callback|CV * coderef|

This function is called every time the user navigates to a new file or
directory in the file chooser. It can be used to preview the result in the
main window.

=end apidoc

=cut

MODULE = FLTK::file_chooser               PACKAGE = FLTK

void
file_chooser_callback( CV * coderef )
    CODE:
        file_chooser_cb = newSVsv( ST( 0 ) );
        fltk::file_chooser_callback(_cb_f);

BOOT:
    export_tag("file_chooser_callback", "dialog");
    export_tag("file_chooser_callback", "default");

#endif // ifndef DISABLE_FILE_CHOOSER
