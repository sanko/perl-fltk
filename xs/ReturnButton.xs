#include "include/FLTK_pm.h"

MODULE = FLTK::ReturnButton               PACKAGE = FLTK::ReturnButton

#ifndef DISABLE_RETURNBUTTON

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ReturnButton - 12:50, press Return

=head1 Description

Same as a normal L<button|FLTK::Button> except the
L<C<shortcut( )>|FLTK::Widget/"shortcut"> is preset to C<ReturnKey> and
C<KeypadEnter>, and a glyph is drawn to indicate this.

=begin apidoc

=cut

#include <fltk/ReturnButton.h>

=for apidoc ||FLTK::ReturnButton button|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::ReturnButton> object. Obviously.

=cut

#include "include/WidgetSubclass.h"

void
fltK::ReturnButton::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::ReturnButton>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::ReturnButton::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

#endif // #ifndef DISABLE_RETURNBUTTON

BOOT:
    isa("FLTK::ReturnButton", "FLTK::Button");
