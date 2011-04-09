#include "include/FLTK_pm.h"

MODULE = FLTK::TextDisplay               PACKAGE = FLTK::TextDisplay

#ifndef DISABLE_TEXTDISPLAY

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::TextDisplay -

=head1 Description



=begin apidoc

=cut

#include <fltk/TextDisplay.h>

=for apidoc ||FLTK::TabGroup * group|new|int x|int y|int w|int h|char * label = ''|

Creates a new L<TextDisplay|FLTK::TextDisplay> widget using the given
position, size, and label string.

=cut

#include "include/RectangleSubclass.h"

fltk::TextDisplay *
fltk::TextDisplay::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::TextDisplay>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc ||int length|size||

Returns the number of characters in L<C<text()>|/"text">. This may be greater
than C<length($input-E<gt>text())> if there are C<NULL> characters in it.

=cut

int
fltk::TextDisplay::size( )

=for apidoc ||char * string|text||

The current string, as edited by the user. L<C<size()>|/"size"> returns how
many bytes are in the string.

=for apidoc |||text|char * string|

Set the text.

=cut

SV *
fltk::TextDisplay::text( char * string = NO_INIT )
    CASE: items == 1
        CODE:
            ST( 0 ) = newSVpv( (char *) THIS->text( ), 0 );
            sv_2mortal( ST( 0 ) );
            XSRETURN( 1 );
    CASE: items == 2
        CODE:
            THIS->text( string );
            XSRETURN_EMPTY;

=for apidoc ||bool ret|static_text|char * string|

Same as L<C<text($string)>|/"text_string">, except it does not copy the
string, instead it makes L<C<text()>|/"text"> return a pointer to C<$string>.

C<$string> must point to static memory that will not be altered until at least
the L<TextDisplay|FLTK::TextDisplay> widget is destroyed or the
L<C<text()>|/"text"> is changed again. If the user attempts to edit the string
it is then copied to the internal buffer and the editing done there. This can
save a lot of time and memory if your program is changing the string to
various constants a lot but the user rarely edits it.

=cut

void
fltk::TextDisplay::static_text( char * string )
    CASE: items == 2
        C_ARGS: string

=for apidoc ||char chr|at|int index|

Same as L<C<text()[$index]>|/"text">, but may be faster in plausible
implementations. No bounds checking is done.

=cut

char
fltk::TextDisplay::at( int index )

=for apidoc |||buffer|FLTK::TextBuffer * buffer|

Attach a L<text buffer|FLTK::TextBuffer> to display, replacing the current
buffer (if any).

=for apidoc ||FLTK::TextBuffer * buffer|buffer||

Get the associated L<text buffer|FLTK::TextBuffer>.

=cut

fltk::TextBuffer *
fltk::TextDisplay::buffer( fltk::TextBuffer * buffer )
    CASE: items == 2
        CODE:
            THIS->buffer( buffer );
        OUTPUT:
    CASE:
        C_ARGS:
        OUTPUT:
            RETVAL

=for apidoc |||append|const char * text|

Append text to the end of the buffer.

=for apidoc |||insert|const char * text|

Insert text to the current cursor position.

=for apidoc |||overstrike|const char * text|

Overstrike text from the current cursor position.

=cut

void
fltk::TextDisplay::append( const char * text )

void
fltk::TextDisplay::insert( const char * text )

void
fltk::TextDisplay::overstrike( const char * text )

=for apidoc |||insert_position|int newPos|

Set new cursor position.

=for apidoc ||int currentPos|insert_position||

Get current cursor position.

=cut

int
fltk::TextDisplay::insert_position( int newPos )
    CASE: items == 2
        CODE:
            THIS->insert_position( newPos );
        OUTPUT:
    CASE:
        C_ARGS:

=for apidoc |||show_insert_position||

Make cursor position visible in screen.

=cut

void
fltk::TextDisplay::show_insert_position( )

=for apidoc |||show_cursor|bool b = true|

Show cursor.

=cut

void
fltk::TextDisplay::show_cursor( bool b = true )

=for apidoc |||hide_cursor||

Hide cursor.

=cut

void
fltk::TextDisplay::hide_cursor( )

=for apidoc ||bool state|cursor_on||

Returns cursor visibility state.

=cut

bool
fltk::TextDisplay::cursor_on( )

=for apidoc |||cursor_style|int style|

Set cursor style.

=cut

void
fltk::TextDisplay::cursor_style( int style )

=for apidoc ||FLTK::Color color|cursor_color||

Returns cursor color.

=for apidoc |||cursor_color|FLTK::Color * color|

Set cursor color.

=cut

