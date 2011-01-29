#!perl -Iblib/lib -Iblib/arch

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for xs/Preferences.xsi

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82;
use Module::Build qw[];
use File::Temp qw[];
use Test::NeedsDisplay ':skip_all';
plan tests => 106;
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK;

#
is(FLTK::Preferences::SYSTEM(), 0, 'FLTK::Preferences::SYSTEM() == 0');
is(FLTK::Preferences::USER(),   1, 'FLTK::Preferences::USER() == 1');
my $dir = File::Temp->newdir('FLTK_Preferences_XXXX', TMPDIR => 1);
{    # path, vendor, application
    my $prefs = new_ok('FLTK::Preferences',
                       [$dir, 'BlahSoft', 'ThunderWare'],
                       'Prefs in user-defined storage directory');
    $dir =~ s'\\'/'g;
    like($prefs->getUserdataPath, qr[$dir.+],
         'User-defined storage directory is correct');
}
{    # root, vendor, application
    my $s_prefs = new_ok('FLTK::Preferences',
                         [FLTK::Preferences::SYSTEM(), 'AcmeSoft',
                          'WonderWare 2.0'
                         ],
                         'SYSTEM prefs'
    );
    my $u_prefs = new_ok('FLTK::Preferences',
                         [FLTK::Preferences::USER(), 'AcmeSoft',
                          'WonderWare 2.0'
                         ],
                         'USER prefs'
    );
    my $p_prefs =
        new_ok('FLTK::Preferences', [$dir, 'AcmeSoft', 'WonderWare 2.0'],
               'PATH prefs');
    isn't($s_prefs->getUserdataPath, $u_prefs->getUserdataPath,
          'SYSTEM and USER prefs are stored in different locations');
    isn't($s_prefs->getUserdataPath, $p_prefs->getUserdataPath,
          'SYSTEM and PATH prefs are stored in different locations');
    ok($u_prefs->getUserdataPath ne $p_prefs->getUserdataPath,
        'USER and PATH prefs are stored in different locations');
}
{    # prefs, group
    my $prefs = FLTK::Preferences->new(FLTK::Preferences::SYSTEM(),
                                       'RandomSoft', 'UnderWare');
    my $group = new_ok('FLTK::Preferences',
                       [$prefs, 'New Group'],
                       'Prefs based on existing Prefs object');
}
{    # Flush data under various conditions
    {    # Leaving scope
        my $prefs = new_ok('FLTK::Preferences',
                           [$dir, 'FLTK', 'Scope'],
                           'Small scope prefs object (for set)');
        ok($prefs->set('Int Value', 2), 'Setting FLTK/Scope/Int Value = 2');
        ok($prefs->set('Float Value', 2.1),
            'Setting FLTK/Scope/Float Value = 2.1');
        ok($prefs->set('String Value', 'Two and change'),
            'Setting FLTK/Scope/String Value = "Two and change"');
    }
    {    # Read stored data...
        my $prefs = new_ok('FLTK::Preferences',
                           [$dir, 'FLTK', 'Scope'],
                           'Small scope prefs object (for get)');
        is($prefs->get('Int Value'), 2, 'Getting FLTK/Scope/Int Value == 2');
        is($prefs->get('Float Value'),
            2.1, 'Getting FLTK/Scope/Float Value == 2.1');
        is($prefs->get('String Value'),
            'Two and change',
            'Getting FLTK/Scope/String Value eq "Two and change"');
    }
}
{        # With explicit destroy()
    my $prefs = new_ok('FLTK::Preferences',
                       [$dir, 'FLTK', 'Explicit'],
                       'Small Explicit prefs object (for set)');
    ok($prefs->set('String', 'Testing'),
        'Setting FLTK/Explicit/String = "Testing"');
    $prefs->destroy;
    is($prefs, undef, 'prefs object has been manually destroyed');

    # Read stored data...
    my $prefs_r = new_ok('FLTK::Preferences',
                         [$dir, 'FLTK', 'Explicit'],
                         'Small Explicit prefs object (for get)');
    is($prefs_r->get('String'),
        'Testing', 'Getting FLTK/Explicit/String eq "Testing"');
}
{    # With Flush flush()
    my $prefs = new_ok('FLTK::Preferences',
                       [$dir, 'FLTK', 'Flush'],
                       'Small Flush prefs object (for set)');
    ok($prefs->set('String', 'Testing'),
        'Setting FLTK/Flush/String = "Testing"');
    $prefs->flush;
    isa_ok($prefs, 'FLTK::Preferences', 'prefs object is still active');

    # Read stored data...
    my $prefs_r = new_ok('FLTK::Preferences',
                         [$dir, 'FLTK', 'Flush'],
                         'Small Flush prefs object (for get)');
    is($prefs_r->get('String'),
        'Testing', 'Getting FLTK/Flush/String eq "Testing"');
}
{    # Add a number of groups and read them back for these tests
    my $prefs = new_ok('FLTK::Preferences',
                       [$dir, 'FLTK', 'Groups'],
                       'New Prefs object to add groups to');
    my @grouplist = qw[Just a few group names to fill the list];
    my $grouplist = scalar @grouplist;
    my %grouplist = map { $_ => 1 } @grouplist;
    for my $group (@grouplist) {
        new_ok('FLTK::Preferences',
               [$prefs, $group],
               sprintf 'Adding new group named "%s"', $group);
    }
    is($prefs->groups, $grouplist,
        sprintf 'All %d groups added have been counted', $grouplist);
    for my $index (0 .. $grouplist) {
        delete $grouplist{$prefs->group($index)};
    }
    is(scalar(keys %grouplist), 0, 'All groups accounted for');
    {
        my $tally = $grouplist;
        for my $group (@grouplist) {
            ok($prefs->groupExists($group),
                sprintf 'Group "%s" exists', $group);
            ok($prefs->deleteGroup($group),
                sprintf 'Group "%s" has been deleted', $group);
            $tally--;
            ok((!$prefs->groupExists($group)),
                sprintf 'Group "%s" no longer exists', $group);
            is($prefs->groups, $tally, sprintf '%d groups left', $tally);
        }
        is($prefs->groups, 0, 'Group list is empty again');
    }
    ok(!$prefs->groupExists('Never added'),
        'Checking for non-existant group');
}
{    # Add a number of key/value pairs for these tests
    my $prefs = new_ok('FLTK::Preferences',
                       [$dir, 'FLTK', 'Entries'],
                       'New Prefs object to add entries to');
    my %entrylist = (Test => 'Reset', 4 => 'Int Key', 'Int Value' => 3);
    my @entrylist = sort keys %entrylist;
    my $entrylist = scalar @entrylist;
    for my $entry (@entrylist) {
        ok($prefs->set($entry, $entrylist{$entry}),
            sprintf 'Adding new entry named "%s" with value %s',
            $entry, $entrylist{$entry});
    }
    is($prefs->entries, $entrylist,
        sprintf 'All %d entries added have been counted', $entrylist);
    for my $index (0 .. $entrylist - 1) {
        delete $entrylist{$prefs->entry($index)};
    }
    is(scalar(keys %entrylist), 0, 'All entries accounted for');
    {
        my $tally = $entrylist;
        for my $entry (@entrylist) {
            ok($prefs->entryExists($entry),
                sprintf 'entry "%s" exists', $entry);
            ok($prefs->deleteEntry($entry),
                sprintf 'entry "%s" has been deleted', $entry);
            $tally--;
            ok((!$prefs->entryExists($entry)),
                sprintf 'entry "%s" no longer exists', $entry);
            is($prefs->entries, $tally, sprintf '%d entries left', $tally);
        }
        is($prefs->entries, 0, 'entry list is empty again');
    }
    ok(!$prefs->entryExists('Never added'),
        'Checking for non-existant entry');
}
{    # Set values and later get them
    my $prefs = new_ok('FLTK::Preferences',
                       [$dir, 'FLTK', 'Values'],
                       'New Prefs object to add values to');
    ok($prefs->set('Key', 'Value'), 'Setting Key = "Value"');
    is($prefs->get('Key'), 'Value', 'Getting Key eq "Value"');
    is($prefs->get('Does not exist'),
        undef, 'Getting undef value for key "Does not exist"');
    is($prefs->get('Does not exist either', 'Default Value'),
        'Default Value',
        'Getting "Default Value" for key "Does not exist either"');
    is($prefs->size('Key'), 5, 'The value of "Key" is five bytes long');
    is($prefs->size('Empty Value'),
        0, 'The non-existant value of "Empty Value" is zero bytes long');
}
