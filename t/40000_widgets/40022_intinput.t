#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Input.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82 tests => 2;
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
my $I = new_ok('FLTK::IntInput' => [0, 0, 100, 100],
               'new FLTK::IntInput( 0, 0, 100, 100 )');
$W->end();
$W->show();
note 'TODO: test type()';
note '  FLTK::NumericInput is the missing link in the inheritance chain';
