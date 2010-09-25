#include "include/FLTK_pm.h"

MODULE = FLTK::FileIcon               PACKAGE = FLTK::FileIcon

#ifndef DISABLE_FILEICON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::FileIcon - Subclass of FLTK::Image used to represent a single file type

=head1 Description



=begin apidoc

=cut

#include <fltk/FileIcon.h>

=for apidoc d||FLTK::FileIcon icon|new|char * pattern|int type|int ndata = 0|

Create a new file icon.

=cut

fltk::FileIcon *
fltk::FileIcon::new( char * pattern, int type, int ndata = 0 )

#endif // ifndef DISABLE_FILEICON

BOOT:
    isa("FLTK::FileIcon", "FLTK::Symbol");
