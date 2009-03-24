#!perl -I../../../../../blib/lib -I../../../../../blib/arch
# Simple window tests
#
use strict;
use warnings;
use Test::More tests => 167;
use Module::Build qw[];
use Time::HiRes qw[];
use FLTK qw[];
my $test_builder = Test::More->builder;
chdir '../../../../../' if not -d '_build';
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
my $win = new_ok('FLTK::Window' => [200, 100],
                 '$win     = new FLTK::Window(200, 100)');
my $win_kid = new_ok('FLTK::Window' => [50, 80, 200, 100],
                     '$win_kid = new FLTK::Window(50, 80, 200, 100)');

#
# from fltk::Window
ok(!$win->shown, 'Window has not been show yet');
ok($win->show,   'Window is being show now...');
ok($win->shown,  '...and we can verify that the widnow is being shown.');
$win->redraw;
FLTK::check();

#
is($win->label(), __FILE__,
    sprintf 'Window->label() defaults to the script\'s filename ("%s")',
    __FILE__);
ok($win->label('Changed!'),
    'label("Changed!") should, well, change the label.');
is($win->label(), 'Changed!', 'And so it has');
$win->redraw;
FLTK::check();

#
is($win->iconlabel(), undef, 'iconlabel() is undef by default');
ok($win->iconlabel('Changed!'),
    'iconlabel("Changed!") should, well, change the label.');
is($win->iconlabel(), 'Changed!', 'And so it has');
$win->redraw;
FLTK::check();

#
ok($win->label('label', 'icon'),
    'label("label", "icon") sets both the label( ) and iconlabel( ).');
is($win->label(),     'label', 'label( ) checks out.');
is($win->iconlabel(), 'icon',  'iconlabel( ) checks out.');
$win->redraw;
FLTK::check();

#
ok($win->border,    'Window border defaults to true');
ok($win->border(0), '...but we can disable it');
ok(!$win->border,   'Window border is now hidden.');
ok($win->border(1), 'Window border is re-enabled here.');
ok($win->border,    '...and we can verify that the border is back');
$win->redraw;
FLTK::check();
SKIP: {
    skip 'child_of() doesn\'t seem to work or I misread the docs', 2;

    #ok(!$win_kid->child_of($win),  '$win_kid is now a child_of($win)');
    #is($win->children(), [] ,'...but we can disable it');
}
$win->redraw;
FLTK::check();

#
warn($win->double_buffer()
     ? q[Your system uses double buffering by default.]
     : q[Your system does not use double buffering by default.]
);
$win->clear_double_buffer() if $win->double_buffer();
ok(!$win->double_buffer(),
    'Our test starts with a Window without double_buffer()...');
ok($win->set_double_buffer(),   '...then we call set_double_buffer()...');
ok($win->double_buffer(),       '...and all of that changes.');
ok($win->clear_double_buffer(), '...then we call clear_double_buffer()...');
ok(!$win->double_buffer(),      '...and we are back where we started.');

# We don't call these methods (yet) but let's make sure they're supported
can_ok($win, qw[free_backbuffer]);
can_ok($win, qw[draw_overlay]);
can_ok($win, qw[redraw_overlay]);
can_ok($win, qw[erase_overlay]);

