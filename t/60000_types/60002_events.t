#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/events.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More tests => 167;
use Module::Build qw[];
use Time::HiRes qw[];
my $test_builder = Test::More->builder;
chdir '../..' if not -d '_build';
use lib 'inc';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use_ok('FLTK', qw[:events]);

# Event types and Event Keys imported with :event tag
for my $sub (
        qw[ ACCELERATOR ACTIVATE ALT ANY_BUTTON AddKey BUTTON1 BUTTON2 BUTTON3
        BackSpaceKey CAPSLOCK COMMAND CTRL CapsLockKey ClearKey DEACTIVATE
        DEVICE_AIRBRUSH DEVICE_CURSOR DEVICE_ERASER DEVICE_MOUSE DEVICE_STYLUS
        DEVICE_TOUCH DND_DRAG DND_ENTER DND_LEAVE DND_RELEASE DRAG DecimalKey
        DeleteKey DivideKey DownKey ENTER EndKey EscapeKey
        F0Key F10Key F11Key F12Key F1Key F2Key F3Key F4Key F5Key F6Key F7Key
        F8Key F9Key
        FOCUS FOCUS_CHANGE
        HIDE
        HelpKey HomeKey InsertKey KEY KEYUP
        Keypad Keypad0 Keypad1 Keypad2 Keypad3 Keypad4 Keypad5 Keypad6 Keypad7
        Keypad8 Keypad9 KeypadEnter KeypadLast
        LEAVE
        LastFunctionKey LeftAccKey LeftAltKey LeftButton LeftCmdKey
        LeftCtrlKey LeftKey LeftMetaKey LeftShiftKey
        META MOUSEWHEEL MOVE
        MenuKey MiddleButton MultiplyKey NO_EVENT NUMLOCK NumLockKey
        OPTION PASTE PUSH PageDownKey PageUpKey PauseKey PrintKey RELEASE
        ReturnKey RightAccKey RightAltKey RightButton RightCmdKey RightCtrlKey
        RightKey RightMetaKey RightShiftKey SCROLLLOCK SHIFT SHORTCUT SHOW
        ScrollLockKey SpaceKey SubtractKey TIMEOUT TOOLTIP TabKey UNFOCUS
        UpKey belowmouse compose compose_reset copy dnd event event_button
        event_clicks event_device event_dx event_dy event_inside
        event_is_click event_key event_key_repeated event_key_state
        event_length event_name event_pressure event_state event_text
        event_x event_x_root event_x_tilt event_y event_y_root event_y_tilt
        exit_modal exit_modal_flag focus foreachShortcut get_key_state
        get_mouse grab key key_name modal paste pushed try_shortcut warp_mouse
        ]
    )
{   can_ok(__PACKAGE__, $sub);
}

#
ok(BUTTON(0),  'BUTTON(0)');
ok(BUTTON(1),  'BUTTON(1)');
ok(BUTTON(2),  'BUTTON(2)');
ok(BUTTON(3),  'BUTTON(3)');
ok(BUTTON(4),  'BUTTON(4)');
ok(BUTTON(5),  'BUTTON(5)');
ok(BUTTON(6),  'BUTTON(6)');
ok(BUTTON(7),  'BUTTON(7)');
ok(BUTTON(8),  'BUTTON(8)');
ok(!BUTTON(9), 'BUTTON(9) fails');

#
note 'TODO: Uh... everything';
