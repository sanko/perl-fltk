#include "include/FLTK_pm.h"

MODULE = FLTK::LabelType               PACKAGE = FLTK::LabelType

#ifndef DISABLE_LABELTYPE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::LabelType - Determines how to draw a label's text

=head1 Description

A L<LabelType|FLTK::LabelType> determines how to draw the text of the label.
This is not used very much, it can be used to draw engraved or shadowed
labels. You could also put in code that interprets the text of the label and
draws anything you want with it.

=cut

#include <fltk/LabelType.h>

=begin apidoc

=for apidoc ||FLTK::LabelType type|new|char * name|



=cut

fltk::LabelType *
fltk::LabelType::new( char * name )

=for apidoc ||char * string|name||



=cut

const char *
fltk::LabelType::name( )
    CODE:
        RETVAL = THIS->name;
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::LabelType type|next||



=for apidoc ||FLTK::LabelType type|first||



=cut

fltk::LabelType *
fltk::LabelType::next( )
    CODE:
        RETVAL = THIS->next;
    OUTPUT:
        RETVAL

fltk::LabelType *
fltk::LabelType::first( )
    CODE:
        RETVAL = THIS->first;
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::LabelType type|find|char * name|



=cut

fltk::LabelType *
fltk::LabelType::find( char * name )

#INCLUDE: EngravedLabel.xsi

#endif // ifndef DISABLE_LABELTYPE
