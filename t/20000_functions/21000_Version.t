#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for functions found in xs/Version.xsi and lib/FLTK/Version.pm

=for TODO ...create lib/FLTK/Version.pm

=for git $Id$

=cut

use strict;
use warnings;
use Test::More tests => 7;
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
use FLTK qw[:version];

# Imported with version tag
for my $sub (qw[FL_MAJOR_VERSION FL_MINOR_VERSION FL_PATCH_VERSION
             FL_VERSION version])
{   can_ok(__PACKAGE__, $sub);
}
is(FL_MAJOR_VERSION(), 2, 'This was build with the experimental FLTK libs');
is(FL_VERSION(), version(), 'FL_VERSION and version() match');
