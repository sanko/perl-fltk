#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

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
use_ok('FLTK', qw[:all]);

#
is(FLTK::ok(),           '&OK',      'Default English value for ok()');
is(FLTK::ok('Alright!'), 'Alright!', 'Change value with ok( \'Alright!\' )');
is(FLTK::ok(),           'Alright!', 'Verify new value for ok()');

#
is(FLTK::yes(),        '&Yes',  'Default English value for yes()');
is(FLTK::yes('Yeah!'), 'Yeah!', 'Change value with yes( \'Yeah!\' )');
is(FLTK::yes(),        'Yeah!', 'Verify new value for yes()');

#
is(FLTK::no(),        '&No',   'Default English value for no()');
is(FLTK::no('Nope!'), 'Nope!', 'Change value with no( \'Nope!\' )');
is(FLTK::no(),        'Nope!', 'Verify new value for no()');

#
is(FLTK::cancel(), '&Cancel', 'Default English value for cancel()');
is(FLTK::cancel('Forget it!'),
    'Forget it!', 'Change value with cancel( \'Forget it!\' )');
is(FLTK::cancel(), 'Forget it!', 'Verify new value for cancel()');

#
ok(!message_window_timeout(), 'Default value for message_window_timeout()');
is(message_window_timeout(0.25),
    0.25, 'Change value with message_window_timeout( 1.5 )');
is(message_window_timeout(), 0.25,
    'Verify new value for message_window_timeout()');

#
ok(!message_window_scrollable(),
    'Default value for message_window_scrollable()');
is(message_window_scrollable(1),
    1, 'Change value with message_window_scrollable( 1 )');
is(message_window_scrollable(),
    1, 'Verify new value for message_window_scrollable()');

#
ok(!message_window_label(), 'Default value for message_window_scrollable()');
is(message_window_label('This is my title!'),
    'This is my title!',
    'Change value with message_window_label( \'This is my title!\' )');
is(message_window_label(),
    'This is my title!',
    'Verify new value for message_window_label()');

#
isa_ok(message_style(), 'FLTK::NamedStyle', 'message_style()');
isa_ok(icon_style(),    'FLTK::NamedStyle', 'icon_style()');

#
warn
    'These pop up and go a way quick because the message_window_timeout is now 0.25s';
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