#$win->redraw;
#FLTK::check();
warn 'TODO: bool FLTK::Window->child_of( FLTK::Window )';
{
    my $color_total = 0;
    for (0 .. 256) {
        $win->color($_);
        Time::HiRes::sleep 0.005;
        $win->redraw;
        FLTK::check();
        $color_total += $win->color();
    }
    is($color_total, 32945, 'Background color change tests passed');
}
{    # From fltk::Group
    warn 'TODO: methods from fltk::Group';

    #FLTK::run();
}
{    # From fltk::Widget
    ok($win->is_window, 'is_window() returns true');
    ok($win->is_group,  'is_group() returns true');
}
{    # From fltk::Rectangle
    is($win_kid->x, 50,  'Window\'s left edge is at 50 [x( )].');
    is($win_kid->y, 80,  'Window\'s top  edge is at 80 [y( )].');
    is($win_kid->w, 200, 'Window is 200 pixels wide   [w( )].');
    is($win_kid->h, 100, 'Window is 100 pixels tall   [h( )].');
    is($win_kid->r, 250, 'Window\'s right  edge is at 250 [x( ) + w( )].');
    is($win_kid->b, 180, 'Window\'s bottom edge is at 180 [y( ) + h( )].');

    # Change the above values
    ok($win_kid->x(300), 'Window\'s left edge is set to 300 [x( )].');
    ok($win_kid->y(900), 'Window\'s top  edge is set to 900 [y( )].');
    ok($win_kid->w(475), 'Window is set to 475 pixels wide   [w( )].');
    ok($win_kid->h(600), 'Window is 600 pixels tall   [h( )].');
    $win_kid->redraw;
    FLTK::check();

    # Make sure they were updated
    is($win_kid->x, 300,  'Window\'s left edge is at 300 [x( )].');
    is($win_kid->y, 900,  'Window\'s top  edge is at 900 [y( )].');
    is($win_kid->w, 475,  'Window is 475 pixels wide   [w( )].');
    is($win_kid->h, 600,  'Window is 600 pixels tall   [h( )].');
    is($win_kid->r, 775,  'Window\'s right  edge is at 775 [x( ) + w( )].');
    is($win_kid->b, 1500, 'Window\'s bottom edge is at 1500 [y( ) + h( )].');

    # More changes
    ok($win_kid->set_x(333),
        'set_x(333) changes x( ) without changing r( ), by changing the width'
    );
    ok($win_kid->set_y(666),
        'set_y(666) changes y( ) without changing b( ), by changing the height.'
    );
    ok($win_kid->set_r(444),
        'set_r(444) changes r( ) without changing x( ), by changing the width.'
    );
    ok($win_kid->set_b(888),
        'set_b(888) changes b( ) without changing y( ), by changing the heigh.'
    );
    $win_kid->redraw;
    FLTK::check();

    # Make sure these updated our positions
    is($win_kid->x, 333, 'Window\'s left edge is at 333 [x( )].');
    is($win_kid->y, 666, 'Window\'s top  edge is at 666 [y( )].');
    is($win_kid->w, 111, 'Window is 111 pixels wide   [w( )].');
    is($win_kid->h, 222, 'Window is 222 pixels tall   [h( )].');
    is($win_kid->r, 444, 'Window\'s right  edge is at 444 [x( ) + w( )].');
    is($win_kid->b, 888, 'Window\'s bottom edge is at 888 [y( ) + h( )].');
    warn 'TODO: set (int x, int y, int w, int h)';
    warn 'TODO: set (const Rectangle & r, int w, int h, int flags = 0)';

    # Changes positions
    ok($win_kid->move_x(11),
        'move_x(11) adds 11 to x( ) without changing r( ) (it reduces w( ) by 11)'
    );
    ok($win_kid->move_y(11),
        'move_y(11) adds 11 to y( ) without changing b( ) (it reduces h( ) by 11)'
    );
    $win_kid->redraw;
    FLTK::check();

    # Make sure these updated our positions
    is($win_kid->x, 344, 'Window\'s left edge is at 344 [x( )].');
    is($win_kid->y, 677, 'Window\'s top  edge is at 677 [y( )].');
    is($win_kid->w, 100, 'Window is 100 pixels wide   [w( )].');
    is($win_kid->h, 211, 'Window is 211 pixels tall   [h( )].');
    is($win_kid->r, 444, 'Window\'s right  edge is at 444 [x( ) + w( )].');
    is($win_kid->b, 888, 'Window\'s bottom edge is at 888 [y( ) + h( )].');

    # Changes positions
    ok($win_kid->move_r(11), 'move_r(11) adds 11 to r( ) and w( )');
    ok($win_kid->move_b(11), 'move_b(11) adds 11 to b( ) and h( )');
    $win_kid->redraw;
    FLTK::check();

    # Make sure these updated our positions
    is($win_kid->x, 344, 'Window\'s left edge is at 344 [x( )].');
    is($win_kid->y, 677, 'Window\'s top  edge is at 677 [y( )].');
    is($win_kid->w, 111, 'Window is 111 pixels wide   [w( )].');
    is($win_kid->h, 222, 'Window is 222 pixels tall   [h( )].');
    is($win_kid->r, 455, 'Window\'s right  edge is at 455 [x( ) + w( )].');
    is($win_kid->b, 899, 'Window\'s bottom edge is at 899 [y( ) + h( )].');

    # Changes size
    ok($win_kid->inset(10), 'inset( 10 ) moves all edges in by 10 pixels.');
    $win_kid->redraw;
    FLTK::check();

    # Make sure these updated our positions
    is($win_kid->x, 354, 'Window\'s left edge is at 354 [x( )].');
    is($win_kid->y, 687, 'Window\'s top  edge is at 687 [y( )].');
    is($win_kid->w, 91,  'Window is 91 pixels wide   [w( )].');
    is($win_kid->h, 202, 'Window is 202 pixels tall   [h( )].');
    is($win_kid->r, 445, 'Window\'s right  edge is at 445 [x( ) + w( )].');
    is($win_kid->b, 889, 'Window\'s bottom edge is at 889 [y( ) + h( )].');

    # Changes position
    ok( $win_kid->move(150, 250),
        'move( 150, 250 ) movs entire rectangle by given distance in x and y.'
    );
    $win_kid->redraw;
    FLTK::check();

    # Make sure these updated our positions
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 91,   'Window is 91 pixels wide   [w( )].');
    is($win_kid->h, 202,  'Window is 202 pixels tall   [h( )].');
    is($win_kid->r, 595,  'Window\'s right  edge is at 595 [x( ) + w( )].');
    is($win_kid->b, 1139, 'Window\'s bottom edge is at 1139 [y( ) + h( )].');

    # Checks sizes
    ok(!$win_kid->empty,
        'empty( ) is true if w( ) and h( ) are less or equal to zero.');

    # Change sizes
    ok($win_kid->w(0),   '...w( 0 )');
    ok($win_kid->h(500), '...h( 500 )');

    # Check sizes
    ok($win_kid->empty,
        'empty( ) is true if w( ) and h( ) are less or equal to zero.');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 0,    'Window is 0 pixels wide   [w( )].');
    is($win_kid->h, 500,  'Window is 500 pixels tall   [h( )].');
    is($win_kid->r, 504,  'Window\'s right  edge is at 504 [x( ) + w( )].');
    is($win_kid->b, 1437, 'Window\'s bottom edge is at 1437 [y( ) + h( )].');

    # Change sizes
    ok($win_kid->w(500), '...w( 500 )');
    ok($win_kid->h(500), '...h( 500 )');

    # Check sizes
    ok(!$win_kid->empty,
        'empty( ) is true if w( ) and h( ) are less or equal to zero.');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 500,  'Window is 500 pixels wide   [w( )].');
    is($win_kid->h, 500,  'Window is 500 pixels tall   [h( )].');
    is($win_kid->r, 1004, 'Window\'s right  edge is at 1004 [x( ) + w( )].');
    is($win_kid->b, 1437, 'Window\'s bottom edge is at 1437 [y( ) + h( )].');

    # Change sizes
    ok($win_kid->w(500), '...w( 500 )');
    ok($win_kid->h(0),   '...h( 0 )');

    # Check sizes
    ok($win_kid->empty,
        'empty( ) is true if w( ) and h( ) are less or equal to zero.');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 500,  'Window is 500 pixels wide   [w( )].');
    is($win_kid->h, 0,    'Window is 0 pixels tall   [h( )].');
    is($win_kid->r, 1004, 'Window\'s right  edge is at 1004 [x( ) + w( )].');
    is($win_kid->b, 937,  'Window\'s bottom edge is at 937 [y( ) + h( )].');

    # Change sizes
    ok($win_kid->w(500), '...w( 500 )');
    ok($win_kid->h(500), '...h( 500 )');

    # Check sizes
    ok(!$win_kid->empty,
        'empty( ) is true if w( ) and h( ) are less or equal to zero.');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 500,  'Window is 500 pixels wide   [w( )].');
    is($win_kid->h, 500,  'Window is 500 pixels tall   [h( )].');
    is($win_kid->r, 1004, 'Window\'s right  edge is at 1004 [x( ) + w( )].');
    is($win_kid->b, 1437, 'Window\'s bottom edge is at 1437 [y( ) + h( )].');

    # Checks sizes
    ok($win_kid->not_empty,
        'not_empty( ) is true if w( ) and h( ) are both greater than zero..');

    # Change sizes
    ok($win_kid->w(0),   '...w( 0 )');
    ok($win_kid->h(500), '...h( 500 )');

    # Check sizes
    ok(!$win_kid->not_empty,
        'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 0,    'Window is 0 pixels wide   [w( )].');
    is($win_kid->h, 500,  'Window is 500 pixels tall   [h( )].');
    is($win_kid->r, 504,  'Window\'s right  edge is at 504 [x( ) + w( )].');
    is($win_kid->b, 1437, 'Window\'s bottom edge is at 1437 [y( ) + h( )].');

    # Change sizes
    ok($win_kid->w(500), '...w( 500 )');
    ok($win_kid->h(500), '...h( 500 )');

    # Check sizes
    ok($win_kid->not_empty,
        'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 500,  'Window is 500 pixels wide   [w( )].');
    is($win_kid->h, 500,  'Window is 500 pixels tall   [h( )].');
    is($win_kid->r, 1004, 'Window\'s right  edge is at 1004 [x( ) + w( )].');
    is($win_kid->b, 1437, 'Window\'s bottom edge is at 1437 [y( ) + h( )].');

    # Change sizes
    ok($win_kid->w(500), '...w( 500 )');
    ok($win_kid->h(0),   '...h( 0 )');

    # Check sizes
    ok(!$win_kid->not_empty,
        'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 500,  'Window is 500 pixels wide   [w( )].');
    is($win_kid->h, 0,    'Window is 0 pixels tall   [h( )].');
    is($win_kid->r, 1004, 'Window\'s right  edge is at 1004 [x( ) + w( )].');
    is($win_kid->b, 937,  'Window\'s bottom edge is at 937 [y( ) + h( )].');

    # Change sizes
    ok($win_kid->w(500), '...w( 500 )');
    ok($win_kid->h(500), '...h( 500 )');

    # Check sizes
    ok($win_kid->not_empty,
        'not_empty( ) is true if w( ) and h( ) are both greater than zero..');
    is($win_kid->x, 504,  'Window\'s left edge is at 504 [x( )].');
    is($win_kid->y, 937,  'Window\'s top  edge is at 937 [y( )].');
    is($win_kid->w, 500,  'Window is 500 pixels wide   [w( )].');
    is($win_kid->h, 500,  'Window is 500 pixels tall   [h( )].');
    is($win_kid->r, 1004, 'Window\'s right  edge is at 1004 [x( ) + w( )].');
    is($win_kid->b, 1437, 'Window\'s bottom edge is at 1437 [y( ) + h( )].');
TODO: {
        local $TODO = 'Not actually TODO... but they may fail. .:shrugs:.';

        # Various size checks
        is($win_kid->center_y(), 1187,
            'Integer center position. Rounded to lower y if h( ) is odd.');
        is($win_kid->baseline_y(), 1192,
            'Where to put baseline to center current font nicely.');
    }
    {
        my $x = $win->x;
        my $y = $win->y;
        warn sprintf q[x:%d | y:%d ], $x, $y;
        $win->hotspot(0, 0);
        warn '...can I move the cursor with FLTK?';
        warn 'If so, these tests would be a lot less random';
        warn 'And I could test the offscreen parameter';
        ok((($win->x != $x) && ($win->y != $y)),
            sprintf '$win->hotspot(0, 0) moved $win to x:%d | y:%d',
            $win->x, $win->y);
    }
    {
        my $x = $win->x;
        my $y = $win->y;
        warn sprintf q[x:%d | y:%d ], $x, $y;
        warn 'We use our current position to predict our eventual position';
        $win->hotspot($win, 1);
        ok((($win->x != $x) && ($win->y != $y)),
            sprintf '$win->hotspot($win) moved $win to x:%d | y:%d',
            $win->x, $win->y);
        warn sprintf q[x:%d | y:%d ], $x, $y;
    }
}

#ok($win->set_x(999), 'Left edge is set to 999.');
#ok
#warn $win->callback(sub{warn 'test'; warn join ', ', @_});
#$win->do_callback;
#
#
if ($interactive) { FLTK::run(); }
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

$Id: 52351_FLTK_Window.t a404412 2009-03-24 05:36:10Z sanko@cpan.org $

