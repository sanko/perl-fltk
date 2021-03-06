#include "include/FLTK_pm.h"

MODULE = FLTK::Output               PACKAGE = FLTK::Output

#ifndef DISABLE_OUTPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Output - One-line text output

=head1 Description

This widget displays a piece of text. When you set the
L<C<value()>|FLTK::Widget/"value">, it does a C<strcpy()> to it's own storage,
which is useful for program-generated values. You can also call
L<C<static_value( )>|FLTK::Widget/"static_value"> if you know the original
text will not be deleted. The text may contain any characters except C<\0>.
Any control characters less than 32 will display in C<^X> notation. Other
characters are drawn without any changes.

The user may select portions of the text using the mouse and paste the
contents into other fields or programs.

=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/Output.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::Output output|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::Output> object.

=cut

#include "include/RectangleSubclass.h"

fltk::Output *
fltk::Output::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Output>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::NamedStyle * style|default_style||

L<Output|FLTK::Output> has it's own style so the color can be set to gray like
Motif-style programs want.

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Output::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

#INCLUDE: MultiLineOutput.xsi

#INCLUDE: ValueOutput.xsi

#endif // ifndef DISABLE_OUTPUT

BOOT:
    isa("FLTK::Output", "FLTK::Input");
