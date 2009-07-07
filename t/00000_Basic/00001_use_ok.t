#!perl -I../../blib/lib -I../../blib/arch -I../../blib/arch/FLTK/FLTK
# As simple as it gets
#
use strict;
use warnings;
use Test::More tests => 1;
use Module::Build qw[];
use Time::HiRes qw[];
use FLTK qw[];
my $test_builder = Test::More->builder;
chdir '../..' if not -d '_build';
use lib 'inc';
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
Test::More::use_ok('FLTK', qw[:all !ok]); # FLTK::ok() redefines Test::More::ok()

# $Id$
