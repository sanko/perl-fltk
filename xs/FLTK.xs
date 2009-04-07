#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "./ppport.pl"

#include <fltk/Widget.h>

=pod

=for apidoc U||cb|WIDGET|CODE

This is the function called by FLTK whenever callbacks are triggered.

=cut

void cb (fltk::Widget * WIDGET, void * CODE) {
    AV *cbargs = (AV *)CODE;
    I32 alen = av_len(cbargs);
    CV *thecb = (CV *)SvRV(*av_fetch(cbargs, 0, 0));

    dSP;
    ENTER;
    SAVETMPS;

    PUSHMARK(sp);

    //warn("alen == %d", alen);

    for(int i = 1; i <= alen; i++) {
        //warn ( "arg %d : %s", i, av_fetch(cbargs, i, 0) );
        XPUSHs(*av_fetch(cbargs, i, 0));
    }

    PUTBACK;
    call_sv((SV*)thecb, G_DISCARD);

    FREETMPS;
    LEAVE;
}

using namespace fltk;

MODULE = FLTK               PACKAGE = FLTK

#if 0

=for apidoc U||add_symbol|NAME|COLOR|SCALABLE

TODO

=cut

void
add_symbol ( NAME, COLOR, SCALABLE )
    const char * NAME
    fltk::Color  COLOR
    int          SCALABLE

#endif

#if 0

=for apidoc U||cairo_create_surface|WINDOW

TODO

=cut

# cairo_surface_t *
# cairo_create_surface ( WINDOW )
#    fltk::Window * WINDOW

#endif





INCLUDE: fltk/file_chooser.xsi

INCLUDE: fltk/ask.xsi

INCLUDE: fltk/events.xsi

INCLUDE: fltk/flags.xsi

INCLUDE: fltk/run.xsi

INCLUDE: FLTK_color.xsi


#include <fltk/box.h>

Box *
UP_BOX ( )
	CODE:
		RETVAL = UP_BOX;
	OUTPUT:
		RETVAL

Box *
DOWN_BOX ( )
	CODE:
		RETVAL = DOWN_BOX;
	OUTPUT:
		RETVAL

Box *
THIN_UP_BOX ( )
	CODE:
		RETVAL = THIN_UP_BOX;
	OUTPUT:
		RETVAL

Box *
THIN_DOWN_BOX ( )
	CODE:
		RETVAL = THIN_DOWN_BOX;
	OUTPUT:
		RETVAL

Box *
ENGRAVED_BOX ( )
	CODE:
		RETVAL = ENGRAVED_BOX;
	OUTPUT:
		RETVAL

Box *
EMBOSSED_BOX ( )
	CODE:
		RETVAL = EMBOSSED_BOX;
	OUTPUT:
		RETVAL

Box *
BORDER_BOX ( )
	CODE:
		RETVAL = BORDER_BOX;
	OUTPUT:
		RETVAL

Box *
FLAT_BOX ( )
	CODE:
		RETVAL = FLAT_BOX;
	OUTPUT:
		RETVAL

Box *
HIGHLIGHT_UP_BOX ( )
	CODE:
		RETVAL = HIGHLIGHT_UP_BOX;
	OUTPUT:
		RETVAL

Box *
HIGHLIGHT_DOWN_BOX ( )
	CODE:
		RETVAL = HIGHLIGHT_DOWN_BOX;
	OUTPUT:
		RETVAL

Box *
ROUND_UP_BOX ( )
	CODE:
		RETVAL = ROUND_UP_BOX;
	OUTPUT:
		RETVAL

Box *
ROUND_DOWN_BOX ( )
	CODE:
		RETVAL = ROUND_DOWN_BOX;
	OUTPUT:
		RETVAL

Box *
DIAMOND_UP_BOX ( )
	CODE:
		RETVAL = DIAMOND_UP_BOX;
	OUTPUT:
		RETVAL

Box *
DIAMOND_DOWN_BOX ( )
	CODE:
		RETVAL = DIAMOND_DOWN_BOX;
	OUTPUT:
		RETVAL

Box *
NO_BOX ( )
	CODE:
		RETVAL = NO_BOX;
	OUTPUT:
		RETVAL

