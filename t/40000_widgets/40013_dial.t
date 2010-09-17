#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Dial.xsi

=for git $Id$

=cut
use strict;
use warnings;
use Test::More 0.82 tests => 8;
use Module::Build qw[];
use Time::HiRes qw[];
use Test::NeedsDisplay;
my $test_builder = Test::More->builder;
chdir '../..' if not -d '_build';
use lib 'inc';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK;

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
$W->begin();
my $C0 = new_ok('FLTK::Dial' => [0, 0, 100, 100],
                'new FLTK::Dial( 0, 0, 100, 100 )');
my $C1 = new_ok('FLTK::Dial' => [100, 0, 100, 100],
                'new FLTK::Dial( 100, 0, 100, 100 )');
$W->end();
$W->show() if $interactive;

#
note '$C0->angle1( 10 )';
$C0->angle1(10);
note '$C0->angle2( 100 )';
$C0->angle2(100);
is($C0->angle1(), 10,  'angle1 == 10');
is($C0->angle2(), 100, 'angle2 == 100');
note '$C0->angles( 0, 360 )';
$C0->angles(0, 360);
is($C0->angle1(), 0,   'angle1 == 0');
is($C0->angle2(), 360, 'angle2 == 360');

#
for (0 .. 100) {
    $_ *= 2;
    $C0->value($_ / 10);
    $C1->value((360 - $_) / 100);
    FLTK::wait(0.01);
}

#
is($C0->value(), 20, '$C0->value == 20');
like($C1->value(), qr[^1.6\d*$], '$C1->value is around 1.06');
