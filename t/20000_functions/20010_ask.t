#!perl

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for functions found in xs/ask.xsi

=for TODO Somehow test selecting different buttons (with defaults and C<ESC>)

=for git $Id$

=cut
use strict;
use warnings;
use Test::More tests => 30;
use Module::Build qw[];
use Time::HiRes qw[];
use Test::NeedsDisplay;
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK qw[:vars :dialog];

#
is($ok, '&OK', 'Default English value for $ok');
ok($ok = 'Alright!', 'Change value of $ok to \'Alright!\'');
is($FLTK::ok, 'Alright!', 'Verify new value for $ok');

#
is($yes, '&Yes', 'Default English value for $yes');
ok($yes = 'Yeah!', 'Change value of yes to \'Yeah!\'');
is($FLTK::yes, 'Yeah!', 'Verify new value of $yes');

#
is($no, '&No', 'Default English value for $no');
ok($no = 'Nope!', 'Change value of $no to \'Nope!\'');
is($FLTK::no, 'Nope!', 'Verify new value of $no');

#
is($cancel, '&Cancel', 'Default English value of $cancel');
ok($cancel = 'Forget it!', 'Change value of cancel to \'Forget it!\'');
is($FLTK::cancel, 'Forget it!', 'Verify new value of $cancel');

#
ok(!$message_window_timeout, 'Default value for $message_window_timeout');
ok($message_window_timeout = 0.25,
    'Change value of $message_window_timeout to 0.25');
is($FLTK::message_window_timeout, 0.25,
    'Verify new value of $message_window_timeout');

#
ok(!$message_window_scrollable,
    'Default value for $message_window_scrollable');
ok($message_window_scrollable = 1,
    'Change value of $message_window_scrollable to 1');
is($FLTK::message_window_scrollable,
    1, 'Verify new value of $message_window_scrollable');

#
ok(!$message_window_label, 'Default value of $message_window_scrollable');
ok($message_window_label = 'This is my title!',
    'Change value of $message_window_label to \'This is my title!\'');
is($FLTK::message_window_label,
    'This is my title!',
    'Verify new value of $message_window_label');

#
my $message_style = message_style();
my $icon_style    = icon_style();
isa_ok(message_style(), 'FLTK::NamedStyle', 'message_style()');
isa_ok(icon_style(),    'FLTK::NamedStyle', 'icon_style()');

#
note
    'These pop up and go away quick because the message_window_timeout is now 0.25s';
ok(!message("This is a test."),
    'message("This is a test.") always returns void');
ok(!alert("This is a test."), 'alert("This is a test.") always returns void');
is(ask("This is a test."), -1,
    'ask("This is a test.") returns -1 on timeout');
is(input("This is a test.", "default"),
    undef, 'input("This is a test.", "default") returns undef on timeout');
is(password("This is a test.", "default"),
    undef, 'password("This is a test.", "default") returns undef on timeout');
is( choice("This is a test.", 'One', 'Two', 'Three'),
    -1,
    'choice("This is a test.", "One", "Two", "Three") returns -1 on timeout'
);
is( choice_alert("This is a test.", 'One', 'Two', 'Three'),
    -1,
    'choice_alert("This is a test.", "One", "Two", "Three") returns -1 on timeout'
);
