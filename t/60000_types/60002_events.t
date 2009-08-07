#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/events.xsi

=for git $Id$

=cut
use strict;
use warnings;
use Test::More tests => 126;
use Module::Build qw[];
use Time::HiRes qw[];
my $test_builder = Test::More->builder;
chdir '../..' if not -d '_build';
use lib 'inc';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');
$SIG{__WARN__} = (
    $verbose
    ? sub {
        diag(sprintf('%02.4f', Time::HiRes::time- $^T), ' ', shift);
        }
    : sub { }
);

#
use_ok('FLTK', qw[:events]);

# Event types and Event Keys imported with :event tag
for my $sub (
            qw[ NO_EVENT PUSH RELEASE ENTER LEAVE DRAG FOCUS UNFOCUS KEY KEYUP
            FOCUS_CHANGE MOVE SHORTCUT DEACTIVATE ACTIVATE HIDE SHOW PASTE
            TIMEOUT MOUSEWHEEL DND_ENTER DND_DRAG DND_LEAVE DND_RELEASE
            TOOLTIP
            LeftButton MiddleButton RightButton SpaceKey BackSpaceKey TabKey
            ClearKey ReturnKey PauseKey ScrollLockKey EscapeKey HomeKey
            LeftKey UpKey RightKey DownKey PageUpKey PageDownKey EndKey
            PrintKey InsertKey MenuKey HelpKey NumLockKey Keypad KeypadEnter
            MultiplyKey AddKey SubtractKey DecimalKey DivideKey Keypad0
            Keypad1 Keypad2 Keypad3 Keypad4 Keypad5 Keypad6 Keypad7 Keypad8
            Keypad9 KeypadLast F0Key F1Key F2Key F3Key F4Key F5Key F6Key F7Key
            F8Key F9Key F10Key F11Key F12Key LastFunctionKey LeftShiftKey
            RightShiftKey LeftCtrlKey RightCtrlKey CapsLockKey LeftMetaKey
            RightMetaKey LeftAltKey RightAltKey DeleteKey LeftAccKey
            RightAccKey LeftCmdKey RightCmdKey
            SHIFT CAPSLOCK CTRL ALT NUMLOCK META SCROLLLOCK BUTTON1 BUTTON2
            BUTTON3 ANY_BUTTON ACCELERATOR OPTION COMMAND
            DEVICE_MOUSE DEVICE_STYLUS DEVICE_ERASER DEVICE_CURSOR
            DEVICE_AIRBRUSH DEVICE_TOUCH ]
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
diag 'TODO: Uh... everything';
