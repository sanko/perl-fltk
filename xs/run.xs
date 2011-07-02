#include "include/FLTK_pm.h"

#ifndef PerlIO
#define PerlIO_fileno(f) fileno(f)
#endif
#ifndef _WIN32
#define _get_osfhandle(f) f // converts perl fd into a winsock fd on win32
#endif

MODULE = FLTK::run               PACKAGE = FLTK::run

#ifndef DISABLE_RUN

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532007

=for git $Id$

=head1 NAME

FLTK::run - Basic activity functions for the Fast Light Toolkit

=head1 Description



=cut

#include <fltk/run.h>

=begin apidoc

=for apidoc FT[run]|X||display|char * d|

Startup method to set what C<X> display to use. This uses C<setenv()> to
change the C<DISPLAY> environment variable, so it will affect programs that
are exec'd by this one.

This does some "uglification" required by C<X>. If there is no colon in the
string it appends ":0.0" to it. Thus a plain machine name may be used.

On non-C<X> systems this sets the environment variable anyway, even though it
probably will not affect the display used. It appears that putenv is missing
on some versions of Windows so I commented it all out there, sigh.

=for hackers Found in F<fltk/setdisplay.cxx>

=cut

MODULE = FLTK::run               PACKAGE = FLTK

void
display ( char * d )
    CODE:
        fltk::display( d );

