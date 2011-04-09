#include "include/FLTK_pm.h"

MODULE = FLTK::Input               PACKAGE = FLTK::Input

#ifndef DISABLE_INPUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Input - One-line text input field

=head1 Description

This is the FLTK text input widget. It displays a single line of text and lets
the user edit it. The text may contain any bytes (even C<\0>). The bytes
C<0..31> are displayed in C<^X> notation, the rest are interpreted as UTF-8
(see L<C<utf8decode()>|/"utf8decode">).

The default L<C<when()>|FLTK::Widget/"when"> is C<WHEN_RELEASE>. This is fine
for a popup control panel where nothing happens until the panel is closed. But
for most other uses of the input field you want to change it. Useful values
are:

=over

=item C<WHEN_NEVER>

The callback is not done, but L<C<changed()>|/"changed"> is turned on.

=item C<WHEN_CHANGED>

The callback is done each time the text is changed by the user.

=item C<WHEN_ENTER_KEY>

Hitting the enter key after changing the text will cause the callback.

=item C<WHEN_ENTER_KEY_ALWAYS>

The Enter key will do the callback even if the text has not changed. Useful
for command fields. Also you need to do this if you want both the enter key
and either C<WHEN_CHANGED> or C<WHEN_RELEASE>, in this case you can tell if
Enter was typed by testing C<event_key() == FLTK::EnterKey>.

=back

If you wish to restrict the text the user can type (such as limiting it to
numbers, a particular length, etc), you should subclass this and override the
L<C<replace()>|/"replace"> function with a version that rejects changes you
don't want to allow.

If you don't like the keybindings you can override
L<C<handle()>|FLTK::Widget/"handle"> to change them.

All arguments that are lengths or offsets into the strings are in bytes, not
the UTF-8 characters they represent.

=cut

#ifdef NORMAL // from perl, probably
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif // ifdef NORMAL

#include <fltk/Input.h>

#ifdef PERL_NORMAL // Undo our workaround
#define NORMAL PERL_NORMAL
#endif // ifdef PERL_NORMAL

=begin apidoc

=for apidoc ||FLTK::Input input|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::Input> object. Obviously.

=end apidoc

=cut

#include "include/RectangleSubclass.h"

fltk::Input *
fltk::Input::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Input>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=begin apidoc

=for apidoc ||bool handled|handle_key||

Handle C<KEY> events. The default L<C<handle()>|FLTK::Widget/"handle"> method
calls this. This provides an Emacs and Windows style of editing. Most Emacs
commands are first run through L<C<try_shortcut()>|/"try_shortcut"> to test if
they are menu items for the program.

=over

=item C<Shift>: do not move the mark when moving the point

=item C<LeftKey>, C<Ctrl+B>: move left one character

=item C<Ctrl+LeftKey>, C<Alt+B>: move left one word

=item C<RightKey>, C<Ctrl+F>: move right one character

=item C<Ctrl+RightKey>, C<Alt+F>: move right one word

=item C<Ctrl+A>: go to start of line, if already there select all text

=item C<HomeKey>: go to start of line

=item C<EndKey>, Ctrl+E>: go to end of line

=item C<Ctrl+Insert>: copy

=item C<Shift+Insert>: paste

=item C<Shift+Delete>: cut

=item C<Delete>, C<Ctrl+D>: delete region or one character

=item C<Ctrl+Delete>, C<Alt+D>: delete region or one word

=item C<BackSpace>, C<Ctrl+H>: delete region or left one character

=item C<Ctrl+BackSpace>, C<Alt+H>: delete region or left one word

=item C<Return>, C<KeypadEnter>: if
L<C<when() & WHEN_ENTER_KEY>|FLTK::Widget/"when">, and no shift keys held
down, this selects all and does the callback. Otherwise key is ignored.

=item C<Ctrl+K>: cuts from the position to the end of line

=item C<Ctrl+C>: copy

=item C<Ctrl+T>: swap the two characters around point. If point is at end swap
the last two characters.

=item C<Ctrl+U>: delete all the text

=item C<Ctrl+V>: paste

=item C<Ctrl+X>, C<Ctrl+W>: cut

=item C<Ctrl+Y>: redo

=item C<Ctrl+Z>, C<Ctrl+/>: undo

=item All printing characters are run through L<C<compose()>|/"compose"> and
the result used to insert text.

=back

For L<Input|FLTK::Input> widgets in C<WORDWRAP> mode, you can also do these:

=over

=item C<UpKey>, C<Ctrl+P>: move up one line

=item C<DownKey>, C<Ctrl+N>: move down one line

=item C<PageUpKey>: move up 1 line less than the vertical widget size

=item C<PageDownKey>: move down 1 line less than the vertical widget size

=item C<Ctrl+HomeKey>, C<Alt+A>: got to start of text

