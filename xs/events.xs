#include "include/FLTK_pm.h"

MODULE = FLTK::events               PACKAGE = FLTK::events

#ifndef DISABLE_EVENTS

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::events - Event types and data

=head1 Description

Event types and data. A L<C<Widget::handle()>|FLTK::Widget/"handle"> method
needs this.

=cut

#ifdef ENTER
#define PERL_ENTER ENTER
#undef ENTER
#endif // #ifdef ENTER

#ifdef LEAVE
#define PERL_LEAVE LEAVE
#undef LEAVE
#endif // #ifdef LEAVE

#include <fltk/events.h>

=head1 Events

FLTK's event system passes numbered arguments to
L<C<Widget::handle()>|FLTK::Subclass/handle> and returns the same from
L<C<event()>|FLTK::Widget/"event">. These events may be imported with the
C<events> tag and include the following:

=over

=item C<NO_EVENT>

=item C<PUSH>

=item C<RELEASE>

=item C<ENTER>

=item C<LEAVE>

=item C<DRAG>

=item C<FOCUS>

=item C<UNFOCUS>

=item C<KEY>

=item C<KEYUP>

=item C<FOCUS_CHANGE>

=item C<MOVE>

=item C<SHORTCUT>

=item C<DEACTIVATE>

=item C<ACTIVATE>

=item C<HIDE>

=item C<SHOW>

=item C<PASTE>

=item C<TIMEOUT>

=item C<MOUSEWHEEL>

=item C<DND_ENTER>

=item C<DND_DRAG>

=item C<DND_LEAVE>

=item C<DND_RELEASE>

=item C<TOOLTIP>

=back

If you're rolling your own event system (See
L<FLTK::Subclass|FLTK::Subclass>), you're gonna need these.

=cut

BOOT:
    register_constant( "NO_EVENT", newSViv( fltk::NO_EVENT ));
    export_tag("NO_EVENT", "events");
    register_constant( "PUSH", newSViv( fltk::PUSH ));
    export_tag("PUSH", "events");
    register_constant( "RELEASE", newSViv( fltk::RELEASE ));
    export_tag("RELEASE", "events");
    register_constant( "ENTER", newSViv( fltk::ENTER ));
    export_tag("ENTER", "events");
    register_constant( "LEAVE", newSViv( fltk::LEAVE ));
    export_tag("LEAVE", "events");
    register_constant( "DRAG", newSViv( fltk::DRAG ));
    export_tag("DRAG", "events");
    register_constant( "FOCUS", newSViv( fltk::FOCUS ));
    export_tag("FOCUS", "events");
    register_constant( "UNFOCUS", newSViv( fltk::UNFOCUS ));
    export_tag("UNFOCUS", "events");
    register_constant( "KEY", newSViv( fltk::KEY ));
    export_tag("KEY", "events");
    register_constant( "KEYUP", newSViv( fltk::KEYUP ));
    export_tag("KEYUP", "events");
    register_constant( "FOCUS_CHANGE", newSViv( fltk::FOCUS_CHANGE ));
    export_tag("FOCUS_CHANGE", "events");
    register_constant( "MOVE", newSViv( fltk::MOVE ));
    export_tag("MOVE", "events");
    register_constant( "SHORTCUT", newSViv( fltk::SHORTCUT ));
    export_tag("SHORTCUT", "events");
    register_constant( "DEACTIVATE", newSViv( fltk::DEACTIVATE ));
    export_tag("DEACTIVATE", "events");
    register_constant( "ACTIVATE", newSViv( fltk::ACTIVATE ));
    export_tag("ACTIVATE", "events");
    register_constant( "HIDE", newSViv( fltk::HIDE ));
    export_tag("HIDE", "events");
    register_constant( "SHOW", newSViv( fltk::SHOW ));
    export_tag("SHOW", "events");
    register_constant( "PASTE", newSViv( fltk::PASTE ));
    export_tag("PASTE", "events");
    register_constant( "TIMEOUT", newSViv( fltk::TIMEOUT ));
    export_tag("TIMEOUT", "events");
    register_constant( "MOUSEWHEEL", newSViv( fltk::MOUSEWHEEL ));
    export_tag("MOUSEWHEEL", "events");
    register_constant( "DND_ENTER", newSViv( fltk::DND_ENTER ));
    export_tag("DND_ENTER", "events");
    register_constant( "DND_DRAG", newSViv( fltk::DND_DRAG ));
    export_tag("DND_DRAG", "events");
    register_constant( "DND_LEAVE", newSViv( fltk::DND_LEAVE ));
    export_tag("DND_LEAVE", "events");
    register_constant( "DND_RELEASE", newSViv( fltk::DND_RELEASE ));
    export_tag("DND_RELEASE", "events");
    register_constant( "TOOLTIP", newSViv( fltk::TOOLTIP ));
    export_tag("TOOLTIP", "events");

=pod

=head1 Event Keys

Values returned by C<event_key()>, passed to C<event_key_state()> and
C<get_key_state()>, and used for the low 16 bits of C<add_shortcut()>.

The actual values returned are based on X11 keysym values, though fltk always
returns "unshifted" values much like Windows does. A given key always returns
the same value no matter what shift keys are held down. Use C<event_text()> to
see the results of any shift keys.

The lowercase letters 'a' through 'z' and the ascii symbols '`', '-', '=',
'[', ']', '\\', ',', '.', '/', ';', '\'' and space are used to identify the
keys in the main keyboard.

On X systems unrecognized keys are returned unchanged as their X keysym value.
If they have no keysym it uses the scan code or'd with C<0x8000>, this is what
all those blue buttons on a Microsoft keyboard will do. I don't know how to
get those buttons on Windows.

