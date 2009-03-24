#!perl -I../../blib/lib -I../../blib/arch
# Simple FLTK::Rectangle tests
#
use strict;
use warnings;
use Test::More tests => 138;
use Module::Build qw[];
use Time::HiRes qw[];
use FLTK qw[];
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
new_ok('FLTK::Rectangle' => [], 'new FLTK::Rectangle( )');
new_ok('FLTK::Rectangle' => [200, 100], 'new FLTK::Rectangle( 200, 100 )');
my $rec = new_ok('FLTK::Rectangle' => [50, 80, 200, 100],
                 '$rec = new FLTK::Rectangle( 50, 80, 200, 100 )');
my $rec_empty = new_ok('FLTK::Rectangle' => [0, 80, 200, 100],
                       '$rec_empty = new FLTK::Rectangle( 0, 80, 200, 100 )');
my $rec_extra = new_ok('FLTK::Rectangle' => [500, 800, 50, 50],
                       '$rec_extra = new FLTK::Rectangle( 500, 800, 50, 50 )'
);
new_ok('FLTK::Rectangle' => [$rec], 'new FLTK::Rectangle( $rec )');
new_ok('FLTK::Rectangle' => [$rec, 500, 500],
       'new FLTK::Rectangle( $rec, 500, 500 )');

#
is($rec->x, 50,  'Rectangle\'s left edge is at 50 [x( )].');
is($rec->y, 80,  'Rectangle\'s top  edge is at 80 [y( )].');
is($rec->w, 200, 'Rectangle is 200 pixels wide   [w( )].');
is($rec->h, 100, 'Rectangle is 100 pixels tall   [h( )].');
is($rec->r, 250, 'Rectangle\'s right  edge is at 250 [x( ) + w( )].');
is($rec->b, 180, 'Rectangle\'s bottom edge is at 180 [y( ) + h( )].');

# Change the above values
ok($rec->x(300), 'Rectangle\'s left edge is set to 300 [x( )].');
ok($rec->y(900), 'Rectangle\'s top  edge is set to 900 [y( )].');
ok($rec->w(475), 'Rectangle is set to 475 pixels wide   [w( )].');
ok($rec->h(600), 'Rectangle is 600 pixels tall   [h( )].');
FLTK::check();

# Make sure they were updated
is($rec->x, 300,  'Rectangle\'s left edge is at 300 [x( )].');
is($rec->y, 900,  'Rectangle\'s top  edge is at 900 [y( )].');
is($rec->w, 475,  'Rectangle is 475 pixels wide   [w( )].');
is($rec->h, 600,  'Rectangle is 600 pixels tall   [h( )].');
is($rec->r, 775,  'Rectangle\'s right  edge is at 775 [x( ) + w( )].');
is($rec->b, 1500, 'Rectangle\'s bottom edge is at 1500 [y( ) + h( )].');

# More changes
warn 'set_x(333) changes x( ) without changing r( ), by changing the width';
$rec->set_x(333);
warn 'set_y(666) changes y( ) without changing b( ), by changing the height.';
$rec->set_y(666);
warn 'set_r(444) changes r( ) without changing x( ), by changing the width.';
$rec->set_r(444);
warn 'set_b(888) changes b( ) without changing y( ), by changing the heigh.';
$rec->set_b(888);
FLTK::check();

# Make sure these updated our positions
is($rec->x, 333, 'Rectangle\'s left edge is at 333 [x( )].');
is($rec->y, 666, 'Rectangle\'s top  edge is at 666 [y( )].');
is($rec->w, 111, 'Rectangle is 111 pixels wide   [w( )].');
is($rec->h, 222, 'Rectangle is 222 pixels tall   [h( )].');
is($rec->r, 444, 'Rectangle\'s right  edge is at 444 [x( ) + w( )].');
is($rec->b, 888, 'Rectangle\'s bottom edge is at 888 [y( ) + h( )].');
warn 'TODO: set (int x, int y, int w, int h)';
warn 'TODO: set (const Rectangle & r, int w, int h, int flags = 0)';

# Changes positions
warn
    'move_x(11) adds 11 to x( ) without changing r( ) (it reduces w( ) by 11)';
$rec->move_x(11);
warn
    'move_y(11) adds 11 to y( ) without changing b( ) (it reduces h( ) by 11)';
$rec->move_y(11);
FLTK::check();

