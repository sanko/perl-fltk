
=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Module::Build based install

=for git $Id$

=cut

use strict;
use warnings;
use Module::Build;
use lib 'inc';
use Config qw[%Config];
use File::Find qw[find];
my $automated_testing = $ENV{AUTOMATED_TESTING} || $ENV{PERL_MM_USE_DEFAULT};
my $is_developer = ($ENV{RELEASE_TESTING} || -d '.git');
my @tests;
find \&find_cb, qw[t/10000_basic t/20000_functions t/40000_widgets
    t/50000_objects t/60000_types], ($is_developer ? 't/90000_author' : ());
@tests = sort @tests;
my $class = $is_developer ? 'MBX::FLTK::Developer' : 'MBX::FLTK';

if (!eval "require $class") {
    printf 'Failed to load %s: %s This ain\'t good, so... bye!', $class, $@;
    exit 0;
}
my $mb = $class->new(
    module_name       => 'FLTK',
    license           => 'artistic_2',
    dist_author       => 'Sanko Robinson <sanko@cpan.org>',
    dist_version_from => 'lib/FLTK.pm',
    dist_abstract =>
        'Perl interface to the (experimental) 2.0.x branch of the FLTK GUI toolkit',
    requires => {perl                 => 5.008000,
                 base                 => 0,
                 'Test::More'         => 0.88,
                 Config               => 0,
                 Cwd                  => 0,
                 'ExtUtils::ParseXS'  => 0,
                 'ExtUtils::CBuilder' => 0.27,
                 'File::Spec'         => 0,
                 'File::Find'         => 0,
                 'File::Path'         => 2.07,
                 'Module::Build'      => '0.35_05',
                 'Devel::PPPort'      => 0
    },
    build_requires => {perl                 => 5.008000,
                       'Test::More'         => 0.88,
                       Config               => 0,
                       Cwd                  => 0,
                       'ExtUtils::ParseXS'  => 0,
                       'ExtUtils::CBuilder' => 0.27,
                       'File::Spec'         => 0,
                       'File::Find'         => 0,
                       'File::Path'         => 2.07,
                       'Module::Build'      => '0.35_05',
                       'Devel::PPPort'      => 0,
                       'Alien::FLTK'        => '0.06921_004',
                       'Pod::Parser'        => 0
    },
    recommends     => {OpenGL => 0.58},
    add_to_cleanup => [qw[FLTK-*],
                       map {"*$_"} (
                             '.' . $Config{'so'}, $Config{'_o'}, $Config{'_a'}
                       )
    ],
    no_index => {directory => [qw[examples inc t]],
                 files     => [qw[xs/include/ppport.h]]
    },
    test_files => \@tests,
    meta_merge => {
        generated_by => 'Conversion, software version 7.0',
        keywords     => [
            qw[FLTK Fast Light Toolkit widget FL GUI UI window 2.0.x experimental]
        ],
        resources => {
              bugtracker => 'http://github.com/sanko/fltk-perl/issues',
              ChangeLog => 'http://github.com/sanko/fltk-perl/commits/master',
              homepage  => 'http://sanko.github.com/fltk-perl/',
              license => 'http://www.perlfoundation.org/artistic_license_2_0',
              repository => 'http://github.com/sanko/fltk-perl'
        }
    },
    get_options => {'interactive!' => {},
                    'messy!'       => {}
    },
);
print "Checking for a functioning C++ compiler...\n";
if ($mb->cbuilder->have_cplusplus()) { print "Looks good\n\n" }
else { print "fail\n* No compiler found. Exiting.\n"; exit 0 }
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
