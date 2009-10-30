#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/damage.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More tests => 10;
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
use FLTK qw[:damage];

# Event types and Event Keys imported with :event tag
for my $sub (qw[ DAMAGE_CHILD DAMAGE_CHILD_LABEL DAMAGE_EXPOSE DAMAGE_ALL
             DAMAGE_VALUE DAMAGE_PUSHED DAMAGE_SCROLL DAMAGE_OVERLAY
             DAMAGE_HIGHLIGHT DAMAGE_CONTENTS ]
    )
{   can_ok(__PACKAGE__, $sub);
}
