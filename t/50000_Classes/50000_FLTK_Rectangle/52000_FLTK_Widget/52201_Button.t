#!perl -I../../../../blib/lib -I../../../../blib/arch
# Simple button tests
#
use strict;
use warnings;
use Test::More;
use Module::Build qw[];
use Time::HiRes qw[];
use FLTK qw[];
my $test_builder = Test::More->builder;
chdir '../../../../' if not -d '_build';
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
my @btn_types = map { 'FLTK::' . $_ } qw[Button CheckButton LightButton
    RadioButton HighlightButton RepeatButton ReturnButton ToggleButton];

#
plan tests => (scalar(@btn_types) * 9) + 1 + 1;
my $win = new_ok('FLTK::Window' => [160, (scalar(@btn_types) * 25) + 5],
                 'new FLTK::Window(200, 100)');
$win->show;
$win->begin();
my $i = -1;
my @btns;
for my $class (@btn_types) {
    my $btn = $class->new(5, ((++$i * 25) + 5), 150, 20, $class);
    isa_ok($btn, $class, sprintf '%s->new(5, %d, 80, 20, "%s")',
           $class, (($i * 25) + 5), $class);
    ok(!$btn->value, 'Null value at beginning');
    warn '...we set it to true here...';
    $btn->value(1);
    is($btn->value, 1, '...and verify it\'s true here.');
    warn 'Now, let\'s set it to false...';
    $btn->value(0);
    ok(!$btn->value, '...and make sure of it here.');
    is($btn->label(), $class, sprintf 'Label is okay (%s)', $class);
    ok($btn->label('Update'), 'Changed label.');
    is($btn->label(), 'Update', 'Verify label was changed.');
    $btn->callback(
        sub {
            isa_ok(shift, $class, 'Callback triggered. First param');
        }
    );
    ok($btn->do_callback(), sprintf '%s->do_callback()', $class);
    push @btns, $btn;
}
$win->end();
{
    my $color_total = 0;
    for my $i (0 .. 256) {
        $_->color($i) && $_->label("Color: $i") for @btns;
        Time::HiRes::sleep 0.008;
        $win->redraw;
        FLTK::check();
        $color_total += $btns[0]->color();
    }
    is($color_total, 32640, 'Background color change tests passed');
}
if ($interactive) { FLTK::run(); }
__END__
Copyright (C) 2009 by Sanko Robinson <sanko@cpan.org>

This program is free software; you can redistribute it and/or modify it
under the terms of The Artistic License 2.0.  See the LICENSE file
included with this distribution or
http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered by
the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

$Id: 52201_Button.t 43c1956 2009-03-24 16:25:46Z sanko@cpan.org $
