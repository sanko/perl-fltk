#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Input.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82 tests => 11;
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
use_ok('FLTK');

# type() ...uh, types
for my $sub (qw[FLOAT_INPUT INT_INPUT NORMAL SECRET WORDWRAP]) { can_ok('FLTK::Input', $sub); }

#
my $W = new FLTK::Window(200, 100);
$W || BAIL_OUT('Failed to create window');
$W->begin();
my $I = new_ok('FLTK::Input' => [0, 0, 100, 100],
                'new FLTK::Input( 0, 0, 100, 100 )');
$W->end();
$W->show();


$I->text('This is a test!');
is( $I->text(), 'This is a test!', 'text() returns the contents');
my $var = 'TEST';
$I->static_text($var);
is( $I->text(), $var, '$I->text( $var ); $I->text->( ) returns the value of $var');
$I->static_text($var, 2);
note 'I consider this a bug in the library...';
is( $I->text(), $var, '$I->text( $var, 2 ); $I->text->( ) returns the full value of $var');
$var = "HAHAHAHA";
like($I->text(), qr[$var], 'text() returns the contents');


#


#die $I->text;

note 'TODO: ...everything';
#
#is($FI->value(), 0, 'value() is 1.2345678901234567890123456789012345678901');

#FLTK::run();
