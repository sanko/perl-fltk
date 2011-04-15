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
plan tests => 10;
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK;
{ package FLTKx::TestButton; use parent-norequire, 'FLTK::Button'; }
{ package FLTKx::TestGroup;  use parent-norequire, 'FLTK::Group'; }

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
my $grp = new_ok('FLTK::Group' => [0, 0, 100, 100],
                 'new FLTK::Group( 0, 0, 100, 100 )');
is($grp, $W->add($grp), 'FLTK::Window->add( $grp ) returns $grp');
my $btn = new_ok('FLTK::Button' => [100, 0, 100, 100],
                 'new FLTK::Button( 100, 0, 100, 100 )');
is($btn, $grp->add($btn), '$grp->add( $btn ) returns $btn');
isa_ok($grp->add(new_ok('FLTK::Input' => [100, 0, 100, 100],
                        'new FLTK::Input( 100, 0, 100, 100 )'
                 )
       ),
       'FLTK::Input',
       '$grp->add( FLTK::Input->new( ... ) ) returns new widget'
);

#
my $subclass_grp = new_ok('FLTKx::TestGroup' => [0, 0, 100, 100],
                          'new FLTKx::TestGroup( 0, 0, 100, 100 )');
is($subclass_grp,
    $W->add($subclass_grp),
    'FLTK::Window->add( $subclass_grp ) returns $subclass_grp');
my $subclass_btn = new_ok('FLTKx::TestButton' => [100, 0, 100, 100],
                          'new FLTKx::TestButton( 100, 0, 100, 100 )');
is($subclass_btn,
    $subclass_grp->add($subclass_btn),
    '$subclass_grp->add( $subclass_btn ) returns $subclass_btn');
