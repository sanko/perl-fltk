
=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Module::Build based install

=for git $Id$

=cut

use strict;
use warnings;
use Module::Build;
use Config qw[%Config];
use File::Find qw[find];
my $automated_testing = $ENV{AUTOMATED_TESTING} || $ENV{PERL_MM_USE_DEFAULT};
my $is_developer = ($ENV{RELEASE_TESTING} || -d '.git');
my @tests;
find \&find_cb, qw[t/10000_basic t/20000_functions t/40000_widgets
    t/50000_objects t/60000_types], ($is_developer ? 't/90000_author' : ());
@tests = sort @tests;
my $class = 'inc::MBX::FLTK' . ($is_developer ? '::Developer' : '');

if (!eval "require $class") {
    printf 'Failed to load %s: %s This ain\'t good, so... bye!', $class, $@;
    exit 0;
}
my $mb = $class->new(
    module_name => 'FLTK',
    license     => 'artistic_2',
    dist_author => 'Sanko Robinson <sanko@cpan.org>',
    dist_abstract =>
        'Perl bindings to the 2.0.x branch of the Fast Light Toolkit',
    requires       => {Exporter => 0, XSLoader => 0},
    build_requires => {'Alien::FLTK2' => 0.07704001,
                       base           => 0,
                       Config         => 0,
                       Cwd            => 0,
                       ($is_developer ? ('Devel::PPPort' => 0) : ()),
                       Exporter             => 0,
                       'ExtUtils::CBuilder' => 0.27,
                       'ExtUtils::ParseXS'  => 0,
                       'File::Find'         => 0,
                       'File::Path'         => 2.07,
                       'File::Spec'         => 0,
                       'Module::Build'      => '0.36',
                       perl                 => 5.008000,
                       'Pod::Parser'        => 0,
                       'TAP::Harness'       => 3.18,
                       'Test::More'         => 0.88,
                       'Test::NeedsDisplay' => 1.07,
                       XSLoader             => 0
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
    test_files       => \@tests,
    test_file_exts   => [qw(.t .tap .txt)],
    use_tap_harness  => 1,
    tap_harness_args => {jobs  => 9,
                         rules => {par => ['*']}
    },
    meta_merge => {
        keywords => [
            qw[FLTK Fast Light Toolkit widget FL GUI UI window 2.0.x experimental]
        ],
        resources => {
            bugtracker => {web => 'http://github.com/sanko/perl-fltk2/issues',
                           mailto => 'sanko@cpan.org'
            },
            repository => {url  => 'git://github.com/sanko/perl-fltk2.git',
                           web  => 'http://github.com/sanko/perl-fltk2',
                           type => 'git'
            },
            ChangeLog => 'http://github.com/sanko/perl-fltk2/commits/master/',
            homepage  => 'http://sanko.github.com/perl-fltk2/',
            license => ['http://www.perlfoundation.org/artistic_license_2_0']
        }
    },
    needs_compiler => 1,    # adds ExtUtils::CBuilder to build_requires
    get_options => {'interactive!' => {},
                    'messy!'       => {}
    }
);
##############################################################################
$mb->notes(automated_testing => $automated_testing             ? 1 : 0);
$mb->notes(is_developer      => $is_developer                  ? 1 : 0);
$mb->notes(verbose           => $mb->args('messy')             ? 1 : 0);
$mb->notes(interactive       => $mb->args('interactive')       ? 1 : 0);
$mb->notes(threads           => $Config::Config{'useithreads'} ? 1 : 0);
$mb->notes(test_suite        => \@tests);
$mb->notes(gmtime            => scalar gmtime);
##############################################################################
$mb->create_build_script;
exit 0;
##############################################################################
sub find_cb {
    return if -d $_ or -l $_;
    return unless -T $_;
    return unless $_ =~ m[.+\.t$];
    return push @tests, $File::Find::name;
}