=item C<Ctrl+EndKey>, C<Alt+E>: go to end of text

=item C<Return>, C<KeypadEnter>: inserts a newline

=item C<Ctrl+O>: insert a newline and leave the cursor before it.

=back

This method may be overridden for subclassing.

=for apidoc ||bool different|text|char * string|int length|

Change the L<C<text()>|/"text"> to return the first C<length> bytes of
C<string> and L<C<size()>|/"size"> to return C<length>, and set the
L<C<position()>|/"position"> to C<length> and the L<C<mark()>|/"mark"> to zero
(thus highlighting the entire value).

Returns true if the bytes in the new string are different than the old string.

=for apidoc ||bool different|text|char * string|

Same as
L<C<$input-E<gt>text($string, $string ? length($string) : 0)>|/"text">.

=for apidoc ||char * string|text||

The current string, as edited by the user. L<C<size()>|/"size"> returns how
many bytes are in the string.

=cut

SV *
fltk::Input::text( char * string = NO_INIT, int length = NO_INIT )
    CASE: items == 1
        CODE:
            ST( 0 ) = newSVpv( (char *) THIS->text( ), 0 );
            sv_2mortal( ST( 0 ) );
            XSRETURN( 1 );
    CASE: items == 2
        CODE:
            ST( 0 ) = boolSV( THIS->text( string ) );
            sv_2mortal( ST( 0 ) );
            XSRETURN( 1 );
    CASE: items == 3
        CODE:
            ST( 0 ) = boolSV( THIS->text( string, length ) );
            sv_2mortal( ST( 0 ) );
            XSRETURN( 1 );

=for apidoc ||bool ret|static_text|char * string|int length|

Same as L<C<text($string, $length)>|/"text_string_length_">, except it does
not copy the string, instead it makes L<C<text()>|/"text"> return a pointer to
C<$string> (unless C<$length> is 0, in which case it makes it point to a
zero-length string).

C<$string> must point to static memory that will not be altered until at least
the L<Input|FLTK::Input> widget is destroyed or the L<C<text()>|/"text"> is
changed again. If the user attempts to edit the string it is then copied to
the internal buffer and the editing done there. This can save a lot of time
and memory if your program is changing the string to various constants a lot
but the user rarely edits it.

=for apidoc ||bool ret|static_text|char * string|

Same as
L<C<$input-E<gt>static_text($string, $string ? length($string) : 0)>|/"static_text">.

=cut

bool
fltk::Input::static_text( char * string, int length = NO_INIT )
    CASE: items == 2
        C_ARGS: string
    CASE: items == 3
        C_ARGS: string, length

=for apidoc ||char chr|at|int index|

Same as L<C<text()[$index]>|/"text">, but may be faster in plausible
implementations. No bounds checking is done.

=for apidoc ||int length|size||

Returns the number of characters in L<C<text()>|/"text">. This may be greater
than C<length($input->text())> if there are C<NULL> characters in it.

=for apidoc |||reserve|int newsize|

Reserve the interal private buffer of at least C<newsize> bytes, even if the
current L<C<text()>|/"text"> is not that long. Can be used to avoid
unnecessary memory reallocations if you know you will be replacing the
L<C<text()>|/"text"> with a longer one later.

=cut

char
fltk::Input::at( int index )

int
fltk::Input::size( )

void
fltk::Input::reserve( int newsize )

=for apidoc ||int pos|position||

Returns the current location of the cursor.

=for apidoc |||position|int new_position|

Same as
L<C<position($new_position, $new_position)>|/"position_new_position_new_mark_">.

=for apidoc |||position|int new_position|int new_mark|

The input widget maintains two pointers into the string. The "position" is
where the cursor is. The "mark" is the other end of the selected text. If they
are equal then there is no selection. Changing this does not affect the X
selection, call L<C<copy()>|/"copy"> if you want that.

Changing these values causes a L<C<redraw()>|/"redraw">. The new values are
bounds checked and limited to the size of the string.

It is up to the caller to make sure the position and mark are at the borders
of UTF-8 characters!

=cut

