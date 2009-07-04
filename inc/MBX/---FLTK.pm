package MBX::FLTK;
{
    use strict;
    use warnings;
    $|++;
    use Config qw[%Config];
    use ExtUtils::ParseXS qw[];
    use ExtUtils::CBuilder qw[];
    use File::Spec::Functions qw[catdir rel2abs];
    use File::Find qw[find];
    use File::Path 2.07 qw[make_path];
    use base 'Module::Build';
    use Alien::FLTK;
    my ($VERBOSE);

    sub VERBOSE {
        return if !eval { Module::Build->current };
        $VERBOSE = Module::Build->current->notes('verbose')
            if !defined $VERBOSE;
        return $VERBOSE;
    }
    my $c = ExtUtils::CBuilder->new(
        config => {
            ld      => 'g++',
            ccflags => sub {
                my $ccflags = $Config{'ccflags'};
                $ccflags =~ s[-DPERL_IMPLICIT_\w+][]g;
                return $ccflags;
                }
                ->(),
            #lddflags => '-lmsimg32'
        },
        quiet => !VERBOSE
    );

    sub ACTION_dist {
        my ($self, $args) = @_;
        if ('XXX - DEVELOPER USE ONLY') {
            require Devel::PPPort;
            my $ppp = rel2abs(catdir(qw[xs ppport.pl]));
            Devel::PPPort::WriteFile($ppp) if !-e $ppp;
        }
        $self->SUPER::ACTION_dist(@_);
    }

    sub ACTION_code {
        my ($self, $args) = @_;
        my $dir = Alien::FLTK->library_path();
        my @libs
            = map { catdir $dir , 'lib' . $_ . $Config{'_a'} }
            qw[fltk2 fltk2_images fltk2_png fltk2_jpeg fltk2_z fltk2_gl];

        #
        my @xs;
        find(sub { push @xs, $File::Find::name if m[.+\.xs$]; }, 'xs');
        my $libcomctl32;
        find(
            sub {
                $libcomctl32 = $File::Find::name
                    if $_ =~ qr[libcomctl32$Config{'_a'}];
            },
            split ' ',
            $Config{'libpth'}
        );

        #
        my @obj;
    XS: for my $XS (@xs) {
            my $cpp = _xs_to_cpp($self, $XS)
                or do { printf 'Cannot Parse %s', $XS; exit 0 };
            if ($self->up_to_date($cpp, $c->object_file($cpp))) {
                push @obj, $c->object_file($cpp);
                next XS;
            }
            push @obj, $c->compile(
                source       => $cpp,
                include_dirs => [catdir($Config{'archlibexp'}, 'CORE'),
                                 Alien::FLTK->include_path()
                ],
                extra_compiler_flags => [
                    #qw[ -fno-exceptions -fno-strict-aliasing
                    #    -Wunused -Wno-format-y2k
                    #    -c -O3
                    #    -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
                    #    -Wno-non-virtual-dtor                    ]
                ]
            );
        }
        make_path(catdir(qw[blib arch auto FLTK]),
                  {verbose => VERBOSE, mode => 0711});
        if (!$self->up_to_date([@obj, @libs],
                               catdir(qw[blib arch auto FLTK],
                                      'FLTK.' . $Config{'so'}
                               )
            )
            )
        {   my ($dll, @cleanup)
                = $c->link(
                objects => [@obj, @libs #, $libcomctl32
                ],
                lib_file =>
                    catdir(qw[blib arch auto FLTK], 'FLTK.' . $Config{'so'}),
                module_name        => 'FLTK',
                extra_linker_flags => [
                    $Config{ldflags},
                    $Config{'libs'},
                    #qw[-Wunused -Wno-format-y2k  -fno-exceptions -fno-strict-aliasing],
                    '-L' . Alien::FLTK->library_path(),
                    '-lmsimg32',
                    Alien::FLTK->ldflags()
                ]
                );
            @cleanup = map { s["][]g; rel2abs($_); } @cleanup;
            $self->add_to_cleanup(@cleanup);
            $self->add_to_cleanup(@obj);
            $self->add_to_cleanup(@libs);
        }
        $self->SUPER::ACTION_code;
    }

    sub _xs_to_cpp {
        my ($self, $xs) = @_;
        my ($cpp, $typemap) = ($xs, $xs);
        $cpp     =~ s[\.xs$][\.cxx];
        $typemap =~ s[\.xs$][\.tm];
        $typemap = 'type.map' if !-e $typemap;
        my @xsi;
        find sub { push @xsi, $File::Find::name if m[\.xsi$] }, catdir('xs');
        $self->add_to_cleanup($cpp);
        return $cpp
            if $self->up_to_date([@xsi, $xs, catdir('xs', $typemap)], $cpp);
        printf "%s -> %s (%s)\n", $xs, $cpp, $typemap;
        ExtUtils::ParseXS->process_file(filename   => $xs,
                                        output     => $cpp,
                                        'C++'      => 1,
                                        hiertype   => 1,
                                        typemap    => $typemap,
                                        prototypes => 1
        ) or return;
        return $cpp;
    }

    sub make_tarball {
        my ($self, $dir, $file, $quiet) = @_;
        $file ||= $dir;
        $self->do_system(
            'tar --mode=0755 -c' . ($quiet ? q[] : 'v') . "f $file.tar $dir");
        $self->do_system("gzip -9 -f -n $file.tar");
        return 1;
    }
    1;
}