Box *
SHADOW_BOX ( )
	CODE:
		RETVAL = SHADOW_BOX;
	OUTPUT:
		RETVAL

Box *
ROUNDED_BOX ( )
	CODE:
		RETVAL = ROUNDED_BOX;
	OUTPUT:
		RETVAL

Box *
RSHADOW_BOX ( )
	CODE:
		RETVAL = RSHADOW_BOX;
	OUTPUT:
		RETVAL

Box *
RFLAT_BOX ( )
	CODE:
		RETVAL = RFLAT_BOX;
	OUTPUT:
		RETVAL

Box *
OVAL_BOX ( )
	CODE:
		RETVAL = OVAL_BOX;
	OUTPUT:
		RETVAL

Box *
OSHADOW_BOX ( )
	CODE:
		RETVAL = OSHADOW_BOX;
	OUTPUT:
		RETVAL

Box *
OFLAT_BOX ( )
	CODE:
		RETVAL = OFLAT_BOX;
	OUTPUT:
		RETVAL

Box *
BORDER_FRAME ( )
	CODE:
		RETVAL = BORDER_FRAME;
	OUTPUT:
		RETVAL

Box *
PLASTIC_UP_BOX ( )
	CODE:
		RETVAL = PLASTIC_UP_BOX;
	OUTPUT:
		RETVAL

Box *
PLASTIC_DOWN_BOX ( )
	CODE:
		RETVAL = PLASTIC_DOWN_BOX;
	OUTPUT:
		RETVAL






#include <fltk/color.h>

int
NO_COLOR ( )
    CODE:
        RETVAL = NO_COLOR;
    OUTPUT:
        RETVAL

int
FREE_COLOR ( )
    CODE:
        RETVAL = FREE_COLOR;
    OUTPUT:
        RETVAL

int
NUM_FREE_COLOR ( )
    CODE:
        RETVAL = NUM_FREE_COLOR;
    OUTPUT:
        RETVAL

int
GRAY00 ( )
    CODE:
        RETVAL = GRAY00;
    OUTPUT:
        RETVAL

int
GRAY05 ( )
    CODE:
        RETVAL = GRAY05;
    OUTPUT:
        RETVAL

int
GRAY10 ( )
    CODE:
        RETVAL = GRAY10;
    OUTPUT:
        RETVAL

int
GRAY15 ( )
    CODE:
        RETVAL = GRAY15;
    OUTPUT:
        RETVAL

int
GRAY20 ( )
    CODE:
        RETVAL = GRAY20;
    OUTPUT:
        RETVAL

int
GRAY25 ( )
    CODE:
        RETVAL = GRAY25;
    OUTPUT:
        RETVAL

int
GRAY30 ( )
    CODE:
        RETVAL = GRAY30;
    OUTPUT:
        RETVAL

int
GRAY33 ( )
    CODE:
        RETVAL = GRAY33;
    OUTPUT:
        RETVAL

int
GRAY35 ( )
    CODE:
        RETVAL = GRAY35;
    OUTPUT:
        RETVAL

int
GRAY40 ( )
    CODE:
        RETVAL = GRAY40;
    OUTPUT:
        RETVAL

int
GRAY45 ( )
    CODE:
        RETVAL = GRAY45;
    OUTPUT:
        RETVAL

int
GRAY50 ( )
    CODE:
        RETVAL = GRAY50;
    OUTPUT:
        RETVAL

int
GRAY55 ( )
    CODE:
        RETVAL = GRAY55;
    OUTPUT:
        RETVAL

int
GRAY60 ( )
    CODE:
        RETVAL = GRAY60;
    OUTPUT:
        RETVAL

int
GRAY65 ( )
    CODE:
        RETVAL = GRAY65;
    OUTPUT:
        RETVAL

int
GRAY66 ( )
    CODE:
        RETVAL = GRAY66;
    OUTPUT:
        RETVAL

int
GRAY70 ( )
    CODE:
        RETVAL = GRAY70;
    OUTPUT:
        RETVAL

