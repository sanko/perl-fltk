#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Rectangle.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More tests => 199;
use Module::Build qw[];
use File::Temp qw[];
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

# 0 width, 0 height, position 0, 0
my $rect_1 = new_ok('FLTK::Rectangle', [], '$rect_1 = new( )');
ok(!$rect_1->contains(10, 10), '  ...does not contain pixel 10,10');

#
my $rect_2 = new_ok('FLTK::Rectangle',
                    [10, 20, 100, 75],
                    '$rect_2 = new( 10, 20, 100, 75 )');
ok(!$rect_2->contains(10, 19), '  ...does not contain pixel 10,19');
ok(!$rect_2->contains(9,  20), '  ...does not contain pixel 9,20');
ok($rect_2->contains(10,  20), '  ...contains pixel 10,20');
ok($rect_2->contains(109, 94), '  ...contains pixel 109,94');
ok(!$rect_2->contains(109, 95), '  ...does not contain pixel 109,95');
ok(!$rect_2->contains(110, 94), '  ...does not contain pixel 110,94');
is($rect_2->x, 10,  '  ...left edge is at 10');
is($rect_2->r, 110, '  ...right edge is at 110');
is($rect_2->y, 20,  '  ...top edge is at 20');
is($rect_2->b, 95,  '  ...bottom edge is at 95');
is($rect_2->w, 100, '  ...is 100 pixels wide');
is($rect_2->h, 75,  '  ...is 75 pixels tall');

#
my $rect_3 = new_ok('FLTK::Rectangle', [100, 50], '$rect_3 = new( 100, 50 )');
is($rect_3->x, 0,   '  ...left edge is at 0');
is($rect_3->r, 100, '  ...right edge is at 100');
is($rect_3->y, 0,   '  ...top edge is at 0');
is($rect_3->b, 50,  '  ...bottom edge is at 50');
is($rect_3->w, 100, '  ...is 100 pixels wide');
is($rect_3->h, 50,  '  ...is 50 pixels tall');

#
my $rect_4 = new_ok('FLTK::Rectangle', [$rect_1], '$rect_4 = new( $rect_1 )');

#
my $rect_5 = new_ok('FLTK::Rectangle',
                    [$rect_1, 20, 200],
                    '$rect_5 = new( $rect_1, 20, 200 )');
is($rect_5->w, 20,  '  ...is 20 pixels wide');
is($rect_5->h, 200, '  ...is 200 pixels tall');

#
my $rect_6 = new_ok('FLTK::Rectangle',
                    [$rect_1, 20, 10, 5],
                    '$rect_6 = new( $rect_1, 20, 10, 5 )');
is($rect_6->w, 20, '  ...is 20 pixels wide');
is($rect_6->h, 10, '  ...is 10 pixels tall');

#
my $rect_7 = new_ok('FLTK::Rectangle',
                    [$rect_2, 100, 300],
                    '$rect_7 = new( $rect_2, 100, 300 )');
is($rect_7->x, 10,  '  ...left edge is at 10');
is($rect_7->r, 110, '  ...right edge is at 110');
is($rect_7->y, -93, '  ...top edge is at -93 (?)');
is($rect_7->b, 207, '  ...bottom edge is at 207 (?)');
is($rect_7->w, 100, '  ...is 100 pixels wide');
is($rect_7->h, 300, '  ...is 300 pixels tall');