Supported keys may be imported with the C<events> tag and include...

=over

=item C<LeftButton>

=item C<MiddleButton>

=item C<RightButton>

=item C<SpaceKey>

=item C<BackSpaceKey>

=item C<TabKey>

=item C<ClearKey>

On some systems with NumLock off '5' produces this.

=item C<ReturnKey>

Main Enter key, Windows and X documentation calls this "Return"

=item C<PauseKey>

Pause / Break button

=item C<ScrollLockKey>

=item C<EscapeKey>

=item C<HomeKey>

=item C<LeftKey>

=item C<UpKey>

=item C<RightKey>

=item C<DownKey>

=item C<PageUpKey>

=item C<PageDownKey>

=item C<EndKey>

=item C<PrintKey>

Print Scr / Sys Rq key

=item C<InsertKey>

=item C<MenuKey>

Key in lower-right (between Ctrl and Win) with picture of popup menu

=item C<HelpKey>

Help key on Macintosh keyboards

=item C<NumLockKey>

=item C<Keypad>

Add ASCII to this to get keypad keys.

As in C<Keypad + "+"> is the same as C<AddKey>.

=item C<KeypadEnter>

Enter on the keypad. Same as C<Keypad + "\r">

=item C<MultiplyKey>

C<*> on the keypad. Same as C<Keypad + "*">

=item C<AddKey>

C<+> on the keypad. Same as C<Keypad + "+">

=item C<SubtractKey>

C<-> on the keypad. Same as C<Keypad + "-">

=item C<DecimalKey>

C<.> on the keypad

=item C<DivideKey>

C</> on the keypad

=item C<Keypad0>

C<0> on the keypad

=item C<Keypad1>

C<1> on the keypad

=item C<Keypad2>

C<2> on the keypad

=item C<Keypad3>

C<3> on the keypad

=item C<Keypad4>

C<4> on the keypad

=item C<Keypad5>

C<5> on the keypad

=item C<Keypad6>

C<6> on the keypad

=item C<Keypad7>

C<7> on the keypad

=item C<Keypad8>

C<8> on the keypad

=item C<Keypad9>

C<9> on the keypad

=item C<KeypadLast>

C<Keypad + '='>, largest legal keypad key

=item C<F0Key>

Add a number to get function key.

As in C<F0Key + 3> is the same as C<F3Key>

=item C<F1Key>

=item C<F2Key>

=item C<F3Key>

=item C<F4Key>

=item C<F5Key>

=item C<F6Key>

=item C<F7Key>

=item C<F8Key>

=item C<F9Key>

=item C<F10Key>

=item C<F11Key>

=item C<F12Key>

=item C<LastFunctionKey>

Largest legal function key. Same as C<F0Key + 35>

=item C<LeftShiftKey>

Left-hand Shift

=item C<RightShiftKey>

Right-hand Shift

=item C<LeftCtrlKey>

Left-hand Ctrl

=item C<RightCtrlKey>

Right-hand Ctrl

=item C<CapsLockKey>

Caps Lock

=item C<LeftMetaKey>

The left "Windows" or "Apple" key

=item C<RightMetaKey>

The right "Windows" or "Apple" key

=item C<LeftAltKey>

Left-hand Alt (option on Mac)

=item C<RightAltKey>

Right-hand Alt (option on Mac)

=item C<DeleteKey>

Delete

=item C<LeftAccKey>

Same as C<LeftCtrlKey> on Mac, C<LeftAltKey> on other systems.

=item C<RightAccKey>

Same as C<RightCtrlKey> on Mac, C<RightAltKey> on other systems.

=item C<LeftCmdKey>

Same as C<LeftMetaKey> on Mac, C<LeftCtrlKey> on other systems.

=item C<RightCmdKey>

Same as C<RightMetaKey> on Mac, C<RightCtrlKey> on other systems.

=back

...in addition to the above, letters C<a .. z> and all punctuation are passed
by their ordinal values.

=cut

