#include "include/FLTK_pm.h"

MODULE = FLTK::Plugin               PACKAGE = FLTK::Plugin

#ifndef DISABLE_PLUGIN

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::Plugin - Portable loading of plugins

=head1 Description

This is a wrapper to make it simple to load plugins on various systems.

=cut

#include <fltk/load_plugin.h>

=begin apidoc

=for apidoc ||void * pointer|load_plugin|char * file|char * symbol = ''|

Will load the C<file> as a plugin and then return a pointer to C<symbol> in
that file.

If C<symbol> is undefined, it will return a non-zero value if the plugin loads
but you cannot use this value for anything.

If there is any problem (file not found, does not load as a plugin, the symbol
is not found) it will return null if there is any problem and print debugging
info on C<STDERR>.

=cut

MODULE = FLTK::Plugin               PACKAGE = FLTK

void *
load_plugin( char * name, char * symbol = 0 )

#endif // ifndef DISABLE_PLUGIN

BOOT:
    export_tag("load_plugin", "version");
