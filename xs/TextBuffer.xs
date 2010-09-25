#include "include/FLTK_pm.h"

MODULE = FLTK::TextBuffer               PACKAGE = FLTK::TextBuffer

#ifndef DISABLE_TEXTBUFFER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532

=for git $Id$

=head1 NAME

FLTK::TextBuffer -

=head1 Description



=cut

#include <fltk/TextBuffer.h>

=head1 Constructor

=for apidoc d||FLTK::TextBuffer buffer|new|int requested_size|

Creates an empty text buffer of pre-determined size. Use this to avoid
unnecessary re-allocation if you know exactly how much the buffer will need to
hold.

=head2 Usage

=for markdown {%highlight perl%}

    my $buffer   = FLTK::TextBuffer->new( $requested_size );
    my $buffer_2 = FLTK::TextBuffer->new( 1027 * 256 );
    my $buffer_3 = FLTK::TextBuffer->new( );

=for markdown {%endhighlight%}

=cut

#include "include/WidgetSubclass.h"

void
fltk::TextBuffer::new( int requested_size = 0 )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new fltk::TextBuffer( requested_size );
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=head1 Methods

=head2 C<< my $length = $buffer->length( ) >>

=for apidoc ||int length|length||

=cut

int
fltk::TextBuffer::length( )

=pod

=head2 C<< my $txt = $buffer->text( ) >>
X<text>

=for apidoc ||const char * txt|text||

Return the entire contents of the text buffer.

=head2 C<< $buffer->text( $txt ) >>

=for apidoc |||text|const char * txt|

Replace the entire contents of the text buffer.

=cut

