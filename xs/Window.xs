#include "include/FLTK_pm.h"

//#define DISABLE_WINDOW_ICON 1

MODULE = FLTK::Window               PACKAGE = FLTK::Window

#ifndef DISABLE_WINDOW

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Window - Where you put stuff

=head1 Description

This widget produces an actual window. This can either be a main window, with
a border and title and all the window management controls, or a "subwindow"
inside a window. This is controlled by whether or not the window has a
L<C<parent()>|FLTK::Widget/"parent">. Internally there are now significant
differences between "main" windows and "subwindows" and these really should be
different classes, they are the same for historic reasons.

Once you create a window, you usually add children Widgets to it by using
L<C<add(child)>|FLTK::Group/add> or by using L<C<begin()>|FLTK::Group/begin>
and then constructing the children. See L<C<FLTK::Group>|FLTK::Group> for more
information on how to add and remove children.

There are several subclasses of L<C<FLTK::Window>|FLTK::Window> that provide
double-buffering, overlay, menu, and OpenGL support.

The window's callback is done if the user tries to close a window using the
window manager and L<C<FLTK::modal()>|FLTK/"modal"> is zero or equal to the
window. Window has a default callback that calls
L<C<hide()>|FLTK::Widget/"hide"> and calls L<C<exit(0)>|FLTK/"exit"> if this
is the last top-level window.

You can set the L<C<shortcut()>|FLTK::Widget/"shortcut"> and then that key
will call the callback. If you don't change it then that key will close the
window.

=head1 Synopsis

=for markdown {%highlight perl linenos%}

  use FLTK;
  my $win = FLTK::Window->new(100, 100, 500, 800);
  $win->show();
  FLTK::run();

=for markdown {%endhighlight%}

=begin apidoc

=for apidoc ||FLTK::Window win|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::Window> object.

=for apidoc ||FLTK::Window * win|new|int w|int h|char * label = ''|

Same but window is placed by OS.

=cut

#include <fltk/Window.h>
#include "include/RectangleSubclass.h"
#ifdef WIN32 // the following is needed for the window icon (WIN32 only)
#ifndef DISABLE_WINDOW_ICON
#include <windows.h>
#include <fltk/x.h>
#endif // #ifndef DISABLE_WINDOW_ICON
#endif // ifdef WIN32

fltk::Window *
fltk::Window::new( ... )
    CASE: ( items == 3 || items == 4 )
        CODE:
            char * label = PL_origfilename;
            int w = (int)SvIV(ST(1));
            int h = (int)SvIV(ST(2));
            if (items == 4) label = (char *)SvPV_nolen(ST(3));
            RETVAL = new RectangleSubclass<fltk::Window>(CLASS,w,h,label);
        OUTPUT:
            RETVAL
    CASE: (items == 5 || items == 6)
        CODE:
            char * label = PL_origfilename;
            int x = (int)SvIV(ST(1));
            int y = (int)SvIV(ST(2));
            int w = (int)SvIV(ST(3));
            int h = (int)SvIV(ST(4));
            if (items == 6) label = (char *)SvPV_nolen(ST(5));
            RETVAL = new RectangleSubclass<fltk::Window>(CLASS,x,y,w,h,label);
        OUTPUT:
            RETVAL
    POSTCALL:
        if (RETVAL != NULL) {
#ifdef WIN32
#ifndef DISABLE_WINDOW_ICON
            RETVAL->icon((char *)LoadIcon (dllInstance( ), "FLTK" ));
#endif // #ifndef DISABLE_WINDOW_ICON
#endif // ifdef WIN32
        }

=for apidoc |||border|bool set|

If C<set> is a true value, then a window border will be set, otherwise the
window will have neither border nor caption.

=for apidoc ||bool set|border||



=cut

