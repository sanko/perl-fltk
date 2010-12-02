#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/TextBuffer.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More skip_all => 'fltk::TextBuffer is buggy';
use Module::Build qw[];
use File::Temp qw[tempfile];
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
require FLTK;

#
my $buffer_1 = new_ok('FLTK::TextBuffer', [1024 * 256], 'new( 1024 * 256 )');
my $buffer_2 = new_ok('FLTK::TextBuffer', [],           'new( )');

#
$buffer_1->text("This is a test.");
is($buffer_1->length, 15, 'After text("This is a test."), length() == 15');
is($buffer_1->text, "This is a test.", ' ...text() eq "This is a test."');
is($buffer_1->character(0),  "T",  ' ...character( 0 ) eq "T"');
is($buffer_1->character(14), ".",  ' ...character( 14 ) eq "."');
is($buffer_1->character(15), "\0", ' ...character( 15 ) eq "\0"');
is($buffer_1->text_range(1, 4), "his", ' ...text_range( 1, 4 ) eq "his"');

# Multi-line content
$buffer_1->insert(0, "More test stuff.");
is($buffer_1->length, 31,
    'After insert(0, "More test stuff."), length() == 31');
is($buffer_1->text,
    "More test stuff.This is a test.",
    ' ...text() eq "More test stuff.This is a test."');
$buffer_1->insert(16, " ");
is($buffer_1->length, 32, 'After insert(16, " "), length() == 32');
is($buffer_1->text,
    "More test stuff. This is a test.",
    ' ...text() eq "More test stuff. This is a test."');
$buffer_1->append("Trailing text.");
is($buffer_1->length, 46, 'After append("Trailing text."), length() == 46');
is($buffer_1->text,
    "More test stuff. This is a test.Trailing text.",
    ' ...text() eq "More test stuff. This is a test.Trailing text."');
$buffer_1->remove(5, 10);
is($buffer_1->length, 41, 'After remove(5, 10), length() == 41');
is($buffer_1->text,
    "More stuff. This is a test.Trailing text.",
    ' ...text() eq "More stuff. This is a test.Trailing text."');
$buffer_1->replace(27, 27, " ");
is($buffer_1->length, 42, 'After replace(27, 27, " "), length() == 42');
is($buffer_1->text,
    "More stuff. This is a test. Trailing text.",
    ' ...text() eq "More stuff. This is a test. Trailing text."');

# Copy to buffer_2 from buffer_1
$buffer_2->copy($buffer_1, 12, 27, 0);
is($buffer_2->length, 15,
    'After copy( $buffer_1, 12, 27, 0), length() == 15');
is($buffer_2->text, "This is a test.", ' ...text() eq "This is a test."');

