#include "include/FLTK_pm.h"

MODULE = FLTK::Symbol               PACKAGE = FLTK::Symbol

#ifndef DISABLE_SYMBOL

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=for version 0.531

=for todo Subclass this like Widget

=head1 NAME

FLTK::Symbol - Base class for all small, reusable graphics

=head1 Description

All small reusable graphics drawn by fltk are based on this class. This
includes bitmapped images, the boxes drawn around widgets, symbols drawn into
buttons, small symbols drawn between the letters in labels, and a number of
formatting symbols to change the color or fontsize or alignment of labels.

Symbols are typically statically allocated and exist for the life of the
program. They may either be identified directly by a pointer to them, or by a
string name. The strings are stored in a simple hash table that should be
quite efficient up to a few thousand named symbols.

=begin apidoc

=cut

#include <fltk/Symbol.h>

=for apidoc ||char * name|name||

Returns the name of the symbol.

=for apidoc |||name|char * name|

Sets the name of the symbol. If it is in the hash table under the old name it
is removed. If the new name is defined, then it is added under the new name to
the hash table.

=cut

const char *
fltk::Symbol::name( const char * name = NO_INIT )
    CASE: items == 1
        C_ARGS:
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->name( name );

=for apidoc |||measure|int w|int h|

Returns the size a L<Symbol|FLTK::Symbol> will draw.

The variables C<$w> and C<$h> should be preset to a size you I<want> to draw
the symbol, many L<Symbols|FLTK::Symbol> can scale and will return without
changing these values. Or they may alter the values to preserve aspect ratio.
Or they may just return constant sizes.

The most recent values sent to C<setcolor( )>, C<setbgcolor( )>,
C<setdrawflags( )>, C<setfont( )>, etc, may influence the values that this
returns.

=cut

void
fltk::Symbol::measure( IN_OUTLIST int w, IN_OUTLIST int h )
    C_ARGS: w, h

=for apidoc |||set_inset|int x|int y|int w|int h|



=for apidoc |||set_inset|int x|int y|



=for apidoc |||set_inset|int x|



=for apidoc |||set_inset|FLTK::Rectangle rect|

Set the inset rectangle. This is normally done by the constructor for a
subclass. If the l<C<inset( )>|FLTK::Symbol/"inset"> method is not overridden,
the values in this rectangle define the edges.

=cut

void
fltk::Symbol::set_inset( x, int y = NO_INIT, int w = NO_INIT, int h = NO_INIT )
    CASE: items == 5
        int x
        C_ARGS: x, y, w, h
    CASE: items == 3
        int x
        C_ARGS: x, y
    CASE: items == 2 && sv_isobject( ST( 1 ) )
        fltk::Rectangle * x
        C_ARGS: * x
    CASE: items == 2
        int x
        C_ARGS: x

=for apidoc ||FLTK::Rectangle rect|get_inset||



=cut

fltk::Rectangle
fltk::Symbol::get_inset( )

=for apidoc ||int x|dx||

Returns C<$symbol-E<gt>getInset( )-E<gt>x( )>. This is usally the width of the
left inset for the image, though if the C<inset( )> method was overridden it
may return a different number.

=for apidoc ||int y|dy||

Returns C<$symbol-E<gt>getInset-E<gt>y( )>. This is usally the height of the
top inset for the image, though if the C<inset( )> method was overridden it
may return a different number.

=for apidoc ||int w|dw||

Returns C<-$symbol-E<gt>getInset-E<gt>w( )>. This is usally the width of the
left and right insets added together, though if the C<inset( )> method was
overridden it may return a different number.

=for apidoc ||int h|dh||

Returns C<-$symbol-E<gt>getInset-E<gt>h( )>. This is usally the height of the
top and bottom insets added together, though if the C<inset( )> method was
overridden it may return a different number.

=cut

int
fltk::Symbol::dx( )

int
fltk::Symbol::dy( )

int
fltk::Symbol::dw( )

int
fltk::Symbol::dh( )

=for apidoc ||FLTK::Symbol * this|find|const char * name|

Locate a symbol by the name used to construct it. Returns either a pointer to
the symbol, or null if it is undefined.

=for apidoc ||FLTK::Symbol * this|find|const char * name|const char * end|

Locate a symbol by the substring after an C<@> sign as used by C<drawtext( )>.
C<$name> points at the start of the name, C<$end> points to the character
after the end (this allows the name to be extracted from a longer string
without having to copy it).

C<drawtext( )> can pass "arguments" to symbols as extra text before and after
the actual name. If the text does not seem to correspond to a symbol name,
this function tries to strip off these argments and try again. The current
rules are to remove a leading C<#> and C<+> or C<-> sign, remove a leading and
trailing integer, so C<@+400foo21> will locate the symbol "foo". If that still
does not work, it tries the first letter as a 1-letter symbol, so
C<@Ccolorname> will work.

When the symbol's C<draw( )> function is called,
L<C<text( )>|FLTK::Symbol/"text"> is set to C<$name> and
L<C<text_length( )>|FLTK::Symbol/"text_length"> is set to C<$end> minus
C<$name>, so the C<draw( )> method can examine these arguments.

=cut

const fltk::Symbol *
find( const char * name, char * end = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = fltk::Symbol::find( name );
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            RETVAL = fltk::Symbol::find( name, (const char *) end );
        OUTPUT:
            RETVAL

=for apidoc |||text|char * string|unsigned n|

Set the values returned by L<C<text( )>|FLTK::Symbol/"text( )"> and
L<C<text_length( )>|FLTK::Symbol/"text_length">.

=for apidoc ||char * text|text||

Returns a pointer to right after the C<@> sign to the text used to invoke this
symbol. This is a zero-length string if not being called from
L<C<drawtext( )>|FLTK::Symbol/"drawtext">. This is useful for extracting the
arguments that are skipped by the L<C<find( )>|FLTK::Symbol/"find"> method.

=cut

const char *
fltk::Symbol::text( char * string = NO_INIT, unsigned n = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 3
        CODE:
            THIS->text( (const char *) string, n );

=for apidoc ||unsigned length|text_length||

Returns the number of bytes between the C<@> sign and the C<;> or null or
space that terminates the symbol when called from
L<C<drawtext( )>|FLTK::Symbol/"drawtext">. This is useful for parsing the
arguments. This returns zero if it is not being called from
L<C<drawtext( )>|FLTK::Symbol/"drawtext">.

=cut

unsigned
fltk::Symbol::text_length( )

#endif // ifndef DISABLE_SYMBOL
