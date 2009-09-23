#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/run.xsi

=for git $Id$

=cut
use strict;
use warnings;
use Test::More 0.82 tests => 4;
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
use_ok('FLTK', qw[:run]);

#

{ # add_timeout tests
    sub t_one {pass 'add_timeout called'}
    add_timeout(1, \&t_one);
    ok( FLTK::wait(10), 'wait( 10 ) returns true value there is an event to handle');
    ok(!FLTK::wait(10), 'wait( 10 ) returns false value when there are no events');
}
