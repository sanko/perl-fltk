#include "include/FLTK_pm.h"

MODULE = FLTK::Font               PACKAGE = FLTK::Font

#ifndef DISABLE_FONT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Font - Font selection code for the Fast Light Tool Kit

=head1 Description

Identifies a font. You can create these with L<C<font(name)>|/"font_name_"> or
with L<C<list_fonts()>|/"list_fonts">. Do not attempt to create your instances
or modify it.

=begin apidoc

=cut

#include <fltk/Font.h>

BOOT:
    register_constant("BOLD", newSViv(fltk::BOLD));
    export_tag( "BOLD", "font" );
    register_constant("ITALIC", newSViv(fltk::ITALIC));
    export_tag( "ITALIC", "font" );
    register_constant("BOLD_ITALIC", newSViv(fltk::BOLD_ITALIC));
    export_tag( "BOLD_ITALIC", "font" );

=for apidoc T[font]||FLTK::Font font|font|char * name|int attributes = 0|

Find a font with the given "nice" name. You can get bold and italic by adding
a space and "bold" or "italic" (or both) to the name, or by passing them as
the attributes. Case is ignored and fltk will accept some variations in the
font name.

The current implementation calls L<C<list_fonts()>|/"list_fonts"> and then
does a binary search of the returned list. This can make the first call pretty
slow, especially on X. Directly calling the system has a problem in that we
want the same structure returned for any call that names the same font. This
is sufficiently painful that I have not done this yet.

=for apidoc T[font]||FLTK::Font font|font|int id|

Find a L<Font|FLTK::Font> from an fltk1 integer font id.

=cut

MODULE = FLTK::Font               PACKAGE = FLTK

fltk::Font *
font( name, int attributes = 0 )
    CASE: items == 1 && SvIOK(ST(0)) && SvIOK(ST(0))
        int name
        CODE:
            RETVAL = fltk::font( name );
        OUTPUT:
            RETVAL
    CASE:
        char * name
        CODE:
            RETVAL = fltk::font( name, attributes );
        OUTPUT:
            RETVAL

BOOT:
    export_tag( "font", "font" );

MODULE = FLTK::Font               PACKAGE = FLTK::Font

=for apidoc T[font]||AV * fonts|list_fonts||

Returns an array containing every font on the server. Each element is a "base"
font, there may be bold, italic, and bold+italic version of each font pointed
to by L<C<bold()>|/"bold"> or L<C<italic()>|/"italic">.

Subsequent calls will usually return the same array quickly, but if a signal
comes in indicating a change it will probably delete the old array and return
a new one.

=cut

MODULE = FLTK::Font               PACKAGE = FLTK

AV *
list_fonts ( )
    PREINIT:
        fltk::Font ** fonts;
        int           total;
    CODE:
        RETVAL = newAV( );
        sv_2mortal( (SV*) RETVAL );
        total = fltk::list_fonts( fonts );
        for ( int i = 0; i < total; i++ ) {
            SV * obj = newSV(0);
            sv_setref_pv(obj, "FLTK::Font", (void*)fonts[i]); /* -- hand rolled -- */
            av_push( RETVAL, obj );
        }
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "list_fonts", "font" );

MODULE = FLTK::Font               PACKAGE = FLTK::Font

=for apidoc ||char * str|name||

Return a single string that names this font. Passing this string and zero for
the attributes to L<C<find()>|/"find"> will return the same font.

If the font's attributes are non-zero, this is done by appending a space and
"Bold" and/or "Italic" to the name. This allows a single string rather than a
string+attribute pair to identify a font, which is really useful for saving
them in a file.

=for apidoc |||name|int attributes|

Returns a string name for this font with any attributes (C<BOLD>, C<ITALIC>).
Using the returned string and attributes as arguments to L<C<find()>|/"find">
will return the same font.

=cut

const char *
fltk::Font::name( int attributes = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE:
        C_ARGS: & attributes
        OUTPUT:
            RETVAL
            attributes

=for apidoc ||FLTK::Font * similar|plus|int attributes|

Return a font from the same family with the extra attributes turned
on. This may return the same font if the attributes are already on
or there is no font with those attributes.

=cut

fltk::Font *
fltk::Font::plus( int attributes )

=for apidoc ||FLTK::Font * bfont|bold||

Same as L<C<plus(BOLD)>|/"plus">, returns a bold version of this font.

=for apidoc ||FLTK::Font ifont|italic||

Same as L<C<plus(ITALIC)>|/"plus">, returns an italic version of this font.

=cut

fltk::Font *
fltk::Font::bold( )

fltk::Font *
fltk::Font::italic( )

=for apidoc ||AV * list|sizes||

Returns list of sizes. The sizes are sorted from smallest to largest and
indicate what sizes can be given to L<C<setfont()>|FLTK::draw/"setfont"> that
will be matched exactly (L<C<setfont()>|FLTK::draw/"setfont"> will pick the
closest size for other sizes). A zero in the first location of the array
indicates a scalable font, where any size works, although the array may still
list sizes that work "better" than others. The returned array points at a
static buffer that is overwritten each call, so you want to copy it if you
plan to keep it.

=cut

AV *
fltk::Font::sizes ( )
    PREINIT:
        int * sizes;
        int   total;
   CODE:
        RETVAL = newAV( );
        sv_2mortal( (SV*) RETVAL );
        total = THIS->sizes( sizes );
        for ( int i = 0; i < total; i++ )
            av_push( RETVAL, newSViv( sizes[ i ] ));
    OUTPUT:
        RETVAL

=for apidoc ||AV * encodings|encodings||

Return all the encodings for this font. These strings may be sent to
L<C<set_encoding()>|/"set_encodings"> before using the font.

=cut

AV *
fltk::Font::encodings ( )
    PREINIT:
        const char ** encodings;
        int           total;
    CODE:
        RETVAL = newAV( );
        sv_2mortal((SV*)RETVAL);
        total = THIS->encodings( encodings );
        for ( int i = 0; i < total; i++ )
            av_push( RETVAL, newSVpv( encodings[ i ], 0 ) );
    OUTPUT:
        RETVAL

=for apidoc ||char * name|system_name||

Returns the string actually passed to the operating system, which may be
different than L<C<name()>|/"name">.

For Xlib, this is a pattern sent to XListFonts to find all the sizes. For most
other systems this is the same as L<C<name()>|/"name"> without any attributes.

=cut

const char *
fltk::Font::system_name( )

#endif // ifndef DISABLE_FONT
