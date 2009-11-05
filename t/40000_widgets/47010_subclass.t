#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for (Subclassed Widgets)

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82;
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
plan tests => 6;
use FLTK qw[:events];

#
{

    package FLTKx::TestButton;
    our @ISA = qw[FLTK::Button];

    sub handle {
        my ($obj, $event) = @_;
        ::pass('FLTKx::TestButton->handle(SHOW) called on Widget creation')
            if $event == ::SHOW();
        ::pass('FLTKx::TestButton->handle(HIDE) called on Widget creation')
            if $event == ::HIDE();
        return 1 if $event == ::SHOW();
        return 0;
    }
}
{

    package FLTKx::Test::HiddenButton;
    our @ISA = qw[FLTK::Button];

    sub handle {
        my ($obj, $event) = @_;
        ::BAIL_OUT(
            "We should never be in a position to call FLTKx::Test::HiddenButton->handle($event)"
        );
        return 0;
    }
}

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');

#
my $W0 = new_ok("FLTKx::Test::HiddenButton" => [100, 0, 100, 100],
                "new FLTKx::Test::HiddenButton ( 100, 0, 100, 100 )");
isa_ok($W0, "FLTKx::Test::HiddenButton", $W0);
$W->begin();    # Inside of the group should be seen
my $W1 = new_ok("FLTKx::TestButton" => [0, 0, 100, 100],
                "new FLTKx::TestButton ( 0, 0, 100, 100 )");
isa_ok($W1, "FLTKx::TestButton", $W1);
$W->end();
$W->show();     # if $interactive;
FLTK::wait(1);
$W->hide();
$W1->destroy();
$W0->destroy();
