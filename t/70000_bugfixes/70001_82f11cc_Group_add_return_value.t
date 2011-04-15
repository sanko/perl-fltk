#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Make sure FLTK::Group->add( $widget ) returns the correct $widget

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82;
use Module::Build qw[];
use Time::HiRes qw[];
use Test::NeedsDisplay ':skip_all';
plan tests => 6;
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK;

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
my $grp = new_ok('FLTK::Group' => [0, 0, 100, 100],
                 'new FLTK::Group( 0, 0, 100, 100 )');
is($grp, $W->add($grp), 'FLTK::Window->add( $group ) returns $group');
my $btn = new_ok('FLTK::Button' => [100, 0, 100, 100],
                 'new FLTK::Button( 100, 0, 100, 100 )');
is($btn, $grp->add($btn), 'FLTK::Group->add( $widget ) returns $widget');
isa_ok($grp->add(new_ok('FLTK::Input' => [100, 0, 100, 100],
                        'new FLTK::Input( 100, 0, 100, 100 )'
                 )
       ),
       'FLTK::Input',
       'FLTK::Group->add( FLTK::Input->new( ... ) ) returns new widget'
);