BOOT:
    register_constant( "LeftButton", newSViv( fltk::LeftButton ));
    export_tag("LeftButton", "events");
    register_constant( "MiddleButton", newSViv( fltk::MiddleButton ));
    export_tag("MiddleButton", "events");
    register_constant( "RightButton", newSViv( fltk::RightButton ));
    export_tag("RightButton", "events");
    register_constant( "SpaceKey", newSViv( fltk::SpaceKey ));
    export_tag("SpaceKey", "events");
    register_constant( "BackSpaceKey", newSViv( fltk::BackSpaceKey ));
    export_tag("BackSpaceKey", "events");
    register_constant( "TabKey", newSViv( fltk::TabKey ));
    export_tag("TabKey", "events");
    register_constant( "ClearKey", newSViv( fltk::ClearKey ));
    export_tag("ClearKey", "events");
    register_constant( "ReturnKey", newSViv( fltk::ReturnKey ));
    export_tag("ReturnKey", "events");
    register_constant( "PauseKey", newSViv( fltk::PauseKey ));
    export_tag("PauseKey", "events");
    register_constant( "ScrollLockKey", newSViv( fltk::ScrollLockKey ));
    export_tag("ScrollLockKey", "events");
    register_constant( "EscapeKey", newSViv( fltk::EscapeKey ));
    export_tag("EscapeKey", "events");
    register_constant( "HomeKey", newSViv( fltk::HomeKey ));
    export_tag("HomeKey", "events");
    register_constant( "LeftKey", newSViv( fltk::LeftKey ));
    export_tag("LeftKey", "events");
    register_constant( "UpKey", newSViv( fltk::UpKey ));
    export_tag("UpKey", "events");
    register_constant( "RightKey", newSViv( fltk::RightKey ));
    export_tag("RightKey", "events");
    register_constant( "DownKey", newSViv( fltk::DownKey ));
    export_tag("DownKey", "events");
    register_constant( "PageUpKey", newSViv( fltk::PageUpKey ));
    export_tag("PageUpKey", "events");
    register_constant( "PageDownKey", newSViv( fltk::PageDownKey ));
    export_tag("PageDownKey", "events");
    register_constant( "EndKey", newSViv( fltk::EndKey ));
    export_tag("EndKey", "events");
    register_constant( "PrintKey", newSViv( fltk::PrintKey ));
    export_tag("PrintKey", "events");
    register_constant( "InsertKey", newSViv( fltk::InsertKey ));
    export_tag("InsertKey", "events");
    register_constant( "MenuKey", newSViv( fltk::MenuKey ));
    export_tag("MenuKey", "events");
    register_constant( "HelpKey", newSViv( fltk::HelpKey ));
    export_tag("HelpKey", "events");
    register_constant( "NumLockKey", newSViv( fltk::NumLockKey ));
    export_tag("NumLockKey", "events");
    register_constant( "Keypad", newSViv( fltk::Keypad ));
    export_tag("Keypad", "events");
    register_constant( "KeypadEnter", newSViv( fltk::KeypadEnter ));
    export_tag("KeypadEnter", "events");
    register_constant( "MultiplyKey", newSViv( fltk::MultiplyKey ));
    export_tag("MultiplyKey", "events");
    register_constant( "AddKey", newSViv( fltk::AddKey ));
    export_tag("AddKey", "events");
    register_constant( "SubtractKey", newSViv( fltk::SubtractKey ));
    export_tag("SubtractKey", "events");
    register_constant( "DecimalKey", newSViv( fltk::DecimalKey ));
    export_tag("DecimalKey", "events");
    register_constant( "DivideKey", newSViv( fltk::DivideKey ));
    export_tag("DivideKey", "events");
    register_constant( "Keypad0", newSViv( fltk::Keypad0 ));
    export_tag("Keypad0", "events");
    register_constant( "Keypad1", newSViv( fltk::Keypad1 ));
    export_tag("Keypad1", "events");
    register_constant( "Keypad2", newSViv( fltk::Keypad2 ));
    export_tag("Keypad2", "events");
    register_constant( "Keypad3", newSViv( fltk::Keypad3 ));
    export_tag("Keypad3", "events");
    register_constant( "Keypad4", newSViv( fltk::Keypad4 ));
    export_tag("Keypad4", "events");
    register_constant( "Keypad5", newSViv( fltk::Keypad5 ));
    export_tag("Keypad5", "events");
    register_constant( "Keypad6", newSViv( fltk::Keypad6 ));
    export_tag("Keypad6", "events");
    register_constant( "Keypad7", newSViv( fltk::Keypad7 ));
    export_tag("Keypad7", "events");
    register_constant( "Keypad8", newSViv( fltk::Keypad8 ));
    export_tag("Keypad8", "events");
    register_constant( "Keypad9", newSViv( fltk::Keypad9 ));
    export_tag("Keypad9", "events");
    register_constant( "KeypadLast", newSViv( fltk::KeypadLast ));
    export_tag("KeypadLast", "events");
    register_constant( "F0Key", newSViv( fltk::F0Key ));
    export_tag("F0Key", "events");
    register_constant( "F1Key", newSViv( fltk::F1Key ));
    export_tag("F1Key", "events");
    register_constant( "F2Key", newSViv( fltk::F2Key ));
    export_tag("F2Key", "events");
    register_constant( "F3Key", newSViv( fltk::F3Key ));
    export_tag("F3Key", "events");
    register_constant( "F4Key", newSViv( fltk::F4Key ));
    export_tag("F4Key", "events");
    register_constant( "F5Key", newSViv( fltk::F5Key ));
    export_tag("F5Key", "events");
    register_constant( "F6Key", newSViv( fltk::F6Key ));
    export_tag("F6Key", "events");
    register_constant( "F7Key", newSViv( fltk::F7Key ));
    export_tag("F7Key", "events");
    register_constant( "F8Key", newSViv( fltk::F8Key ));
    export_tag("F8Key", "events");
    register_constant( "F9Key", newSViv( fltk::F9Key ));
    export_tag("F9Key", "events");
    register_constant( "F10Key", newSViv( fltk::F10Key ));
    export_tag("F10Key", "events");
    register_constant( "F11Key", newSViv( fltk::F11Key ));
    export_tag("F11Key", "events");
    register_constant( "F12Key", newSViv( fltk::F12Key ));
    export_tag("F12Key", "events");
    register_constant( "LastFunctionKey", newSViv( fltk::LastFunctionKey ));
    export_tag("LastFunctionKey", "events");
    register_constant( "LeftShiftKey", newSViv( fltk::LeftShiftKey ));
    export_tag("LeftShiftKey", "events");
    register_constant( "RightShiftKey", newSViv( fltk::RightShiftKey ));
    export_tag("RightShiftKey", "events");
    register_constant( "LeftCtrlKey", newSViv( fltk::LeftCtrlKey ));
    export_tag("LeftCtrlKey", "events");
    register_constant( "RightCtrlKey", newSViv( fltk::RightCtrlKey ));
    export_tag("RightCtrlKey", "events");
    register_constant( "CapsLockKey", newSViv( fltk::CapsLockKey ));
    export_tag("CapsLockKey", "events");
    register_constant( "LeftMetaKey", newSViv( fltk::LeftMetaKey ));
    export_tag("LeftMetaKey", "events");
    register_constant( "RightMetaKey", newSViv( fltk::RightMetaKey ));
    export_tag("RightMetaKey", "events");
    register_constant( "LeftAltKey", newSViv( fltk::LeftAltKey ));
    export_tag("LeftAltKey", "events");
    register_constant( "RightAltKey", newSViv( fltk::RightAltKey ));
    export_tag("RightAltKey", "events");
    register_constant( "DeleteKey", newSViv( fltk::DeleteKey ));
    export_tag("DeleteKey", "events");
    register_constant( "LeftAccKey", newSViv( fltk::LeftAccKey ));
    export_tag("LeftAccKey", "events");
    register_constant( "RightAccKey", newSViv( fltk::RightAccKey ));
    export_tag("RightAccKey", "events");
    register_constant( "LeftCmdKey", newSViv( fltk::LeftCmdKey ));
    export_tag("LeftCmdKey", "events");
    register_constant( "RightCmdKey", newSViv( fltk::RightCmdKey ));
    export_tag("RightCmdKey", "events");

