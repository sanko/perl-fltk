#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/run.xsi

=for git $Id$

=cut
use strict;
use warnings;
use Test::More 0.82 tests => 1;
use Module::Build qw[];
use Time::HiRes qw[];
use Test::NeedsDisplay;
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK qw[:run];
{
    FLTK::wait(0.01) for 1 .. 60;
    my $i = 0;
    add_timeout(2, sub { $i++; pass 'add_timeout called' });
    for (1 .. 60) { sleep 1; FLTK::wait(1); last if $i; }
}
