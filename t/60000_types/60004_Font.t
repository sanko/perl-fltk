#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Font.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More tests => 38;
use Module::Build qw[];
use Time::HiRes qw[];
use Test::NeedsDisplay ':skip_all';
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK qw[:font];

# Font types imported with :font tag
for my $sub (qw[
             HELVETICA HELVETICA_BOLD HELVETICA_ITALIC HELVETICA_BOLD_ITALIC
             COURIER   COURIER_BOLD   COURIER_ITALIC   COURIER_BOLD_ITALIC
             TIMES     TIMES_BOLD     TIMES_ITALIC     TIMES_BOLD_ITALIC
             SYMBOL_FONT
             SCREEN_FONT SCREEN_BOLD_FONT
             ZAPF_DINGBATS
             BOLD ITALIC BOLD_ITALIC
             font list_fonts ]
    )
{   can_ok(__PACKAGE__, $sub);
}

#
is(font('Does not exist'), undef, 'Missing fonts return undef');

#
isa_ok(list_fonts(), 'ARRAY', 'The return value from list_fonts( )');
my $fonts = list_fonts();
note(sprintf 'This system has %d fonts:', scalar @$fonts);
note(sprintf '    %30s|%s|%s',
     $_->name(),
     join(', ', @{$_->encodings()}),
     join(', ', @{$_->sizes()}))
    for @$fonts;

#
SKIP: {
    my $type = 100;
    my $FONT;

    # Try to find one of the "web safe" fonts that fit our tests
    font($_) and $FONT = $_ and last for (qw[Verdana Geneva Arial Helvetica]);
    my $Reg = font($FONT);
    skip 'This system does not have the any of the fonts I need', 15 if !$Reg;

    #
    note 'Testing with ' . $FONT;
    isa_ok($Reg, 'FLTK::Font', sprintf 'font("%s")', $FONT);
    like($Reg->name($type), qr[$FONT]i,
         sprintf '$Reg->name( $type ) returns %s', $FONT);
    is($type, 0, '...and $type == 0');
    my $Bold = font($FONT . ' Bold');
    isa_ok($Bold, 'FLTK::Font', sprintf 'font("%s Bold")', $FONT);
    like($Bold->name($type), qr[$FONT]i,
         sprintf '$Bold->name( $type ) returns %s', $FONT);
    is($type, BOLD(), '...and $type == BOLD');
    my $Italic = font($FONT . ' Italic');
    isa_ok($Italic, 'FLTK::Font', sprintf 'font("%s Italic")', $FONT);
    like($Italic->name($type), qr[$FONT]i,
         sprintf '$Italic->name( $type ) returns %s', $FONT);
    is($type, ITALIC(), '...and $type == ITALIC');
    my $BoldItalic = font($FONT . ' Bold Italic');
    isa_ok($BoldItalic, 'FLTK::Font', sprintf 'font("%s Bold Italic")',
           $FONT);
    like($BoldItalic->name($type),
         qr[$FONT]i, sprintf '$BoldItalic->name( $type ) returns %s', $FONT);
    is($type, BOLD_ITALIC(), '...and $type == BOLD_ITALIC');

    #
    isa_ok($Reg->sizes(),     'ARRAY', 'sizes( ) returns a list');
    isa_ok($Reg->encodings(), 'ARRAY', 'encodings() returns a list');
    ok($Reg->system_name(), sprintf 'The system_name( ) for %s is "%s"',
        $FONT, $Reg->system_name() || 'undef');
}