#
is(($buffer_2->undo())[0], 0, 'copy( ... ) is not an undoable process');
$buffer_2->insert(0, "Test");
is($buffer_2->length, 19, 'After insert(0, "Test"), length() == 19');
is($buffer_2->text,
    "TestThis is a test.",
    ' ...text() eq "TestThis is a test."');
{
    my @undone = $buffer_2->undo();
    is($undone[0],        1,  'insert( ... ) is an undoable process');
    is($undone[1],        0,  ' ...which leaves the cursor position at 0');
    is($buffer_2->length, 15, 'After undo( ), length() == 15');
    is($buffer_2->text, "This is a test.", ' ...text() eq "This is a test."');
    @undone = $buffer_2->undo();
    is($undone[0],        1,  'undo( ) is an undoable process');
    is($undone[1],        4,  ' ...which returns the cursor position to 4');
    is($buffer_2->length, 19, 'After undo( ), length() == 19');
    is($buffer_2->text,
        "TestThis is a test.",
        ' ...text() eq "TestThis is a test."');

    #
    @undone = $buffer_2->undo();
    is($undone[0],        1,  'insert( ... ) is an undoable process');
    is($undone[1],        0,  ' ...which leaves the cursor position at 0');
    is($buffer_2->length, 15, 'After undo( ), length() == 15');
    is($buffer_2->text, "This is a test.", ' ...text() eq "This is a test."');
}
$buffer_2->replace(0, $buffer_2->length, "");
is($buffer_2->text, "",
    'Text cleared with replace(0, $buffer_2->length, "")');
{    #
    my ($fh, $filename)
        = tempfile(CLEANUP => 1, TMPDIR => 1, SUFFIX => '.txt');
    is(syswrite($fh, 'Quick test.'), 11, 'Wrote 11 bytes to temp file');
    is($buffer_2->insertfile($filename, 0), 0, 'insertfile( ... ) okay');
    is($buffer_2->text, "Quick test.", 'Text is now eq "Quick test."');
    is($buffer_2->insertfile("File does not exist", 0),
        !0, 'insertfile( "File does not exist" ) fails');
    is($buffer_2->text, "Quick test.", 'Text is still eq "Quick test."');

    #warn $buffer_2->insertfile($filename, 0);
    #
    is($buffer_2->appendfile($filename), 0, 'appendfile( ... ) okay');
    is($buffer_2->text,
        "Quick test.Quick test.",
        'Text is now eq "Quick test.Quick test."');
    is($buffer_2->insertfile("File does not exist", 0),
        !0, 'appendfile( "File does not exist" ) fails');
    is($buffer_2->text,
        "Quick test.Quick test.",
        'Text is still eq "Quick test.Quick test."');

    #
    is($buffer_2->loadfile($filename), 0, 'loadfile( ... ) okay');
    is($buffer_2->text, "Quick test.", 'Text is now eq "Quick test."');
    is($buffer_2->loadfile("File does not exist"),
        !0, 'loadfile( "File does not exist" ) fails');
    is($buffer_2->text, "", 'Text is still eq ""');

    #
    is($buffer_2->loadfile($filename, 0), 2, 'loadfile( ..., 0 ) okay');
    is($buffer_2->text, "", 'Text is now eq ""');
    is($buffer_2->loadfile("File does not exist", 0),
        !0, 'loadfile( "File does not exist", 0 ) fails');
    is($buffer_2->text, "", 'Text is still eq ""');

    #
    is($buffer_2->loadfile($filename), 0, 'loadfile( ... ) okay (again)');
}
{
    my ($fh, $filename)
        = tempfile(CLEANUP => 1, TMPDIR => 1, SUFFIX => '.txt');
    is($buffer_2->savefile($filename), 0, 'savefile( ... ) is okay');
    is(sysread($fh, my ($data), -s $filename),
        11, '11 bytes read from temp file');
    is($data, 'Quick test.', 'Read data is "Quick test."');
}
{
    my ($fh, $filename)
        = tempfile(CLEANUP => 1, TMPDIR => 1, SUFFIX => '.txt');
    is($buffer_2->outputfile($filename, 1, 5),
        0, 'outputfile( ..., 1, 5 ) is okay');
    is(sysread($fh, my ($data), -s $filename),
        4, '4 bytes read from temp file');
    is($data, 'uick', 'Read data is "uick"');
}
note 'With tab inserted at position 0...';
$buffer_2->insert(0, "\t");
is($buffer_2->expand_character(0, 0), ' ' x 8, 'Tabs expand to eight spaces');
TODO: {
    local $TODO = 'Bug in fltk2?';
    is($buffer_2->expand_character("\t", 0, 4),
        ' ' x 4, 'expand_character("\t", 0, 4) expands to four spaces');
}
is($buffer_2->character_width("\t", 0, 4),
    4, 'character_width("\t", 0, 4) returns 4');
is($buffer_2->character_width("\t", 0),
    8, 'character_width("\t", 0) returns 8');
is($buffer_2->character_width("\t"), 8, 'character_width("\t") returns 8');
is($buffer_2->character_width("a"),  1, 'character_width("a") returns 1');
is($buffer_2->character_width("abcdefg", 3),
    1, 'character_width("abcdefg", 3) returns 1');
is($buffer_2->count_displayed_characters(0, 5),
    12, 'count_displayed_characters(0, 5) == 12');
is($buffer_2->count_displayed_characters(1, 5),
    4, 'count_displayed_characters(1, 5) == 4');
