#include "include/FLTK_pm.h"

MODULE = FLTK::ValueOutput               PACKAGE = FLTK::ValueOutput

#ifndef DISABLE_VALUEOUTPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ValueOutput - Valuator that displays the number like a text box

=head1 Description

A valuator that displays the number like a text box. This is indended for
showing the user a number, there is no way for the user to change the number.
It is much lighter weight than using an L<FLTK::Output|FLTK::Output> widget
for this.

There is no way for the user to change the number, but calling
L<C<value()>|FLTK::Widget/"value"> will change it.

=cut

#include <fltk/ValueOutput.h>

=for apidoc ||FLTK::ValueOutput * output|new|int x|int y|int w|int h|char * label = ''|



=cut

fltk::ValueOutput *
fltk::ValueOutput::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::ValueOutput>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_VALUEOUTPUT

BOOT:
    isa( "FLTK::ValueOutput" , "FLTK::Output");