=pod

=head1 Flags

Flags returned by C<event_state()>, and used as the high 16 bits of
L<C<Widget::add_shortcut()>|FLTK::Widget/"add_shortcut"> values (the low 16
bits are all zero, so these may be or'd with key values).

The function C<BUTTON(n)> will turn C<n> (1 .. 8) into the flag for a mouse
button.

The current flags imported with the C<:events> targ are...

=over

=item C<SHIFT>

Either shift key held down

=item C<CAPSLOCK>

Caps lock is toggled on
=item C<CTRL>

Either ctrl key held down

=item C<ALT>

Either alt key held down

=item C<NUMLOCK>

Num Lock turned on.

=item C<META>

"Windows" or the "Apple" keys held down.

=item C<SCROLLLOCK>

Scroll Lock turned on.

=item C<BUTTON1>

Left mouse button held down.

=item C<BUTTON2>

Middle mouse button held down.

=item C<BUTTON3>

Right mouse button held down.

=item C<ANY_BUTTON>

Any mouse button (up to 8).

=item C<ACCELERATOR>

C<ALT> on Windows/Linux, C<CTRL> on OS/X, use for menu accelerators.

=item C<COMMAND>

C<CTRL> on Windows/Linux, C<META> on OS/X, use for menu shortcuts.

=item C<OPTION>

C<ALT|META> on Windows/Linux, just C<ALT> on OS/X, use as a drag modifier.

=back

=cut

BOOT:
    register_constant( "SHIFT", newSViv( fltk::SHIFT ));
    export_tag("SHIFT", "events");
    register_constant( "CAPSLOCK", newSViv( fltk::CAPSLOCK ));
    export_tag("CAPSLOCK", "events");
    register_constant( "CTRL", newSViv( fltk::CTRL ));
    export_tag("CTRL", "events");
    register_constant( "ALT", newSViv( fltk::ALT ));
    export_tag("ALT", "events");
    register_constant( "NUMLOCK", newSViv( fltk::NUMLOCK ));
    export_tag("NUMLOCK", "events");
    register_constant( "META", newSViv( fltk::META ));
    export_tag("META", "events");
    register_constant( "SCROLLLOCK", newSViv( fltk::SCROLLLOCK ));
    export_tag("SCROLLLOCK", "events");
    register_constant( "BUTTON1", newSViv( fltk::BUTTON1 ));
    export_tag("BUTTON1", "events");
    register_constant( "BUTTON2", newSViv( fltk::BUTTON2 ));
    export_tag("BUTTON2", "events");
    register_constant( "BUTTON3", newSViv( fltk::BUTTON3 ));
    export_tag("BUTTON3", "events");
    register_constant( "ANY_BUTTON", newSViv( fltk::ANY_BUTTON ));
    export_tag("ANY_BUTTON", "events");
    register_constant( "ACCELERATOR", newSViv( fltk::ACCELERATOR ));
    export_tag("ACCELERATOR", "events");
    register_constant( "OPTION", newSViv( fltk::OPTION ));
    export_tag("OPTION", "events");
    register_constant( "COMMAND", newSViv( fltk::COMMAND ));
    export_tag("COMMAND", "events");

=begin apidoc

=for apidoc FT[events]||int flags|BUTTON|int number|

The function C<BUTTON(n)> will turn C<number> (1 .. 8) into the
L<flag|/"Flags"> for a mouse button.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

unsigned
BUTTON( int number )
    CODE:
        RETVAL = fltk::BUTTON( number );
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "BUTTON", "events" );

MODULE = FLTK::events               PACKAGE = FLTK::events

=pod

=end apidoc

=head1 Devices

Device identifiers are returned by C<event_device()>. This is useful to get
the device type that caused a C<PUSH>, C<RELEASE>, C<DRAG> or C<MOVE> event.

Current devices (which are imported with the C<events> tag) include...

=over

=item C<DEVICE_MOUSE>

Event triggered by the system mouse.

=item C<DEVICE_STYLUS>

Event triggered by a pen on a tablet, givin pressure and tilt information.

=item C<DEVICE_ERASER>

Event triggered by an eraser on a tablet, givin pressure and tilt information.

=item C<DEVICE_CURSOR>

Event triggered by a puck style device on a tablet.

=item C<DEVICE_AIRBRUSH>

Event triggered by an airbrush on a tablet, giving pressure and tilt
information.

=item C<DEVICE_TOUCH>

Event triggered by touch a touch screen device.

=back

=cut