# Work with $rect_1
is($rect_1->w(0), undef, '$rect_1->w( 0 );');
is($rect_1->w(),  0,     '  ...width is now 0');
is($rect_1->h(0), undef, '$rect_1->h( 0 );');
is($rect_1->h(),  0,     '  ...height is now 0');
ok($rect_1->empty,      '  ...is empty');
ok(!$rect_1->not_empty, '  ...is not... not empty');
is($rect_1->x(10),  undef, '$rect_1->x( 10 );');
is($rect_1->x(),    10,    '  ...left edge is now 10');
is($rect_1->y(30),  undef, '$rect_1->y( 30 );');
is($rect_1->y(),    30,    '  ...top edge is now 30');
is($rect_1->w(100), undef, '$rect_1->w( 100 );');
is($rect_1->w(),    100,   '  ...width is now 100');
is($rect_1->h(400), undef, '$rect_1->h( 400 );');
is($rect_1->h(),    400,   '  ...height is now 400');
is($rect_1->b,      430,   '  ...bottom edge is at 430');
is($rect_1->r,      110,   '  ...right edge is at 110');
ok(!$rect_1->empty,    '  ...is no longer empty');
ok($rect_1->not_empty, '  ...is not empty');
is($rect_1->set_x(43),  undef, '$rect_1->set_x( 43 );');
is($rect_1->x(),        43,    '  ...left edge is now at 43');
is($rect_1->y(),        30,    '  ...top edge is still at 30');
is($rect_1->w(),        67,    '  ...width is now 67');
is($rect_1->h(),        400,   '  ...height is still 400');
is($rect_1->b,          430,   '  ...bottom edge is still at 430');
is($rect_1->r,          110,   '  ...right edge is still at 110');
is($rect_1->set_y(32),  undef, '$rect_1->set_y( 32 );');
is($rect_1->x(),        43,    '  ...left edge is still at 43');
is($rect_1->y(),        32,    '  ...top edge is now at 32');
is($rect_1->w(),        67,    '  ...width is still at 67');
is($rect_1->h(),        398,   '  ...height is now 398');
is($rect_1->b,          430,   '  ...bottom edge is still at 430');
is($rect_1->r,          110,   '  ...right edge is still at 110');
is($rect_1->set_r(443), undef, '$rect_1->set_r( 443 );');
is($rect_1->x(),        43,    '  ...left edge is still at 43');
is($rect_1->y(),        32,    '  ...top edge is still at 32');
is($rect_1->w(),        400,   '  ...width is now 400');
is($rect_1->h(),        398,   '  ...height is now 398');
is($rect_1->b,          430,   '  ...bottom edge is still at 430');
is($rect_1->r,          443,   '  ...right edge is now at 443');
is($rect_1->set_b(532), undef, '$rect_1->set_b( 532 );');
is($rect_1->x(),        43,    '  ...left edge is still at 43');
is($rect_1->y(),        32,    '  ...top edge is still at 32');
is($rect_1->w(),        400,   '  ...width is still 400');
is($rect_1->h(),        500,   '  ...height is now 500');
is($rect_1->b,          532,   '  ...bottom edge is now at 532');
is($rect_1->r,          443,   '  ...right edge is still at 443');
is($rect_1->set(50, 50, 50, 50), undef, '$rect_1->set( 50, 50, 50, 50 );');
is($rect_1->x(), 50,  '  ...left edge is now at 50');
is($rect_1->y(), 50,  '  ...top edge is now at 50');
is($rect_1->w(), 50,  '  ...width is now 50');
is($rect_1->h(), 50,  '  ...height is now 50');
is($rect_1->b,   100, '  ...bottom edge is now at 100');
is($rect_1->r,   100, '  ...right edge is now at 100');
is($rect_1->set($rect_2, 110, 57), undef,
    '$rect_1->set( $rect_2, 110, 57 );');
is($rect_1->x(), 5,   '  ...left edge is now at 5');
is($rect_1->y(), 29,  '  ...top edge is now at 29');
is($rect_1->w(), 110, '  ...width is now 110');
is($rect_1->h(), 57,  '  ...height is now 57');
is($rect_1->b,   86,  '  ...bottom edge is now at 86');
is($rect_1->r,   115, '  ...right edge is now at 115');
is($rect_1->set($rect_2, 34, 62, 1),
    undef, '$rect_1->set( $rect_2, 34, 62, 1 );');
