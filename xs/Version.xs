#include "include/FLTK_pm.h"

MODULE = FLTK::Version               PACKAGE = FLTK::Version

#ifndef DISABLE_VERSION

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Version - Version info for FLTK

=head1 Description

Contains the version number for the FLTK library. This allows you to write
conditionally compiled code for different versions of FLTK.

C<FL_VERSION> describes the major, minor, and patch version numbers. The
integer value is the major number. One digit is used for the minor number, and
three for the "patch" number which is increased for each binary differnt
release (it can go to C<999>).

Import C<FL_VERSION>, C<FL_MAJOR_VERSION>, C<FL_MINOR_VERSION>, and
C<FL_PATCH_VERSION> constants with the C<version> tag.

=cut

#include <fltk/FL_VERSION.h>

=begin apidoc

=for apidoc T[version]||double ver|version||

Returns the value of C<FL_VERSION> that FLTK was compiled with. This can be
compared to the C<FL_VERSION> function to see if the shared library of fltk
your program linked with is up to date.

=end apidoc

=cut

MODULE = FLTK::Version               PACKAGE = FLTK

double
version( )
    CODE:
        RETVAL = fltk::version( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("version", "version");
    register_constant("FL_MAJOR_VERSION", newSViv(FL_MAJOR_VERSION));
    export_tag("FL_MAJOR_VERSION", "version");
    register_constant("FL_MINOR_VERSION", newSViv(FL_MINOR_VERSION));
    export_tag("FL_MINOR_VERSION", "version");
    register_constant("FL_PATCH_VERSION", newSViv(FL_PATCH_VERSION));
    export_tag("FL_PATCH_VERSION", "version");
    register_constant("FL_VERSION", newSVnv(FL_VERSION));
    export_tag("FL_VERSION", "version");

#endif // ifndef DISABLE_VERSION
