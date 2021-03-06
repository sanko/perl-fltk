#include "include/FLTK_pm.h"

MODULE = FLTK::Widget               PACKAGE = FLTK::Widget

#ifndef DISABLE_WIDGET

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Widget - Base class for all widgets in the Fast Light Toolkit

=head1 Description

The base class for all widgets in FLTK. The basic Widget draws an empty
L<C<box()>|FLTK::Widget/"box"> and the L<C<label()>|FLTK::Widget/"label">,
and ignores all events. This can be useful for making decorations or providing
areas that pop up a L<C<tooltip()>|FLTK::Widget/"tooltip">.

=head1 Subclassing Widgets

Blah, blah, blah...

=head2 Methods to Override

=head3 C<handle( event )>

Handles an event. Returns non-zero if the widget understood and used the
event.

The event numbers are listed in F<fltk/events.h>.  All other information about
the current event (like mouse position) is accessed by various functions
listed in the same header file.

The default version returns true for C<FLTK::ENTER> and C<FLTK::MOVE> events,
this is done so you can put tooltips on the base widget. All other events
return zero.

If you want to send an event to a widget you probably want to call
L<C<send()>|FLTK::Widget/"send">, not
L<C<handle()>|FLTK::Widget/"handle( event )">. Send will do extra work with
each event before calling this, such as turning C<HIGHLIGHT> and C<FOCUSED>
flags on/off.

=begin apidoc

=cut

#include <fltk/Widget.h>

#include <fltk/LabelType.h>

=for apidoc ||FLTK::Widget widget|new|int x|int y|int w|int h|int label = ''|

The default constructor takes a value for L<C<x()>|/"x">, L<C<y()>|/"y">,
L<C<w()>|/"w">, and L<C<h()>|/"h">, and an optional value for
L<C<label()>|/"label">. Not that all subclasses provide an identical
constructor and may also provide alternative constructors.

If L<C<FLTK::Group->begin()>|FLTK::Group/"begin"> has been called, this widget
is added as a new child of that group, and L<C<parent()>|/"parent"> is set to
the group. If L<C<FLTK::Group->begin()>|FLTK::Group/"begin"> has not been
called, or L<C<FLTK::Group->end()>|FLTK::Group/"end"> has been called,
or L<C<FLTK::Group->current(0)>|FLTK::Group/"current">, then the
L<C<parent()>|/"parent"> is undef. In this case you must add the widget
yourself in order to see it.

=cut

#include "include/RectangleSubclass.h"