is($rect_1->x(),        43,    '  ...left edge is now at 43');
is($rect_1->y(),        20,    '  ...top edge is now at 20');
is($rect_1->w(),        34,    '  ...width is now 34');
is($rect_1->h(),        62,    '  ...height is now 62');
is($rect_1->b,          82,    '  ...bottom edge is now at 82');
is($rect_1->r,          77,    '  ...right edge is now at 77');
is($rect_1->move_x(18), undef, '$rect_1->move_x( 18 );');
is($rect_1->x(),        61,    '  ...left edge is now at 61');
is($rect_1->y(),        20,    '  ...top edge is still at 20');
is($rect_1->w(),        16,    '  ...width is now 16');
is($rect_1->h(),        62,    '  ...height is still 62');
is($rect_1->b,          82,    '  ...bottom edge is still at 82');
is($rect_1->r,          77,    '  ...right edge is still at 77');
is($rect_1->move_y(25), undef, '$rect_1->move_y( 25 );');
is($rect_1->x(),        61,    '  ...left edge is still at 61');
is($rect_1->y(),        45,    '  ...top edge is now at 45');
is($rect_1->w(),        16,    '  ...width is still 16');
is($rect_1->h(),        37,    '  ...height is now 37');
is($rect_1->b,          82,    '  ...bottom edge is still at 82');
is($rect_1->r,          77,    '  ...right edge is still at 77');
is($rect_1->move_r(55), undef, '$rect_1->move_r( 55 );');
is($rect_1->x(),        61,    '  ...left edge is still at 61');
is($rect_1->y(),        45,    '  ...top edge is now at 45');
is($rect_1->w(),        71,    '  ...width is now 71');
is($rect_1->h(),        37,    '  ...height is now 37');
is($rect_1->b,          82,    '  ...bottom edge is still at 82');
is($rect_1->r,          132,   '  ...right edge is now at 132');
is($rect_1->move_b(84), undef, '$rect_1->move_b( 84 );');
is($rect_1->x(),        61,    '  ...left edge is still at 61');
is($rect_1->y(),        45,    '  ...top edge is still at 45');
is($rect_1->w(),        71,    '  ...width is now 71');
is($rect_1->h(),        121,   '  ...height is now 121');
is($rect_1->b,          166,   '  ...bottom edge is now at 166');
is($rect_1->r,          132,   '  ...right edge is now at 132');
is($rect_1->inset(5),   undef, '$rect_1->inset( 5 );');
is($rect_1->x(),        66,    '  ...left edge is now at 66');
is($rect_1->y(),        50,    '  ...top edge is now at 50');
is($rect_1->w(),        61,    '  ...width is now 61');
is($rect_1->h(),        111,   '  ...height is now 111');
is($rect_1->b,          161,   '  ...bottom edge is now at 161');
is($rect_1->r,          127,   '  ...right edge is now at 127');
is($rect_1->inset(-12), undef, '$rect_1->inset( -12 );');
is($rect_1->x(),        54,    '  ...left edge is now at 54');
is($rect_1->y(),        38,    '  ...top edge is now at 38');
is($rect_1->w(),        85,    '  ...width is now 85');
is($rect_1->h(),        135,   '  ...height is now 135');
is($rect_1->b,          173,   '  ...bottom edge is now at 173');
is($rect_1->r,          139,   '  ...right edge is now at 139');
is($rect_1->move(57, 0), undef, '$rect_1->move( 57, 0 );');
is($rect_1->x(), 111, '  ...left edge is now at 111');
is($rect_1->y(), 38,  '  ...top edge is now at 38');
is($rect_1->w(), 85,  '  ...width is now 85');
is($rect_1->h(), 135, '  ...height is now 135');
is($rect_1->b,   173, '  ...bottom edge is now at 173');
is($rect_1->r,   196, '  ...right edge is now at 196');
is($rect_1->move(-15, 0), undef, '$rect_1->move( -15, 0 );');
is($rect_1->x(), 96,  '  ...left edge is now at 96');
is($rect_1->y(), 38,  '  ...top edge is now at 38');
is($rect_1->w(), 85,  '  ...width is now 85');
is($rect_1->h(), 135, '  ...height is now 135');
is($rect_1->b,   173, '  ...bottom edge is now at 173');
is($rect_1->r,   181, '  ...right edge is now at 181');
is($rect_1->move(0, 35), undef, '$rect_1->move( 0, 35 );');
is($rect_1->x(), 96,  '  ...left edge is now at 96');
is($rect_1->y(), 73,  '  ...top edge is now at 73');
is($rect_1->w(), 85,  '  ...width is now 85');
is($rect_1->h(), 135, '  ...height is now 135');
is($rect_1->b,   208, '  ...bottom edge is now at 208');
is($rect_1->r,   181, '  ...right edge is now at 181');
is($rect_1->move(0, -54), undef, '$rect_1->move( 0, -54 );');
is($rect_1->x(), 96,  '  ...left edge is now at 96');
is($rect_1->y(), 19,  '  ...top edge is now at 19');
is($rect_1->w(), 85,  '  ...width is now 85');
is($rect_1->h(), 135, '  ...height is now 135');
is($rect_1->b,   154, '  ...bottom edge is now at 154');
is($rect_1->r,   181, '  ...right edge is still at 181');
is($rect_1->move(20, 23), undef, '$rect_1->move( 20, 23 );');
is($rect_1->x(), 116, '  ...left edge is now at 116');
is($rect_1->y(), 42,  '  ...top edge is now at 42');
is($rect_1->w(), 85,  '  ...width is now 85');
is($rect_1->h(), 135, '  ...height is now 135');
is($rect_1->b,   177, '  ...bottom edge is now at 177');
is($rect_1->r,   201, '  ...right edge is now at 201');
is($rect_1->move(-22, -25), undef, '$rect_1->move( -22, -25 );');
is($rect_1->x(), 94,  '  ...left edge is now at 94');
is($rect_1->y(), 17,  '  ...top edge is now at 17');
is($rect_1->w(), 85,  '  ...width is now 85');
is($rect_1->h(), 135, '  ...height is now 135');
is($rect_1->b,   152, '  ...bottom edge is now at 152');
is($rect_1->r,   179, '  ...right edge is now at 179');
is($rect_1->move(0, 0), undef, '$rect_1->move( 0, 0 );');
is($rect_1->x(),        94,  '  ...left edge is now at 94');
is($rect_1->y(),        17,  '  ...top edge is now at 17');
is($rect_1->w(),        85,  '  ...width is now 85');
is($rect_1->h(),        135, '  ...height is now 135');
is($rect_1->b,          152, '  ...bottom edge is now at 152');
is($rect_1->r,          179, '  ...right edge is now at 179');
is($rect_1->center_x(), 136, '  ...center_x is 136');
is($rect_1->center_y(), 84,  '  ...center_y is 84');
is($rect_1->move(25, -65), undef, '$rect_1->move( 25, -65 );');
is($rect_1->center_x(), 161, '  ...center_x is now 161');
is($rect_1->center_y(), 19,  '  ...center_y is now 19');