BOOT:
    register_constant( "DEVICE_MOUSE", newSViv( fltk::DEVICE_MOUSE ));
    export_tag("DEVICE_MOUSE", "events");
    register_constant( "DEVICE_STYLUS", newSViv( fltk::DEVICE_STYLUS ));
    export_tag("DEVICE_STYLUS", "events");
    register_constant( "DEVICE_ERASER", newSViv( fltk::DEVICE_ERASER ));
    export_tag("DEVICE_ERASER", "events");
    register_constant( "DEVICE_CURSOR", newSViv( fltk::DEVICE_CURSOR ));
    export_tag("DEVICE_CURSOR", "events");
    register_constant( "DEVICE_AIRBRUSH", newSViv( fltk::DEVICE_AIRBRUSH ));
    export_tag("DEVICE_AIRBRUSH", "events");
    register_constant( "DEVICE_TOUCH", newSViv( fltk::DEVICE_TOUCH ));
    export_tag("DEVICE_TOUCH", "events");

=begin apidoc

=for apidoc FT[events]||int event|event||



=for apidoc FT[events]||int x|event_x||



=for apidoc FT[events]||int y|event_y||



=for apidoc FT[events]||int dx|event_dx||



=for apidoc FT[events]||int dy|event_dy||



=for apidoc FT[events]||int x|event_x_root||



=for apidoc FT[events]||int y|event_y_root||



=cut

MODULE = FLTK::events               PACKAGE = FLTK

