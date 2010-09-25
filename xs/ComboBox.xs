#include "include/FLTK_pm.h"

MODULE = FLTK::ComboBox               PACKAGE = FLTK::ComboBox

#ifndef DISABLE_COMBOBOX

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::ComboBox - Single line input field with predefined choices via popup menu

=head1 Description



=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/ComboBox.h>

=for apidoc ||FLTK::ComboBox self|new|int x|int y|int w|int h|char * label = ''|



=cut

#include "include/WidgetSubclass.h"

void
fltk::ComboBox::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::ComboBox>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc |||layout||



=cut

void
fltk::ComboBox::layout( )

=for apidoc ||int okay|popup|FLTK::Recangle * rect|char * title = ''|bool menubar = false|



=cut

int
fltk::ComboBox::popup( fltk::Rectangle * rect, char * title = 0, bool menubar = false )
    C_ARGS: * rect, title, menubar

=for apidoc ||int picked|choice|int value|



=for apidoc ||int picked|choice||



=cut

int
fltk::ComboBox::choice( int value = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        C_ARGS: value

=for apidoc ||int item|find_choice||



=cut

int
fltk::ComboBox::find_choice( )

=for apidoc ||bool okay|text|char * string|



=for apidoc ||bool okay|text|char * string|int n|



=for apidoc ||char * string|text||



=cut

int
fltk::ComboBox::text( char * string = NO_INIT, int n = NO_INIT )
    PPCODE:
        if ( items == 1 ) {
            const char * RETVAL = THIS->text( );
            XSprePUSH; PUSHi((IV)RETVAL);
        }
        else if ( items == 2 ) {
            bool RETVAL = THIS->text ( string );
            ST(0) = boolSV(RETVAL);
            sv_2mortal(ST(0));
        }
        else if ( items == 3 ) {
            bool RETVAL = THIS->text ( string, n );
            ST(0) = boolSV(RETVAL);
            sv_2mortal(ST(0));
        }
        XSRETURN(1);

=for apidoc ||bool okay|static_text|char * string|



=for apidoc ||bool okay|static_text|char * string|int n|



=cut

bool
fltk::ComboBox::static_text( const char * string, int n = NO_INIT )
    CASE: items == 2
        C_ARGS: string
    CASE: items == 3
        C_ARGS: string, n

=for apidoc ||char letter|at|int index|



=cut

char
fltk::ComboBox::at( int index )

=for apidoc ||int length|size|bool ofText|



=cut

int
fltk::ComboBox::size( bool ofText )

=for apidoc ||int p|position||



=for apidoc |||position|int p|



=for apidoc |||position|int p|int m|



=cut

int
fltk::ComboBox::position( int p = NO_INIT, int m = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->position( p );
    CASE: items == 3
        CODE:
            THIS->position( p, m );

=for apidoc ||int position|mark||



=for apidoc |||mark|int m|



=cut

int
fltk::ComboBox::mark( int m = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->mark( m );

=for apidoc |||up_down_position|int p|bool b|



=cut

void
fltk::ComboBox::up_down_position( int p, bool b )

=for apidoc ||bool okay|replace|int a|int b|char * c|int d|



=for apidoc ||bool okay|replace|int a|int b|char c|



=cut

bool
fltk::ComboBox::replace ( int a, int b, c, int d = NO_INIT )
    CASE: items == 4
        char c;
        C_ARGS: a, b, c
        OUTPUT:
            RETVAL
    CASE: items == 5
        char * c;
        C_ARGS: a, b, ( const char * ) c, d
        OUTPUT:
            RETVAL

=for apidoc ||bool okay|cut||



=for apidoc ||bool okay|cut|int n|



=for apidoc ||bool okay|cut|int n|int b|



=cut

bool
fltk::ComboBox::cut( int n = NO_INIT, int b = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        C_ARGS: n
    CASE: items == 3
        C_ARGS: n, b

=for apidoc ||bool okay|insert|char * text|int line = 0|



=cut

bool
fltk::ComboBox::insert( const char * text, int l = 0 )

=for apidoc ||bool okay|copy|bool clipboard = true|



=cut

bool
fltk::ComboBox::copy( bool clipboard = true )

=for apidoc ||bool okay|undo||



=cut

bool
fltk::ComboBox::undo( )

=for apidoc ||int pos|word_start|int index|



=for apidoc ||int pos|word_end|int index|



=for apidoc ||int pos|line_start|int index|



=for apidoc ||int pos|line_end|int index|



=cut

int
fltk::ComboBox::word_start( int index )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = THIS->word_start( index ); break;
            case 1: RETVAL = THIS->word_end( index );   break;
            case 2: RETVAL = THIS->line_start( index ); break;
            case 3: RETVAL = THIS->line_end( index );   break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
          word_end = 1
        line_start = 2
          line_end = 3

=for apidoc ||int pos|mouse_position|FLTK::Rectangle * rectangle|



=cut

int
fltk::ComboBox::mouse_position( fltk::Rectangle * rectangle )
    C_ARGS: * rectangle

=for apidoc ||int x |xscroll||



=for apidoc ||int y|yscroll||



=cut

int
fltk::ComboBox::xscroll( )

int
fltk::ComboBox::yscroll( )

#ifdef WIN32

=for apidoc |W||input_callback_|FLTK::Widget * widget|FLTK::Combobox * d|



=cut

void
fltk::ComboBox::input_callback_( fltk::Widget * widget, fltk::ComboBox * d )
    C_ARGS: widget, (void *) d

#endif // #ifdef WIN32

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

#endif // #ifndef DISABLE_COMBOBOX

BOOT:
    isa("FLTK::ComboBox", "FLTK::Choice");
