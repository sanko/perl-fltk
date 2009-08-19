#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for functions found in xs/draw.xsi

=for TODO Everything

=for git $Id$

=cut

use strict;
use warnings;
use Test::More tests => 63;
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
use_ok('FLTK', qw[:draw]);

# imported with :draw tag
for my $sub (qw[ push_matrix pop_matrix scale translate rotate concat
             load_identity transform push_clip clipout pop_clip push_no_clip
             not_clipped intersect_with_clip setcolor setcolor_alpha getcolor
             drawstyle setdrawflags drawflags line_style line_width
             line_dashes SOLID DASH DOT DASHDOT DASHDOTDOT CAP_FLAT CAP_ROUND
             CAP_SQUARE JOIN_MITER JOIN_ROUND JOIN_BEVEL newpath addvertex
             addvertices addvertices_transformed addcurve addarc addpie
             addchord closepath strokepath fillpath fillstrokepath fillrect
             strokerect drawline drawpoint setfont getfont getsize getwidth
             getdescent drawtext_transformed drawtext measure column_widths
             drawimage readimage ]
    )
{   can_ok(__PACKAGE__, $sub);
}

TODO: {
    local $TODO = 'scrollrect(...) is incomplete...';
    can_ok(__PACKAGE__, 'scrollrect');
}
