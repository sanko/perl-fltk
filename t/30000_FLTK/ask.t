#!perl -I../../blib/lib -I../../blib/arch
# Simple fltk/ask.h tests
#
use strict;
use warnings;
use FLTK qw[:ask];
use Test::More tests => 29;
use Module::Build qw[];
use Time::HiRes qw[];
my $test_builder = Test::More->builder;
chdir '../../' if not -d '_build';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');
$SIG{__WARN__} = (
    $verbose
    ? sub {
        diag(sprintf(q[%02.4f], Time::HiRes::time- $^T), q[ ], shift);
        }
    : sub { }
);

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
ok(!FLTK::message_window_timeout(),
    'Default value for message_window_timeout()');
is(FLTK::message_window_timeout(0.25),
    0.25, 'Change value with message_window_timeout( 1.5 )');
is(FLTK::message_window_timeout(),
    0.25, 'Verify new value for message_window_timeout()');

#
ok(!FLTK::message_window_scrollable(),
    'Default value for message_window_scrollable()');
is(FLTK::message_window_scrollable(1),
    1, 'Change value with message_window_scrollable( 1 )');
is(FLTK::message_window_scrollable(),
    1, 'Verify new value for message_window_scrollable()');

#
ok(!FLTK::message_window_label(),
    'Default value for message_window_scrollable()');
is(FLTK::message_window_label('This is my title!'),
    'This is my title!',
    'Change value with message_window_label( \'This is my title!\' )');
is(FLTK::message_window_label(),
    'This is my title!',
    'Verify new value for message_window_label()');

#
SKIP: {
    skip '...no typemap for these yet.', 2;
    warn FLTK::message_style();
    warn FLTK::icon_style();
}
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
__END__
Copyright (C) 2009 by Sanko Robinson <sanko@cpan.org>

This program is free software; you can redistribute it and/or modify it
under the terms of The Artistic License 2.0.  See the LICENSE file
included with this distribution or
http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered by
the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

$Id$