# Make sure these updated our positions
is($rec->x, 344, 'Rectangle\'s left edge is at 344 [x( )].');
is($rec->y, 677, 'Rectangle\'s top  edge is at 677 [y( )].');
is($rec->w, 100, 'Rectangle is 100 pixels wide   [w( )].');
is($rec->h, 211, 'Rectangle is 211 pixels tall   [h( )].');
is($rec->r, 444, 'Rectangle\'s right  edge is at 444 [x( ) + w( )].');
is($rec->b, 888, 'Rectangle\'s bottom edge is at 888 [y( ) + h( )].');

# Changes positions
warn 'move_r(11) adds 11 to r( ) and w( )';
$rec->move_r(11);
warn 'move_b(11) adds 11 to b( ) and h( )';
$rec->move_b(11);
FLTK::check();

# Make sure these updated our positions
is($rec->x, 344, 'Rectangle\'s left edge is at 344 [x( )].');
is($rec->y, 677, 'Rectangle\'s top  edge is at 677 [y( )].');
is($rec->w, 111, 'Rectangle is 111 pixels wide   [w( )].');
is($rec->h, 222, 'Rectangle is 222 pixels tall   [h( )].');
is($rec->r, 455, 'Rectangle\'s right  edge is at 455 [x( ) + w( )].');
is($rec->b, 899, 'Rectangle\'s bottom edge is at 899 [y( ) + h( )].');

# Changes size
warn 'inset( 10 ) moves all edges in by 10 pixels.';
$rec->inset(10);
FLTK::check();

# Make sure these updated our positions
is($rec->x, 354, 'Rectangle\'s left edge is at 354 [x( )].');
is($rec->y, 687, 'Rectangle\'s top  edge is at 687 [y( )].');
is($rec->w, 91,  'Rectangle is 91 pixels wide   [w( )].');
is($rec->h, 202, 'Rectangle is 202 pixels tall   [h( )].');
is($rec->r, 445, 'Rectangle\'s right  edge is at 445 [x( ) + w( )].');
is($rec->b, 889, 'Rectangle\'s bottom edge is at 889 [y( ) + h( )].');

# Changes position
warn 'move( 150, 250 ) movs entire rectangle by given distance in x and y.';
$rec->move(150, 250);
FLTK::check();

# Make sure these updated our positions
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 91,   'Rectangle is 91 pixels wide   [w( )].');
is($rec->h, 202,  'Rectangle is 202 pixels tall   [h( )].');
is($rec->r, 595,  'Rectangle\'s right  edge is at 595 [x( ) + w( )].');
is($rec->b, 1139, 'Rectangle\'s bottom edge is at 1139 [y( ) + h( )].');

# Checks sizes
ok(!$rec->empty(),
    'empty( ) is true if w( ) and h( ) are less or equal to zero.');

# Change sizes
is($rec->w(0), 0, '...w( 0 )');
ok($rec->h(500), '...h( 500 )');

# Check sizes
ok($rec->empty,
    'empty( ) is true if w( ) and h( ) are less or equal to zero.');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 0,    'Rectangle is 0 pixels wide   [w( )].');
is($rec->h, 500,  'Rectangle is 500 pixels tall   [h( )].');
is($rec->r, 504,  'Rectangle\'s right  edge is at 504 [x( ) + w( )].');
is($rec->b, 1437, 'Rectangle\'s bottom edge is at 1437 [y( ) + h( )].');

# Change sizes
ok($rec->w(500), '...w( 500 )');
ok($rec->h(500), '...h( 500 )');

# Check sizes
ok(!$rec->empty,
    'empty( ) is true if w( ) and h( ) are less or equal to zero.');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 500,  'Rectangle is 500 pixels wide   [w( )].');
is($rec->h, 500,  'Rectangle is 500 pixels tall   [h( )].');
is($rec->r, 1004, 'Rectangle\'s right  edge is at 1004 [x( ) + w( )].');
is($rec->b, 1437, 'Rectangle\'s bottom edge is at 1437 [y( ) + h( )].');

# Change sizes
ok($rec->w(500), '...w( 500 )');
is($rec->h(0), 0, '...h( 0 )');

# Check sizes
ok($rec->empty,
    'empty( ) is true if w( ) and h( ) are less or equal to zero.');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 500,  'Rectangle is 500 pixels wide   [w( )].');
is($rec->h, 0,    'Rectangle is 0 pixels tall   [h( )].');
is($rec->r, 1004, 'Rectangle\'s right  edge is at 1004 [x( ) + w( )].');
is($rec->b, 937,  'Rectangle\'s bottom edge is at 937 [y( ) + h( )].');

# Change sizes
ok($rec->w(500), '...w( 500 )');
ok($rec->h(500), '...h( 500 )');

