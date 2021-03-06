#include "include/FLTK_pm.h"

MODULE = FLTK::EngravedLabel               PACKAGE = FLTK::EngravedLabel

#ifndef DISABLE_ENGRAVEDLABEL

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::EngravedLabel - Determines how to draw a label's text with an engraved look

=head1 Description

This is a subclass of L<LabelType|FLTK::LabelType>. You can use this to draw
overlapping patterns.

=cut

#include <fltk/LabelType.h>

=begin apidoc

=for apidoc xH||FLTK::EngravedLabel|new|name|

This is on my TODO list...

=cut

fltk::EngravedLabel *
fltk::EngravedLabel::new( char * name, AV * p, ... )
    CODE:
        croak("TODO - FLTK::EngravedLabel is incomplete; Feel free to contribute.");
        //RETVAL = new EngravedLabel(const char * n, const int p[][3]);

#endif // ifndef DISABLE_ENGRAVEDLABEL

BOOT:
    isa( "FLTK::EngravedLabel", "FLTK::LabelType" );