fltk::Widget *
fltk::Widget::new( int x, int y, int w, int h, const char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Widget>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=for apidoc |||destroy|

Destroy the widget.

=cut

void
fltk::Widget::destroy( )
    CODE:
        delete THIS;
        sv_setsv(ST(0), &PL_sv_undef);

=for apidoc ||FLTK::Group * group|parent||

Returns the parent widget. Usually this is a L<FLTK::Group|FLTK::Group> or
L<FLTK::Window|FLTK::Window>. Returns C<undef> if this is an orphan widget.

=for apidoc |||parent|FLTK::Group * group|

Sets the parent.

=cut

fltk::Group *
fltk::Widget::parent ( fltk::Group * group = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->parent( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->parent( group );

=for apidoc ||FLTK::Window * win|window||

Return a pointer to the L<FLTK::Window|FLTK::Window> this widget is in. (it
will skip any and all parent widgets between this and the window). Returns
C<undef> if none. Note: for an L<FLTK::Window>, this returns the I<parent>
window (if any), not I<this> window.

=cut

fltk::Window *
fltk::Widget::window ( )


=for apidoc et[widget]||int type|RESREVED_TYPE||



=for apidoc E||int type|TOGGLE||



=for apidoc E||int type|RADIO||



=for apidoc E||int type|GROUP_TYPE||



=for apidoc E||int type|WINDOW_TYPE||



=cut

int
RESERVED_TYPE ( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = fltk::Widget::RESERVED_TYPE; break;
            case 1: RETVAL = fltk::Widget::TOGGLE;        break;
            case 2: RETVAL = fltk::Widget::RADIO;         break;
            case 3: RETVAL = fltk::Widget::GROUP_TYPE;    break;
            case 4: RETVAL = fltk::Widget::WINDOW_TYPE;   break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
             TOGGLE = 1
              RADIO = 2
         GROUP_TYPE = 3
        WINDOW_TYPE = 4

=for apidoc ||uchar ret|type||

C<8>-bit identifier that controls how widget works. This value had to be
provided for Forms compatibility, but you can use it for any purpose you want
(mostly for "bad object oriented programming" where you insert some subclass
functionality into the base class). Widget subclasses may store values in the
range C<0-99> here (larger values are reserved for use by FLTK).

The L<FLTK::PackedGroup|FLTK::PackedGroup> widget uses the low bit of the
L<C<type()>|/"type"> of each child to indicate C<HORIZONTAL (1)> or
C<VERTICAL (0)>.

For portability, FLTK does not use RTTI (Run Time Typing Infomation)
internally (you are free to use it, though). If you don't have RTTI you can
use the clumsy FLTK mechanisim, by having L<C<type()>|/"type"> use a unique
value. These unique values must be greater than the symbol
C<FLTK::Widget::RESERVED_TYPE> (which is C<100>). Look through the header
files for C<FLTK::Widget::RESERVED_TYPE> to find an unused number. If you
make a subclass of L<FLTK::Window|FLTK::Window>, you must use
C<FLTK::Widget::WINDOW_TYPE + N> (C<N> must be in the range C<1> to C<7>) so
that L<C<is_window()>|/"is_window"> will work, if you make a subclass of
L<FLTK::Group|FLTK::Group>, you must use C<FLTK::Widget::GROUP_TYPE + N> (C<N>
must be in the range C<1> to C<7>) so that L<C<is_group()>|/"is_group"> will
work.

=for apidoc |||type|uchar value|



=cut

uchar
fltk::Widget::type( uchar value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->type( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->type( value );

=for apidoc ||bool ret|is_group|

Returns a true value for subclasses of L<FLTK::Group|FLTK::Group>.

=for apidoc ||bool ret|is_window|

Returns a true value for subclasses of L<FLTK::Window|FLTK::Window>. If this
is true, L<C<is_group()>|/"is_group"> is also true.

=for apidoc ||bool ret|horizontal|

Return true if this widget has a horizontal orientation and
L<FLTK::Pack|FLTK::Pack> will position it agains the top or bottom edge. This
is the default.

See also: L<C<vertical()>|/"vertical">

=for apidoc ||bool ret|vertical|

Same as L<C<!horizontal()>|/"horizontal">

=cut

bool
fltk::Widget::is_group( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->is_group( );  break;
            case 1: RETVAL = THIS->is_window( ); break;
            case 2: RETVAL = THIS->horizontal( ); break;
            case 3: RETVAL = THIS->vertical( );   break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
         is_window = 1
        horizontal = 2
          vertical = 3

=for apidoc ||bool ret|resize|int x|int y|int w|int h|

Change the size or position of the widget. Nothing is done if the passed size
and position are the same as before. If there is a change then
L<C<relayout()>|/"relayout"> is called so that the virtual function
L<C<layout()>|/"layout"> is called before the next L<C<draw()>|/"draw">.

=for apidoc ||bool ret|resize|int w|int h|

Same as L<C<resize( x(), y(), $W, $H)>|/"resize">.

=cut

bool
fltk::Widget::resize ( int x = NO_INIT, int y = NO_INIT, int w, int h )
    CASE: items == 3
        CODE:
            RETVAL = THIS->resize( x, y, w, h );
    CASE: items == 5
        CODE:
            RETVAL = THIS->resize( w, h );
    OUTPUT:
        RETVAL

=for apidoc ||bool ret|positon|int x|int y|

Same as L<C<resize( X, Y, w(), h() )>|/"resize">

=cut

bool
fltk::Widget::position ( int x, int y )

=for apidoc |||get_absolute_rect|FLTK::Rectangle * rect|

Fills the L<FLTK::Rectangle|FLTK::Rectangle> pointed to by C<rect> with the
widget's rectangle expressed in absolute (i.e. screen) coordinates.

=cut

void
fltk::Widget::get_absolute_rect( fltk::Rectangle * rect )

=for apidoc |||label|char * string|

Sets the label directly to a string. The label is printed somewhere on the
widget or next to it. The string passed to label() is I<not> copied, instead
the pointer to the string is stored. If L<C<copy_label()>|/"copy_label"> was
called earlier the old string's memory is freed.

=for apidoc |||tooltip|char * string|

Set the string used as the pop-up tooltip. The pointer to the passed string
is stored, it is not copied! Passing null indicates that the tooltip of the
L<C<parent()>|/"parent"> should be used (or no tooltip if no parent has one).
If you want to disable the tooltip but let the parent have one, set this
tooltip to C<"">.

Putting C<@> commands in to bring up L<Symbol|FLTK::Symbol> objects will allow
a lot of interesting things to be put into the tooltip.

=cut

const char *
fltk::Widget::label ( char * string = NO_INIT )
    CASE: items == 1
        CODE:
            switch( ix ) {
                case 0: RETVAL = THIS->label( );   break;
                case 1: RETVAL = THIS->tooltip( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch( ix ) {
                case 0: THIS->label( string );   break;
                case 1: THIS->tooltip( string ); break;
            }
    ALIAS:
        tooltip = 1

=for apidoc |||copy_label|char * string|

Sets the label to a copy of the string. The passed string is copied to private
storage and used to set the L<C<label()>|/"label">. The memory will be freed
when the widget is destroyed or when L<C<copy_label()>|/"copy_label"> is
called again, or L<C<label(const char*)>|/"label"> is called.

Passing C<undef> will set L<C<label()>|/"label"> to C<undef>.

=cut

void
fltk::Widget::copy_label( char * string )

=for apidoc |||image|FLTK::Image * image|

Sets the image. The C<image> is drawn as part of the label, usually to the
left of the text. This is designed for icons on menu items. If you want to
replace the entire background of the widget with a picture you should set
L<C<box()>|/"box"> instead. Notice that you can also get images into labels by
putting C<@> commands into the L<C<label()>|/"label">.

=for apidoc ||FLTK::Symbol * img|image||

=cut

#include <fltk/Image.h>

const fltk::Symbol *
fltk::Widget::image ( fltk::Image * image = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->image( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->image( image );

=for apidoc ||unsigned key|shortcut||

Returns one of the L<C<add_shortcut()>|/"add_shortcut"> assignments for this
widget, or returns zero if there are none. If you want to look at more than
onle you must use L<C<FLTK::list_shortcuts(this)>|FLTK/"list_shortcuts">.

=for apidoc |||shortcut|unsigned key|

Same as L<C<remove_shortcuts()>|/"remove_shortcut">,
L<C<add_shortcut(key)>|/"add_shortcut"> except it may be implemented in a more
efficient way. The result is exactly one shortcut (or none if C<key> is zero).
Return value is intended to indicate if the shortcut changed, but that is nyi.

=cut

unsigned
fltk::Widget::shortcut ( unsigned KEY = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->shortcut( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->shortcut( KEY );

=for apidoc ||bool ret|add_shortcut|unsigned key|

Add a new shortcut assignment. Returns true if successful. If key is zero or
the assignment already exists this does nothing and returns false.

There can be any number of shortcut assignments, fltk stores them in internal
tables shared by all widgets. A widget can have any number of shortcuts
(though most have zero or one), and a given shortcut value can be assigned to
more than one widget. You can examine the assignments with
L<C<FLTK::list_shortcuts()>|FLTK/"list_shortcuts">.

If you only want one shortcut use L<C<shortcut()>|/"shortcut"> to assign it.

The shortcut value is a bitwise OR (or sum) of a any set of shift flags
returned by L<C<FLTK::event_state()>|/"event_state">, and either a key symbol
returned by L<C<FLTK::event_key()>|/"event_key">, or an ASCII character.
Examples:

=over

=item C<FLTK::CTRL + 'a'>

=item C<FLTK::ACCELERATOR + FLTK::CTRL + 'A'>

=item just 'a'

=item C<FLTK::SHIFT + '#'>

=item C<FLTK::SHIFT + FLTK::UpKey> See
L<C<FLTK::list_matching_shortcuts()>|FLTK/"list_matching_shortcuts"> for the
exact rules for how a C<KEY> event is matched to a shortcut assignment. Case
is ignored (the lower-case version of any letter is actually put in the
table).

=back

When FLTK gets a keystroke, it sends it to the
L<C<FLTK::focus()>|FLTK/"focus"> widget. If that widget's
L<C<handle()>|/"handle"> returns 0, it will also send the keystroke to all
parents of that widget (this is mostly for keyboard navigation to work). If
all of them return 0, or the L<C<FLTK::focus()>|FLTK/"focus"> is null, then it
will try sending a C<SHORTCUT> event to every single widget inside the same
window as the focus until one of them returns non-zero. In most cases widgets
will call L<C<Widget::test_shortcut()>|FLTK::Widget/"test_shortcut"> to see if
the keystroke is registered here (many widgets will also directly test the key
to see if it is something they are interested in).

=for apidoc ||bool ret|remove_shortcut|unsigned key|

Delete a shortcut assignment. Returns true if it actually existed.

=cut

bool
fltk::Widget::add_shortcut ( unsigned key )
    CODE:
        switch( ix ) {
            case 0:    RETVAL = THIS->add_shortcut( key ); break;
            case 1: RETVAL = THIS->remove_shortcut( key ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        remove_shortcut = 1

=for apidoc ||unsigned key|label_shortcut||

Returns a value that can be passed to L<C<add_shortcut()>|/"add_shortcut"> so
that this widget has a real shortcut assignment to match any C<&x> in it's
L<C<label()>|/"label">. The returned value is C<ALT|c> where C<c> is the
character after the first '&' in the label, or zero if there isn't any '&'
sign or if L<C<flag(RAW_LABEL)>|/"flag"> is on.

=cut

unsigned
fltk::Widget::label_shortcut ( )

=for apidoc ||bool ret|test_labe_shortcut||

Test to see if the current C<KEY> or C<SHORTCUT> event matches a shortcut
specified with C<&x> in the label.

This will match if the character in the L<C<label()>|/"label"> after a '&'
matches L<C<event_text()[0]>|/"event_text">. Case is ignored. The caller may
want to check if C<ACCELERATOR> or some other shift key is held down before
calling this so that plain keys do not do anything, and should certainly make
sure no other widgets want the shortcut.

This is ignored if L<C<flag(RAW_LABEL)>|/"flag"> is on (which stops the C<&x>
from printing as an underscore. The sequence "&&" is ignored as well because
that is used to print a plain '&' in the label.

=cut

bool
fltk::Widget::test_label_shortcut ( )

=for apidoc ||bool ret|test_shortcut||

Same as L<C<test_shortcut(true)>|/"test_shortcut">.

=for apidoc ||bool ret|test_shortcut|bool test_label|

Returns true if the current event matches one of the assignements made with
L<C<add_shortcut()>|/"add_shortcut">, or if C<test_label> is true and
L<C<test_label_shortcut()>|"test_label_shortcut"> returns true. Normally a
widget calls this in response to a C<SHORTCUT> event to see if the shortcut
key is assigned to it.

This is done by doing
L<C<list_matching_shortcuts()>|FLTK/"list_matching_shortcuts"> and seeing if
this widget is in the returned list. If the list is empty and C<test_label> is
true, it will return L<C<test_label_shortcut()>|/"test_label_shortcut">.

If the current event matches a different widget "better" than this one, then
false is returned. For instance if this widget has 'x' as a shortcut, this
will return true if the user types 'X'. But if another widget has 'X' then
this will return false. See
L<C<FLTK::list_matching_shortcuts()>|FLTK/"list_matching_shortcuts"> for the
rules about what ones are "better".

=cut

bool
fltk::Widget::test_shortcut ( bool test_label = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->test_shortcut( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = THIS->test_shortcut( test_label );
        OUTPUT:
            RETVAL

=for apidoc |||callback|CV * coderef|SV * args = NO_INIT|

Each widget has a single callback. You can set it or examine it with these
methods. The callback is called with the widget as the first argument and any
data in C<args> as the second argument. It is called in response to user
events, but exactly when depends on the widget. For instance a button calls it
when the button is released.

B<NOTE>: To make use of callbacks, your perl must be recent enough to support
weak references.

=for apidoc |||callback|CV * coderef|

For convenience you can also define the callback as taking only the Widget as
an argument.

B<NOTE>: This may not be portable to some machines.

=for apidoc Hx||FLTK::Callback * cb|callback|

Returns the callback as a blessed L<FLTK::Callback> object.

=for apidoc Hx|||callback|FLTK::Callback * callback|

Accepts a blessed L<FLTK::Callback|FLTK::Callback> object.

=cut

fltk::Callback *
fltk::Widget::callback( callback = NO_INIT, SV * args = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->callback( );
        OUTPUT:
            RETVAL
    CASE: (SvROK( ST( 1 ) ) ) && ( SvTYPE(SvRV(ST(1))) == SVt_PVCV )
        CV * callback
        CODE:
            HV   * stash = SvSTASH( SvRV( ST( 0 ) ) );
            char * CLASS = HvNAME( stash );
            HV   * cb    = newHV( );
            hv_store( cb, "coderef",  7, newSVsv( ST( 1 ) ),                0 );
            hv_store( cb, "class",    5, newSVpv( CLASS, strlen( CLASS ) ), 0 );
            if ( items == 3 )
                hv_store( cb, "args", 4, newSVsv( args ),                   0 );
            THIS->callback(_cb_w, (void *) cb);
    CASE:
        fltk::Callback * callback
        CODE:
            THIS->callback( callback );

=for apidoc |||user_data|SV * args|

Set the second argument to the callback.

See Also: L<C<callback>|/"callback">, L<C<argument>|/"argument">.

=for apidoc ||SV * data|user_data||

Returns the second argument to the callback.

=for apidoc |||argument|SV * arg|

Set the second argument to the callback to a number.

See Also: L<C<callback>|/"callback">, L<C<user_data>|/"user_data">.

=for apidoc ||SV * data|argument||

Returns the second argument to the callback.

=cut

SV *
fltk::Widget::user_data ( SV * args = NO_INIT )
    CASE: items == 1
        CODE:
            AV * arr = (AV*)THIS->user_data( ); // XXX - check if arr == NULL
            RETVAL = av_len(arr) == 2 ? *av_fetch(arr, 2, 0) : &PL_sv_undef;
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            AV * arr = newAV( );
            av_push(arr, av_shift((AV*)THIS->user_data()));
            SV * widget = newSVsv((SV*)ST(0));
#ifdef SvWEAKREF // XXX - Do I need to check this here? See FLTK::cb_w()
            //sv_rvweaken(widget);
#else // ifdef SvWEAKREF
            croak("weak references are not implemented in this release of perl");
            XSRETURN_EMPTY;
#endif // ifdef SvWEAKREF
            av_push(arr, widget); // widget
            for (int i = 1; i < items; i++) {
                av_push(arr, newSVsv((SV*)ST(i)));
            }
            THIS->user_data(arr);
    ALIAS:
        argument    = 1


=for apidoc |||when|uchar flag|

Flags indicating when to do the L<C<callback()>|/"callback">. This field is in
the base class so that you can scan a panel and
L<C<do_callback()>|/"do_callback"> on all the ones that don't do their own
callbacks in response to an C<OK> button.

The following constants can be used, their exact meaning depends on the
widget's implementation:

=over

=item C<FLTK::WHEN_NEVER>

Never call the L<C<callback (0)>|/"callback">.

=item C<FLTK::WHEN_CHANGED>

Do the callback each time the widget's value is changed by the user (many
callbacks may be done as the user drags the mouse)

=item C<FLTK::WHEN_RELEASE>

Each keystroke that modifies the value, or when the mouse is released and the
value has changed, causes the callback (some widgets do not implement this and
act like L<FLTK::WHEN_CHANGED>)

=item C<FLTK::WHEN_RELEASE_ALWAYS>

Each recognized keystroke and the mouse being released will cause the
callback, even if the value did not change. (some widgets do not implement
this and act like C<FLTK::WHEN_RELEASE>)

=item C<FLTK::WHEN_ENTER_KEY>

Do the callback when the user presses the C<ENTER> key and the value has
chagned (used by L<FLTK::Input|FLTK::Input> and
L<FLTK::Browser|FLTK::Browser>).

=item C<FLTK::WHEN_ENTER_KEY_ALWAYS>

Do the callback when the user presses the C<ENTER> key, even if the value has
not changed.

=item C<FLTK::WHEN_ENTER_KEY_CHANGED>

Do the callback when the user presses the C<ENTER> key and each time the value
changes.

=back

=for apidoc Hx||uchar flag|when|

=cut

uchar
fltk::Widget::when ( uchar flag = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->when( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->when( flag );

=for apidoc Hx|||default_callback|FLTK::Widget * w|SV * args = NO_INIT|

This is the initial value for L<C<callback()>|/"callback">. It does
L<C<set_changed()>|/"set_changed"> on the widget, thus recording the fact that
the callback was done. Do not set the callback to C<undef>, use this if you
want no action.

...between you and me, I don't really get this so I'll just hide for now.

=cut

void
fltk::Widget::default_callback( fltk::Widget * w, SV * args = NO_INIT)
    CODE:
        SV * _widget = newSVsv((SV*)ST(1));
#ifdef SvWEAKREF // XXX - Do I need to check this here? See FLTK::cb_w()
        //sv_rvweaken(_widget);
#else // ifdef SvWEAKREF
        croak("weak references are not implemented in this release of perl");
        XSRETURN_EMPTY;
#endif // ifdef SvWEAKREF
        AV  * arr     = newAV( );
        if (THIS->user_data() == NULL) // if THIS has no cb, do nothing
            return;
        SV ** coderef = av_fetch((AV*)THIS->user_data(), 0, 0);
        av_push(arr, newSVsv(*coderef));
        av_push(arr, _widget);
        if ( items == 3 )
            av_push(arr, newSVsv(args));
        THIS->default_callback(w, (void *) arr);

=for apidoc |||do_callback||

You can cause a widget to do its callback at any time.

=for apidoc x|||do_callback|FLTK::Widget * widget|SV * args = NO_INIT|

You can also call the callback function with arbitrary arguments.

=cut

void
fltk::Widget::do_callback( fltk::Widget * widget = NO_INIT, SV * args = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->do_callback( );
    CASE:
        CODE:
            SV * _widget = newSVsv((SV*)ST(1));
#ifdef SvWEAKREF // XXX - Do I need to check this here? See FLTK::cb_w()
            //sv_rvweaken(_widget);
#else // ifdef SvWEAKREF
        croak("weak references are not implemented in this release of perl");
        XSRETURN_EMPTY;
#endif // ifdef SvWEAKREF
            AV  * arr     = newAV( );
            if (THIS->user_data() == NULL) // if THIS has no cb, do nothing
                return;
            SV ** coderef = av_fetch((AV*)THIS->user_data(), 0, 0);
            av_push(arr, newSVsv(*coderef));
            av_push(arr, _widget);
            if ( items == 3 )
                av_push(arr, newSVsv(args));
            THIS->do_callback(widget, (void *) arr);


=for apidoc ||bool ret|contains|FLTK::Widget * child|

Returns a true value if L<widget|FLTK::Widget> C<child> is a child of this
widget, or is equal to this widget. Returns a false value if C<child> is
undefined.

=for apidoc ||bool ret|inside|FLTK::Widget * parent|

Returns true if this is a child of C<parent>, or is equal to C<parent>.
Returns false if C<parent> is undef.

=cut

bool
fltk::Widget::contains ( fltk::Widget * child )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->contains(child); break;
            case 1: RETVAL = THIS->inside(child);   break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        inside = 1

=for apidoc ||bool ret|active||

Returns true if L<C<deactivate()>|/"deactivate"> has not been called, or
L<C<activate()>|/"activate"> has been called since then.

Parents may also be deactivated, in which case this widget will not get events
even if this is true. You can test for this with
C<!>L<C<active_r()>|/"active_r">.

=for apidoc ||bool ret|active_r||

Returns true if L<C<active()>|/"active"> is true for this and all parent
widgets. This is actually the C<INACTIVE_R> bit in L<C<flags()>|/"flags">,
fltk keeps this up to date as widgets are deactivated and/or added to inactive
parents.

=for apidoc ||bool ret|output||

This flag is similar to L<C<!active()>|/"active"> except it does not change
how the widget is drawn. The widget will not recieve any events. This is
useful for making scrollbars or buttons that work as displays rather than
input devices.

Set or clear this flag with L<C<set_output()>|/"set_output"> and
L<C<clear_output()>|/"clear_output">.

=for apidoc ||bool ret|visible||

Returns true if the widget is visible (L<C<flag(INVISIBLE)>|/"flag"> is
false).

=for apidoc ||bool ret|visible_r||

Returns true if the widget and all of its parents are visible. Only if this is
true can the user see the widget.

=for apidoc ||bool ret|takesevents||

This is the same as C<(active() && visible() && output())> but faster.
L<C<send()>|/"send"> uses this to decide whether or not to call
L<C<handle()>|/"handle"> for most events.

=for apidoc ||bool ret|click_to_focus||

If true then clicking on this widget will give it the focus (the
L<C<handle()>|/"handle"> method must also return non-zero for C<FLTK::PUSH>
and for C<FLTK::FOCUS> events).

By default fltk only turns this on on certain widgets such as
L<FLTK::Input|FLTK::Input>. Turning this on on all widgets will make the user
interface match Windows more closely.

=for apidoc ||bool ret|tab_to_focus||

If true then this widget can be given focus by keyboard navigation. (the
L<C<handle()>|/"handle"> method must also return non-zero for
C<FLTK::FOCUS> events).

Turning this off with L<C<clear_tab_to_focus()>|/"clear_tab_to_focus"> will
also turn off the L<C<click_to_focus()>|/"click_to_focus"> flag. This is for
compatability in case we change the default to a more Windows-like style where
all widgets get the focus on clicks.

For historical reasons this flag is true on many more widgets than it should
be, and FLTK relies on L<C<handle()>|/"handle"> returing C<0> for C<FOCUS>.
This may change in the future so that more widgets have this flag off.

=for apidoc ||bool ret|changed||

The default L<C<callback()>|/"callback"> turns this flag on. This can be used
to find what widgets have had their value changed by the user, for instance in
response to an "OK" button.

Most widgets turn this flag off when they do the callback, and when the
program sets the stored value.

=for apidoc H||bool ret|value||

A true/false flag used by L<FLTK::Button|FLTK::Button> to indicate the current
state and by "parent" items in a hierarchial L<FLTK::Browser|FLTK::Browser> to
indicate if they are open. Many widgets will draw pushed-in or otherwise
indicate that this flag is on.

=for hackers For some reason, this is documented in fltk but it doesn't
actually exist in this class

=for apidoc ||bool ret|selected||

A true/false flag used to mark widgets currently selected in
L<FLTK::Menu|FLTK::Menu> and L<FLTK::Browser|FLTK::Browser> widgets. Some
widgets will draw with much different colors if this is on.

=for apidoc ||bool ret|pushed||

Returns true if this is equal to L<C<FLTK::pushed()>|FLTK/"pushed">, meaning
it has responded to an C<FLTK::PUSH> event and the mouse is still held down.

=for apidoc ||bool ret|focused||

Returns true if this is equal to L<C<FLTK::focus()>|FLTK/"focus">, meaning it
has the keyboard focus and C<FLTK::KEY> events will be sent to this widget.

=for apidoc ||bool ret|belowmouse||

Returns true if this is equal to L<C<FLTK::belowmouse()>|FLTK/"belowmouse">,
meaning it has the keyboard focus and C<FLTK::MOVE> or C<FLTK::PUSH> events
will be sent to this widget.

=for apidoc ||bool ret|clear||

Same as L<C<state(false)>|/"state">. If you know the widget will already be
redrawn, or it is not displayed, it is faster to call the inline
L<C<clear_flag(STATE)>|/"clear_flag"> function.

=for apidoc ||bool ret|take_focus||

Tries to make this widget be the keyboard focus widget, by first sending it an
C<FLTK::FOCUS> event, and if it returns non-zero, setting
L<C<FLTK::focus()>|FLTK/"focus"> to this widget. You should use this method to
assign the focus to a widget. Returns true if the widget accepted the focus.

On current systems, fltk does not force the window system to set the focus. If
the window does not have focus it will usually switch back to the previous
window when the user types a key.

=cut

bool
fltk::Widget::active( )
    CODE:
        switch ( ix ) {
            case  0: RETVAL = THIS->active( );         break;
            case  1: RETVAL = THIS->active_r( );       break;
            case  2: RETVAL = THIS->output( );         break;
            case  3: RETVAL = THIS->visible( );        break;
            case  4: RETVAL = THIS->visible_r( );      break;
            case  5: RETVAL = THIS->takesevents( );    break;
            case  6: RETVAL = THIS->click_to_focus( ); break;
            case  7: RETVAL = THIS->tab_to_focus( );   break;
            case  8: RETVAL = THIS->changed( );        break;
          //case  9: RETVAL = THIS->value( );          break;
            case 10: RETVAL = THIS->selected( );       break;
            case 11: RETVAL = THIS->pushed( );         break;
            case 12: RETVAL = THIS->focused( );        break;
            case 13: RETVAL = THIS->belowmouse( );     break;
            case 15: RETVAL = THIS->clear( );          break;
            case 16: RETVAL = THIS->take_focus( );     break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
              active_r =  1
                output =  2
               visible =  3
             visible_r =  4
           takesevents =  5
        click_to_focus =  6
          tab_to_focus =  7
               changed =  8
                 value =  9
              selected = 10
                pushed = 11
               focused = 12
            belowmouse = 13
                 clear = 15
            take_focus = 16


=for apidoc ||FLTK::Flags f|flags||

Each Widget, and most drawing functions, take a bitmask of flags that indicate
the current state and exactly how to draw things. See <fltk/Flags.h> for
values.

This is for copying the flag values, use L<C<flag(c)>|/"flag"> to test them.

=for apidoc |||flags|FLTK::Flags f|

Replace L<C<flags()>|/"flags">. This is for constructors, don't use it
elsewhere.

=cut

fltk::Flags
fltk::Widget::flags( fltk::Flags f = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->flags( );
            OUTPUT:
                RETVAL
    CASE:
        CODE:
            THIS->flags( f );

=for apidoc |||set_flag|unsigned f|

Make L<C<flag(f)>|/"flag"> return true by turning on that bit. You can set
more than one by or'ing them together.

=for apidoc |||clear_flag|unsigned f|

Make L<C<flag(f)>|/"flag"> return false by turning off that bit. You can turn
off multiple bits by or'ing them toegher.

=for apidoc |||set_flag|unsigned f|bool b|

Make L<C<flag(f)>|/"flag"> return C<b>. Same as
C<b ? set_flag(f) : clear_flag(f)>.

=for apidoc |||invert_flag|unsigned f|

Flip the result of L<C<flag(f)>|/"flag"> if C<f> is a single bit. If you or
together bits it will flip them all.

=cut

void
fltk::Widget::set_flag( unsigned f, bool b = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->set_flag( f );
    CASE:
        CODE:
            THIS->set_flag( f, b );

void
fltk::Widget::clear_flag( unsigned f )

void
fltk::Widget::invert_flag( unsigned f )

=for apidoc ||bool on|flag|unsigned f|

Returns true if the bit for C<f> is on.

=for apidoc ||bool on|any_of|unsigned f|

Returns true if I<any> of the bits in C<f> are on. Actually, this is the same
function as L<C<flag(f)>|/"flag"> but using this may make the code more
readable.

=for apidoc ||bool on|all_of|unsigned f|

Returns true if I<all> of the bits in C<f> are on. C<f> should be several bits
or'd together, otherwise this is the same as L<C<flag(f)>|/"flag">.

=cut

bool
fltk::Widget::flag( unsigned f )
    ALIAS:
        any_of = 1
        all_of = 2
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->flag( f ); break;
            case 1: RETVAL = THIS->any_of( f ); break;
            case 2: RETVAL = THIS->all_of( f ); break;
        }
    OUTPUT:
        RETVAL

=for apidoc ||bool value|state||

Widgets have space in them to store a single true/false value (put into the
C<STATE> bit of L<C<flags()>|/"flags">). This is used by buttons and
checkmarks and radio menu items.

=for apidoc |||state|bool value||

Change the L<C<state()>|/"state">. Also calls
L<C<clear_changed()>|/"clear_changed">. If the state is different,
L<C<redraw(DAMAGE_VALUE)>|/"redraw"> is called and true is returned. If the
state is the same then false is returned and the widget is not redrawn.

=cut

bool
fltk::Widget::state( bool value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->state( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->state( value );

=for apidoc |||align|unsigned flags|

Forces the values of all the C<FLTK::ALIGN_*> flags to the passed value. This
determines how the label is printed next to or inside the widget. The default
value is C<FLTK::ALIGN_CENTER>, which centers the label. The value can be any
of the C<ALIGN> flags or'd together.

=for apidoc ||FLTK::Flags flags|align||

=cut

fltk::Flags
fltk::Widget::align( unsigned flags = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->align( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->align( flags );

=for apidoc |||activate||

If L<C<active()>|/"active"> is false, this turns it on. If
L<C<active_r()>|/"active_r"> is now true L<C<send()>|/"send"> an
C<FLTK::ACTIVATE> event.

=for apidoc |||activate|bool b|

Toggle between L<C<activate()>|/"activate"> and L<C<deactivate()>|/"deactivate">.

=cut

void
fltk::Widget::activate( int b = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->activate( );
    CASE:
        CODE:
            THIS->activate( b );

=for apidoc |||set_output||



=for apidoc |||clear_output||



=for apidoc |||set_changed||



=for apidoc |||clear_changed||



=for apidoc |||clear_selected||



=for apidoc |||set_click_to_focus||



=for apidoc |||clear_click_to_focus||



=for apidoc |||set_tab_to_focus||



=for apidoc |||clear_tab_to_focus||



=for apidoc |||set_vertical||

Makes L<C<vertical()>|/"vertical"> return true. This will affect how a
surrounding L<FLTK::Pack|FLTK::Pack> (or similar group) will place the widget,
but you must call L<C<relayout()>|/"relayout"> to indicate that this must be
recalculated.

Some widgets classes such as L<FLTK::MenuBar|FLTK::MenuBar> or
L<FLTK::Slider|FLTK::Slider> will draw differently if this is turned on, in a
vertical arrangement.

=for apidoc |||set_horizontal||

Undoes L<C<set_vertical()>|/"set_vertical"> and makes
L<C<horizontal()>|/"horizontal"> return true. This will affect how a
surrounding L<FLTK::Pack> (or similar group) will place the widget, but you
must call L<C<relayout()>|/"relayout"> to indicate that this must be
recalculated.

=for apidoc |||throw_focus||

This function is called by the destructor and by
L<C<deactivate()>|/"deactivate"> and by L<C<hide()>|/"hide">. It indicates
that the widget does not want to receive any more events, and also removes all
global variables that point at the widget (not just the
L<C<FLTK::focus()>|FLTK/"focus">, but the
L<C<FLTK::belowmouse()>|FLTK/"belowmouse">, L<C<FLTK::modal()>|FLTK/"modal">,
and some internal pointers). Unlike older versions of fltk, no events (i.e.
C<FLTK::LEAVE> or C<FLTK::UNFOCUS>) are sent to the widget.

=for apidoc |||remove_shortcuts||

Remove all shortcuts for the widget. This is automatically done by the
L<C<Widget>|FLTK::Widget> destructor.

=for apidoc |||make_current||

Make the fltk drawing functions draw into this widget. The transformation is
set so C<0,0> is at the upper-left corner of the widget and 1 unit equals one
pixel. The transformation stack is empied, and all other graphics state is
left in unknown settings.

The equivalent of this is already done before a
L<C<Widget::draw()>|FLTK::Widget/"draw"> function is called. The only reason
to call this is for incremental updating of widgets without using
L<C<redraw()>|/"redraw">. This will crash if the widget is not in a currently
L<C<shown()>|/"shown"> window. Also this may not work correctly for
double-buffered windows.

=for apidoc |||draw_background||

Draw what would be in the area of the widget if the widget was not there. By
calling this in L<C<draw()>|/"draw">, a widgets can redraw as though they are
partially transparent, or more complicated shapes than rectangles. Note that
only parent widgets are drawn, not underlapping ones.

If C<DAMAGE_EXPOSE> is on in L<C<damage()>|/"damage"> then the window (or at
least some region of it) is being completely redrawn. Normally FLTK will have
already drawn the background, so to avoid redundant drawing this will return
immediatly without drawing anything. However FLTK may be compiled with
C<USE_CLIPOUT> (an option to reduce blinking in single-buffered windows) and
in that case the widget must draw any visible background. In this case this
function always draws the background.

=for apidoc |||draw_frame||

Same as L<C<draw_box()>|/"draw_box"> but draws only the boundary of the
L<C<box()>|/"box"> by calling it's draw routine with the C<INVISIBLE> flag
set. This only works for rectangular boxes. This is useful for avoiding
blinking during update for widgets that erase their contents as part of
redrawnig them anyway (ie anything displaying text).

=cut

void
fltk::Widget::set_output( )
    CODE:
        switch( ix ) {
            case  0:           THIS->set_output( ); break;
            case  1:         THIS->clear_output( ); break;
            case  2:          THIS->set_changed( ); break;
            case  3:        THIS->clear_changed( ); break;
            case  4:         THIS->set_selected( ); break;
            case  5:       THIS->clear_selected( ); break;
            case  6:   THIS->set_click_to_focus( ); break;
            case  7: THIS->clear_click_to_focus( ); break;
            case  8:     THIS->set_tab_to_focus( ); break;
            case  9:   THIS->clear_tab_to_focus( ); break;
            case 10:         THIS->set_vertical( ); break;
            case 11:       THIS->set_horizontal( ); break;
            case 12:          THIS->throw_focus( ); break;
            case 13:     THIS->remove_shortcuts( ); break;
            case 14:         THIS->make_current( ); break;
            case 15:      THIS->draw_background( ); break;
            case 16:           THIS->draw_frame( ); break;
        }
    ALIAS:
                clear_output =  1
                 set_changed =  2
               clear_changed =  3
                set_selected =  4
              clear_selected =  5
          set_click_to_focus =  6
        clear_click_to_focus =  7
            set_tab_to_focus =  8
          clear_tab_to_focus =  9
                set_vertical = 10
              set_horizontal = 11
                 throw_focus = 12
            remove_shortcuts = 13
                make_current = 14
             draw_background = 15
                  draw_frame = 16

=for apidoc |||redraw||

Same as C<redraw(DAMAGE_ALL)>. This bit is used by most widgets to indicate
that they should not attempt any incremental update, and should instead
completely draw themselves.

=for apidoc |||redraw|uchar flags|

Indicates that L<C<draw()>|/"draw"> should be called, and turns on the given
bits in L<C<damage()>|/"damage">. At least these bits, and possibly others,
will still be on when L<C<draw()>|/"draw"> is called.

=for apidoc |||redraw|FLTK::Rectangle * rect|



=cut

void
fltk::Widget::redraw( args = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->redraw( );
    CASE: sv_isobject(ST(0))
        fltk::Rectangle * args
        CODE:
            THIS->redraw( * args );
    CASE:
        uchar args
        CODE:
            THIS->redraw( args );

=for apidoc |||redraw_label||

Indicates that the L<C<label()>|/"label"> should be redrawn. This does nothing
if there is no label. If it is an outside label (see L<C<align()>|/"align">)
then the L<C<parent()>|/"parent"> is told to redraw it. Otherwise
L<C<redraw()>|/"redraw"> is called.

=for apidoc |||redraw_highlight||

Causes a redraw if highlighting changes.

Calls L<C<redraw(DAMAGE_HIGHLIGHT)>|/"redraw"> if this widget has a non-zero
L<C<highlight_color()>|/"hightlight_color">. This is designed to be called in
response to C<ENTER >and C<EXIT> events and not redraw the widget if the no
highlight color is being used.

=cut

void
fltk::Widget::redraw_label( )
    CODE:
        switch ( ix ) {
            case 0: THIS->redraw_label( );     break;
            case 1: THIS->redraw_highlight( ); break;
        }
    ALIAS:
        redraw_highlight = 1


=for apidoc |||draw_box||

Draw the widget's L<C<box()>|/"box"> such that it fills the entire area of the
widget. If the box is not rectangluar, this also draws the area of the parent
widget that is exposed.

This also does C<drawstyle(style(),flags()&~OUTPUT)> and thus the colors and
font are set up for drawing text in the widget.

=for apidoc |||draw_box|FLTK::Rectangle * rect|

Draw the widget's L<C<box()>|/"box"> such that it fills the entire area of
L<C<rect>|FLTK::Rectangle>.

=cut

void
fltk::Widget::draw_box ( fltk::Rectangle * rect = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->draw_box( );
    CASE:
        CODE:
            THIS->draw_box( *rect );

=for apidoc |||draw_label||

Calls L<C<draw_label()>|/"draw_label"> with the area inside the
L<C<box()>|/"box"> and with the alignment stored in L<C<flags()>|/"flags">.
The L<C<labelfont()>|/"labelfont"> and L<C<labelcolor()>|/"labelcolor"> are
used. For historic reasons if the C<OUTPUT> flag is on then the
L<C<textfont()>|/"textfont"> and L<C<textcolor()>|/"textcolor"> are used.

=for apidoc |||draw_label|FLTK::Rectangle * ir|FLTK::Flags flags|

Draws labels inside the widget using the current font and color settings.
C<XYWH> is the bounding box to fit the label into, flags is used to align in
that box.

If the C<flags> contain any C<ALIGN> flags and don't have C<ALIGN_INSIDE> then
the L<C<label()>|/"label"> is not drawn. Instead the L<C<image()>|/"image"> is
drawn to fill the box (most L<C<image()>|/"image"> types will center the
picture).

Otherwise it tries to put both the L<C<label()>|/"label"> and the
L<C<image()>|/"image"> into the box in a nice way. The L<C<image()>|/"image">
is put against the side that any ALIGN flags say, and then the
L<C<label()>|/"label"> is put next to that.

=cut

void
fltk::Widget::draw_label ( fltk::Rectangle * ir = NO_INIT, fltk::Flags flags = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->draw_label( );
    CASE: items == 3
        CODE:
            THIS->draw_label( *ir, flags );

=for apidoc |||draw_glyph|int which|FLTK::Rectangle * rect|

Changes the lower 5 bits (the "align" bits) of L<C<drawflags()>|/"drawflags">
to be the  value of C<which>, then draws the L<C<glyph()>|/"glyph">, then put
L<C<drawflags()>|/"drawflags"> back. This is a convienence function for
widgets that actually need to draw several different glyphs. They have to
define a glyph which draws a different image depending on the align flags.
This allows the style to be changed by replacing the glyph function, though
the replacement should draw the same things for the align flags, perhaps by
being an L<FLTK::MultiImage>|FLTK::MultiImage>.

=for hackers Found in F<src/default_glyph.cxx>

=cut

void
fltk::Widget::draw_glyph ( int which, fltk::Rectangle * rect )
    C_ARGS: which, * rect

=for apidoc ||AV * wh|measure_label||

Replace C<w> and C<h> with the size of the area the label will take up. This
is the size of the L<C<draw_outside_label()>|/"draw_outside_label"> and thus
does not include any L<C<image()>|/"image"> and always uses the labelfont even
if the C<OUTPUT> flag is set.

If the C<ALIGN_WRAP> flag is set this chooses the rather arbitrary width of
300 to wrap the label at. Ideally this should have been passed in C<w> but is
not for back-compatability reasons.

=for hackers Found in F<fltk/widget_draw.cxx>.

=cut

void
fltk::Widget::measure_label( OUTLIST int w, OUTLIST int h )
    C_ARGS: w, h

=for apidoc ||FLTK::Box b|box||

The type of box to draw around the outer edge of the widget (for the majority
of widgets, some classes ignore this or use it to draw only text fields inside
the widget). The default is C<FLTK::DOWN_BOX>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||box|FLTK::Box b|

Sets the type of box to draw around the outer edge of widget.

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Box bb|buttonbox||

The type of box to draw buttons internal the widget (notice that
L<FLTK::Button|FLTK::Button> uses box, however). The default is
C<FLTK::UP_BOX>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||buttonbox|FLTK::Box bb|

Returns the type of box to draw buttions internal the widget.

=for hackers Found in F<src/Style.cxx>

=cut

fltk::Box *
fltk::Widget::box( fltk::Box * box = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL =       THIS->box( ); break;
                case 1: RETVAL = THIS->buttonbox( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch( ix ) {
                case 0:       THIS->box( box ); break;
                case 1: THIS->buttonbox( box ); break;
            }
    ALIAS:
        buttonbox = 1

=for apidoc ||FLTK::Symbol * image|glyph||

A small image that some Widgets use to draw part of themselves. For instance
the L<FLTK::CheckButton|FLTK::CheckButton> class has this set to a Symbol that
draws the white box and the checkmark if C<VALUE> is true.

Im most cases the L<C<FLTK::drawflags()>|FLTK/"drawflags"> are examined to
decide between differnt symbols. The default value draws empty squares and
arrow buttons if C<ALIGN> flags are on, see
L<Widget::default_glpyh|FLTK::Widget/"default_glyph">.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||glyph|FLTK::Symbol * image|

Sets a small image that some Widgets use to draw part of themselves.

=for hackers Found in F<src/Style.cxx>

=cut

fltk::Symbol *
fltk::Widget::glyph( fltk::Symbol * symbol = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->glyph( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->glyph( symbol );

=for apidoc ||FLTK::Font * font|labelfont||

The font used to draw the label. Default is C<FLTK::HELVETICA>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||labelfont|FLTK::Font * Font|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Font * font|textfont||

Font to use to draw information inside the widget, such as the text in a text
editor or menu or browser. Default is C<FLTK::HELVETICA>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||textfont|FLTK::Font * font|

=for hackers Found in F<src/Style.cxx>

=cut

fltk::Font *
fltk::Widget::labelfont ( fltk::Font * font = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->labelfont( ); break;
                case 1: RETVAL =  THIS->textfont( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->labelfont( font ); break;
                case 1:  THIS->textfont( font ); break;
            }
    ALIAS:
        textfont = 1

=for apidoc ||FLTK::LabelType * type|labeltype||

How to draw the label. This provides things like inset, shadow, and the
symbols. C<FLTK::NORMAL_LABEL>.

=for apidoc |||labeltype|FLTK::LabelType * type|

=cut

fltk::LabelType *
fltk::Widget::labeltype( fltk::LabelType * type = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->labeltype( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->labeltype( type );

=for apidoc ||FLTK::Color color|color|

Color of the widgets. The default is C<FLTK::WHITE>. You may think most
widgets are gray, but this is because L<Group|FLTK::Group> and
L<Window|FLTK::Window> have their own L<Style|FLTK::Style> with this set to
C<FLTK::GRAY75>, and also because many parts of widgets are drawn with the
L<C<buttoncolor()>|/"buttoncolor">.

If you want to change the overall color of all the gray parts of the interface
you want to call L<C<FLTK::set_background(color)>|FLTK/"set_background">
instead, as this will set the entry for C<FLTK::GRAY75> and also set the "gray
ramp" so that the edges of buttons are the same color.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||color|FLTK::Color color|



=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|textcolor||

Color to draw text inside the widget. Default is black. This is also used by
many widgets to control the color when they draw the L<C<glyph()>|/"glyph">,
thus it can control the color of checkmarks in
L<FLTK::CheckButton|FLTK::CheckButton>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||textcolor|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|selection_color||

Color drawn behind selected text in inputs, or selected browser or menu items,
or lit light buttons. The default is C<FLTK::WINDOWS_BLUE>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||selection_color|FLTK::Color color|

=for apidoc ||FLTK::Color color|selection_textcolor||

The color to draw text atop the L<C<selection_color>|/"selection_color">. The
default of zero indicates that fltk will choose a contrasting color (either
the same as the original color or white or black). I recommend you use the
default if possible.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||selection_textcolor|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|buttoncolor||

Color used when drawing buttons. Default is C<FLTK::GRAY75>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||buttoncolor|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|labelcolor||

Color used to draw labels. Default is C<FLTK::BLACK>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||labelcolor|FLTK::Color color|

=for apidoc ||FLTK::Color color|highlight_color||

The color to draw the widget when the mouse is over it (for scrollbars and
sliders this is used to color the buttons). Depending on the widget this will
either recolor the buttons that are normally colored with
L<C<buttoncolor()>|/"buttoncolor">, or will recolor the main area that is
normally colored with L<C<color()>|/"color">.

The default value is zero, which indicates that highlighting is disabled.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||highlight_color|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|highlight_textcolor||

Color used to draw the labels or text when the background is drawn in the
L<C<highlight_color>|/"highlight_color">. The default of zero indicates that
fltk will choose a contrasting color (either the same as the original color or
white or black). I recommend you use the default if possible.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||highlight_textcolor|FLTK::Color color|

=cut

fltk::Color
fltk::Widget::color ( fltk::Color color = NO_INIT )
    CASE: items == 1
        CODE:
            switch( ix ) {
                case 0:               RETVAL = THIS->color( ); break;
                case 1:           RETVAL = THIS->textcolor( ); break;
                case 2:     RETVAL = THIS->selection_color( ); break;
                case 3: RETVAL = THIS->selection_textcolor( ); break;
                case 4:         RETVAL = THIS->buttoncolor( ); break;
                case 5:          RETVAL = THIS->labelcolor( ); break;
                case 6:     RETVAL = THIS->highlight_color( ); break;
                case 7: RETVAL = THIS->highlight_textcolor( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch( ix ) {
                case 0:               THIS->color( color ); break;
                case 1:           THIS->textcolor( color ); break;
                case 2:     THIS->selection_color( color ); break;
                case 3: THIS->selection_textcolor( color ); break;
                case 4:         THIS->buttoncolor( color ); break;
                case 5:          THIS->labelcolor( color ); break;
                case 6:     THIS->highlight_color( color ); break;
                case 7: THIS->highlight_textcolor( color ); break;
            }
    ALIAS:
                  textcolor = 1
            selection_color = 2
        selection_textcolor = 3
                buttoncolor = 4
                 labelcolor = 5
            highlight_color = 6
        highlight_textcolor = 7

=for apidoc ||float size|labelsize||

Size of L<C<labelfont()>|/"labelfont">. Default is 12.

=for hackers Found in F<src/Style.cxx>

=for apidoc ||float size|textsize||

Size of L<C<textfont()>|/"textfont">. This is also used by many Widgets to
control the size they draw the L<C<glyph()>|/"glyph">. Default is 12.

=for hackers Found in F<src/Style.cxx>

=for apidoc ||float size|leading||

Extra spacing added between text lines or other things that are stacked
vertically. The default is 2. The function
L<C<FLTK::drawtext()>|FLTK/"drawtext"> will use the value from
L<C<Widget::default_style>|FLTK::Widget/"default_style">, but text editors and
browsers and menus and similar widgets will use the local value.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||labelsize|float size|

=for hackers Found in F<src/Style.cxx>

=for apidoc |||textsize|float size|

=for hackers Found in F<src/Style.cxx>

=for apidoc |||leading|float size|

=for hackers Found in F<src/Style.cxx>

=cut

float
fltk::Widget::labelsize( float size = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->labelsize( ); break;
                case 1:  RETVAL = THIS->textsize( ); break;
                case 2:   RETVAL = THIS->leading( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->labelsize( size ); break;
                case 1:  THIS->textsize( size ); break;
                case 2:   THIS->leading( size ); break;
             }
    ALIAS:
        textsize = 1
         leading = 2

=for apidoc ||char align|scrollbar_align||

Where to place scrollbars around a L<Browser|FLTK::Browser> or other scrolling
widget. The default is C<FLTK::ALIGN_RIGHT|FLTK::ALIGN_BOTTOM>.

=for apidoc ||char width|scrollbar_width||

How wide the scrollbars are around a Browser or other scrolling widget. The
default is 15.

=for apidoc |||scrollbar_align|char align|

=for apidoc |||scrollbar_width|char width|

=cut

unsigned char
fltk::Widget::scrollbar_align ( unsigned char value = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->scrollbar_align( ); break;
                case 1: RETVAL = THIS->scrollbar_width( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->scrollbar_align( value ); break;
                case 1: THIS->scrollbar_width( value ); break;
            }
    ALIAS:
        scrollbar_width = 1

#ifndef DISABLE_ASSOCIATIONFUNCTOR

=for apidoc Hx|||add|AssociationType|data

Add an association to a this widget. The associated data is of the given
association type. The associated data must not be NULL. NULL is simply not
added as association.

=cut

#include <fltk/WidgetAssociation.h>

void
fltk::Widget::add ( fltk::AssociationType ATYPE, SV * DATA = NO_INIT )
    CODE:
        THIS->add( ATYPE, (void *) DATA );

#endif // ifndef DISABLE_ASSOCIATIONFUNCTOR

=for apidoc ||bool ret|set|

Same as L<C<state(true)>|/"state">. If you know the widget will already be
redrawn, or it is not displayed, it is faster to call the inline
L<C<set_flag(STATE)>|/"set_flag"> function.

=for apidoc Hx|||set|AssociationType|data

Removes all associations of the given assiciation type from this widget and,
if data is not C<undef>, add the given data pointer as a new association.

The removed data is freed by calling the destroy method of the association
type.

=cut

#ifndef DISABLE_ASSOCIATIONFUNCTOR

bool
fltk::Widget::set ( fltk::AssociationType ATYPE = NO_INIT , SV * DATA = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->set( );
        OUTPUT:
            RETVAL
    CASE: items
            CODE:
                THIS->set( ATYPE, (void *) DATA )

#else  // ifndef DISABLE_ASSOCIATIONFUNCTOR

bool
fltk::Widget::set ( )
    OUTPUT:
        RETVAL

#endif // ifndef DISABLE_ASSOCIATIONFUNCTOR

#ifndef DISABLE_ASSOCIATIONFUNCTOR

=for apidoc Hx||data|get|AssociationType

Returns the first association of the given type that is connected with this
widget.

Returns C<undef> if none.

=cut

SV *
fltk::Widget::get( fltk::AssociationType ATYPE )
    CODE:
        RETVAL = THIS->get( ATYPE );
    OUTPUT:
        RETVAL

=for apidoc Hx||data|foreach|at|fkt

Call the functor for each piece of data of the give
L<AssociationType|FLTK::AssociationType>.

This is a wrapper for C<::foreach(&at, this, fkt)>.

=cut

SV *
fltk::Widget::foreach( fltk::AssociationType at, fltk::AssociationFunctor fkt )

=for apidoc Hx||bool ret|remove|at|data

Tries to remove one association from a widget, if it exists it is removed and
the function returns true, if such an association doesn't exist false is
returned and nothing is changed.

=for apidoc Hx||bool ret|find|at|data

Tries to find an association of this type with the given data if found the
function returns true, else false.

=cut

bool
fltk::Widget::remove( fltk::AssociationType at, SV * data )
    CODE:
        switch( ix ) {
            case 0: RETVAL = THIS->remove(at, (void *) data); break;
            case 1:   RETVAL = THIS->find(at, (void *) data); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
        find = 1

#endif // ifndef DISABLE_ASSOCIATIONFUNCTOR

    # Leave the documentation in FLTK/Widget.pod but...

=for apidoc et[when]||int when|WHEN_NEVER|



=for apidoc et[when]||int when|WHEN_CHANGED|



=for apidoc et[when]||int when|WHEN_RELEASE|



=for apidoc et[when]||int when|WHEN_RELEASE_ALWAYS|



=for apidoc et[when]||int when|WHEN_ENTER_KEY|



=for apidoc et[when]||int when|WHEN_ENTER_KEY_ALWAYS|



=for apidoc et[when]||int when|WHEN_ENTER_KEY_CHANGED|



=for apidoc et[when]||int when|WHEN_NOT_CHANGED|



=cut

BOOT:
    register_constant("WHEN_CHANGED", newSViv( fltk::WHEN_CHANGED ));
    export_tag( "WHEN_CHANGED", "when" );
    register_constant("WHEN_RELEASE", newSViv( fltk::WHEN_RELEASE ));
    export_tag( "WHEN_RELEASE", "when" );
    register_constant("WHEN_RELEASE_ALWAYS", newSViv( fltk::WHEN_RELEASE_ALWAYS ));
    export_tag( "WHEN_RELEASE_ALWAYS", "when" );
    register_constant("WHEN_ENTER_KEY", newSViv( fltk::WHEN_ENTER_KEY ));
    export_tag( "WHEN_ENTER_KEY", "when" );
    register_constant("WHEN_ENTER_KEY_ALWAYS", newSViv( fltk::WHEN_ENTER_KEY_ALWAYS ));
    export_tag( "WHEN_ENTER_KEY_ALWAYS", "when" );
    register_constant("WHEN_ENTER_KEY_CHANGED", newSViv( fltk::WHEN_ENTER_KEY_CHANGED ));
    export_tag( "WHEN_ENTER_KEY_CHANGED", "when" );
    register_constant("WHEN_NOT_CHANGED", newSViv( fltk::WHEN_NOT_CHANGED ));
    export_tag( "WHEN_NOT_CHANGED", "when" );














































=for apidoc |||relayout||

Same as L<C<relayout(LAYOUT_DAMAGE)>|/"relayout">, indicates that data inside
the widget may have changed, but the size did not change. This flag is also on
when the widget is initially created.

=for apidoc |||relayout|uchar flags|

Cause L<C<layout()>|/"layout"> to be called later. Turns on the specified
flags in L<C<layout_damage()>|/"layout_damage">, and turns on C<LAYOUT_CHILD>
in all parents of this widget. C<flags> cannot be zero, the maaning of the
flags is listed under F<fltk/layout.h>.

=cut

void
fltk::Widget::relayout( uchar flags = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->relayout( );
    CASE:
        C_ARGS: flags

=for apidoc ||uchar flags|layout_damage||

The 'or' of all the calls to L<C<relayout()>|/"relayout"> or
L<C<resize()>|/"resize"> done since the last time L<C<layout()>|/"layout"> was
called.

A typical layout function does not care about the widget moving, an easy way
to skip it is as follows:

    package MyWidget; # XXX - Untested
    { # ... ISA stuff, etc. ...
        sub layout {
            my ($self) = @_;
            return if !($self->layout_damage() & ~LAYOUT_XY);
            do_expensive_layout( );
            $self->redraw( );
        }
    }

=for apidoc |||layout_damage|uchar flag|

Directly change the value returned by L<C<layout_damage()>|/"layout_damage">.

=cut

uchar
fltk::Widget::layout_damage ( uchar flag = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->layout_damage( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->layout_damage( flag );

=for apidoc Et[damage]||int flag|DAMAGE_CHILD||

A child of this group widget needs to be redrawn (non-group widgets can use
this bit for their own purposes).

=for apidoc Et[damage]||int flag|DAMAGE_CHILD_LABEL||

An outside label of this widget needs to be redrawn. This is handled (and this
bit is cleared) by the parent group.

Because anti-aliasing cannot be redrawn atop itself, this is not
used anymore. Instead if an outside label needs to change the entire
parent widget is redrawn.

=for apidoc Et[damage]||int flag|DAMAGE_EXPOSE||

Damage caused by L<C<damage()>|/"damage"> or by expose events from the
operating system. If this and L<C<FLTK::DAMAGE_ALL>|/"DAMAGE_ALL"> is on the
widget should draw every pixel inside it's region.

=for apidoc Et[damage]||int flag|DAMAGE_ALL||

This bit is set by L<C<redraw()>|/"redraw"> and indicates that all of the
widget (but not "holes" where the background shows through) needs to be
redraw.

=for apidoc Et[damage]||int flag|DAMAGE_VALUE||

A widget may use this to indicate that the displayed value has changed.

=for apidoc Et[damage]||int flag|DAMAGE_PUSHED||

A widget may use this to indicate that the user has pushed or released a
button.

=for apidoc Et[damage]||int flag|DAMAGE_SCROLL||

A widget may use this to indicate that the displayed data has scrolled moved
horizontally and/or vertically.

=for apidoc Et[damage]||int flag|DAMAGE_OVERLAY||

Same value as L<C<FLTK::DAMAGE_SCROLL>|/"FLTK::DAMAGE_SCROLL">.

=for apidoc Et[damage]||int flag|DAMAGE_HIGHLIGHT||

A widget may use this to indicate that the mouse has entered/exited part of
the widget.

=for apidoc Et[damage]||int flag|DAMAGE_CONTENTS||

Same as L<C<FLTK::DAMAGE_EXPOSE>|/"DAMAGE_EXPOSE"> but if
L<C<FLTK::DAMAGE_ALL>|/"FLTK::DAMAGE_ALL"> is off a widget can use this for
it's own purposes.

=cut

#include <fltk/damage.h>

BOOT:
    register_constant("DAMAGE_CHILD", newSViv( fltk::DAMAGE_CHILD ));
    export_tag( "DAMAGE_CHILD", "damage" );
    register_constant("DAMAGE_CHILD_LABEL", newSViv( fltk::DAMAGE_CHILD_LABEL ));
    export_tag( "DAMAGE_CHILD_LABEL", "damage" );
    register_constant("DAMAGE_EXPOSE", newSViv( fltk::DAMAGE_EXPOSE ));
    export_tag( "DAMAGE_EXPOSE", "damage" );
    register_constant("DAMAGE_ALL", newSViv( fltk::DAMAGE_ALL ));
    export_tag( "DAMAGE_ALL", "damage" );
    register_constant("DAMAGE_VALUE", newSViv( fltk::DAMAGE_VALUE ));
    export_tag( "DAMAGE_VALUE", "damage" );
    register_constant("DAMAGE_SCROLL", newSViv( fltk::DAMAGE_SCROLL ));
    export_tag( "DAMAGE_SCROLL", "damage" );
    register_constant("DAMAGE_OVERLAY", newSViv( fltk::DAMAGE_OVERLAY ));
    export_tag( "DAMAGE_OVERLAY", "damage" );
    register_constant("DAMAGE_HIGHLIGHT", newSViv( fltk::DAMAGE_HIGHLIGHT ));
    export_tag( "DAMAGE_HIGHLIGHT", "damage" );
    register_constant("DAMAGE_HIGHLIGHT", newSViv( fltk::DAMAGE_HIGHLIGHT ));
    export_tag( "DAMAGE_HIGHLIGHT", "damage" );
    register_constant("DAMAGE_CONTENTS", newSViv( fltk::DAMAGE_CONTENTS ));
    export_tag( "DAMAGE_CONTENTS", "damage" );

=for apidoc ||uchar c|damage||

The 'or' of all the calls to L<C<redraw()>|/"redraw"> done since the last
L<C<draw()>|/"draw">. Cleared to zero after L<C<draw()>|/"draw"> is called.

=cut

uchar
fltk::Widget::damage( )
    OUTPUT:
        RETVAL

=for apidoc |||set_damage|uchar c|

Directly change the value returned by L<C<damage()>|/"damage">. Note that this
I<replaces> the value, it does not turn bits on. Use L<C<redraw()>|/"redraw">
to turn bits on.

=cut

void
fltk::Widget::set_damage( uchar c )

=for apidoc ||int return |send|int event|

Wrapper for L<C<handle()>|/"handle">. This should be called to send events. It
does a few things:

=over

=item It calculates L<C<event_x()>|FLTK::Widget/"event_x"> and
L<C<event_y()>|FLTK::Widget/"event_y"> to be relative to the widget. The
previous values are restored before this returns.

=item It makes sure the widget is active and/or visible if the event requres
this.

=item If this is not the L<C<FLTK::belowmouse()>|FLTK/"belowmouse"> widget
then it changes C<FLTK::MOVE> into C<FLTK::ENTER> and turns C<FLTK::DND_DRAG>
into C<FLTK::DND_ENTER>. If this I<is> the
L<C<FLTK::belowmouse()>|FLTK/"belowmouse"> widget then the opposite conversion
is done.

=item For move, focus, and push events if
L<C<handle()>|FLTK::Widget/"handle( event )"> returns true it sets the
L<C<FLTK::belowmouse()>|FLTK/"belowmouse"> or L<C<FLTK::focus()>|FLTK/"focus">
or L<C<FLTK::pushed()>|FLTK/"pushed"> widget to reflect this.

=back

=cut

int
fltk::Widget::send( int event )

=for apidoc |||add_timeout|float time|

Call L<C<handle(TIMEOUT)>|/"handle"> at the given time in the future. This
will happen exactly once. To make it happen repeatedly, call
L<C<repeat_timeout()>|/"repeat_timeout"> from inside
L<C<handle(TIMEOUT)>|/"handle">.

=for apidoc |||repeat_timeout|float time|

Call L<C<handle(TIMEOUT)>|/"handle"> at the given time interval since the last
timeout. This will produce much more accurate time intervals than
L<C<add_timeout>|/"add_timeout">.

=cut

void
fltk::Widget::add_timeout( float time )
    CODE:
        switch ( ix ) {
            case 0: THIS->add_timeout( time );    break;
            case 1: THIS->repeat_timeout( time ); break;
        }
    ALIAS:
        repeat_timeout = 1

=for apidoc |||remove_timeout||

Cancel any and all pending L<C<handle(TIMEOUT)>|/"handle"> callbacks.

=for apidoc |||deactivate||

If L<C<active()>|/"active"> is true, this turns it off. If
L<C<active_r()>|/"active_r"> was true L<C<send()>|/"send"> an
C<FLTK::DEACTIVATE> event.

=for apidoc |||show||

If L<C<visible()>|/"visible"> is false, turn it on. If
L<C<visible_r()>|/"visible_r"> is then true, L<C<send()>|/"send"> a
C<FLTK::SHOW> event.

=for apidoc |||hide||

If L<C<visible()>|/"visible"> is true, turn it off. If
L<C<visible_r()>|/"visible_r"> was true then L<C<send()>|/"send"> a
C<FLTK::HIDE> event, and L<C<redraw()>|/"redraw"> the parent if necessary.

=for apidoc |||setonly||

Calls L<C<set()>|/"set"> on this widget and calls L<C<clear()>|/"clear"> on
all adjacent widgets in the same parent L<Group|FLTK::Group> that have the
L<C<type()>|/"type"> set to C<RADIO>.

=for apidoc |||set_visible||

=for apidoc |||clear_visible||

=cut

void
fltk::Widget::remove_timeout( )
    CODE:
        switch( ix ) {
            case 0: THIS->remove_timeout( ); break;
            case 2: THIS->deactivate( );      break;
            case 3: THIS->show( );            break;
            case 4: THIS->hide( );            break;
            case 5: THIS->setonly( );         break;
            case 6: THIS->set_visible( );     break;
            case 7: THIS->clear_visible( );   break;
        }
    ALIAS:
           deactivate = 2
                 show = 3
                 hide = 4
              setonly = 5
          set_visible = 6
        clear_visible = 7

=for apidoc ||bool ret|copy_style|FLTK::Style * s|

Copy the L<Style|FLTK::Style> from another widget. Copying a style pointer
from another widget is not safe if that style is C<dynamic()> because it may
change or be deleted. This makes another C<dynamic()> copy if necessary. For
non-dynamic styles the pointer is copied.

=cut

bool
fltk::Widget::copy_style( fltk::Style * s )

=for apidoc ||FLTK::NamedStyle * style|default_style||

Get the style

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Widget::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

#INCLUDE: ccCellBox.xsi

#INCLUDE: ccHueBox.xsi

#INCLUDE: ccValueBox.xsi

#INCLUDE: ClockOutput.xsi

#INCLUDE: Group.xsi

#INCLUDE: ProgressBar.xsi

#INCLUDE: Valuator.xsi

#endif // ifndef DISABLE_WIDGET

BOOT:
    isa( "FLTK::Widget", "FLTK::Rectangle" );
