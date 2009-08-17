#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Subclass.xsi (Subclassed Widgets)

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
$SIG{__WARN__} = (
    $verbose
    ? sub {
        diag(sprintf('%02.4f', Time::HiRes::time- $^T), ' ', shift);
        }
    : sub { }
);

#
my @classes = sort qw[
                       Button
                       CheckButton
];
plan tests => 1 + 6 * scalar @classes;    # Order of operations ftw!
use_ok('FLTK', ':events');

#
my $TEMPLATE = <<'';
{
    package Test::%s;
    our @ISA = qw[FLTK::%s];
    sub handle {
        my ($obj, $event) = @_;
        ::pass(
             'Test::%s->handle(SHOW) called on Widget creation')
            if $event == ::SHOW();
        ::pass(
             'Test::%s->handle(HIDE) called on Widget creation')
            if $event == ::HIDE();
        return 1 if $event == ::SHOW();
        return 0;
    }
}
{
    package Hidden::%s;
    our @ISA = qw[FLTK::%s];
    sub handle {
        my ($obj, $event) = @_;
        ::BAIL_OUT(
            "We should never be in a position to call Hidden::%s->handle($event)"
        );
        return 0;
    }
}


#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');

#
for my $class (@classes) {
SKIP: {
        skip "I can't seem to find class FLTK::$class", 6
            if !scalar eval '@FLTK::' . $class . '::ISA';
        eval sprintf $TEMPLATE, map {$class} 0 .. 8;
        my $W0 = new_ok("Hidden::$class" => [100, 0, 100, 100],
                        "new Hidden::$class ( 100, 0, 100, 100 )");
        isa_ok($W0, "FLTK::$class", $W0);
        $W->begin();    # Inside of the group should be seen
        my $W1 = new_ok("Test::$class" => [0, 0, 100, 100],
                        "new Test::$class ( 0, 0, 100, 100 )");
        isa_ok($W1, "FLTK::$class", $W1);
        $W->end();
        $W->show();
        FLTK::wait(1);
        $W->hide();
        $W1->destroy();
        $W0->destroy();
    }
}
