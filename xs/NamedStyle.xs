#include "include/FLTK_pm.h"

MODULE = FLTK::NamedStyle               PACKAGE = FLTK::NamedStyle

#ifndef DISABLE_NAMEDSTYLE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::NamedStyle - Simulate themes (by name) for the Fast Light Toolkit

=head1 Description

Typically a widget class will define a single NamedStyle that is used by all
instances of that widget. A "theme" can locate this structure by looking it up
by name (using the L<C<find()>|FLTK::Style/"find"> method) and then change it
to change the appearance of all widgets of that class.

The reason a string name is used, rather than making the style be a public
static data member of the class, is so that a theme can modify a large number
of types of widgets without having them all linked into a program. If
L<C<find()>|FLTK::Style/"find"> returns null it should just skip that setting
code because that widget is not used by this program.

The "revert" function is mostly provided to make it easy to initialize the
fields even though C++ does not allow a structure constant. It is also used to
undo theme changes when L<C<FLTK::reset_theme()>|FLTK/"reset_theme"> is
called.

=begin apidoc

=cut

#include <fltk/Style.h>

=for apidoc |||destroy|

Destroy the L<NamedStyle|FLTK::NamedStyle>.

=cut

void
fltk::NamedStyle::destroy( )
    CODE:
        delete THIS;
        sv_setsv(ST(0), &PL_sv_undef);

=for apidoc ||FLTK::NamedStyle style|new|const char * name|FLTK::Style * revert|FLTK::NamedStyle * backptr|



=for apidoc ||FLTK::NamedStyle style|new|FLTK::NamedStyle * existing_style|



=cut

fltk::NamedStyle *
fltk::NamedStyle::new( style, fltk::Style * revert = NO_INIT, fltk::NamedStyle * backptr = NO_INIT )
    CASE: items == 2
        fltk::NamedStyle * style
        CODE:
            RETVAL = new fltk::NamedStyle( * style );
        OUTPUT:
            RETVAL
    CASE: items == 4
        const char * style
        CODE:
            RETVAL = new fltk::NamedStyle( style, (void ( * )( fltk::Style * )) revert, &backptr );
        OUTPUT:
            RETVAL

=for apidoc ||const char * name|name||


=cut

const char *
fltk::NamedStyle::name( const char * name = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->name;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->name = name;

=for apidoc ||FLTK::NamedStyle next|next|||


=cut

fltk::NamedStyle *
fltk::NamedStyle::next( )
    CODE:
        RETVAL = THIS->next;
    OUTPUT:
        RETVAL

=for apidoc F||FLTK::NamedStyle style|first||



=cut

fltk::NamedStyle *
first( )
    CODE:
        RETVAL = fltk::NamedStyle::first;
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_NAMEDSTYLE

BOOT:
    isa("FLTK::NamedStyle", "FLTK::Style");