int
GRAY75 ( )
    CODE:
        RETVAL = GRAY75;
    OUTPUT:
        RETVAL

int
GRAY80 ( )
    CODE:
        RETVAL = GRAY80;
    OUTPUT:
        RETVAL

int
GRAY85 ( )
    CODE:
        RETVAL = GRAY85;
    OUTPUT:
        RETVAL

int
GRAY90 ( )
    CODE:
        RETVAL = GRAY90;
    OUTPUT:
        RETVAL

int
GRAY95 ( )
    CODE:
        RETVAL = GRAY95;
    OUTPUT:
        RETVAL

int
GRAY99 ( )
    CODE:
        RETVAL = GRAY99;
    OUTPUT:
        RETVAL

int
BLACK ( )
    CODE:
        RETVAL = BLACK;
    OUTPUT:
        RETVAL

int
RED ( )
    CODE:
        RETVAL = RED;
    OUTPUT:
        RETVAL

int
GREEN ( )
    CODE:
        RETVAL = GREEN;
    OUTPUT:
        RETVAL

int
YELLOW ( )
    CODE:
        RETVAL = YELLOW;
    OUTPUT:
        RETVAL

int
BLUE ( )
    CODE:
        RETVAL = BLUE;
    OUTPUT:
        RETVAL

int
MAGENTA ( )
    CODE:
        RETVAL = MAGENTA;
    OUTPUT:
        RETVAL

int
CYAN ( )
    CODE:
        RETVAL = CYAN;
    OUTPUT:
        RETVAL

int
WHITE ( )
    CODE:
        RETVAL = WHITE;
    OUTPUT:
        RETVAL

int
DARK_RED ( )
    CODE:
        RETVAL = DARK_RED;
    OUTPUT:
        RETVAL

int
DARK_GREEN ( )
    CODE:
        RETVAL = DARK_GREEN;
    OUTPUT:
        RETVAL

int
DARK_YELLOW ( )
    CODE:
        RETVAL = DARK_YELLOW;
    OUTPUT:
        RETVAL

int
DARK_BLUE ( )
    CODE:
        RETVAL = DARK_BLUE;
    OUTPUT:
        RETVAL

int
DARK_MAGENTA ( )
    CODE:
        RETVAL = DARK_MAGENTA;
    OUTPUT:
        RETVAL

int
DARK_CYAN ( )
    CODE:
        RETVAL = DARK_CYAN;
    OUTPUT:
        RETVAL

int
WINDOWS_BLUE ( )
    CODE:
        RETVAL = WINDOWS_BLUE;
    OUTPUT:
        RETVAL















Font *
HELVETICA ( )
	CODE:
		RETVAL = HELVETICA;
	OUTPUT:
		RETVAL

Font *
HELVETICA_BOLD ( )
	CODE:
		RETVAL = HELVETICA_BOLD;
	OUTPUT:
		RETVAL

Font *
HELVETICA_ITALIC ( )
	CODE:
		RETVAL = HELVETICA_ITALIC;
	OUTPUT:
		RETVAL

Font *
HELVETICA_BOLD_ITALIC ( )
	CODE:
		RETVAL = HELVETICA_BOLD_ITALIC;
	OUTPUT:
		RETVAL

Font *
COURIER ( )
	CODE:
		RETVAL = COURIER;
	OUTPUT:
		RETVAL

Font *
COURIER_BOLD ( )
	CODE:
		RETVAL = COURIER_BOLD;
	OUTPUT:
		RETVAL

Font *
COURIER_ITALIC ( )
	CODE:
		RETVAL = COURIER_ITALIC;
	OUTPUT:
		RETVAL

Font *
COURIER_BOLD_ITALIC ( )
	CODE:
		RETVAL = COURIER_BOLD_ITALIC;
	OUTPUT:
		RETVAL

Font *
TIMES ( )
	CODE:
		RETVAL = TIMES;
	OUTPUT:
		RETVAL

Font *
TIMES_BOLD ( )
	CODE:
		RETVAL = TIMES_BOLD;
	OUTPUT:
		RETVAL

Font *
TIMES_ITALIC ( )
	CODE:
		RETVAL = TIMES_ITALIC;
	OUTPUT:
		RETVAL

