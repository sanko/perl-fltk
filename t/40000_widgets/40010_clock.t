#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Clock.xsi (Clock and ClockOutput objects)

=for git $Id$

=cut
use strict;
use warnings;
use Test::More tests => 21;
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
use_ok('FLTK', qw[:clock]);

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
$W->show();

#
is($CO->value(), 0, 'Default value for ClockOutput is 0');
warn 'Changing ClockOutput value to ' . time;
$CO->value(time);
is($CO->value(), time, 'New value for ClockOutput is current time');
warn 'Changing ClockOutput value back to 0';
$CO->value(0);

#
warn 'Changing ClockOutput time to 3:14:15';
$CO->value(3, 14, 15);
is($CO->hour(),   3,  'ClockOutput->hour() is 3');
is($CO->minute(), 14, 'ClockOutput->minute() is 14');
is($CO->second(), 15, 'ClockOutput->second() is 15');

#
warn 'Changing ClockOutput time to 141:42:13';
$CO->value(141, 42, 13);
warn
    'In reality, values above 12:59:59 should be considered a bug in toolkit';
is($CO->hour(),   141, 'ClockOutput->hour() is 141');
is($CO->minute(), 42,  'ClockOutput->minute() is 42');
is($CO->second(), 13,  'ClockOutput->second() is 13');

#
is($CO->value(), 0, 'Calue for ClockOutput is still 0');
warn 'value(h, m, s) does not change actual value()';

#
is($C1->value(), time, 'Default value for Clock is the current time');
is($C2->value(), 0,    'Orphan Clock objects do not keep track of time');
for (1 .. 3) {
    sleep 1;
    FLTK::wait(1);
}
FLTK::wait();
is(    # XXX - ...timestamps may be off due to processing time; close enough?
    int($C1->value() / 10 ), int(time / 10),
    'After 3 seconds of sleep, the value for Clock is still the current time'
);
is($C2->value(), 0,
    'After 3 seconds of sleep, the value for an orphan Clock is still 0');
