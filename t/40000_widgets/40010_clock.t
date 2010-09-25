#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Clock.xsi (Clock and ClockOutput objects)

=for git $Id$

=cut
use strict;
use warnings;
use Test::More 0.82 tests => 20;
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
use FLTK qw[:clock];

# ClockOutput types imported with :clock tag
for my $sub (qw[SQUARE ANALOG ROUND DIGITAL]) { can_ok(__PACKAGE__, $sub); }

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
$W->begin();
my $CO = new_ok('FLTK::ClockOutput' => [0, 0, 100, 100],
                'new FLTK::ClockOutput( 0, 0, 100, 100 )');
my $C1 = new_ok('FLTK::Clock' => [100, 0, 100, 100],
                'new FLTK::Clock( 100, 0, 100, 100 )');
$W->end();
my $C2 = new_ok('FLTK::Clock' => [100, 0, 100, 100],
                'new FLTK::Clock( 100, 0, 100, 100 )');
$W->show();    # if $interactive;

#
is($CO->value(), 0, 'Default value for ClockOutput is 0');
note sprintf 'Changing ClockOutput value to 987654321 (%s)',
    scalar gmtime 987654321;
$CO->value(987654321);
is($CO->value(), 987654321,
    'New value for ClockOutput is ' . scalar gmtime 987654321);
note 'Changing ClockOutput value back to 0';
$CO->value(0);

#
note 'Changing ClockOutput time to 3:14:15';
$CO->value(3, 14, 15);
is($CO->hour(),   3,  'ClockOutput->hour() is 3');
is($CO->minute(), 14, 'ClockOutput->minute() is 14');
is($CO->second(), 15, 'ClockOutput->second() is 15');

#
note 'Changing ClockOutput time to 141:42:13';
$CO->value(141, 42, 13);
note
    'In reality, values above 12:59:59 should be considered a bug in toolkit';
is($CO->hour(),   141, 'ClockOutput->hour() is 141');
is($CO->minute(), 42,  'ClockOutput->minute() is 42');
is($CO->second(), 13,  'ClockOutput->second() is 13');

#
is($CO->value(), 0, 'Calue for ClockOutput is still 0');
note 'value(h, m, s) does not change actual value()';

#
TODO: {
    local $TODO = 'timestamps may be off due to processing time';
    is($C1->value(), time, 'Default value for Clock is the current time');
}
is($C2->value(), 0, 'Orphan Clock objects do not keep track of time');
my $_value = $C1->value();
for my $countdown (reverse 1 .. 3) {
    sleep 1;
    FLTK::wait(1);
    $W->label("Closing in $countdown seconds");
}
FLTK::wait();
ok( ($C1->value() >= $_value + 3),
    'After 3 seconds of sleep, the value for Clock is still the current time'
);
is($C2->value(), 0,
    'After 3 seconds of sleep, the value for an orphan Clock is still 0');