int
fltk::Input::position( int new_position = NO_INIT, int new_mark = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->position( new_position );
            XSRETURN_EMPTY;
    CASE: items == 3
        CODE:
            THIS->position( new_position, new_mark );
            XSRETURN_EMPTY;

=for apidoc ||int mark|mark||



=for apidoc |||mark|int new_mark|

Same as L<C<$inputE<gt>position($input-E<gt>position(),$index)>|/"position">.

=cut

int
fltk::Input::mark( int new_mark = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        CODE:
            THIS->mark( new_mark );
            XSRETURN_EMPTY;

=for apidoc |||up_down_position|int position|int keepmark|

Does the correct thing for arrow keys. C<position> must be the location of the
start of a line. Sets the L<position|/"position"> (and L<mark|/"mark"> if
C<keepmark> is false) to somewhere after C<position>, such that pressing the
arrows repeatedly will cause the point to move up and down.

=cut

void
fltk::Input::up_down_position( int position, bool keepmark )

=for apidoc ||bool return|replace|int begin|int end|char * text|int length|

This call does all editing of the text. It deletes the region between C<begin>
and C<end> (either one may be less or equal to the other), and then inserts
C<length> (which may be zero) characters from the string C<text> at that point
and leaves the L<C<mark()>|/"mark"> and L<C<position()>|/"position"> after the
insertion. If the text is changed the callback is done if the
L<C<when()>|FLTK::Widget/"when"> flags indicate it should be done.

C<begin> and C<end> are bounds checked so don't worry about sending values
outside the length of the string.

=cut

bool
fltk::Input::replace( int begin, int end, char * text, int length = strlen( text ) )

=for apidoc ||bool okay|cut||

Wrapper around L<C<replace()>|/"replace">, this deletes the region between the
point and the mark. It does nothing if they are equal.

=for apidoc ||bool okay|cut|int length|

Wrapper around L<C<replace()>|/"replace"> this deletes up to C<length>
characters after the point, or before the point if C<length> is negative.
C<length> is bounds checked.

=for apidoc ||bool okay|cut|int begin|int end|

Wrapper around L<C<replace()>|/"replace"> this deletes the characters between
C<begin> and C<end>. The values are clamped to the ends of the string, and
C<end> can be less than C<begin>.

=cut

bool
fltk::Input::cut( int begin = NO_INIT, int end = NO_INIT )
    CASE: items == 1
        C_ARGS:
    CASE: items == 2
        C_ARGS: begin
    CASE: items == 3
        C_ARGS: begin, end

=for apidoc ||bool okay|insert|char * text|

Wrapper around L<C<replace()>|/"replace">. This inserts the string at the
point and leaves the point after it.

=for apidoc ||bool okay|insert|char * text|int length|

Wrapper around L<C<replace()>|/"replace">. This inserts C<length> characters
from the C<text> (including C<\0> characters!) at the point and leaves the
point after it.

=cut

bool
fltk::Input::insert( char * text, int length = strlen( text ) )
    CASE: items == 2
        C_ARGS: text
    CASE: items == 3
        C_ARGS: text, length

=for apidoc ||bool okay|copy|bool to_clipboard = true|

Put the current selection between L<C<mark()>|/"mark"> and
L<C<position()>|/"position"> into the selection or clipboard by calling
L<C<copy()>|FLTK/"copy">. If L<C<position()>|/"position"> and
L<C<mark()>|/"mark"> are equal this does nothing (ie it does not clear the
clipboard).

If C<to_clipboard> is true, the text is put into the user-visible cut & paste
clipboard (this is probably what you want). If C<to_clipboard> is false, it is
put into the less-visible selection buffer that is used to do middle-mouse
paste and drag & drop.

To paste the clipboard, call L<C<paste(1)>|FLTK/"paste"> and fltk will send
the widget a C<PASTE> event with the text, which will cause it to be inserted.

=cut

bool
fltk::Input::copy( bool to_clipboard = true )

=for apidoc ||bool okay|undo||

If this is the most recent widget on which L<C<replace()>|/"replace"> was done
on, this will undo that L<C<replace()>|/"replace"> and probably several others
(ie if the user has typed a lot of text it will undo all of it even though
that was probably many calls to L<C<replace()>|/"replace">). Returns true if
any change was made.

=cut

bool
fltk::Input::undo( )

=for apidoc ||int index|word_start|int position|

Returns the location of the first word boundary at or before C<position>.

=for apidoc ||int index|word_end|int position|

Returns the location of the next word boundary at or after C<position>.

=for apidoc ||int index|line_start|int position|

Returns the location of the start of the line containing the C<position>.

=for apidoc ||int index|line_end|int position|

Returns the location of the next newline or wordwrap space at or after
C<position>.

=cut

int
fltk::Input::word_start( int position )

int
fltk::Input::word_end( int position )

int
fltk::Input::line_start( int position )

int
fltk::Input::line_end( int position )

=for apidoc ||int index|mouse_position|FLTK::Rectangle * rectangle|

Figure out what character the most recent mouse event would be pointing to,
assumming you drew the text by calling L<C<draw()>|FLTK::draw/"draw"> with the
same L<C<rectangle>|FLTK::Rectangle>. Returns C<0> if the mouse is before the
first character, and L<C<size()>|/"size"> if it is after the last one.

=cut

int
fltk::Input::mouse_position( fltk::Rectangle * rectangle )
    C_ARGS: * rectangle

=for apidoc ||int x|xscroll||


=for apidoc ||int y|yscroll||


=cut

int
fltk::Input::xscroll( )

int
fltk::Input::yscroll( )

=end apidoc

=head1 Values for L<C<type>|FLTK::Widget/"type">

=over

=item C<NORMAL>

=item C<FLOAT_INPUT>

=item C<INT_INPUT>

=item C<SECRET>

=item C<WORDWRAP>

=back

=cut

int
NORMAL( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::Input::NORMAL;      break;
            case 1: RETVAL = fltk::Input::FLOAT_INPUT; break;
            case 2: RETVAL = fltk::Input::INT_INPUT;   break;
            case 3: RETVAL = fltk::Input::SECRET;      break;
            case 5: RETVAL = fltk::Input::WORDWRAP;    break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        FLOAT_INPUT = 1
          INT_INPUT = 2
             SECRET = 3
           WORDWRAP = 5

=head1 Subclassing FLTK::Input

The following methods may be overridden in subclasses of
L<FLTK::Input|FLTK::Input>:

=head2 C<handle>

You may override C<handle> which accepts an C<event> and a
L<C<rectangle>|FLTK::Rectangle>. The passed rectangle is the area the text is
to be drawn into. This method is provided so a subclass can place the text
into a subrectangle.

The default handle...

=over

=item * Handles C<FOCUS>, C<UNFOCUS>

=item * May do callback on C<HIDE>

=item * Any keystrokes call L<C<handle_key()>|/"handle_key">

=item * Handles C<PUSH>, C<DRAG>, C<RELEASE> to select regions of text, move
the cursor, and start drag & drop. Double click selects words, triple click
selects lines (triple click is broken on Windows).

=item * Receives drag&drop and accepts.

=item * Handles C<PASTE> events caused by accepting the drag&drop or by
calling L<C<paste()>|FLTK/"paste"> (which L<C<handle_key()>|/"handle_key">
does for C<^V>)

=back

=head2 C<handle_key>

Handle C<KEY> events. The default L<C<handle()>|FLTK::Widget/"handle"> method
calls this. This provides an Emacs and Windows style of editing. Most Emacs
commands are first run through L<C<try_shortcut()>|/"try_shortcut"> to test if
they are menu items for the program.

=over

=item C<Shift>: do not move the mark when moving the point

=item C<LeftKey>, C<Ctrl+B>: move left one character

=item C<Ctrl+LeftKey>, C<Alt+B>: move left one word

=item C<RightKey>, C<Ctrl+F>: move right one character

=item C<Ctrl+RightKey>, C<Alt+F>: move right one word

=item C<Ctrl+A>: go to start of line, if already there select all text

=item C<HomeKey>: go to start of line

=item C<EndKey>, Ctrl+E>: go to end of line

=item C<Ctrl+Insert>: copy

=item C<Shift+Insert>: paste

=item C<Shift+Delete>: cut

=item C<Delete>, C<Ctrl+D>: delete region or one character

=item C<Ctrl+Delete>, C<Alt+D>: delete region or one word

=item C<BackSpace>, C<Ctrl+H>: delete region or left one character

=item C<Ctrl+BackSpace>, C<Alt+H>: delete region or left one word

=item C<Return>, C<KeypadEnter>: if
L<C<when() & WHEN_ENTER_KEY>|FLTK::Widget/"when">, and no shift keys held
down, this selects all and does the callback. Otherwise key is ignored.

=item C<Ctrl+K>: cuts from the position to the end of line

=item C<Ctrl+C>: copy

=item C<Ctrl+T>: swap the two characters around point. If point is at end swap
the last two characters.

=item C<Ctrl+U>: delete all the text

=item C<Ctrl+V>: paste

=item C<Ctrl+X>, C<Ctrl+W>: cut

=item C<Ctrl+Y>: redo

=item C<Ctrl+Z>, C<Ctrl+/>: undo

=item All printing characters are run through L<C<compose()>|/"compose"> and
the result used to insert text.

=back

For L<Input|FLTK::Input> widgets in C<WORDWRAP> mode, you can also do these:

=over

=item C<UpKey>, C<Ctrl+P>: move up one line

=item C<DownKey>, C<Ctrl+N>: move down one line

=item C<PageUpKey>: move up 1 line less than the vertical widget size

=item C<PageDownKey>: move down 1 line less than the vertical widget size

=item C<Ctrl+HomeKey>, C<Alt+A>: got to start of text

=item C<Ctrl+EndKey>, C<Alt+E>: go to end of text

=item C<Return>, C<KeypadEnter>: inserts a newline

=item C<Ctrl+O>: insert a newline and leave the cursor before it.

=back

=cut

#INCLUDE: MultiLineInput.xsi

#INCLUDE: NumericInput.xsi

#INCLUDE: Output.xsi

#INCLUDE: SecretInput.xsi

#endif // ifndef DISABLE_INPUT

BOOT:
    isa("FLTK::Input", "FLTK::Widget");