Font *
TIMES_BOLD_ITALIC ( )
	CODE:
		RETVAL = TIMES_BOLD_ITALIC;
	OUTPUT:
		RETVAL

Font *
SYMBOL_FONT ( )
	CODE:
		RETVAL = SYMBOL_FONT;
	OUTPUT:
		RETVAL

Font *
SCREEN_FONT ( )
	CODE:
		RETVAL = SCREEN_FONT;
	OUTPUT:
		RETVAL

Font *
SCREEN_BOLD_FONT ( )
	CODE:
		RETVAL = SCREEN_BOLD_FONT;
	OUTPUT:
		RETVAL

Font *
ZAPF_DINGBATS ( )
	CODE:
		RETVAL = ZAPF_DINGBATS;
	OUTPUT:
		RETVAL

























LabelType *
NO_LABEL ( )
	CODE:
		RETVAL = NO_LABEL;
	OUTPUT:
		RETVAL

LabelType *
NORMAL_LABEL ( )
	CODE:
		RETVAL = NORMAL_LABEL;
	OUTPUT:
		RETVAL

LabelType *
SYMBOL_LABEL ( )
	CODE:
		RETVAL = SYMBOL_LABEL;
	OUTPUT:
		RETVAL

LabelType *
SHADOW_LABEL ( )
	CODE:
		RETVAL = SHADOW_LABEL;
	OUTPUT:
		RETVAL

LabelType *
ENGRAVED_LABEL ( )
	CODE:
		RETVAL = ENGRAVED_LABEL;
	OUTPUT:
		RETVAL

LabelType *
EMBOSSED_LABEL ( )
	CODE:
		RETVAL = EMBOSSED_LABEL;
	OUTPUT:
		RETVAL










#include <fltk/Cursor.h>


fltk::Cursor *
CURSOR_DEFAULT ( )
	CODE:
		RETVAL = CURSOR_DEFAULT;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_ARROW ( )
	CODE:
		RETVAL = CURSOR_ARROW;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_CROSS ( )
	CODE:
		RETVAL = CURSOR_CROSS;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_WAIT ( )
	CODE:
		RETVAL = CURSOR_WAIT;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_INSERT ( )
	CODE:
		RETVAL = CURSOR_INSERT;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_HAND ( )
	CODE:
		RETVAL = CURSOR_HAND;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_HELP ( )
	CODE:
		RETVAL = CURSOR_HELP;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_MOVE ( )
	CODE:
		RETVAL = CURSOR_MOVE;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_NS ( )
	CODE:
		RETVAL = CURSOR_NS;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_WE ( )
	CODE:
		RETVAL = CURSOR_WE;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_NWSE ( )
	CODE:
		RETVAL = CURSOR_NWSE;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_NESW ( )
	CODE:
		RETVAL = CURSOR_NESW;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_NO ( )
	CODE:
		RETVAL = CURSOR_NO;
	OUTPUT:
		RETVAL

fltk::Cursor *
CURSOR_NONE ( )
	CODE:
		RETVAL = CURSOR_NONE;
	OUTPUT:
		RETVAL













































































 # Top level

INCLUDE: FLTK_AssociationFunctor.xsi

INCLUDE: FLTK_Font.xsi

INCLUDE: FLTK_Rectangle.xsi

INCLUDE: FLTK_Style.xsi

# INCLUDE: FLTK_Symbol.xsi

 #
 # Copyright (C) 2009 by Sanko Robinson <sanko@cpan.org>
 #
 # This program is free software; you can redistribute it and/or modify it
 # under the terms of The Artistic License 2.0.  See the LICENSE file
 # included with this distribution or
 # http://www.perlfoundation.org/artistic_license_2_0.  For
 # clarification, see http://www.perlfoundation.org/artistic_2_0_notes.
 #
 # When separated from the distribution, all POD documentation is covered by
 # the Creative Commons Attribution-Share Alike 3.0 License.  See
 # http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
 # clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.
 #
 # $Id: FLTK.xs e14ddfd 2009-03-31 04:47:22Z sanko@cpan.org $
 #