fltk::Color
fltk::TextDisplay::cursor_color( fltk::Color color = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->cursor_color( color );
        OUTPUT:
    CASE:
        C_ARGS:

=for apidoc ||int start|word_start|int pos|

Returns begining of the word where C<$pos> is located.

=for apidoc ||int end|word_end|int pos|

=cut

int
fltk::TextDisplay::word_start( int pos )

int
fltk::TextDisplay::word_end( int pos )

=for apidoc |||next_word||

Go to the next word.

=cor apidoc |||previous_word||

Go to the previous word.

=cut

void
fltk::TextDisplay::next_word( )

void
fltk::TextDisplay::previous_word( )

=for apidoc |||wrap_mode|bool wrap|int wrap_margin = 0|

Set wrapping mode. C<$wrap_margin> is width to wrap at, zero means use
L<C<w()>|FLTK::Rectangle/"w">.

=cut

void
fltk::TextDisplay::wrap_mode( bool wrap, int wrap_margin = 0 )

=for apidoc |||linenumber_width|int width|

Set line number area width.

=for apidoc ||int width|linenumber_width||

Returns line number area width.

=cut

int
fltk::TextDisplay::linenumber_width( int width = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->linenumber_width( width );
        OUTPUT:
    CASE:
        C_ARGS:

=for apidoc |||highlight_data|FLTK::TextBuffer * styleBuffer|FLTK::TextDisplay::StyleTableEntry * styleTable|int nStyles|char unfinishedStyle|CV * unfinishedHighlightCB|SV * cbArg = NO_INIT|

Attach (or remove) highlight information in text display and redisplay.
Highlighting information consists of a style buffer which parallels the normal
text buffer, but codes font and color information for the display; a style
table which translates style buffer codes (indexed by buffer character - 'A')
into fonts and colors; and a callback mechanism for as-needed highlighting,
triggered by a style buffer entry of "unfinishedStyle". Style buffer can
trigger additional redisplay during a normal buffer modification if the buffer
contains a primary TextSelection.

Style buffers, tables and their associated memory are managed by the caller.

=cut

void
fltk::TextDisplay::highlight_data( fltk::TextBuffer * styleBuffer, fltk::TextDisplay::StyleTableEntry * styleTable, int nStyles, char unfinishedStyle, CV * unfinishedHighlightCB, SV * cbArg = NO_INIT)
    CODE:
        HV   * cb    = newHV( );
        hv_store( cb, "coderef",  7, newSVsv( ST( 5 ) ), 0 );
        if ( items == 6 ) /* Timeout callbacks can be called without arguments */
            hv_store( cb, "args", 4, newSVsv( cbArg ),    0 );
        /* for (Timeout* t = first_timeout; t; t = t->next)
            if (t->cb == _cb &&
                av_fetch(*(AV*)t->arg, 0, 0) == newSVsv((SV*)ST(0))
            ) {RETVAL = true; break; }
        }*/
        THIS->highlight_data( styleBuffer, styleTable, nStyles, unfinishedStyle, _cb_u, ( void * ) cb );

=for apidoc ||bool okay|move_right||

Move cursor to the right.

=for apidoc ||bool okay|move_left||

Move cursor to the left.

=for apidoc ||bool okay|move_up||

Move cursor up.

=for apidoc ||bool okay|move_down||

Move curosr down.

=cut

bool
fltk::TextDisplay::move_right( )

bool
fltk::TextDisplay::move_left( )

bool
fltk::TextDisplay::move_up( )

bool
fltk::TextDisplay::move_down( )

=for apidoc |||redisplay_range|int start|int end|

Redisplay text in a defined range.

=cut

void
fltk::TextDisplay::redisplay_range( int start, int end )

=for apidoc |||scroll|int topLineNum|int horizOffset|

Scroll to a new position.

=cut

void
fltk::TextDisplay::scroll( int topLineNum, int horizOffset )

=for apidoc ||bool inside|in_selection|int X|int Y|

Returns a true value if position C<($X, $Y)> is inside of the primary
TextSelection.

=cut

bool
fltk::TextDisplay::in_selection( int X, int Y )

=for apidoc ||int start|line_start|int position|

Returns the beginning of the line where C<$position> is located.

=for apidoc ||int end|line_end|int position|bool start_pos_is_line_start = false|

Returns the end of the line where C<$position> is located.

=cut

int
fltk::TextDisplay::line_start( int position )

int
fltk::TextDisplay::line_end( int position, bool start_pos_is_line_start = false )

=for apidoc ||int count|visible_lines||

Returns the number of visible lines.

=cut

int
fltk::TextDisplay::visible_lines( )

=for apidoc ||int index|top_line||

Returns the current visible topline.

=cut

int
fltk::TextDisplay::top_line( )

=for apidoc ||int offset|hor_offset||

Returns the current horizontal offset

=cut

int
fltk::TextDisplay::hor_offset( )

=for apidoc ||int start|find_next_char|int position|

Finds the start of the next character, starting from C<$position>. If
C<$position> points to the start of a character, it is returned. This is
mainly used with UTF-8 strings.

=cut

int
fltk::TextDisplay::find_next_char( int position )

=for apidoc ||int start|find_prev_char|int position|

Finds the start of the previous character, starting from C<$position>. If
C<$position> points to the start of a character, it is returned. This is
mainly used with UTF-8 strings.

=cut

int
fltk::TextDisplay::find_prev_char( int position )

=for apidoc ||int position|xy_to_position|int X|int Y|int PosType = CHARACTER_POS|

Translates window coordinates to the nearest (insert cursor or character cell)
text position. The parameter C<$posType> specifies how to interpret the
position:

=over

=item C<FLTK::TextDisplay::CURSOR_POS> means translate the coordinates to the
nearest cursor position

=item C<FLTK::TextDisplay::CHARACTER_POS> means return the position of the
character closest to C<($X, $Y)>

=back

=cut

int
fltk::TextDisplay::xy_to_position( int X, int Y, int PosType = fltk::TextDisplay::CHARACTER_POS )

=for apidoc ||AV * row_col|xy_to_rowcol|int X|int Y|int PosType

Translates window coordinates to the nearest row and column number for
positioning the cursor. This, of course, makes no sense when the font is
proportional, since there are no absolute columns. The parameter C<$posType>
specifies how to interpret the position:


=over

=item C<FLTK::TextDisplay::CURSOR_POS> means translate the coordinates to the
nearest position between characters

=item C<FLTK::TextDisplay::CHARACTER_POS> means translate the position to the
nearest character cell.

=back

=cut

void
fltk::TextDisplay::xy_to_rowcol( int X, int Y, OUTLIST int row, OUTLIST int column, int PosType )

=for apidoc ||bool in_range|position_to_xy|int position|int * X|int * Y|

Translates a buffer text position to the C<XY> location where the top left of
the cursor would be positioned to point to that character. Returns C<0> if the
position is not displayed because it is B<vertically> outof view. If the
position is horizontally out of view, returns the C<X> coordinate where the
position would be if it were visible.

=cut

bool
fltk::TextDisplay::position_to_xy( int position, IN_OUTLIST int X, IN_OUTLIST int Y )

=for apidoc ||int count|total_lines||

Returns the total number of lines.

=cut

int
fltk::TextDisplay::total_lines( )

int
NORMAL_CURSOR ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::TextDisplay::NORMAL_CURSOR; break;
            case 1: RETVAL = fltk::TextDisplay::CARET_CURSOR;  break;
            case 2: RETVAL = fltk::TextDisplay::DIM_CURSOR;    break;
            case 3: RETVAL = fltk::TextDisplay::BLOCK_CURSOR;  break;
            case 4: RETVAL = fltk::TextDisplay::HEAVY_CURSOR;  break;
         }
    OUTPUT:
        RETVAL
    ALIAS:
          CARET_CURSOR = 1
            DIM_CURSOR = 2
          BLOCK_CURSOR = 3
          HEAVY_CURSOR = 4

int
CURSOR_POS ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::TextDisplay::CURSOR_POS;    break;
            case 1: RETVAL = fltk::TextDisplay::CHARACTER_POS; break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        CHARACTER_POS = 1

=begin developers

drag types- they match fltk::event_clicks() so that single clicking to start a
collection selects by character, double clicking selects by word and triple
clicking selects by line.

=cut

int
DRAG_CHAR ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::TextDisplay::DRAG_CHAR; break;
            case 1: RETVAL = fltk::TextDisplay::DRAG_WORD; break;
            case 2: RETVAL = fltk::TextDisplay::DRAG_LINE; break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        DRAG_WORD = 1
        DRAG_LINE = 2


int
ATTR_NONE ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::TextDisplay::ATTR_NONE;      break;
            case 1: RETVAL = fltk::TextDisplay::ATTR_UNDERLINE; break;
            case 2: RETVAL = fltk::TextDisplay::ATTR_HIDDEN;    break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        ATTR_UNDERLINE = 1
           ATTR_HIDDEN = 2

#INCLUDE: TextDisplay/StyleTableEntry.xsi

#endif // #ifndef DISABLE_TEXTDISPLAY
