#!perl -I../../../blib/lib -I../../../blib/arch
# FLTK::Widget
#
use strict;
use warnings;
use Test::More tests => 16;
use Module::Build qw[];
use Time::HiRes qw[];
use FLTK qw[];
use File::Spec qw[];
my $test_builder = Test::More->builder;
chdir '../../../' if not -d '_build';
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
my $wid = new FLTK::Widget(50, 80, 200, 100);
isa_ok($wid, 'FLTK::Widget', '$wid     = new FLTK::Widget(50, 80, 200, 100)');
my $wid_lbl = new FLTK::Widget(450, 480, 600, 300, 'label!');
isa_ok($wid_lbl, 'FLTK::Widget',
       '$wid_lbl = new FLTK::Widget(450, 480, 600, 300, "label!")');

#
warn 'TODO: send(event)';

#
ok(!$wid->is_window,     '$wid->is_window() returns false');
ok(!$wid->is_group,      '$wid->is_group() returns false');
ok(!$wid_lbl->is_window, '$wid_lbl->is_window() returns false');
ok(!$wid->is_group,      '$wid_lbl->is_group() returns false');

#
is($wid_lbl->label, 'label!', '$wid_lbl->label() eq "label!"');
is($wid->label, __FILE__, sprintf '$wid->label() eq "%s"', __FILE__);

# From FLTK::Rectangle
is($wid->x,     50,  '$wid->x() == 50');
is($wid->y,     80,  '$wid->y() == 80');
is($wid->w,     200, '$wid->w() == 200');
is($wid->h,     100, '$wid->h() == 100');
is($wid_lbl->x, 450, '$wid_lbl->x() == 50');
is($wid_lbl->y, 480, '$wid_lbl->y() == 480');
is($wid_lbl->w, 600, '$wid_lbl->w() == 600');
is($wid_lbl->h, 300, '$wid_lbl->h() == 300');
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

$Id: 52000_FLTK_Widget.t a404412 2009-03-24 05:36:10Z sanko@cpan.org $


