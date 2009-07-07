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
    {  # All this just to run the (currenly read only) use_scripts flag off...

        package ExtUtils::CBuilder::Platform::Windows;
        use strict;
        use warnings;
        no warnings 'redefine';

        sub link {
            my ($self, %args) = @_;
            my $cf = $self->{config};
            my @objects
                = (ref $args{objects} eq 'ARRAY'
                   ? @{$args{objects}}
                   : $args{objects});
            my $to = join '', (File::Spec->splitpath($objects[0]))[0, 1];
            $to ||= File::Spec->curdir();
            (my $file_base = $args{module_name}) =~ s/.*:://;
            my $output = $args{lib_file}
                || File::Spec->catfile($to, "$file_base.$cf->{dlext}");

          # if running in perl source tree, look for libs there, not installed
            my $lddlflags = $cf->{lddlflags};
            my $perl_src  = $self->perl_src();
            $lddlflags =~ s/\Q$cf->{archlibexp}\E[\\\/]CORE/$perl_src/
                if $perl_src;
            my %spec = (
                srcdir        => $to,
                builddir      => $to,
                startup       => [],
                objects       => \@objects,
                libs          => [],
                output        => $output,
                ld            => $cf->{ld},
                libperl       => $cf->{libperl},
                perllibs      => [$self->split_like_shell($cf->{perllibs})],
                libpath       => [$self->split_like_shell($cf->{libpth})],
                lddlflags     => [$self->split_like_shell($lddlflags)],
                other_ldflags => [
                      $self->split_like_shell($args{extra_linker_flags} || '')
                ],
                use_scripts => 0   # XXX provide user option to change this???
            );
            unless ($spec{basename}) {
                ($spec{basename} = $args{module_name}) =~ s/.*:://;
            }
            $spec{srcdir}   = File::Spec->canonpath($spec{srcdir});
            $spec{builddir} = File::Spec->canonpath($spec{builddir});
            $spec{output} ||= File::Spec->catfile($spec{builddir},
                                        $spec{basename} . '.' . $cf->{dlext});
            $spec{manifest} ||= File::Spec->catfile($spec{builddir},
                          $spec{basename} . '.' . $cf->{dlext} . '.manifest');
            $spec{implib} ||= File::Spec->catfile($spec{builddir},
                                            $spec{basename} . $cf->{lib_ext});
            $spec{explib} ||= File::Spec->catfile($spec{builddir},
                                                  $spec{basename} . '.exp');
            if ($cf->{cc} eq 'cl') {
                $spec{dbg_file} ||= File::Spec->catfile($spec{builddir},
                                                    $spec{basename} . '.pdb');
            }
            elsif ($cf->{cc} eq 'bcc32') {
                $spec{dbg_file} ||= File::Spec->catfile($spec{builddir},
                                                    $spec{basename} . '.tds');
            }
            $spec{def_file} ||= File::Spec->catfile($spec{srcdir},
                                                    $spec{basename} . '.def');
            $spec{base_file} ||= File::Spec->catfile($spec{srcdir},
                                                   $spec{basename} . '.base');
            $self->add_to_cleanup(grep defined,
                                  @{  [@spec{
                                           qw(manifest implib explib dbg_file def_file base_file map_file)
                                           }
                                      ]
                                      }
            );
            foreach my $opt (
                qw(output manifest implib explib dbg_file def_file map_file base_file)
                )
            {   $self->normalize_filespecs(\$spec{$opt});
            }
            foreach my $opt (qw(libpath startup objects)) {
                $self->normalize_filespecs($spec{$opt});
            }
            (my $def_base = $spec{def_file}) =~ tr/'"//d;
            $def_base =~ s/\.def$//;
            $self->prelink(dl_name => $args{module_name},
                           dl_file => $def_base,
                           dl_base => $spec{basename}
            );
            my @cmds = $self->format_linker_cmd(%spec);
            while (my $cmd = shift @cmds) {
                $self->do_system(@$cmd);
            }
            $spec{output} =~ tr/'"//d;
            return wantarray
                ? grep defined,
                @spec{
                qw[output manifest implib explib dbg_file def_file map_file base_file]
                }
                : $spec{output};
        }
    }
    my ($VERBOSE);

    sub VERBOSE {
        return if !eval { Module::Build->current };
        $VERBOSE = Module::Build->current->notes('verbose')
            if !defined $VERBOSE;
        return $VERBOSE;
    }

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
        my @xs;
        find(sub { push @xs, $File::Find::name if m[.+\.xs$]; }, 'xs');
        my @obj;
    XS: for my $XS (@xs) {
            my $cpp = _xs_to_cpp($self, $XS)
                or do { printf 'Cannot Parse %s', $XS; exit 0 };
            if ($self->up_to_date($cpp, $self->cbuilder->object_file($cpp))) {
                push @obj, $self->cbuilder->object_file($cpp);
                next XS;
            }
            push @obj,
                $self->cbuilder->compile(
                               source               => $cpp,
                               extra_compiler_flags => Alien::FLTK->cxxflags()
                );
        }
        make_path(catdir(qw[blib arch auto FLTK]),
                  {verbose => VERBOSE, mode => 0711});
        if (!$self->up_to_date([@obj],
                               catdir(qw[blib arch auto FLTK],
                                      'FLTK.' . $Config{'so'}
                               )
            )
            )
        {   my ($dll, @cleanup)
                = $self->cbuilder->link(
                 objects => \@obj,
                 lib_file =>
                     catdir(qw[blib arch auto FLTK], 'FLTK.' . $Config{'so'}),
                 module_name => 'FLTK',
                 extra_linker_flags =>
                     Alien::FLTK->ldflags(qw[gl images static]),
                );
            @cleanup = map { s["][]g; rel2abs($_); } @cleanup;
            $self->add_to_cleanup(@cleanup);
            $self->add_to_cleanup(@obj);
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
__END__
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
        return 1 if !eval { Module::Build->current };
        $VERBOSE = Module::Build->current->notes('verbose')
            if !defined $VERBOSE;
        return $VERBOSE;
    }
    my $c = ExtUtils::CBuilder->new(
        config => {
            #ld      => 'g++',
            ccflags => sub {
                my $ccflags = $Config{'ccflags'};
                $ccflags =~ s[-DPERL_IMPLICIT_\w+][]g;
                return $ccflags;
                }
                ->(),
        },
        #quiet => !VERBOSE
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
        my @libs = map { catdir $dir , 'lib' . $_ . $Config{'_a'} }
            #qw[fltk2_images fltk2_png fltk2_jpeg fltk2_z],
            #qw[fltk2_gl fltk2_glut],
            qw[fltk2];

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
            push @obj,
                $c->compile(source       => $cpp,
                            include_dirs => [
                                        catdir($Config{'archlibexp'}, 'CORE'),
                                        Alien::FLTK->include_path()
                            ],
                            extra_compiler_flags => Alien::FLTK->cxxflags()
                );
        }
        make_path(catdir(qw[blib arch auto FLTK]),
                  {verbose => VERBOSE, mode => 0711});
        if (!$self->up_to_date(\@obj,
                               catdir(qw[blib arch auto FLTK],
                                      'FLTK.' . $Config{'so'}
                               )
            )
            )
        {   my ($dll, @cleanup)
                = $c->link(
                 objects => [@obj, @libs],
                 lib_file =>
                     catdir(qw[blib arch auto FLTK], 'FLTK.' . $Config{'so'}),
                 module_name        => 'FLTK',
                 extra_linker_flags => Alien::FLTK->ldflags(qw[images gl])
            );
            @cleanup = map { s["][]g; rel2abs($_); } @cleanup;
            $self->add_to_cleanup(@cleanup);
            $self->add_to_cleanup(@obj);
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