#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for functions found in xs/Flags.xsi

=for TODO Everything

=for git $Id$

=cut

use strict;
use warnings;
use Test::More tests => 47;
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
use_ok('FLTK', qw[:flags]);

# Event types and Event Keys imported with :flags tag
for my $sub (qw[ NO_FLAGS
            ALIGN_TOP ALIGN_BOTTOM ALIGN_LEFT ALIGN_RIGHT ALIGN_CENTER
            ALIGN_INSIDE ALIGN_CLIP ALIGN_WRAP ALIGN_MASK
            ALIGN_POSITIONMASK
            ALIGN_TOPLEFT ALIGN_BOTTOMLEFT ALIGN_TOPRIGHT
            ALIGN_BOTTOMRIGHT ALIGN_CENTERLEFT ALIGN_CENTERRIGHT
            ALIGN_INSIDE_TOP ALIGN_INSIDE_BOTTOM ALIGN_INSIDE_LEFT
            ALIGN_INSIDE_TOPLEFT ALIGN_INSIDE_BOTTOMLEFT
            ALIGN_INSIDE_RIGHT ALIGN_INSIDE_TOPRIGHT
            ALIGN_INSIDE_BOTTOMRIGHT ALIGN_MENU ALIGN_BROWSER
            INACTIVE OUTPUT STATE SELECTED INVISIBLE HIGHLIGHT CHANGED
            COPIED_LABEL RAW_LABEL LAYOUT_VERTICAL TAB_TO_FOCUS
            CLICK_TO_FOCUS INACTIVE_R FOCUSED PUSHED RESIZE_NONE
            RESIZE_FIT RESIZE_FILL OPENED ]
    )
{   can_ok(__PACKAGE__, $sub);
}
