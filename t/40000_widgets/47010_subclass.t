#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Subclass.xsi (Subclassed Widgets)

=for git $Id$

=cut
use strict;
use warnings;
use Test::More tests => 11;
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
use_ok('FLTK', ':events');

#
{

    package Test::Button::Subclass;
    our @ISA = qw[FLTK::Button];

    sub handle {
        my ($obj, $event) = @_;
        ::pass(
             'Test::Button::Subclass->handle(SHOW) called on Widget creation')
            if $event == ::SHOW();
        ::pass(
             'Test::Button::Subclass->handle(HIDE) called on Widget creation')
            if $event == ::HIDE();
        return 1 if $event == ::SHOW();
        return 0;
    }
}
{

    package Test::Input::Subclass;
    our @ISA = qw[FLTK::Input];

    sub handle {
        my ($obj, $event) = @_;
        ::pass('Test::Input::Input->handle(SHOW) called on Widget creation')
            if $event == ::SHOW();
        ::pass('Test::Input::Input->handle(HIDE) called on Widget creation')
            if $event == ::HIDE();
        return 1 if $event == ::SHOW();
        return 0;
    }
}
{

    package Test::CheckButton::Subclass;
    our @ISA = qw[FLTK::CheckButton];

    sub handle {
        my ($obj, $event) = @_;
        ::BAIL_OUT(
            "We should never be in a position to call Test::CheckButton::Subclass->handle($event)"
        );
        return 0;
    }
}

# Outside of a group, handle isn't called because the Widget is never shown
my $W0 = new_ok('Test::CheckButton::Subclass' => [100, 0, 100, 100],
                'new Test::CheckButton::Subclass( 100, 0, 100, 100 )');
isa_ok($W0, 'FLTK::CheckButton', $W0);

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
$W->begin();
my $W1 = new_ok('Test::Button::Subclass' => [0, 0, 100, 100],
                'new Test::Button::Subclass( 0, 0, 100, 100 )');
isa_ok($W1, 'FLTK::Button', $W1);
SKIP: {
    skip 'FLTK::Input has not been dealt with yet.', 4;
    my $W2 = new_ok('Test::Input::Subclass' => [100, 0, 100, 100],
                    'new Test::Input::Subclass( 100, 0, 100, 100 )');
    isa_ok($W2, 'FLTK::Input', $W2);
}

#
$W->end();
$W->show();
FLTK::wait(1);
$W->hide();