const char *
fltk::TextBuffer::text ( const char * txt = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->text( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->text( txt );

=pod

X<character>

=head2 C<< my $char = $buffer->character( $pos ) >>

=for apidoc ||char char|character|int pos|

Returns the character at buffer position C<$pos>. Positions start at C<0>.

=cut

char
fltk::TextBuffer::character( int pos )

=pod

X<text_range>

=head2 C<my $txt = $buffer-E<gt>text_range( $start, $end )>

=for apidoc ||char * txt|text_range|int start|int end|

Returns a copy of the text between C<$start> and C<$end> character positions.
Positions are C<0> (zero) based and the range does I<not> include the
character pointed to by C<$end>.

=cut

char *
fltk::TextBuffer::text_range( int start, int end )

=pod

X<text_in_rectangle>

=head2 C<my $txt = $buffer-E<gt>text_in_rectangle( $start, $end, $rectStart, $rectEnd )>

=for apidoc ||char * txt|text_in_rectangle|int start|int end|int rectStart|int rectEnd|

Returns a copy of the text between C<$start> and C<$end> character positions.
Positions are C<0> (zero) based and the range does I<not> include the
character pointed to by C<$end>.

=cut

char *
fltk::TextBuffer::text_in_rectangle( int start, int end, int rectStart, int rectEnd )

=pod

X<insert>

=head2 C<$buffer-E<gt>insert( $pos, $text )>

=for apidoc |||insert|int pos|const char * text|

Inserts string C<$text> at position C<$pos>.

=cut

void
fltk::TextBuffer::insert( int pos, const char * text )

=pod

X<append>

=head2 C<$buffer-E<gt>append( $text )>

=for apidoc |||append|const char * text|

Appends C<$text> to the end of the buffer.

=cut

void
fltk::TextBuffer::append( const char * text )

=pod

X<remove>

=head2 C<$buffer-E<gt>remove( $start, $end )>

=for apidoc |||remove|int start|int end|

Deletes the text between C<$start> and C<$end> character positions. Positions
are C<0> (zero) based and the range does I<not> include the character pointed
to by C<$end>.

=cut

void
fltk::TextBuffer::remove( int start, int end )

=pod

X<replace>

=head2 C<$buffer-E<gt>replace( $start, $end, $text )>

=for apidoc |||replace|int start|int end|const char * text|

Deletes the characters between C<$start> and C<$end>, and inserts the string
C<$text> in their place.

=cut

void
fltk::TextBuffer::replace( int start, int end, const char * text )

=pod

X<copy>

=head2 C<$to_buffer-E<gt>copy( $from_buffer, $from_start, $from_end, $to_pos )>

=for apidoc |||copy|fltk::TextBuffer * from_buffer|int from_start|int from_end|int to_pos|

Copy the characters between C<$from_start> and C<$from_end> in
C<$from_buffer>, and inserts the string into your object at C<$to_pos>.

=cut

void
fltk::TextBuffer::copy( fltk::TextBuffer * from_buffer, int from_start, int from_end, int to_pos )

=pod

X<undo>

=head2 C<my ($okay, $cursorPosition) = $buffer-E<gt>undo( )>

=for apidoc A||AV * return|undo||

Removes text according to the undo variables or inserts text from the undo
buffer.

The return value is a list of integers indicating is the process was
successful and the current C<$cursorPosition> after this change.

=cut

int
fltk::TextBuffer::undo( OUTLIST int cursorPosition )

=pod

X<canUndo>

=head2 C<$buffer-E<gt>canUndo( $flag ) >

=for apidoc |||canUndo|char flag = 1|

Lets the undo system know if we can undo changes.

=cut

void
fltk::TextBuffer::canUndo( char flag = 1 )

=pod

X<insertfile>

=head2 C<my $status = $buffer-E<gt>insertfle( $file, $position )>

=for apidoc ||int status|insertfile|const char * file|int position|int bufferlen = 128*1024|

Inserts the contents of a C<$file> at the given C<$position>. Optionally, a
third C<$bufferlen> argument is passed which can limit the amount of data
brought in from the C<$file>.

On error, the return value is C<2>. Otherwise, the return value is C<0>.

=cut

int
fltk::TextBuffer::insertfile( const char * file, int position, int bufferlen = 128*1024 )

=pod

X<appendfile>

=head2 C<my $status = $buffer-E<gt>appendfile( $file )>

=for apidoc ||int status|appendfile|const char * file|int bufferlen = 128*1024|

Appends the contents of a C<$file> to the end of the buffer. Optionally, a
second C<$bufferlen> argument is passed which can limit the amount of data
brought in from the C<$file>.

On error, the return value is C<2>. Otherwise, the return value is C<0>.

=cut

int
fltk::TextBuffer::appendfile( const char * file, int bufferlen = 128*1024 )

=pod

X<loadfile>

=head2 C<my $status = $buffer-E<gt>loadfile( file )>

=for apidoc ||int status|loadfile|const char * file|int bufferlen = 128*1024|

Loads the contents of a C<$file> to fill the buffer (current content is
replaced). Optionally, a second C<$bufferlen> argument is passed which can
limit the amount of data brought in from the C<$file>.

On error, the return value is C<2>. Otherwise, the return value is C<0>.

=cut

int
fltk::TextBuffer::loadfile( const char * file, int bufferlen = 128*1024 )

=pod

X<outputfile>

=head2 C<my $status = $buffer-E<gt>outputfile( $file, $start, $end )>

=for apidoc ||int status|outputfile|const char * file|int start|int end|int bufferlen = 128*1024|

Saves the contents of the buffer to a C<$file> starting with the data at the
C<$start> position through the C<$end>. Optionally, a fourth C<$bufferlen> a
rgument is passed which can limit the amount of data written to the C<$file>.

On error, the return value is C<2>. Otherwise, the return value is C<0>.

=cut

int
fltk::TextBuffer::outputfile( const char * file, int start, int end, int bufferlen = 128*1024 )

=pod

X<savefile>

=head2 C<my $status = $buffer-E<gt>savefile( $file )>

=for apidoc ||int status|savefile|const char * file|int bufferlen = 128*1024|

Saves the contents of the buffer to a C<$file>. Optionally, a second
C<$bufferlen> argument is passed which can limit the amount of data written to
the C<$file>.

On error, the return value is C<2>. Otherwise, the return value is C<0>.

=cut

int
fltk::TextBuffer::savefile( const char * file, int bufferlen = 128*1024 )

=pod

X<expand_character>

=head2 C<my $output = $buffer-E<gt>expand_character( $character, $indent, $tabDist, $nullSubsChar )>

=for apidoc A||char * output|expand_character|char character|int indent = 0|int tabDist = NO_INIT|int nullSubsChar = NO_INIT|

Expand a single character from the text buffer into it's screen representation
(which may be several characters for a tab or a control code).

Optional parameters include:

=over

=item C<$indent>

the number of characters from the start of the line for figuring tabs

=item C<$tabDist>

the number of spaces (C< >) a tab (C<\t>) consumes

=item C<$nullSubsChar>

the character which will be used in place of null (C<\0>) characters, the
typical string terminator in C<C++>

=back

=head2 C<my $output = $buffer-E<gt>expand_character( $position, $indent )>

=for apidoc A||char * output|expand_character|int position|int indent = 0|

Get a character from the text buffer expanded into it's screen representation
(which may be several characters for a tab or a control code).

Optional parameters include:

=over

=item C<$indent>

the number of characters from the start of the line for figuring tabs

=back

=cut

SV *
fltk::TextBuffer::expand_character( character, int indent, int tabDist = NO_INIT, char nullSubsChar = NO_INIT )
    CASE: items == 5
        char character
        CODE:
            char * ret;
            warn("Y");
            int len = THIS->expand_character( character, indent, ret, tabDist, nullSubsChar );
            warn("YY | %d | %s", len, ret);
            ST( 0 ) = newSVpv( ret, len );
            warn("YYY");
            sv_2mortal( ST( 0 ) );
            warn("YYYY");
            XSRETURN( 1 );
    CASE:
        int character
        CODE:
            char * ret = 0;
            warn("X");
            int len = THIS->expand_character( character, indent, ret );
            warn("XX | %d | %s", len, ret);
            ST( 0 ) = newSVpv( ret, len );
            warn("XXX");
            sv_2mortal( ST( 0 ) );
            warn("XXXX");
            XSRETURN( 1 );

=pod

X<character_width>

=head2 C<my $width = $buffer-E<gt>character_width( $char, $indent, $tabDist, $nullSubsChar )>

=for apidoc A||char * output|character_width|char char|int indent = 0|int tabDist = NO_INIT|int nullSubsChar = NO_INIT|

Returns the length in displayed characters of C<$char> expanded for display.
If the buffer for which the character width is being measured is doing null
substitution, <$nullSubsChar> should be passed as that character.

Optional parameters include:

=over

=item C<$indent>

the number of characters from the start of the line for figuring tabs

=item C<$tabDist>

the number of spaces (C< >) a tab (C<\t>) consumes

=item C<$nullSubsChar>

the character which will be used in place of null (C<\0>) characters, the
typical string terminator in C<C++>

=back

=cut

int
fltk::TextBuffer::character_width( char character, int indent = 0, int tabDist = 8, char nullSubsChar = 0 )

=pod

X<count_displayed_characters>

=head2 C<my $width = $buffer-E<gt>count_displayed_characters( $lineStartPos, $targetPos )>

=for apidoc ||int width|count_displayed_characters|int lineStartPos|int targetPos|

Count the number of displayed characters between buffer position
C<$linestartpos> and C<$targetpos>. Displayed characters are the characters
shown on the screen to represent characters in the buffer, where tabs and
control characters are expanded.

=cut

int
fltk::TextBuffer::count_displayed_characters( int lineStartPos, int targetPos )

=pod

X<count_displayed_characters_utf>

=head2 C<my $width = $buffer-E<gt>count_displayed_characters_utf( $lineStartPos, $targetPos )>

=for apidoc ||int width|count_displayed_characters_utf|int lineStartPos|int targetPos|

Count the number of displayed characters between buffer position
C<$linestartpos> and C<$targetpos>. Displayed characters are the characters
shown on the screen to represent characters in the buffer, where tabs and
control characters are expanded.

This method is utf8-aware.

=cut

int
fltk::TextBuffer::count_displayed_characters_utf( int lineStartPos, int targetPos )

=pod

X<skip_displayed_characters>

=head2 C<my $width = $buffer-E<gt>skip_displayed_characters( $startPos, $nChars )>

=for apidoc ||int width|skip_displayed_characters|int startPos|int nChars|

Count forward from buffer position C<$startPos> in displayed characters.
Displayed characters are the characters shown on the screen to represent
characters in the buffer, where tabs and control characters are expanded.

=cut

int
fltk::TextBuffer::skip_displayed_characters( int startPos, int targetPos )

=pod

X<skip_displayed_characters_utf>

=head2 C<my $width = $buffer-E<gt>skip_displayed_characters_utf( $startPos, $nChars )>

=for apidoc ||int width|skip_displayed_characters_utf|int startPos|int nChars|

Count forward from buffer position C<$startPos> in displayed characters.
Displayed characters are the characters shown on the screen to represent
characters in the buffer, where tabs and control characters are expanded.

This method is utf8-aware.

=cut

int
fltk::TextBuffer::skip_displayed_characters_utf( int startPos, int targetPos )

=pod

X<count_lines>

=head2 C<my $lines = $buffer-E<gt>count_lines( $startPos, $endPos )>

=for apidoc ||int lines|count_lines|int startPos|int endPos|

Count the number of newlines between C<$startPos> and C<$endPos> in a buffer.
The character at position C<$endPos> is not counted.

=cut

int
fltk::TextBuffer::count_lines( int startPos, int endPos )

=pod

X<skip_lines>

=head2 C<my $lines = $buffer-E<gt>skip_lines( $startPos, $nLines )>

=for apidoc ||int lines|skip_lines|int startPos|int nLines|

Finds the first character of the line C<$nLines> forward from C<$startPos> in
a buffer and returns its position.

=cut

int
fltk::TextBuffer::skip_lines( int startPos, int nLines )

=pod

X<rewind_lines>

=head2 C<my $lines = $buffer-E<gt>rewind_lines( $startPos, $nLines )>

=for apidoc ||int lines|rewind_lines|int startPos|int nLines|

Finds the position of the first character of the line C<$nLines> backwards
from C<$startPos> (not counting the character pointed to by C<$startPos> if
that is a newline). C<$nlines == 0> means find the beginning of the line.

=cut

int
fltk::TextBuffer::rewind_lines( int startPos, int nLines )

=pod

=begin TODO

bool findchar_forward(int startPos, char searchChar, int* foundPos);
bool findchar_backward(int startPos, char searchChar, int* foundPos);

bool findchars_forward(int startpos, const char *searchChars, int *foundPos);
bool findchars_backward(int startpos, const char *searchChars, int *foundPos);

bool search_forward(int startPos, const char* searchString, int* foundPos,
                    bool matchCase = false);

bool search_backward(int startPos, const char* searchString, int* foundPos,
                     bool matchCase = false);

char null_substitution_character() { return nullsubschar_; }
TextSelection* primary_selection() { return &primary_; }
TextSelection* secondary_selection() { return &secondary_; }
TextSelection* highlight_selection() { return &highlight_; }

=end TODO

=cut

#INCLUDE: TextSelection.xsi

#endif // ifndef DISABLE_TEXTBUFFER