int
event( )
    CODE:
        switch( ix ) {
            case 0: RETVAL = fltk::event( ); break;
            case 1: RETVAL = fltk::event_x( ); break;
            case 2: RETVAL = fltk::event_y( ); break;
            case 3: RETVAL = fltk::event_dx( ); break;
            case 4: RETVAL = fltk::event_dy( ); break;
            case 5: RETVAL = fltk::event_x_root( ); break;
            case 6: RETVAL = fltk::event_y_root( ); break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
             event_x = 1
             event_y = 2
            event_dx = 3
            event_dy = 4
        event_x_root = 5
        event_y_root = 6

BOOT:
    export_tag("event_y_root", "events");
    export_tag("event_x_root", "events");
    export_tag("event_dy", "events");
    export_tag("event_dx", "events");
    export_tag("event_y", "events");
    export_tag("event_x", "events");
    export_tag("event", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]|||event_clicks|int i|



=for apidoc FT[events]||int clicks|event_clicks||



=cut

MODULE = FLTK::events               PACKAGE = FLTK

int
event_clicks( int i = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = fltk::event_clicks( );
        OUTPUT:
            RETVAL
    CASE: items == 1
        CODE:
            fltk::event_clicks( i );

BOOT:
    export_tag("event_clicks", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool click|event_is_click||



=for apidoc FT[events]|||event_is_click|bool value|



=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
event_is_click( bool value = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = fltk::event_is_click( );
        OUTPUT:
            RETVAL
    CASE: items == 1
        CODE:
            fltk::event_is_click( value ); /* Really? Only false works? */

BOOT:
    export_tag("event_is_click", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||int state|event_state||



=for apidoc FT[events]||bool state|event_state|unsigned state|



=cut

MODULE = FLTK::events               PACKAGE = FLTK

unsigned
event_state( unsigned state = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = fltk::event_state( );
        OUTPUT:
            RETVAL
    CASE: items == 1
        CODE:
            RETVAL = (unsigned) fltk::event_state( state );

BOOT:
    export_tag("event_state", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||int key|event_key||



=for apidoc FT[events]||int button|event_button||


=cut

MODULE = FLTK::events               PACKAGE = FLTK

unsigned
event_key( )
    CODE:
        RETVAL = fltk::event_key( );
    OUTPUT:
        RETVAL

unsigned
event_button( )
    CODE:
        RETVAL = fltk::event_button( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_key", "events");
    export_tag("event_button", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool state|event_key_state|unsigned state|



=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
event_key_state( unsigned state )
    CODE:
        RETVAL = fltk::event_key_state( state );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_key_state", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||char * string|event_text||



=cut

MODULE = FLTK::events               PACKAGE = FLTK

const char *
event_text( )
    CODE:
        RETVAL = fltk::event_text( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_text", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||int length|event_length||



=for apidoc FT[events]||int repeated|event_key_repeated||



=cut

MODULE = FLTK::events               PACKAGE = FLTK

unsigned
event_length( )
    CODE:
        RETVAL = fltk::event_length( );
    OUTPUT:
        RETVAL

unsigned
event_key_repeated( )
    CODE:
        RETVAL = fltk::event_key_repeated( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_length", "events");
    export_tag("event_key_repeated", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||float pressure|event_pressure||



=for apidoc FT[events]||float tilt_x|event_x_tilt||



=for apidoc FT[events]||float tilt_y|event_y_tilt||



=cut

MODULE = FLTK::events               PACKAGE = FLTK

float
event_pressure( )
    CODE:
        RETVAL = fltk::event_pressure( );
    OUTPUT:
        RETVAL

float
event_x_tilt( )
    CODE:
        RETVAL = fltk::event_x_tilt( );
    OUTPUT:
        RETVAL

float
event_y_tilt( )
    CODE:
        RETVAL = fltk::event_y_tilt( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_pressure", "events");
    export_tag("event_x_tilt", "events");
    export_tag("event_y_tilt", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||int id|event_device||



=cut

MODULE = FLTK::events               PACKAGE = FLTK

int
event_device( )
    CODE:
        RETVAL = fltk::event_device( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_device", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool in|event_inside|FLTK::Rectangle * rectangle|

Returns true if the current L<C<event_x()>|/"event_x"> and
L<C<event_y()>|/"event_y"> put it inside the L<Rectangle|FLTK::Rectangle>. You
should always call this rather than doing your own comparison so you are
consistent about edge effects.

=for hackers Found in C<src/run.cxx>

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
event_inside( fltk::Rectangle * rectangle )
    CODE:
        RETVAL = fltk::event_inside( * rectangle );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_inside", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool changed|compose|int del|

Use of this function is very simple. Any text editing widget should call this
for each C<KEY> event.

If a true value is returned, then it has modified the
L<C<event_text()>|/"event_text"> and L<C<event_length()>|/"event_length"> to a
set of bytes to insert (it may be of zero length!). It will also set the
C<del> parameter to the number of bytes to the left of the cursor to delete,
this is used to delete the results of the previous call to
L<C<compose()>|/"compose">. Compose may consume the key, which is indicated by
returning true, but both the length and C<del> are set to zero.

Compose returns a false value if it thinks the key is a function key that the
widget should handle itself, and not an attempt by the user to insert text.

Though the current implementation returns immediately, future versions may
take quite awhile, as they may pop up a window or do other user-interface
things to allow international characters to be selected.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
compose( IN_OUTLIST int del )
    CODE:
        RETVAL = fltk::compose( del );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("compose", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]|||compose_reset||

If the user moves the cursor, be sure to call
L<C<compose_reset()>|/"compose_reset">. The next call to
L<C<compose()>|/"compose"> will start out in an initial state. In particular
it will not set "del" to non-zero. This call is very fast so it is ok to call
it many times and in many places.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

void
compose_reset( )
    CODE:
        fltk::compose_reset( );

BOOT:
    export_tag("compose_reset", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool handled|try_shortcut||

Try sending the current C<KEY> event as a C<SHORTCUT> event.

Normally the L<C<focus()>|/"focus"> gets all keystrokes, and shortcuts are
only tested if that widget indicates it is uninterested by returning zero from
L<C<Widget::handle()>|FLTK::Subclass/"handle">.  However in some cases the
focus wants to use the keystroke I<only if it is not a shortcut>. The most
common example is Emacs-style editing keystrokes in text editing widgets,
which conflict with Microsoft-compatable menu key bindings, but we want the
editing keys to work if there is no conflict.

This will send a C<SHORTCUT> event just like the focus returned zero, to every
widget in the focus window, and to the L<C<add_handler()>|/"add_handler">
calls, if any. It will return true if any widgets were found that were
interested in it. A C<handle()> method can call this in a C<KEY> event. If it
returns true, return 1 B<immediatly>, as the shortcut will have executed and
may very well have destroyed your widget. If this returns false, then do what
you want the key to do.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
try_shortcut( )
    CODE:
        RETVAL = fltk::try_shortcut( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("try_shortcut", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||char * string|key_name|unsigned hotkey|

Unparse a L<C<FLTK::Widget::shortcut()>|FLTK::Widget/"shortcut">, an
L<C<event_key()>|/"event_key">, or an L<C<event_key()>|/"event_key"> or'd with
L<C<event_state()>|/"event_state">. Returns a human-readable string like
"Alt+N". If C<hotkey> is zero an empty string is returned.

The opposite function is L<C<key()>|/"key">.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

const char *
key_name( unsigned hotkey )
    CODE:
        RETVAL = fltk::key_name( hotkey );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("key_name", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||int key|key|char * name|

Turn a string into a L<C<event_key()>|/"event_key"> value or'd with
L<C<event_shift()>|/"event_shift"> flags. The returned value can be used by by
L<C<FLTK::Widget::add_shortcut()>|FLTK::Widget/"add_shortcut">.  Any error, or
a null or zero-length string, returns 0.

Currently this understands prefixes of "Alt+", "Shift+", and "Ctrl+" to turn
on C<ALT>, C<SHIFT>, and C<CTRL>. Case is ignored and the '+' can be a '-'
instead and the prefixes can be in any order.  You can also use '#' instead of
"Alt+", '+' instead of "Shift+", and '^' instead of "Ctrl+".

After the shift prefixes there can either be a single ASCII letter, "Fn" where
C<n> is a number to indicate a function key, or "0xnnnn" to get an arbitrary
L<C<event_key()>|/"event_kay"> enumeration value.

The inverse function to turn a number into a string is
L<C<key_name()>|/"key_name">. Currently this function does not parse some
strings L<C<key_name()>|/"key_name"> can return, such as the names of arrow
keys!

=cut

MODULE = FLTK::events               PACKAGE = FLTK

unsigned
key( const char * name )
    CODE:
        RETVAL = fltk::key( name );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("key", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||int value|foreachShortcut|FLTK::ShortcutFunctor * SF|FLTK::Widget * widget|

Calls the L<C<handle()>|FLTK::Subclass/"handle"> method from the passed
ShortcutFunctor object for every
L<C<Widget::shortcut()>|FLTK::Widget/"shortcut"> assignment known. If any
return true then this immediately returns that shortcut value, else this
returns zero after calling it for the last one. This is most useful for making
a display of shortcuts for the user, or implementing a shortcut editor.

If C<widget> is not null, only do assignments for that widget, this is much
faster than searching the entire list. This is useful for drawing the
shortcuts on a widget (though most fltk widgets only draw the first one).

=for apidoc FT[events]||int value|foreachShortcut|FLTK::ShortcutFunctor * SF|

Same. But without widget NULL by default.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

unsigned
foreachShortcut( fltk::ShortcutFunctor * SF, fltk::Widget * widget = NO_INIT )
    CODE:
        if ( items == 1 )
            RETVAL = fltk::foreachShortcut( * SF );
        else if ( items == 2 )
            RETVAL = fltk::foreachShortcut( widget, * SF );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("foreachShortcut", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool state|get_key_state|int key|

Returns true if the given key was held down (or pressed) I<during the last
event>. This is constant until the next event is read from the server. The
possible values for the key are listed under C<SpaceKey>.

Note: On Win32, C<event_key_state(KeypadEnter)> does not work.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
get_key_state( unsigned key )
    CODE:
        RETVAL = fltk::get_key_state( key );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("get_key_state", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||AV * xy|get_mouse||

Return where the mouse is on the screen by doing a round-trip query to the
server. You should use L<C<event_x_root()>|/"event_x_root"> and
L<C<event_y_root()>|/"event_y_root"> if possible, but this is necessary if you
are not sure if a mouse event has been processed recently (such as to position
your first window). If the display is not open, this will open it.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

AV *
get_mouse( )
    PREINIT:
        int x, y;
    INIT:
        RETVAL = newAV( );
        sv_2mortal((SV*)RETVAL);
    CODE:
        fltk::get_mouse( x, y );
        av_push( RETVAL, newSViv( x ) );
        av_push( RETVAL, newSViv( y ) );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("get_mouse", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool worked|warp_mouse|int x|int y|

Change where the mouse is on the screen.

Returns true if successful, false on failure (exactly what success and failure
means depends on the os).

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
warp_mouse ( int x, int y )
    CODE:
        RETVAL = fltk::warp_mouse ( x, y );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("warp_mouse", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc F||bool handled|handle|int event|FLTK::Window * window|

This is the function called from the system-specific code for all events that
can be passed to L<C<Widget::handle()>|FLTK::Subclass/"handle">.

You can call it directly to fake events happening to your widgets. Currently
data other than the event number can only be faked by writing to the
undocumented C<fltk::e_*> variables, for instance to make
L<C<event_x()>|/"event_x"> return C<5>, you whould do C<fltk::e_x = 5>. This
may change in future versions of fltk toolkit and is currently not supported
by the FLTK module.

This will redirect events to the L<C<modal()>|/"modal">,
L<C<pushed()>|/"pushed">, L<C<belowmouse()>|/"belowmouse">, or
L<C<focus()>|/"focus"> widget depending on those settings and the event type.
It will turn C<MOVE> into C<DRAG> if any buttons are down. If the resulting
widget returns 0 (or the window or widget is undef) then the functions pointed
to by L<C<add_event_handler()>|/"add_event_handler"> are called.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
handle( int event, fltk::Window * window )
    CODE:
        RETVAL = fltk::handle( event, window );
    OUTPUT:
        RETVAL

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||FLTK::Widget * under|belowmouse||

Get the widget that is below the mouse. This is the last widget to respond to
an C<ENTER> event as long as the mouse is still pointing at it. This is for
highlighting buttons and bringing up tooltips. It is not used to send C<PUSH>
or C<MOVE> directly, for several obscure reasons, but those events typically
go to this widget.

=for apidoc FT[events]|||belowmouse|FLTK::Widget * widget|

Change the L<C<belowmouse()>|/"belowmouse"> widget, the previous one and all
parents (that don't contain the new widget) are sent C<LEAVE> events. Changing
this does not send C<ENTER> to this or any widget, because sending C<ENTER> is
supposed to test if the widget wants the mouse (by it returning non-zero from
handle()).

=cut

MODULE = FLTK::events               PACKAGE = FLTK

fltk::Widget *
belowmouse( fltk::Widget * widget = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = fltk::belowmouse( );
        OUTPUT:
            RETVAL
    CASE: items == 1
        CODE:
            fltk::belowmouse( widget );

BOOT:
    export_tag("belowmouse", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||FLTK::Widget * current|pushed||

Get the widget that is being pushed. C<DRAG> or C<RELEASE> (and any more
C<PUSH>) events will be sent to this widget. This is null if no mouse button
is being held down, or if no widget responded to the C<PUSH> event.

=for apidoc FT[events]|||pushed|FLTK::Widget widget|

Change the L<C<pushed()>|/"pushed"> widget. This sends no events.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

fltk::Widget *
pushed( fltk::Widget * widget = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = fltk::pushed( );
        OUTPUT:
            RETVAL
    CASE: items == 1
        CODE:
            fltk::pushed( widget );

BOOT:
    export_tag("pushed", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||FLTK::Widget * widget|focus||

Returns the widgets that will receive C<KEY> events. This is undef if the
application does not have focus now, or if no widgets accepted focus.

=for apidoc FT[events]|||focus|FLTK::Widget * widget|

Change L<C<focus()>|/"focus"> to the given widget, the previous widget and all
parents (that don't contain the new widget) are sent C<UNFOCUS> events, the
new widget is sent an C<FOCUS> event, and all parents of it get
C<FOCUS_CHANGE> events.

L<C<focus()>|/"focus"> is set whether or not the applicaton has the focus or
if the widgets accept the focus. You may want to use
L<C<FLTK::Widget::take_focus()>|FLTK::Widget/"take_focus"> instead, it will
test first.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

fltk::Widget *
focus( fltk::Widget * widget = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = fltk::focus( );
        OUTPUT:
            RETVAL
    CASE: items == 1
        CODE:
            focus( widget );

BOOT:
    export_tag("focus", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]|||copy|char * stuff|int length = strlen(stuff)|bool clipboard = false|

Change the current selection. The block of text is copied to an internal
buffer by FLTK (be careful if doing this in response to a C<PASTE> as this may
be the same buffer returned by L<C<event_text()>|/"event_text">).

The block of text may be retrieved (from this program or whatever program last
set it) with L<C<paste()>|/"paste">.

There are actually two buffers. If C<clipboard> is true then the text goes
into the user-visible selection that is moved around with cut/copy/paste
commands (on X this is the CLIPBOARD selection). If C<clipboard> is false then
the text goes into a less-visible buffer used for temporarily selecting text
with the mouse and for drag & drop (on X this is the XA_PRIMARY selection).

=cut

MODULE = FLTK::events               PACKAGE = FLTK

void
copy( const char * stuff, int len = strlen(stuff), bool clipboard = false )
    CODE:
        fltk::copy( stuff, len, clipboard );

BOOT:
    export_tag("copy", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]|||paste|FLTK::Widget * widget|bool clipboard = false|

This is what a widget does when a "paste" command (like Ctrl+V or the middle
mouse click) is done to it. Cause a C<PASTE> event to be sent to the receiver
with the contents of the current selection in the
L<C<event_text()>|/"event_text">. The selection can be set by
L<C<copy()>|/"copy">.

There are actually two buffers. If C<clipboard> is true then the text is from
the user-visible selection that is moved around with cut/copy/paste commands
(on X this is the CLIPBOARD selection). If C<clipboard> is false then the text
is from a less-visible buffer used for temporarily selecting text with the
mouse and for drag & drop (on X this is the XA_PRIMARY selection).

The reciever should be prepared to be called I<directly> by this or, for it to
happen later, or possibly not at all. This allows the window system to take as
long as necessary to retrieve the paste buffer (or even to screw up
completely) without complex and error-prone synchronization code most toolkits
require.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

void
paste( fltk::Widget * reciever, bool clipboard = false )
    CODE:
        fltk::paste( * reciever, clipboard );

BOOT:
    export_tag("paste", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool drag|dnd||

Drag and drop the data set by the most recent L<C<copy()>|/"copy"> (with the
C<clipboard> argument false). Returns true if the data was dropped on
something that accepted it.

By default only blocks of text are dragged. You can use system-specific
variables to change the type of data.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
dnd( )
    CODE:
        RETVAL = fltk::dnd( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("dnd", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]|||modal|FLTK::Widget * widget|bool grab = false|

Restricts events to a certain widget.

First thing: much of the time L<C<Window::exec()>|FLTK::Window/"exec"> will do
what you want, so try using that.

This function sets the passed widget as the "modal widget". All user events
are directed to it or a child of it, preventing the user from messing with
other widgets. The modal widget does not have to be visible or even a child of
a L<Window|FLTK::Window> for this to work (but if it not visible,
L<C<event_x()>|/"event_x"> and L<C<event_y()>|/"event_y"> are meaningless, use
L<C<event_x_root()>|/"event_x_root"> and
L<C<event_y_root()>|/"event_y_root">).

The calling code is responsible for saving the current value of
L<C<modal()>|/"modal"> and L<C<grab()>|/"grab"> and restoring them by calling
this after it is done. The code calling this should then loop calling
L<C<wait()>|FLTK/"wait"> until L<C<exit_modal_flag()>|/"exit_modal_flag"> is
set or you otherwise decide to get out of the modal state. It is the calling
code's responsibility to monitor this flag and restore the modal widget to
it's previous value when it turns on.

C<grab> indicates that the modal widget should get events from anywhere on the
screen. This is done by messing with the window system. If
L<C<exit_modal()>|/"exit_modal"> is called in response to a C<PUSH> event
(rather than waiting for the drag or release event) fltk will "repost" the
event so that it is handled after modal state is exited. This may also be done
for keystrokes in the future. On both X and WIN32 grab will not work unless
you have some visible window because the system interface needs a visible
window id. On X be careful that your program does not enter an infinite loop
while L<C<grab()>|/"grab"> is on, it will lock up your screen!

=for apidoc FT[events]||FLTK::Widget current|modal||

Returns the current modal widget, or undef if there isn't one. It is useful to
test these in timeouts and file descriptor callbacks in order to block actions
that should not happen while the modal window is up. You also need these in
order to save and restore the modal state.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

fltk::Widget *
modal( fltk::Widget * widget = NO_INIT, bool grab = false )
    CASE: items == 0
        CODE:
            RETVAL = fltk::modal( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            fltk::modal( widget, grab );

BOOT:
    export_tag("modal", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool cvalue|grab||

Returns the current value of grab (this is always false if
L<C<modal()>|/"modal"> is undef).

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
grab( )
    CODE:
        RETVAL = fltk::grab( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("grab", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]|||exit_modal||

Turns on L<C<exit_modal_flag()>|/"exit_modal_flag">. This may be used by user
callbacks to cancel modal state. See also
L<C<Window::make_exec_return()>|FLTK::Window/"make_exec_return">.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

void
exit_modal( )
    CODE:
        fltk::exit_modal( );

BOOT:
    export_tag("exit_modal", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||bool eh|exit_modal_flag||

True if L<C<exit_modal()>|/"exit_modal"> has been called. The flag is also set
by the destruction or hiding of the modal widget, and on Windows by other
applications taking the focus when grab is on.

=cut

MODULE = FLTK::events               PACKAGE = FLTK

bool
exit_modal_flag( )
    CODE:
        RETVAL = fltk::exit_modal_flag( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("exit_modal_flag", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

=for apidoc FT[events]||char * string|event_name|int event|

Return the corresponding name of an event, should not consume memory if api is
not used. This is really only good for debugging.

=end apidoc

=cut

MODULE = FLTK::events               PACKAGE = FLTK

const char *
event_name( int event )
    CODE:
        RETVAL = fltk::event_name( event );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("event_name", "events");

MODULE = FLTK::events               PACKAGE = FLTK::events

#ifdef PERL_ENTER
#define ENTER PERL_ENTER
#endif // #ifdef PERL_ENTER
#ifdef PERL_LEAVE
#define LEAVE PERL_LEAVE
#endif // #ifdef PERL_LEAVE

#endif // ifndef DISABLE_EVENTS