BOOT:
    export_tag("display", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[run]||bool okay|enable_tablet_events||

Call this to indicate that you are interested in getting more information from
a pen tablet device. It does some necessary overhead to enable tablets on C<X>
and Windows. In the future FLTK may do this automatically without you calling
this.

If a tablet is detected, L<C<FLTK::event_pressure()>|/"event_pressure"> will
return the pen pressure as a float value between C<0> and C<1>. Some tablets
also support L<C<event_x_tilt()>|/"event_x_tilt"> and
L<C<event_y_tilt()>|/"event_y_tilt">.

=cut

MODULE = FLTK::run               PACKAGE = FLTK

bool
enable_tablet_events( )
    CODE:
        RETVAL = fltk::enable_tablet_events( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("enable_tablet_events", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[run]||int events|wait||

Same as L<C<FLTK::wait(infinity)>|/"wait">. Call this repeatedly to "run" your
program. You can also check what happened each time after this returns, which
is quite useful for managing program state.

=for apidoc FT[run]||int events|wait|int time_to_wait|

Waits until "something happens", or the given time interval passes. It can
return much sooner than the time if something happens.

What this really does is call all idle callbacks, all elapsed timeouts, call
L<C<FLTK::flush()>|/"flush"> to get the screen to update, and then wait some
time (zero if there are idle callbacks, the shortest of all pending timeouts,
or the given time), for any events from the user or any
L<C<FLTK::add_fd()>|/"add_fd"> callbacks. It then handles the events and calls
the callbacks and then returns.

The return value is zero if nothing happened before the passed C<time_to_wait>
expired. It is non-zero if any events or timeouts came in.

=cut

MODULE = FLTK::run               PACKAGE = FLTK

int
wait ( double time_to_wait = NO_INIT )
    CODE:
        if ( items == 0 )
            RETVAL = fltk::wait( );
        else
            RETVAL = fltk::wait( time_to_wait );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("wait", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[run,default]||int return|run|

Calls L<C<FLTK::wait()>|/"wait"> as long as any windows are not closed. When
all the windows are hidden or destroyed (checked by seeing if
L<C<FLTK::Window::first()>|FLTK::Window/"first"> is undef) this will return with
zero. A program can also exit by having a callback call C<exit>.

Most FLTK programs will end with C<exit FLTK::run();>.

=for apidoc FT[run]||int return|check|

Same as  L<C<FLTK::wait(0)>|/"wait">. Calling this during a big calculation
will keep the screen up to date and the interface responsive:

    while (!calculation_done()) {
        calculate();
        FLTK::check();
        last if user_hit_abort_button();
    }

=for apidoc FT[run]||int actions|ready||

Test to see if any events or callbacks are pending. This will return true if
L<C<FLTK::check()>|/"check"> would do anything other than update the screen.
Since this will not draw anything or call any code, it is safe to call this if
your program is in an inconsistent state. This is also useful if your
calculation is updating widgets but you do not want or need the overhead of
the screen updating every time you check for events.

    while (!calculation_done()) {
        calculate();
        if (FLTK::ready()) {
            do_expensive_cleanup();
            FLTK::check();
            last if user_hit_abort_button();
        }
    }

=cut

MODULE = FLTK::run               PACKAGE = FLTK

int
run ( )
    CODE:
        RETVAL = fltk::run( );
    OUTPUT:
        RETVAL

int
check ( )
    CODE:
        RETVAL = fltk::check( );
    OUTPUT:
        RETVAL

int
ready ( )
    CODE:
        RETVAL = fltk::ready( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("run",   "run");
    export_tag("run",   "default");
    export_tag("check", "run");
    export_tag("ready", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[run]|||redraw||

Redraws all widgets. This is a good idea if you have made global changes to
the styles.

=for apidoc FT[run]|||flush||

Get the display up to date. This is done by calling L<C<layout()>|/"layout">
on all Window objects with L<C<layout_damage()>|/"layout_damage"> and then
calling L<C<draw()>|/"draw"> on all Window objects with
L<C<damage()>|/"damage">. (actually it calls
L<C<FLTK::Window::flush()>|FLTK::Window/"flush"> and that calls
L<C<draw()>|/"draw">, but normally you can ignore this). This will also flush
the C<X> i/o buffer, update the cursor shape, update Windows' window sizes,
and other operations to get the display up to date.

L<C<wait()>|/"wait"> calls this before it waits for events.

=cut

MODULE = FLTK::run               PACKAGE = FLTK

void
redraw( )
    CODE:
        fltk::redraw( );

void
flush( )
    CODE:
        fltk::flush( );

BOOT:
    export_tag("redraw", "run");
    export_tag("flush", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc F||int needs_redraw|damage||

True if any L<C<FLTK::Widget::redraw()>|FLTK::Widget/"redraw"> calls have been
done since the last L<C<FLTK::flush()>|FLTK/"flush">. This indicates that
L<C<flush()>|FLTK/"flush"> will do something. Currently the meaning of any
bits are undefined.

Window L<C<flush()>|FLTK/"flush"> routines can set this to indicate that
L<C<flush()>|FLTK/"flush"> should be called again after waiting for more
events. This is useful in some instances such as X windows that are waiting
for a mapping event before being drawn.

=for apidoc FT[run]|||damage|int d|

Sets L<C<damage()>|/"damage"> to C<d>.

=cut

MODULE = FLTK::run               PACKAGE = FLTK

int
damage( int d = NO_INIT )
    CASE: items == 0
        CODE:
            fltk::damage ( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            fltk::damage( d );

BOOT:
    export_tag("damage", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[run]||int time|get_time_secs||

Return portable time that increases by C<1.0> each second.

On Windows it represents the time since system start, on Unixes, it's the
C<gettimeofday()>.

Using a double, the numerical precision exceeds C<1/1040000> even for the Unix
gettimeofday value (which is seconds since 1970). However you should only
store the C<difference> between these values in a float.

The precision of the returned value depends on the OS, but the minimum
precision is 20ms.

=cut

MODULE = FLTK::run               PACKAGE = FLTK

double
get_time_secs( )
    CODE:
        RETVAL = fltk::get_time_secs( );

BOOT:
    export_tag("get_time_secs", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[run]|||add_timeout|int time|CV * callback|SV * args|

Add a one-shot timeout callback. The function will be called by
L<C<fltk::wait()>|FLTK/"wait"> at C<time> seconds after this function is
called. The optional C<args> are passed to the callback.

=for apidoc FT[run]|||repeat_timeout|SV * timeout|

Similar to L<C<add_timeout()>|/"add_timeout">, but rather than the time being
measured from "now", it is measured from when the system call elapsed that
caused this timeout to be called. This will result in far more accurate
spacing of the timeout callbacks, it also has slightly less system call
overhead. (It will also use all your machine time if your timeout code and
fltk's overhead take more than t seconds, as the real timeout will be reduced
to zero).

Outside a timeout callback this acts like L<C<add_timeout()>|/"add_timeout">.

This code will print "TICK" each second on C<*STDOUT>, with a fair degree of
accuracy:

    my $ticker;
    $ticker = FLTK::add_timeout(
        1,
        sub {
            say('TICK');
            FLTK::repeat_timeout(1, $ticker);
        }
    );
    FLTK::wait() while 1;

=cut

MODULE = FLTK::run               PACKAGE = FLTK

SV *
add_timeout( double time, CV * callback, SV * args = NO_INIT )
    CODE:
        AV *seg_av;
        seg_av = newAV();
        av_push(seg_av, newSVsv(ST(1)));
        if ( items == 3 ) av_push(seg_av, newSVsv(args));
        RETVAL = sv_bless(newRV_noinc((SV *)seg_av), gv_stashpv("FLTK::timeout", 1));
        fltk::add_timeout( time, _cb_t, ( void * ) seg_av );
    OUTPUT:
        RETVAL

MODULE = FLTK::run               PACKAGE = FLTK::timeout

void
DESTROY( SV * timeout )
    CODE:
        if (fltk::has_timeout( _cb_t, ( void * ) SvRV(ST(0) )) )
            fltk::remove_timeout( _cb_t, ( void * ) SvRV(ST(0) ));

MODULE = FLTK::run               PACKAGE = FLTK

void
repeat_timeout( double time, SV * timeout )
    CODE:
        fltk::repeat_timeout( time, _cb_t, ( void * ) SvRV(ST(1) ));

BOOT:
    export_tag("add_timeout",    "run");
    export_tag("repeat_timeout", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FHxT[run]||bool exists|has_timeout|SV * timeout|

Returns true if the timeout exists and has not been called yet.

This doesn't work right now because I stuff perl's datatypes where I shouldn't
...I'll come back to it.

=for apidoc FHxT[run]||bool eh|has_check|CV * coderef|SV * args|

Return true if L<C<add_check()>|/"add_check"> has been done with this
C<coderef> and C<args>, and L<C<remove_check()>|/"remove_check"> has not been
done.

=for apidoc FHxT[run]||bool eh|has_idle|CV * coderef|SV * args|

Returns true if the specified idle callback is currently installed.

=cut

MODULE = FLTK::run               PACKAGE = FLTK

bool
has_timeout( SV * timeout )
    CODE:
         RETVAL = fltk::has_timeout( _cb_t, ( void * ) SvRV(ST(0) )) ? 1 : 0;
    OUTPUT:
        RETVAL

bool
has_check( SV * check )
    CODE:
         RETVAL = fltk::has_check( _cb_t, ( void * ) SvRV(ST(0) )) ? 1 : 0;
    OUTPUT:
        RETVAL

bool
has_idle( SV * idle )
    CODE:
         RETVAL = fltk::has_idle( _cb_t, ( void * ) SvRV(ST(0) )) ? 1 : 0;
    OUTPUT:
        RETVAL

BOOT:
    export_tag("has_timeout", "run");
    export_tag("has_check", "run");
    export_tag("has_idle", "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FHxT[run]|||remove_timeout|SV * timeout|

Removes all pending timeout callbacks that match the function and arg. Does
nothing if there are no matching ones that have not been called yet.

Like L<C<has_timeout>|/"has_timeout">, this doesn't work yet.

=for apidoc FT[run]|||add_check|CV * coderef|SV * args|

FLTK will call this callback just before it flushes the display and waits for
events. This is different than L<C<add_idle()>|/"add_idle"> because it is only
called once, then fltk calls the system and tells it not to return until an
event happens. If several checks have been added fltk calls them all, the most
recently added one first.

This can be used by code that wants to monitor the application's state, such
as to keep a display up to date. The advantage of using a check callback is
that it is called only when no events are pending. If events are coming in
quickly, whole blocks of them will be processed before this is called once.
This can save significant time and avoid the application falling behind the
events:

    my $state_changed;   # anything that changes the display turns this on
    sub check {
        return if !$state_changed;
        $state_changed = 0;
        do_expensive_calculation();
        $widget->redraw();
    }
    FLTK::add_check(\&check);
    FLTK::run();

=for apidoc FxHt[run]|||remove_check|CV * coderef|SV * args = NO_INIT|

Remove all matching check callback, if any exists. You can call this from
inside the check callback if you want.

=for apidoc FT[run]|||add_idle|CV * coderef|SV * args = NO_INIT|

Adds a callback function that is called every time by
L<C<FLTK::wait()>|FLTK/"wait"> and also makes it act as though the timeout is
zero (this makes L<C<FLTK::wait()>|FLTK/"wait"> return immediately, so if it
is in a loop it is called repeatedly, and thus the idle fucntion is called
repeatedly). The idle function can be used to get background processing done.

You can have multiple idle callbacks. They are called one after another in a
round-robin fashion, checking for events between each.

L<C<FLTK::wait()>|FLTK/"wait"> and L<C<FLTK::check()>|FLTK/"check"> call idle
callbacks, but L<C<FLTK::ready()>|FLTK/"ready"> does not.

The idle callback can call any FLTK functions, including
L<C<FLTK::wait()>|FLTK/"wait">, L<C<FLTK::check()>|FLTK/"check">, and
L<C<FLTK::ready()>|FLTK/"ready">. In this case fltk will not recursively call
the idle callback.

=for apidoc FT[run]|||remove_idle|CV * coderef|SV * args|

Removes the specified idle callback, if it is installed.

=end apidoc

=cut

MODULE = FLTK::run               PACKAGE = FLTK

void
remove_timeout( SV * timeout )
    CODE:
        if (fltk::has_timeout( _cb_t, ( void * ) SvRV(ST(0) )) )
            fltk::remove_timeout( _cb_t, ( void * ) SvRV(ST(0) ));
        sv_setsv(ST(0), &PL_sv_undef);

SV *
add_check( CV * callback, SV * args = NO_INIT )
    CODE:
        AV *seg_av;
        seg_av = newAV();
        av_push(seg_av, newSVsv(ST(0)));
        if ( items == 2 ) av_push(seg_av, newSVsv(args));
        RETVAL = sv_bless(newRV_noinc((SV *)seg_av), gv_stashpv("FLTK::check", 1));
        fltk::add_check( _cb_t, ( void * ) seg_av );
    OUTPUT:
        RETVAL

MODULE = FLTK::run               PACKAGE = FLTK::check

void
DESTROY( SV * check )
    CODE:
        if (fltk::has_check( _cb_t, ( void * ) SvRV(ST(0) )) )
            fltk::remove_check( _cb_t, ( void * ) SvRV(ST(0) ));

MODULE = FLTK::run               PACKAGE = FLTK

void
remove_check( SV * timeout )
    CODE:
        if (fltk::has_check( _cb_t, ( void * ) SvRV(ST(0) )) )
            fltk::remove_check( _cb_t, ( void * ) SvRV(ST(0) ));
        sv_setsv(ST(0), &PL_sv_undef);

SV *
add_idle( CV * callback, SV * args = NO_INIT )
    CODE:
        AV *seg_av;
        seg_av = newAV();
        av_push(seg_av, newSVsv(ST(0)));
        if ( items == 2 ) av_push(seg_av, newSVsv(args));
        RETVAL = sv_bless(newRV_noinc((SV *)seg_av), gv_stashpv("FLTK::idle", 1));
        fltk::add_idle( _cb_t, ( void * ) seg_av );
    OUTPUT:
        RETVAL

void
remove_idle( SV * idle )
    CODE:
        if (fltk::has_idle( _cb_t, ( void * ) SvRV(ST(0) )) )
            fltk::remove_idle( _cb_t, ( void * ) SvRV(ST(0) ));
        sv_setsv(ST(0), &PL_sv_undef);

MODULE = FLTK::run               PACKAGE = FLTK::idle

void
DESTROY( SV * idle )
    CODE:
        if (fltk::has_idle( _cb_t, ( void * ) SvRV(ST(0) )) )
            fltk::remove_idle( _cb_t, ( void * ) SvRV(ST(0) ));

MODULE = FLTK::run               PACKAGE = FLTK

BOOT:
    export_tag("remove_timeout", "run");
    export_tag("add_check",      "run");
    export_tag("remove_check",   "run");
    export_tag("add_idle",       "run");
    export_tag("remove_idle",    "run");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[fd]||SV * handle|add_fd|PerlIO * fh|int events|CV * callback|SV * args|

Adds a handle to the list watched by FLTK.

C<$events> may be any combination of the following:

=over

=item * C<FLTK::READ>: The callback is triggered whenever there is data to be
read.

Listening sockets trigger this when a new incoming connection is attempted.

=item * C<FLTK::WRITE>: The callback is triggered whenever the filehandle or
socket is ready to accept new data.

=item * C<FLTK::EXCEPT>: The callback is triggered whenever the filehandle or
socket is encounters an exception.

=back

...these constants are exported through the C<:fd> tag.

The callback is called with the filehandle as the first argument and any data
in C<args> as the second argument. It is called in response to user events,
but exactly when depends on the widget. For instance a button calls it when
the button is released.

B<NOTE>: To make use of callbacks, your perl must be recent enough to support
weak references.

=for apidoc FT[fd]||SV * handle|add_fd|int fileno|int events|CV * callback|SV * args|

Adds the handle (if it exists) with the particular fileno.

=cut

BOOT:
    register_constant("READ",   newSViv( fltk::READ   ));
    export_tag("READ", "fd");
    register_constant("WRITE",  newSViv( fltk::WRITE  ));
    export_tag("WRITE", "fd");
    register_constant("EXCEPT", newSViv( fltk::EXCEPT ));
    export_tag("EXCEPT", "fd");

MODULE = FLTK::run               PACKAGE = FLTK

bool
add_fd( fh, int events, CV * callback, SV * args = NO_INIT )
    CASE: SvIOK( ST(0) )
        int fh
        CODE:
            RETVAL = true;
            HV * cb = newHV( );
            hv_store( cb, "coderef", 7, newSVsv( ST( 2 ) ), 0 );
            if ( items == 4 ) /* Callbacks can be called without arguments */
                hv_store( cb, "args", 4, newSVsv( args ),   0 );
            hv_store( cb, "fileno", 6, newSViv( fh ),   0 );
            PerlIO * _fh;
            int fd = PerlLIO_dup( fh );
            /* XXX: user should check errno on undef returns */
            if (fd < 0)
                RETVAL = false;
            else if ( !( _fh = PerlIO_fdopen( fd, "rb" ) ) )
                RETVAL = false;
            else {
                //hv_store( cb, "fh",     2, newSVsv( (SV *) _fh ),  0 );
                fltk::add_fd(
                    _get_osfhandle( fh ), events, _cb_f, ( void * ) cb
                );
            }
        OUTPUT:
            RETVAL
    CASE:
        PerlIO * fh
        CODE:
            RETVAL = true;
            HV * cb = newHV( );
            hv_store( cb, "coderef", 7, newSVsv( ST( 2 ) ), 0 );
            if ( items == 4 ) /* Callbacks can be called without arguments */
                hv_store( cb, "args", 4, newSVsv( args ),  0 );
            int fileno = PerlIO_fileno( fh );
            hv_store( cb, "fileno", 6, newSViv( fileno ),  0 );
            //hv_store( cb, "fh",     2, newSVsv( (SV *) fh ),  0 );
            fltk::add_fd(
                _get_osfhandle( fileno ), events, _cb_f, ( void * ) cb
            );
        OUTPUT:
            RETVAL

BOOT:
    export_tag("add_fd", "fd");

MODULE = FLTK::run               PACKAGE = FLTK::run

=for apidoc FT[fd]||bool okay|remove_fd|PerlIO * fh|int when = -1|

Removes a handle from the list watched by FLTK.

The optional C<$when> argument may be any combination of the following:

=over

=item * C<FLTK::READ>: The callback is triggered whenever there is data to be
read.

Listening sockets trigger this when a new incoming connection is attempted.

=item * C<FLTK::WRITE>: The callback is triggered whenever the filehandle or
socket is ready to accept new data.

=item * C<FLTK::EXCEPT>: The callback is triggered whenever the filehandle or
socket is encounters an exception.

=back

...these constants are exported through the C<:fd> tag.

By default, the filehandle is removed completly which is the same as passing
C<-1>.

=for apidoc F||bool okay|remove_fd|int fileno|int when = -1|

Removes the handle (if it exists) with the particular fileno.

=cut

MODULE = FLTK::run               PACKAGE = FLTK

bool
remove_fd( fh, int when = -1 )
    CASE: SvIOK( ST(0) )
        int fh
        CODE:
            fltk::remove_fd( _get_osfhandle( fh ), when );
            RETVAL = 1;
        OUTPUT:
            RETVAL
    CASE:
        PerlIO * fh
        CODE:
            fltk::remove_fd( _get_osfhandle( PerlIO_fileno( fh ) ), when );
            RETVAL = 1;
        OUTPUT:
            RETVAL

BOOT:
    export_tag("remove_fd", "fd");

#endif // ifndef DISABLE_RUN
