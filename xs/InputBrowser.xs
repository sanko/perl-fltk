#include "include/FLTK_pm.h"

MODULE = FLTK::InputBrowser               PACKAGE = FLTK::InputBrowser

#ifndef DISABLE_INPUTBROWSER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::InputBrowser - Input Browser (Combo Box) widget

=head1 Description

MicroSoft style "ComboBox" with the menu appearing below with a scrollbar. I
would like to use the name "ComboBox" or "InputChoice" for a more
user-friendly version which uses pop-up menus and positions the menu with the
cursor pointing at the current item, but this version can be used to get what
MicroSoft users expect. The implementation is a good example of how to get a
widget to appear in a modal pop-up window.

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/InputBrowser.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=begin apidoc

=for apidoc ||FLTK::InputBrowser self|new|int x|int y|int w|int h|char * label = ""|

Creates a new C<FLTK::InputBrowser> object. Obviously.

=cut

#include "include/WidgetSubclass.h"

void
fltk::InputBrowser::new( int x, int y, int w, int h, const char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::InputBrowser>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=end apidoc

=head1 Values for L<C<type()>|FLTK::Widget/"type">

=over

=item C<NORMAL>

=item C<NONEDITABLE>

=item C<INDENTED>

=item C<NONEDITABLE_INDENTED>

=back

=begin apidoc

=cut

int
NORMAL( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::InputBrowser::NORMAL;               break;
            case 1: RETVAL = fltk::InputBrowser::NONEDITABLE;          break;
            case 2: RETVAL = fltk::InputBrowser::INDENTED;             break;
            case 3: RETVAL = fltk::InputBrowser::NONEDITABLE_INDENTED; break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
                 NONEDITABLE = 1
                    INDENTED = 2
        NONEDITABLE_INDENTED = 3

=for apidoc |||popup||



=for apidoc |||hide_popup||



=cut

void
fltk::InputBrowser::popup( )

void
fltk::InputBrowser::hide_popup( )

=for apidoc ||FLTK::Widget ret|item||



=for apidoc ||FLTK::Widget ret|item|FLTK::Widget * widget|



=cut

fltk::Widget *
fltk::InputBrowser::item( fltk::Widget * widget = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        C_ARGS: widget

=for apidoc |||minw|int width|



=for apidoc ||int w|minw||



=for apidoc |||minh|int height|



=for apidoc ||int h|minh||



=cut

int
fltk::InputBrowser::minw( int width = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->minw( width );

int
fltk::InputBrowser::minh( int height = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->minh( height );

=for apidoc |||maxw|int width|



=for apidoc ||int w|maxw||



=for apidoc |||maxh|int height|



=for apidoc ||int h|maxh||



=cut

int
fltk::InputBrowser::maxw( int width = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->maxw( width );

int
fltk::InputBrowser::maxh( int height = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->maxh( height );

=for apidoc |||text|char * string|



=for apidoc ||char * string|text||



=cut

const char *
fltk::InputBrowser::text( char * string = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->text( string );

#endif // ifndef DISABLE_INPUTBROWSER

BOOT:
    isa("FLTK::InputBrowser", "FLTK::Menu");
