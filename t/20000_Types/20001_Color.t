#!perl -I../../blib/lib -I../../blib/arch -Iinc
# Color typedef tests
#
use strict;
use warnings;
use Test::More tests => 146;
use Module::Build qw[];
use Time::HiRes qw[];
use FLTK qw[:color];
my $test_builder = Test::More->builder;
chdir '../../' if not -d '_build';
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
{
    my %named_colors = (
                  RED            => {in => &RED,            out => 88},
                  BLUE           => {in => &BLUE,           out => 571565568},
                  CYAN           => {in => &CYAN,           out => 572666624},
                  BLACK          => {in => &BLACK,          out => 56},
                  GREEN          => {in => &GREEN,          out => 63},
                  WHITE          => {in => &WHITE,          out => 576017664},
                  GRAY00         => {in => &GRAY00,         out => 32},
                  GRAY05         => {in => &GRAY05,         out => 33},
                  GRAY10         => {in => &GRAY10,         out => 34},
                  GRAY15         => {in => &GRAY15,         out => 35},
                  GRAY20         => {in => &GRAY20,         out => 36},
                  GRAY25         => {in => &GRAY25,         out => 37},
                  GRAY30         => {in => &GRAY30,         out => 38},
                  GRAY33         => {in => &GRAY33,         out => 39},
                  GRAY35         => {in => &GRAY35,         out => 40},
                  GRAY40         => {in => &GRAY40,         out => 41},
                  GRAY45         => {in => &GRAY45,         out => 42},
                  GRAY50         => {in => &GRAY50,         out => 43},
                  GRAY55         => {in => &GRAY55,         out => 44},
                  GRAY60         => {in => &GRAY60,         out => 45},
                  GRAY65         => {in => &GRAY65,         out => 46},
                  GRAY66         => {in => &GRAY66,         out => 47},
                  GRAY70         => {in => &GRAY70,         out => 48},
                  GRAY75         => {in => &GRAY75,         out => 49},
                  GRAY80         => {in => &GRAY80,         out => 50},
                  GRAY85         => {in => &GRAY85,         out => 51},
                  GRAY90         => {in => &GRAY90,         out => 53},
                  GRAY95         => {in => &GRAY95,         out => 54},
                  GRAY99         => {in => &GRAY99,         out => 55},
                  YELLOW         => {in => &YELLOW,         out => 95},
                  MAGENTA        => {in => &MAGENTA,        out => 574916608},
                  NO_COLOR       => {in => &NO_COLOR,       out => 0},
                  DARK_RED       => {in => &DARK_RED,       out => 72},
                  DARK_BLUE      => {in => &DARK_BLUE,      out => 288581120},
                  DARK_CYAN      => {in => &DARK_CYAN,      out => 289669120},
                  FREE_COLOR     => {in => &FREE_COLOR,     out => 16},
                  DARK_GREEN     => {in => &DARK_GREEN,     out => 60},
                  DARK_YELLOW    => {in => &DARK_YELLOW,    out => 76},
                  DARK_MAGENTA   => {in => &DARK_MAGENTA,   out => 290791936},
                  WINDOWS_BLUE   => {in => &WINDOWS_BLUE,   out => 288581120},
                  NUM_FREE_COLOR => {in => &NUM_FREE_COLOR, out => 16}
    );
    for my $color (sort keys %named_colors) {
        is( color($named_colors{$color}{'in'}),
            $named_colors{$color}{'out'},
            sprintf 'color("%s") == %d',
            $color,
            $named_colors{$color}{'out'}
        );
    }

    # "" turns into NO_COLOR
    is(color(''), NO_COLOR, 'color("") == NO_COLOR');
    is(color(),   NO_COLOR, 'color( ) == NO_COLOR');

    # "0"-"99" decimal fltk color number, only works for indexed color range
    is(color(1),  1,  'color(1) == 1');
    is(color(99), 99, 'color(99) == 99');

    # "0xnnn" hex value of any fltk color number
    is(color('0xAAA'), 2730, 'color("0xAAA") == 2730');

    # "rgb" or "#rgb" three hex digits for rgb
    is(color('123'), 287453952, 'color("123") == 287453952');
    is(color('F00'), -16777216, 'color("F00") == -16777216');

    # "rrggbb" or "#rrggbb" 2 hex digits for each of rgb
    is(color('112233'),  287453952, 'color("112233") == 287453952');
    is(color('#112233'), 287453952, 'color("#112233") == 287453952');

    # "rrggbbaa" or "#rrggbbaa" fltk color number in hex
    is(color('11223355'),  287454037, 'color("11223355") == 287454037');
    is(color('#11223355'), 287454037, 'color("#11223355") == 287454037');

    # "rrrgggbbb" or "#rrrgggbbb" 3 hex digits for each of rgb
    is(color('111222333'),  287453952, 'color("111222333") == 287453952');
    is(color('#111222333'), 287453952, 'color("#111222333") == 287453952');

    # "rrrrggggbbbb" or "#rrrrggggbbbb" 4 hex digits for each of rgb
    is(color('111122223333'), 287453952,
        'color("111122223333") == 287453952');
    is(color('#111122223333'), 287453952,
        'color("#111122223333") == 287453952');

    # 17 "web safe colors" as defined by CSS 2.1
    my %web_safe = (maroon  => -2147483648,
                    red     => -16777216,
                    orange  => -5963776,
                    yellow  => -65536,
                    olive   => -2139095040,
                    purple  => -2147450880,
                    fuchsia => -16711936,
                    white   => -256,
                    lime    => 16711680,
                    green   => 8388608,
                    navy    => 32768,
                    blue    => 65280,
                    aqua    => 16776960,
                    teal    => 8421376,
                    black   => 56,
                    silver  => -1061109760,
                    gray    => -2139062272
    );
    for my $color (sort keys %web_safe) {
        is(color($color), $web_safe{$color}, sprintf 'color("%s") == %d',
            $color, $web_safe{$color});
    }

    #all other strings return NO_COLOR.
    no warnings qw[qw];
    for my $color (sort qw[this that the other #testing 22145554564812 ...]) {
        is(color($color), NO_COLOR, sprintf 'color("%s") == NO_COLOR',
            $color);
    }
}
{

    # First n bytes of name
    is(parsecolor('000222', 3), 56, 'parsecolor("000222", 3) == 56');

    # "" turns into NO_COLOR
    is(parsecolor(''), NO_COLOR, 'parsecolor("") == NO_COLOR');
    is(parsecolor('', 0), NO_COLOR, 'parsecolor("", 0) == NO_COLOR');
    is(parsecolor(), NO_COLOR, 'parsecolor( ) == NO_COLOR');

    # "0"-"99" decimal fltk color number, only works for indexed color range
    is(parsecolor(1),  1,  'parsecolor(1) == 1');
    is(parsecolor(99), 99, 'parsecolor(99) == 99');

    # "0xnnn" hex value of any fltk color number
    is(parsecolor('0xAAA'), 2730, 'parsecolor("0xAAA") == 2730');

    # "rgb" or "#rgb" three hex digits for rgb
    is(parsecolor('123'), 287453952, 'parsecolor("123") == 287453952');
    is(parsecolor('F00'), -16777216, 'parsecolor("F00") == -16777216');

    # "rrggbb" or "#rrggbb" 2 hex digits for each of rgb
    is(parsecolor('112233'), 287453952, 'parsecolor("112233") == 287453952');
    is(parsecolor('#112233'), 287453952,
        'parsecolor("#112233") == 287453952');

    # "rrggbbaa" or "#rrggbbaa" fltk color number in hex
    is(parsecolor('11223355'), 287454037,
        'parsecolor("11223355") == 287454037');
    is(parsecolor('#11223355'), 287454037,
        'parsecolor("#11223355") == 287454037');

    # "rrrgggbbb" or "#rrrgggbbb" 3 hex digits for each of rgb
    is(parsecolor('111222333'), 287453952,
        'parsecolor("111222333") == 287453952');
    is(parsecolor('#111222333'),
        287453952, 'parsecolor("#111222333") == 287453952');

    # "rrrrggggbbbb" or "#rrrrggggbbbb" 4 hex digits for each of rgb
    is(parsecolor('111122223333'),
        287453952, 'parsecolor("111122223333") == 287453952');
    is(parsecolor('#111122223333'),
        287453952, 'parsecolor("#111122223333") == 287453952');

    # 17 "web safe colors" as defined by CSS 2.1
    my %web_safe = (maroon  => -2147483648,
                    red     => -16777216,
                    orange  => -5963776,
                    yellow  => -65536,
                    olive   => -2139095040,
                    purple  => -2147450880,
                    fuchsia => -16711936,
                    white   => -256,
                    lime    => 16711680,
                    green   => 8388608,
                    navy    => 32768,
                    blue    => 65280,
                    aqua    => 16776960,
                    teal    => 8421376,
                    black   => 56,
                    silver  => -1061109760,
                    gray    => -2139062272
    );
    for my $color (sort keys %web_safe) {
        is(parsecolor($color), $web_safe{$color},
            sprintf 'parsecolor("%s") == %d',
            $color, $web_safe{$color});
    }
    warn 'TODO: If FLTK is compiled to use X11, then XParseColor() is tried';

    #all other strings return NO_COLOR.
    no warnings qw[qw];
    for my $color (sort qw[this that the other #testing 22145554564812 ...]) {
        is(parsecolor($color), NO_COLOR,
            sprintf 'parsecolor("%s") == NO_COLOR', $color);
    }
}
{

    # Color mixer ...one of many.
    is(lerp(color(BLACK), color(WHITE), 0),
        BLACK, 'lerp(color(BLACK), color(WHITE), 0) == BLACK');
    is(lerp(color(BLACK), color(WHITE), 0.25),
        135599360, 'lerp(color(BLACK), color(WHITE), 0.25) == 135599360');
    is(lerp(color(BLACK), color(WHITE), 0.5),
        287975936, 'lerp(color(BLACK), color(WHITE), 0.5) == 287975936');
    is(lerp(color(BLACK), color(WHITE), 0.75),
        423575296, 'lerp(color(BLACK), color(WHITE), 0.75) == 423575296');
    is(lerp(color(BLACK), color(WHITE), 1),
        color(WHITE), 'lerp(color(BLACK), color(WHITE), 1) == color(WHITE)');
    is(lerp(BLACK, WHITE, 1), WHITE, 'lerp(BLACK, WHITE, 1) == WHITE');
}
{    # Grays out the color
    is(inactive(color(RED)), 2132746496,
        'inactive(color(RED)) == 2132746496');
    is(inactive(color(RED), color(BLUE)),
        -1878510848, 'inactive(color(RED), color(BLUE)) == -1878510848');
    is(inactive(color(RED), color(RED)),
        -16777216, 'inactive(color(RED), color(RED)) == -16777216');
    is(inactive(color(RED) + 1, color(RED) - 1),
        -544145408, 'inactive(color(RED) + 1, color(RED) - 1) == -544145408');
}
{
    is(contrast(color(BLACK), color(WHITE)),
        BLACK, 'contrast(color(RED), color(RED)) == WHITE');
    is(contrast(color(RED), color(RED)),
        BLACK, 'contrast(color(RED), color(RED)) == BLACK');
    is(contrast(color(RED + 1), color(RED- 1)),
        RED + 1, 'contrast(color(RED + 1), color(RED - 1)) == RED + 1');
    is(contrast(color(BLACK), color(BLACK)),
        WHITE, 'contrast(color(BLACK), color(BLACK)) == WHITE');
}
{
    my ($r, $g, $b) = (0, 0, 0);
    split_color(WHITE, $r, $g, $b);
    is_deeply([$r, $g, $b],
              [255, 255, 255],
              'split_color(WHITE, ...) ~ [255, 255, 255]');
    split_color(BLACK, $r, $g, $b);
    is_deeply([$r, $g, $b], [0, 0, 0], 'split_color(BLACK, ...) ~ [0, 0, 0]');
    split_color(RED, $r, $g, $b);
    is_deeply([$r, $g, $b],
              [255, 0, 0],
              'split_color(RED, ...) ~ [255, 0, 0]');
}
{
    is(get_color_index(WHITE), -256, 'get_color_index(WHITE) == -256');
    set_color_index(WHITE, RED);
    warn 'set_color_index(WHITE, RED)';
    is(get_color_index(WHITE), RED,
        'get_color_index(WHITE) == RED (after set_color_index...)');
}
{
    is(get_color_index(GRAY75), -522133504,
        'get_color_index(GRAY75) == -522133504');
    set_background(color(WHITE));
    warn 'set_background( color(WHITE) );';
    is(get_color_index(GRAY75), color(WHITE),
        'get_color_index(GRAY75) == color(WHITE) (after set_background...)');
}
{
    is(nearest_index(color("#000000")),
        BLACK, 'nearest_index(color("#000000")) == BLACK');
    is(nearest_index(color("#FE0000")),
        RED, 'nearest_index(color("#FE0000")) == RED');
    is(nearest_index(color(GREEN)),
        GREEN, 'nearest_index(color(GREEN)) == GREEN');
    is(nearest_index(YELLOW), YELLOW, 'nearest_index(YELLOW) == YELLOW');
}
{
    warn 'TODO: color_chooser( ... )';
}
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

$Id$