# Check sizes
ok(!$rec->empty,
    'empty( ) is true if w( ) and h( ) are less or equal to zero.');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 500,  'Rectangle is 500 pixels wide   [w( )].');
is($rec->h, 500,  'Rectangle is 500 pixels tall   [h( )].');
is($rec->r, 1004, 'Rectangle\'s right  edge is at 1004 [x( ) + w( )].');
is($rec->b, 1437, 'Rectangle\'s bottom edge is at 1437 [y( ) + h( )].');

# Checks sizes
ok($rec->not_empty,
    'not_empty( ) is true if w( ) and h( ) are both greater than zero..');

# Change sizes
is($rec->w(0), 0, '...w( 0 )');
ok($rec->h(500), '...h( 500 )');

# Check sizes
ok(!$rec->not_empty,
    'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 0,    'Rectangle is 0 pixels wide   [w( )].');
is($rec->h, 500,  'Rectangle is 500 pixels tall   [h( )].');
is($rec->r, 504,  'Rectangle\'s right  edge is at 504 [x( ) + w( )].');
is($rec->b, 1437, 'Rectangle\'s bottom edge is at 1437 [y( ) + h( )].');

# Change sizes
ok($rec->w(500), '...w( 500 )');
ok($rec->h(500), '...h( 500 )');

# Check sizes
ok($rec->not_empty,
    'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 500,  'Rectangle is 500 pixels wide   [w( )].');
is($rec->h, 500,  'Rectangle is 500 pixels tall   [h( )].');
is($rec->r, 1004, 'Rectangle\'s right  edge is at 1004 [x( ) + w( )].');
is($rec->b, 1437, 'Rectangle\'s bottom edge is at 1437 [y( ) + h( )].');

# Change sizes
ok($rec->w(500), '...w( 500 )');
is($rec->h(0), 0, '...h( 0 )');

# Check sizes
ok(!$rec->not_empty,
    'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 500,  'Rectangle is 500 pixels wide   [w( )].');
is($rec->h, 0,    'Rectangle is 0 pixels tall   [h( )].');
is($rec->r, 1004, 'Rectangle\'s right  edge is at 1004 [x( ) + w( )].');
is($rec->b, 937,  'Rectangle\'s bottom edge is at 937 [y( ) + h( )].');

# Change sizes
ok($rec->w(500), '...w( 500 )');
ok($rec->h(500), '...h( 500 )');

# Check sizes
ok($rec->not_empty,
    'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
is($rec->x, 504,  'Rectangle\'s left edge is at 504 [x( )].');
is($rec->y, 937,  'Rectangle\'s top  edge is at 937 [y( )].');
is($rec->w, 500,  'Rectangle is 500 pixels wide   [w( )].');
is($rec->h, 500,  'Rectangle is 500 pixels tall   [h( )].');
is($rec->r, 1004, 'Rectangle\'s right  edge is at 1004 [x( ) + w( )].');
is($rec->b, 1437, 'Rectangle\'s bottom edge is at 1437 [y( ) + h( )].');

# More changes
warn 'set(50, 50, 50, 50) changes x( ), y( ), w( ), and h( ) all at once';
$rec->set(50, 50, 50, 50);
warn 'TODO: set (const Rectangle & r, int w, int h, int flags = 0)';
FLTK::check();

# Make sure these updated our positions
is($rec->x, 50,  'Rectangle\'s left edge is at 50 [x( )].');
is($rec->y, 50,  'Rectangle\'s top  edge is at 50 [y( )].');
is($rec->w, 50,  'Rectangle is 50 pixels wide   [w( )].');
is($rec->h, 50,  'Rectangle is 50 pixels tall   [h( )].');
is($rec->r, 100, 'Rectangle\'s right  edge is at 100 [x( ) + w( )].');
is($rec->b, 100, 'Rectangle\'s bottom edge is at 100 [y( ) + h( )].');

# Various size checks
is($rec->center_x(), 75,
    'Integer center position. Rounded to the left if w( ) is odd.');
is($rec->center_y(), 75,
    'Integer center position. Rounded to lower y if h( ) is odd.');
SKIP: {
    skip('XXX - I have not yet figured out why baseline_y fails...', 1);
    is($rec->baseline_y(), 1192,
        'Where to put baseline to center current font nicely.');
}

#
ok($rec->contains(55, 55), 'Rectangle contains( 55, 55 )');
ok(!$rec->contains(101, 101), 'Rectangle does not contain x:101, y:101');

#
warn 'TODO: merge()';
warn 'TODO: intersect()';
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

$Id: 50001_FLTK_Rectangle.t a404412 2009-03-24 05:36:10Z sanko@cpan.org $