bool
fltk::Window::border( bool set = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->border( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->border( set );

=for apidoc |||borders|FLTK::Rectangle rect|

C<$rect> is set to the the size of the borders that will be added around this
window. This is done by querying the window system. Because it is more
convienent for most code the result is actually the rectangle that would be
around the border if this window was zero in size and placed at C<0,0>. C<x,y>
are typically negative and C<w,h> are typically positive. To get the actual
rectangle around your window, add these values to the window's size.

=cut

void
fltk::Window::borders( fltk::Rectangle * rect )

=for apidoc |||child_of|FLTK::Window parent|

Tell the system that this window will not have an icon, it will dissappear and
reappear when C<parent> is iconized or shown, and it is forced to always be
above C<parent>. On X this is called a "Transient window", and Windows calls
this a "overlapping child". C<parent> is different than the
L<C<parent()>|FLTK::Widget/"parent">, which must be zero.

Changing this value causes L<C<DESTROY()>|/"DESTROY"> to be called, due to
stupid limitations in X and Windows.

Win32 and some X window managers have an annoying bug where calling
L<C<show()>|/"show"> on this will also raise the parent window to right below
this, making many useful user interface designs impossible!

If you want a dialog that blocks interaction with the other windows of your
application or with all other applications, you need to look at
L<C<exec()>|/"exec"> (or possibly L<C<FLTK::modal()>|FLTK/"modal">).

=cut

=for apidoc |||show_inside|FLTK::Window parent|

Make the window with a normal system border and behavior, but place it inside
the C<parent> as though that was the desktop. This is what Windows calls
"MDI". Typically the other window (which must already be shown) is a child
window so that space can remain around it for a menu/tool bar.

Notice that L<C<parent()>|FLTK::Widget/"parent"> of the window must be zero
and it will remain zero after this is called. Fltk uses a zero parent to
indicate that the system is managing the window.

On systems that don't support nested desktops (i.e. X) this does
L<C<child_of(parent)>|/"child_of"> and L<C<show()>|/"show">, which produces an
overlapping window that will remain above the frame window.

=cut

void
fltk::Window::child_of( const fltk::Window * parent )
    ALIAS:
        show_inside = 1
    CODE:
        switch ( ix )  {
            case 0: THIS->child_of( parent );    break;
            case 1: THIS->show_inside( parent ); break;
        }

=for apidoc |||clear_double_border||

Turn off double buffering, so that drawing directly goes to the visible image
on the screen. Not all systems can do this, they will remain double buffered
even if this is off.

=cut

void
fltk::Window::clear_double_buffer( )

=for apidoc |||erase_overlay||

Indicate that the overlay drawn with L<C<draw_overlay()>|/"draw_overlay"> is
blank. L<C<draw_overlay()>|/"draw_overlay"> will not be called until
L<C<redraw_overlay()>|/"redraw_overlay"> is called again.

=cut

void
fltk::Window::erase_overlay( )

=for apidoc |||free_backbuffer||

Get rid of extra storage created by drawing when
L<C<double_buffer()>|/"double_buffer"> was turned on.

=cut

void
fltk::Window::free_backbuffer( )

=for apidoc |||iconize||

Iconifies the window. If you call this when L<C<shown()>|/"shown"> is false it
will L<C<show()>|/"show"> it as an icon. If the window is already iconified
this does nothing.

Call L<C<show()>|/"show"> to restore the window.

Currently there are only X and Win32 system-specific ways to control what is
drawn in the icon. You should not rely on window managers displaying the
icons.

=cut

void
fltk::Window::iconize( )

=for apidoc |||redraw_overlay||

Indicate that the image made by L<C<draw_overlay()>|/"draw_overlay"> has
changed and must be drawn or redrawn. If the image is blank you should call
L<C<erase_overlay()>|/"erase_overlay">.

This does nothing if the window is not L<C<shown()>|/"shown">, it is assummed
that overlays are only drawn in response to user input.

=cut

void
fltk::Window::redraw_overlay( )

=for apidoc |||set_double_buffer||

If the window is double-buffered, all drawing is done first to some offscreen
image, and then copied to the screen as a single block. This eliminates
blinking as the window is updated, and often the application looks faster,
even if it actually is slower.

=cut

void
fltk::Window::set_double_buffer( )

=for apidoc |||system_layout||

Resizes the actual system window to match the current size of the fltk widget.
You should call this in your C<layout()> method if xywh have changed. The
L<C<layout_damage()>|FLTK::Widget/"layout_damage"> flags must be on or it
won't work.

=cut

void
fltk::Window::system_layout( )


=for apidoc ||bool db_set|double_buffer||

Returns a true value if L<C<set_double_buffer()>|/"set_double_buffer"> was
called, returns a false value if
L<C<clear_double_buffer()>|/"clear_double_buffer"> was called. If neither has
been called, this returns a machine-dependant state (systems where double
buffering is efficient turn it on by default).

=cut

bool
fltk::Window::double_buffer( )

=for apidoc ||FLTK::Window * window|drawing_window||

Returns the L<Window|FLTK::Window> currently being drawn into. To set this use
L<C<make_current()>|FLTK::Widget/"make_current">. It will already be set when
C<draw()> is called.

=cut

const fltk::Window *
fltk::Window::drawing_window( )

=for apidoc ||bool return|exec|FLTK::Window parent = 0|bool grab = 0|

The window is popped up and this function does not return until
L<C<make_exec_return()>|/"make_exec_return"> is called, or the window is
destroyed or L<C<hide()>|FLTK::Widget/"hide"> is called, or
L<C<FLTK::exit_modal()>|FLTK/"exit_modal"> is called. During this time events
to other windows in this application are either thrown away or redirected to
this window.

This does L<C<child_of(parent)>|/"child_of"> (using first() if parent is
undefined), so this window is a floating panel that is kept above the parent.
It then uses L<C<FLTK::modal(this,grab)>|FLTK/"modal"> to make all events go
to this window.

The return value is the argument to
L<C<make_exec_return()>|/"make_exec_return">, or a false value if any other
method is used to exit the loop.

If C<parent> is undefined, the window that last received an event is used as
the parent. This is convenient for popups that appear in response to a mouse
or key click.

See L<C<FLTK::modal()>|FLTK/"modal"> for what grab does. This is useful for
popup menus.

=cut

bool
fltk::Window::exec( const fltk::Window * parent = 0, bool grab = 0 )

=for apidoc |||fullscreen|FLTK::Monitor monitor

Make the window completely fill the monitor, without any window manager border
or taskbar or anything else visible. Use
L<C<fullscreen_off()>|/"fullscreen_off"> to undo this.

Known bugs:

=over

=item *

Older versions of both Linux and Windows will refuse to hide the taskbar.
Proposed solutions for this tend to have detrimental effects, such as making
it impossible to switch tasks or to put another window atop this one. It
appears that newer versions of both Linux and Windows work correctly, so we
will not fix this.

=item *

Many older X window managers will refuse to position the window correctly and
instead place them so the top-left of the border in the screen corner. You may
be able to fix this by calling L<C<hide()>|FLTK::Widget/"hide"> first, then
L<C<fullscreen()>|/"fullscreen">, then L<C<show()>|/"show">. We don't do this
because it causes newer window systems to blink unnecessarily.

=item *

Some X window managers will raise the window when you change the size.

=item *

Calling L<C<resize()>|FLTK::Widget/"resize"> before calling
L<C<fullscreen_off()>|/"fullscreen_off"> will result in unpredictable effects,
and should be avoided.

=back

=cut

=for apidoc |||fullscreen||

Chooses the L<Monitor|FLTK::Monitor> that the center of the window is on to be
the one to resize to.

=cut


#include <fltk/Monitor.h>

void
fltk::Window::fullscreen( monitor = 0 )
    CASE: items == 1
        int monitor;
        CODE:
            THIS->fullscreen( );
    CASE: items == 2
        const fltk::Monitor * monitor;
        CODE:
           THIS->fullscreen( *monitor );

=for apidoc |||fullscreen_off|int x|int y|int w|int h|

Turns off any side effects of L<C<fullscreen()>|/"fullscreen">, then does
C<resize($x,$y,$w,$h)>.

=cut

=for apidoc |||resize|int x|int y|int w|int h|

Change the size and position of the window. If L<C<shown()>|/"shown"> is true,
these changes are communicated to the window server (which may refuse that
size and cause a further resize). If L<C<shown()>|/"shown"> is false, the size
and position are used when L<C<show()>|/"show"> is called. See
L<FLTK::Group|FLTK::Group> for the effect of resizing on the child widgets.

The special value C<FLTK::USEDEFAULT> may be used for C<X> and C<Y> indicate
that the system should choose the window's position. This will only work
before L<C<show()>|/"show"> is called.

=cut

void
fltk::Window::fullscreen_off ( int X, int Y, int Width, int Height )
    ALIAS:
        resize = 1
    CODE:
        switch( ix ) {
            case 0: THIS->fullscreen_off( X, Y, Width, Height ); break;
            case 1:         THIS->resize( X, Y, Width, Height ); break;
        }

=for apidoc |||hotspot|FLTK::Widget widget|bool offscreen = 0

L<C<position()>|FLTK::Widget/"position"> the window so that the mouse is
pointing at the center of the widget, which may be the window itself. If
C<offscreen> is a true value, the window is allowed to extend off the
L<Monitor|FLTK::Monitor> (some X window managers do not allow this).

=cut

=for apidoc |||hotspot|int CX|int CY|bool offscreen = 0

L<C<position()>|FLTK::Widget/"position"> the window so that the mouse is
pointing at the C<cx,cy> position. If C<offscreen> is a true value, the window
is allowed to extend off the L<Monitor|FLTK::Monitor> (some X window managers
do not allow this.

=cut

void
fltk::Window::hotspot ( A, B = false, C = false )
    CASE: items <= 2 && sv_isobject(ST(1)) && sv_derived_from(ST(1), "FLTK::Widget")
        fltk::Widget * A
        bool B;
        C_ARGS: (const fltk::Widget *) A, B
    CASE:
        int A;
        int B;
        bool C;
        C_ARGS: A, B, C

=for apidoc ||bool is_it|iconic||

Returns a true value if the window is currently displayed as an icon. Returns
a false value if the window is not L<C<shown()>|/"shown"> or
L<C<hide()>|FLTK::Widget/"hide"> has been called.

I<On X this will return true in the time between when L<C<show()>|/"show"> is
called and when the window manager finally puts the window on the screen and
causes an expose event.>

Returns true if the window is L<C<shown>|/"shown"> but is
L<C<iconized>|/"iconize">.

=cut

=for apidoc ||bool was_it|shown||

Returns non-zero if L<C<show()>|/"show"> has been called, but C<DESTROY()> has
not been called. Note that this returns true if L<C<hide()>|/"hide"> was
called or if the user has iconized the window.

=cut

bool
fltk::Window::iconic( )
    ALIAS:
        shown = 1
    CODE:
        switch (ix) {
            case 0: RETVAL = THIS->iconic(); break;
            case 1: RETVAL = THIS->shown();  break;
        }
    OUTPUT:
        RETVAL

=for apidoc |||iconlabel|char * iname|

Sets the text displayed below the icon (or in the taskbar). If you don't set
this it defaults to the L<C<label()>|/"label"> but if that appears to be a
filename, it defaults to the last portion after the last C</> character.

=for apidoc ||char * label|iconlable||

=cut

const char *
fltk::Window::iconlabel( char * iname = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->iconlabel();
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->iconlabel( iname );

=for apidoc |||label|char * name|char * iname|

Sets both the L<C<label()>|/"label"> and the L<C<iconlabel()>|/"iconlabel">.

=cut

=for apidoc |||label|char * name|

Sets the window title, which is drawn in the titlebar by the system.

=for apidoc ||char * title|label||

Returns the window title.

=cut

const char *
fltk::Window::label( char * name = NO_INIT, char * iname = 0 )
    CASE: items == 1
        CODE:
            RETVAL = THIS->label();
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->label( name );
    CASE: items == 3
        CODE:
            THIS->label( name, iname );

=for apidoc |||make_exec_return|bool return_value|

If L<C<exec()>|/"exec"> is currently being called, make it hide this window
and return C<return_value>.

Does nothing if L<C<exec()>|/"exec"> is not being called.

Results are undefined if the innermost L<C<exec()>|/"exec"> is being called on
a window other than this one. Current behavior is to cause that exec to return
false.

=cut

void
fltk::Window::make_exec_return ( bool return_value )

=for apidoc |||show|FLTK::Window parent|

Same as C<child_of(parent); show()>.

=cut

=for apidoc |||show|int argc|AV * argv|

This must be called after L<C<FLTK::args($argc,@argv)>|FLTK/"args"> to show
the "main" window, this indicates which window should be affected by any
C<-geometry> switches. In addition if L<C<FLTK::args()>|FLTK/"args"> has not
been called yet this does so, this is a useful shortcut for the main window in
a small program.

=cut

=for apidoc |||show||

Cause the window to become visible. It is harmless to call this multiple
times.

For subwindows (with a L<C<parent()>|FLTK::Widget/"parent">) this just causes
the window to appear. Currently no guarantee about stacking order is made.

For a outer window (one with no L<C<parent()>|FLTK::Widget/"parent">) this
causes the window to appear on the screen, be de-iconized, and be raised to
the top. Depending on L<C<child_of()>|/"child_of"> settings of this window and
of windows pointing to it, and on system and window manager settings, this may
cause other windows to also be deiconized and raised, or if this window is a
L<C<child_of()>|/"child_of"> then this window may remain iconized.

I<L<C<Window::show()>|/"show"> is not a virtual override of
L<C<Widget::show()>|FLTK::Widget/"show">.> You can call either one. The only
difference is that if an outer window has had L<C<show()>|/"show"> called
already, L<C<Window::show()>|/"show"> will raise and deiconize it, while
L<C<Widget::show()>|FLTK::Widget/"show"> will only
un-L<hide()|FLTK::Widget/"hide"> it, making it appear in the same stacking
order as before but not changing the iconization state (on some X window
managers it will deiconize anyway).

The first time this is called is when the actual "system" window (ie the X
window) is created. Before that an fltk window is simply an internal data
structure and is not visible outside your program. To return to the
non-system-window state call C<DESTROY()>. L<C<hide()>|FLTK::Widget/"hide">
will "unmap" the system window.

The first time L<C<show()>|/"show"> is called on any window is when fltk will
call L<C<FLTK::open_display()>|FLTK/"open_display"> and
L<C<FLTK::load_theme()>|FLTK/"load_theme">, unless you have already called
them. This allows these expensive operations to be deferred as long as
possible, and allows fltk programs to be written that will run without an X
server as long as they don't actually show a window.

=cut

void
fltk::Window::show( arga = NO_INIT, argb = NO_INIT )
    CASE: items == 1
        CODE:
            THIS->show( );
    CASE: items == 3 && SvROK(ST(2)) && SvTYPE(SvRV(ST(2))) == SVt_PVAV
        int arga
        AV * argb
        CODE:
            char ** _argb = new char * [ av_len( argb ) ];
            for ( int n = 0; n < av_len( argb ); n++ ) {
                SV ** item  = av_fetch(argb, n, 0);
                if ( item && SvOK( * item ) )
                    _argb[ n ] = (char *) SvPV_nolen( * item );
            }
            _argb[ av_len( argb ) ] = 0;
            THIS->show(arga, _argb );
    CASE: items == 2
        fltk::Window * arga
        CODE:
            THIS->show((const fltk::Window *) arga);

=for apidoc |||size_range|int minW|int minH|int maxW = 0|int maxH = 0|int dw = 0|int dh = 0

Set the allowable range the user can resize this window to. This only works
for top-level windows.

=over

=item C<$minW> and C<$minH> are the smallest the window can be.

=item C<$maxW> and C<$maxH> are the largest the window can be. If either is
equal to the minimum then you cannot resize in that direction. If either is
zero then FLTK picks a maximum size in that direction such that the window
will fill the screen.

=item C<$dw> and C<$dh> are size increments. The window will be constrained to
widths of C<$minW + N * $dw>, where C<N> is any non-negative integer. If these
are less or equal to 1 they are ignored. (this is ignored on WIN32)

=back

It is undefined what happens if the current size does not fit in the
constraints passed to L<C<size_range()>|/"size_range">.

If this function is not called, FLTK tries to figure out the range from the
setting of C<resizeable()>:

=over

=item If L<C<resizeable()>|/"resizable"> is undefined (this is the default),
then the window cannot be resized.

=item If either dimension of L<C<resizeable()>|/"resizable"> is less than
C<100>, then that is considered the minimum size. Otherwise the
L<C<resizeable()>|/"resizable"> has a minimum size of C<100>.

=item If either dimension of L<C<resizeable()>|/"resizable"> is zero, then
that is also the maximum size (so the window cannot resize in that direction).

=back

=cut

void
fltk::Window::size_range ( int minW, int minH, int maxW = 0, int maxH = 0, int dw = 0, int dh = 0 )

=for apidoc ||FLTK::NamedStyle * style|default_style|

By default a window has box() set to C<FLAT_BOX>, and the color() set to
C<GRAY75>, which is a special color cell that is altered by
L<C<FLTK::set_background()>|FLTK/"set_background">.

If you plan to turn the L<C<border()>|/"border"> off you may want to change
the box() to C<UP_BOX>. You can also produce something that looks like an
arbitrary shape (though really it is showing the original screen contents in
the "outside" area, so the window had better be temporary and the user cannot
move it) by setting the box() to NO_BOX and making draw() only draw the opaque
part.

=for apidoc |||default_style|FLTK::NamedStyle * style|

Set the style.

=cut

fltk::NamedStyle *
fltk::Window::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=for apidoc F||FLTK::Window win|first||

Returns the id of some L<C<visible()>|/"visible"> window. If there is more
than one, the last one to receive an event is returned. This is useful as a
default value for L<C<FLTK::Window::child_of()>|FLTK::Window/"child_of">.
L<C<FLTK::Window::exec()>|FLTK::Window/"exec"> uses it for this if no other
parent is specified. This is also used by L<C<FLTK::run()>|FLTK/"run"> to see
if any windows still exist.

=for apidoc F|||first|FLTK::Window window|

If this C<window> is visible, this removes it from wherever it is in the list
and inserts it at the top, as though it received an event. This can be used to
change the parent of dialog boxes run by
L<C<FLTK::Window::exec()>|FLTK::Window/"exec"> or
L<C<FLTK::ask()>|FLTK/"ask">.

=cut

fltk::Window *
first( fltk::Window * window = NO_INIT )
    PROTOTYPE: DISABLE
    CODE:
        if( items == 0 )
            RETVAL = fltk::Window::first( );
        else
            fltk::Window::first( window );

=for apidoc ||FLTK::Window win|next||

Returns the next L<C<visible()>|/"visible"> top-level window, returns C<undef>
after the last one. You can use this and L<C<first()>|FLTK::Window/"first"> to
iterate through all the visible windows.

=cut

fltk::Window *
fltk::Window::next( )

=for apidoc x|W||icon|char * path|

This loads an icon (F<.ico>) in the window.

=cut

void
fltk::Window::icon( char * path )
    CODE:
#ifdef WIN32
#ifndef DISABLE_WINDOW_ICON
        fltk::CreatedWindow * x = fltk::CreatedWindow::find((fltk::Window *) THIS);
        if (x == NULL)
            return;
        HICON s_icon = (HICON)LoadImage(NULL, path, IMAGE_ICON, 16, 16, LR_LOADFROMFILE|LR_DEFAULTCOLOR|LR_SHARED);
        HICON b_icon = (HICON)LoadImage(NULL, path, IMAGE_ICON, 32, 32, LR_LOADFROMFILE|LR_DEFAULTCOLOR|LR_SHARED);
        if (b_icon == NULL)
            b_icon = s_icon;
        if( b_icon )
            SendMessage( x->xid, WM_SETICON, ICON_BIG, (LPARAM) b_icon);
        if ( s_icon )
            SendMessage( x->xid, WM_SETICON, ICON_SMALL, (LPARAM)s_icon);
#endif // #ifndef DISABLE_WINDOW_ICON
#else
        warn("Loading icons on non-Win32 systems is on my TODO list");
#endif // #ifdef WIN32

=for apidoc xH|W||_icon_resource_example|char * iconID

This loads an icon in the window by name from a resource file. (Currently only
supports (w)perl.exe itself.)

=cut

void
fltk::Window::_icon_resource_example( char * iconID )
    CODE:
#ifdef WIN32
#ifndef DISABLE_WINDOW_ICON
        HICON b_icon = (HICON)LoadImage(fltk::xdisplay, iconID, IMAGE_ICON, 32, 32, LR_DEFAULTCOLOR|LR_SHARED );
        HICON s_icon = (HICON)LoadImage(fltk::xdisplay, iconID, IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR|LR_SHARED );
        HICON t_icon  =       LoadIcon (fltk::xdisplay, iconID);
        if (!t_icon)
            t_icon  = LoadIcon (fltk::xdisplay, iconID );
        //warn ("A b_icon is %s", ( b_icon == NULL? "borked": "okay"));
        //warn ("B s_icon is %s", ( s_icon == NULL? "borked": "okay"));
        //warn ("C t_icon is %s", ( t_icon == NULL? "borked": "okay"));
        //warn ("%s | %s", fltk::xdisplay, GetModuleHandle(0));
        fltk::CreatedWindow* x = fltk::CreatedWindow::find(THIS);

        if ( ! ( x && fltk::xdisplay ) )
            return;
        if ( b_icon )
            SendMessage( x->xid, WM_SETICON, ICON_BIG, (LPARAM) b_icon);
        if ( s_icon )
            SendMessage( x->xid, WM_SETICON, ICON_SMALL, (LPARAM)s_icon);
#endif // #ifndef DISABLE_WINDOW_ICON
#endif // #ifdef WIN32

#INCLUDE: GlWindow.xsi

#INCLUDE: MenuWindow.xsi

#INCLUDE: ShapedWindow.xsi

#endif // ifndef DISABLE_WINDOW

BOOT:
    isa("FLTK::Window", "FLTK::Group");
