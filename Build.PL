use strict;
use warnings;
use lib 'inc';
use MBX::FLTK;
use Config qw[%Config];
use File::Find qw[find];
my $automated_testing = $ENV{AUTOMATED_TESTING} || $ENV{PERL_MM_USE_DEFAULT};
my $is_developer = ((-d '.git') ? 1 : 0) or ($ENV{RELEASE_TESTING} ? 1 : 0);
my @tests;
find \&find_cb, qw[t/00000_Basic t/50000_Classes];
@tests = sort @tests;

#
my $mb = MBX::FLTK->new(
    module_name       => 'FLTK',
    license           => 'artistic_2',
    dist_author       => 'Sanko Robinson <sanko@cpan.org>',
    dist_version_from => 'lib/FLTK.pm',
    dist_abstract =>
        'Perl interface to the (experimental) 2.0.x branch of the FLTK GUI toolkit',
    requires => {perl                 => '5.8.0',    # 5.8.0 is too old IMO...
                 base                 => 0,
                 'Test::More'         => 0.88,
                 Config               => 0,
                 Cwd                  => 0,
                 'ExtUtils::ParseXS'  => 0,
                 'ExtUtils::CBuilder' => 0.24,
                 'File::Spec'         => 0,
                 'File::Find'         => 0,
                 'File::Path'         => 2.04,
                 'Module::Build'      => 0,
                 'Devel::PPPort'      => 0
    },
    build_requires => {perl                 => '5.8.0',
                       'Test::More'         => 0.88,
                       Config               => 0,
                       Cwd                  => 0,
                       'ExtUtils::ParseXS'  => 0,
                       'ExtUtils::CBuilder' => 0.24,
                       'File::Spec'         => 0,
                       'File::Find'         => 0,
                       'File::Path'         => 2.04,
                       'Module::Build'      => 0,
                       'Devel::PPPort'      => 0,
                       'Alien::FLTK'        => 0.06786
    },
    add_to_cleanup => [qw[FLTK-*],
                       map {"*$_"} (
                             '.' . $Config{'so'}, $Config{'_o'}, $Config{'_a'}
                       )
    ],
    no_index => {

        #directory => [qw[examples]],
        #file => [qw[scripts/hello_world.pl]]
    },

    #script_files => qw[scripts/fltk.pl],
    test_files => \@tests,
    meta_merge => {
        generated_by => 'Conversion, software version 7.0',
        keywords =>
            [qw[FLTK Feather Light Toolkit widget FL GUI UI window 2.0.x]],
        resources => {
            #bugtracker => 'http://code.google.com/p/sanko/issues/list',
            #ChangeLog  => 'http://code.google.com/p/sanko/source/list',

            #homepage  => 'http://sankorobinson.com/fltk/',
            license => 'http://www.perlfoundation.org/artistic_license_2_0',

            #MailingList => XXX,
            repository => 'http://github.com/sanko/perl-FLTK'
        }
    },
    get_options => {'interactive!' => {},
                    'messy!'       => {}
    }
);
print sub { my ($x) = @_; chomp $x if !$mb->args('messy'); $x; }
    ->(<<'#END');
 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    Buliding FLTK requires a functioning C++ compiler.  Hold on a sec
    while I locate one...
#END
if (!( ($mb->cbuilder && ($mb->cbuilder->{'quiet'} = !$mb->args('messy')))
       || $mb->cbuilder->have_compiler)
    )
{   print <<'#END'; exit 0; }
 Oops!  ExtUtils::CBuilder failed to find working
    compier so I this is where you and I part ways.  It's been real.
 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
#END
print <<'#END';
 and everything looks okay.  Moving on.
 --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
#END

#
$mb->notes(
    fltk_svn => (
        sub {
            $mb->dist_version =~ m[^\d\.(\d+)(?:\_\d+)?$];
            $1;
            }
            ->()
    )
);

# TODO #######################################################################
$mb->notes(use_images => 0);    # TODO
$mb->notes(use_cairo  => 0);    # TODO
$mb->notes(use_x      => 0);    # TODO
$mb->notes(use_glut   => 0);    # TODO
$mb->notes(use_gl     => 1);
##################################################################### TODO ###
$mb->notes(automated_testing => $automated_testing             ? 1 : 0);
$mb->notes(is_developer      => $is_developer                  ? 1 : 0);
$mb->notes(verbose           => $mb->args('messy')             ? 1 : 0);
$mb->notes(interactive       => $mb->args('interactive')       ? 1 : 0);
$mb->notes(threads           => $Config::Config{'useithreads'} ? 1 : 0);
$mb->notes(test_suite        => \@tests);
$mb->notes(gmtime            => scalar gmtime);
$mb->create_build_script;
exit 0;

sub find_cb {
    return if -d $_ or -l $_;
    return unless -T $_;
    return unless $_ =~ m[.+\.t$];
    return push @tests, $File::Find::name;
}

BEGIN {    # Tired of getting FAIL-mail from outdated build environments
    if ($] < 5.008008) {    # already 3+ years old...
        warn sprintf 'Perl v5.8.8 required--this is only v%vd, stopped', $^V;
        exit 0;
    }

    #if ($Module::Build::VERSION < 0.3) {
    #    warn sprintf
    #        'Module::Build version 0.3 required--this is only version %s',
    #        $Module::Build::VERSION;
    #    exit 0;
    #}
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
