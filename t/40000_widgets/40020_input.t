#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Input.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82 tests => 45;
use Module::Build qw[];
use Time::HiRes qw[];
use Test::NeedsDisplay;
my $test_builder = Test::More->builder;
chdir '../..' if not -d '_build';
use lib 'inc';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK;

# type() ...uh, types
my @types = qw[FLOAT_INPUT INT_INPUT NORMAL SECRET WORDWRAP];
for my $sub (@types) { can_ok('FLTK::Input', $sub); }

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
$W->begin();
my $I = new_ok('FLTK::Input' => [0, 0, 100, 100],
               'new FLTK::Input( 0, 0, 100, 100 )');
$W->end();
$W->show() if $interactive;

#
for my $type (@types) {
    $I->type(eval 'FLTK::Input::' . $type . '( )');
    is($I->type,
        eval 'FLTK::Input::' . $type . '( )',
        'Type changed to ' . $type);
}

#
is($I->size, 0, 'default size of text is 0');
note q[$I->text('This is a test!');];
$I->text('This is a test!');
is($I->size, 15, 'size is now 15');
is($I->text(), 'This is a test!', 'text() returns the contents');
my $var = 'TEST';
$I->static_text($var);
is($I->text(), $var,
    '$I->text( $var ); $I->text->( ) returns the value of $var');
$I->static_text($var, 2);
note 'I consider this a bug in the library...';
is($I->text(), $var,
    '$I->text( $var, 2 ); $I->text->( ) returns the full value of $var');
$var = "HAHAHAHA";
like($I->text(), qr[$var], 'text() returns the contents');

#
is($I->position, 0, 'Initial position is 0');
note q[$I->position(2);];
$I->position(2);
is($I->position, 2, 'Manually set position works');
is($I->mark,     2, 'Default mark is the end of the text (in this case 2)');
note q[$I->text('Long line of text.');];
$I->static_text('Long line of text.');
is($I->position, 0,  'position resets to zero with text()');
is($I->mark,     18, 'mark changes automatically with text()');
note q[$I->static_text('Longer line of text.');];
$I->static_text('Longer line of text.');
is($I->mark, 20, 'mark changes automatically with static_text()');
note q[$I->mark(5);];
$I->mark(5);
is($I->mark, 5, 'manually setting mark() works');
note q[$I->static_text('Longest line of text.');];
$I->static_text('Longest line of text.');
is($I->mark, 21,
    '...but mark still changes automatically with static_text()');
note q[$I->position(2, 4)];
$I->position(2, 4);
is($I->position, 2,
    'setting both position and mark in one go works for position');
is($I->mark, 4, 'setting both position and mark in one go works for mark');

#
is($I->size, 21, 'size of text is now 21');

#
note q[$I->text("This is a long line of text.");];
$I->text("This is a long line of text.");
is($I->text,
    'This is a long line of text.',
    'text() eq "This is a long line of text."');
$I->text("This is a long line of text.");
note q[$I->replace(1,6,'hat wa');];
$I->replace(1, 6, 'hat wa');
is($I->text,
    'That was a long line of text.',
    'text() eq "That was a long line of text."');

#
note q[$I->position(5, 18);];
$I->position(5, 16);
ok($I->cut(), 'Cutting the selected text.');
is($I->text, 'That line of text.', 'text() eq "That line of text."');
note q[$I->position(5);];
$I->position(5);
ok($I->cut(8), 'Cutting eight chars starting at position.');
is($I->text, 'That text.', 'text() eq "That text."');
ok($I->cut(1, 6), 'Cutting chars between index 1 and 6.');
is($I->text, 'Text.', 'text() eq "Text."');

#
note q[$I->position(1);];
$I->position(2);
ok($I->insert('sting with t'),
    'inserting "sting with t" at current position');
is($I->text, 'Testing with txt.', 'text() eq "Testing with txt."');
ok($I->insert('enough', 1),
    'inserting 1 char from "enough" at current position');
is($I->text, 'Testing with text.', 'text() eq "Testing with text."');

#
is($I->word_start(10), 8,  'location of word boundary before 10 == 8');
is($I->word_end(10),   12, 'location of word boundary after 10 == 12');
note '$I->text("Just a few more tests. " x 15);';
$I->text("Just a few more tests. " x 15);
ok($I->line_start(25) < 25, 'line_start(25) < 25');
ok($I->line_end(25) > 25,   'line_end(25) > 25');

#
is($I->size, 345, 'size is now 345');
