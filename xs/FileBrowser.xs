#include "include/FLTK_pm.h"

MODULE = FLTK::FileBrowser               PACKAGE = FLTK::FileBrowser

#ifndef DISABLE_FILEBROWSER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::FileBrowser - Subclass of FLTK::Browser

=head1 Description



=begin apidoc

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#ifndef dirent
#define dirent direct
#endif // #ifndef dirent

#include <fltk/FileBrowser.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=for apidoc d||FLTK::FileBrowser fb|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::FileBrowser> object.

=cut

#include "include/WidgetSubclass.h"

void
fltk::FileBrowser::new( int x, int y, int w, int h, char * label = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new WidgetSubclass<fltk::FileBrowser>(CLASS,x,y,w,h,label);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc d||float size|icon_size||



=for apidoc d|||icon_size|float size|



=cut

double
fltk::FileBrowser::icon_size( float size = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->icon_size( size );

=for apidoc d||chat * pattern|filter||



=for apidoc d|||filter|char * pattern|



=cut

const char *
fltk::FileBrowser::filter( char * pattern = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->filter( pattern );

=for apidoc d||float size|textsize||



=for apidoc d|||textsize|float size|



=cut

double
fltk::FileBrowser::textsize( float size = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->textsize( size );

=for apidoc d||int type|filetype||



=for apidoc d|||filetype|int type|



=cut

double
fltk::FileBrowser::filetype( int type = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->filetype( type );

=for apidoc d||char * dir|directory||


=cut

const char *
fltk::FileBrowser::directory( )

=for apidoc d|||insert|int n|char * label|FLTK::FileIcon * icon|



=for apidoc d|||insert|int n|char * label|void * data|



=cut

void
fltk::FileBrowser::insert( int n, char * label, data )
    CASE: sv_isobject(ST(3)) && sv_derived_from(ST(3), "FLTK::FileIcon")
        fltk::FileIcon * data
    CASE:
        void           * data

=for apidoc d|||add|char * line|FLTK::Icon * icon|



=cut

void
fltk::FileBrowser::add( char * line, fltk::FileIcon * icon )

=for apidoc d|||show_hidden|bool show|

Set this flag if you want to see the hidden files in the browser.

=for apidoc d||bool show|show_hidden||



=cut

bool
fltk::FileBrowser::show_hidden( bool show = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        CODE:
            THIS->show_hidden( show );

#endif // ifndef DISABLE_FILEBROWSER

BOOT:
    isa("FLTK::FileBrowser", "FLTK::Browser");
