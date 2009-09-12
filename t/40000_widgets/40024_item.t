#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Item.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82 tests => 7;
use Module::Build qw[];
use Time::HiRes qw[];
my $test_builder = Test::More->builder;
chdir '../..' if not -d '_build';
use lib 'inc';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use_ok('FLTK');

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
$W->begin();
my $I_1 = new_ok('FLTK::Item' => [], 'new FLTK::Item( )');
my $I_2
    = new_ok('FLTK::Item' => ["my label"], 'new FLTK::Item( "my label" )');
SKIP: {
    skip '...I need to finish FLTK::Symbol', 1 if !@FLTK::Symbol::ISA;
    my $symbol = new FLTK::Symbol();
    my $I_3 = new_ok('FLTK::Item' => ["my label", 3],
                     'new FLTK::Item( "my label", 3 )');
}
my $I_4;
$I_4 = new_ok(
    'FLTK::Item' => [
        'cf', 2,
        sub {
            pass "Callback works";
            is_deeply(\@_,
                      [$I_4, [1 .. 20]],
                      '  ...and was called with the correct arguments.');
        },
        [1 .. 20],
        3
    ],
    'new FLTK::Item( "cf", 2, sub { ok "Callback works"; ...; }, [1..20], 3 )'
);
$I_4->do_callback;

#
$W->end();
