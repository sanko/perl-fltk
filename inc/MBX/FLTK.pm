package MBX::FLTK;
{
    use strict;
    use warnings;
    $|++;
    use Config qw[%Config];
    use ExtUtils::ParseXS qw[];
    use ExtUtils::CBuilder qw[];
    use File::Spec::Functions qw[catdir rel2abs abs2rel canonpath];
    use File::Find qw[find];
    use File::Path 2.07 qw[make_path];
    use base 'Module::Build';
    use Alien::FLTK;
    {

        package ExtUtils::CBuilder::Platform::Windows;
        use strict;
        use warnings;
        no warnings 'redefine';

        # 100 lines just to turn $spec{'use_scripts'} flag off. ((sigh))
        sub link {
            my ($self, %args) = @_;
            my $cf = $self->{config};
            my @objects = (ref $args{objects} eq 'ARRAY'
                           ? @{$args{objects}}
                           : $args{objects}
            );
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
            $self->add_to_cleanup(
                grep defined,
                @{  [@spec{
                         qw[manifest implib explib dbg_file
                             def_file base_file map_file]
                         }
                    ]
                    }
            );
            foreach my $opt (qw[output manifest implib explib
                             dbg_file def_file map_file base_file])
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
                ? grep defined, @spec{
                qw[output manifest implib explib
                    dbg_file def_file map_file base_file]
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
        if ($self->notes('is_developer')) {
            require Devel::PPPort;
            my $ppp = rel2abs(catdir(qw[xs ppport.pl]));
            Devel::PPPort::WriteFile($ppp) if !-e $ppp;
        }
        $self->SUPER::ACTION_dist(@_);
    }

    sub ACTION_code {
        my ($self, $args) = @_;
        my (@xs, @rc, @obj);
        find(sub { push @xs, $File::Find::name if m[.+\.xs$]; }, 'xs');
        find(sub { push @rc, $File::Find::name if !m[.+\.o$]; }, 'xs/rc');
        if ($self->is_windowsish) {
            print "Building Win32 resources...\n";
            my @dot_rc = grep defined,
                map { m[\.rc$] ? rel2abs($_) : () } @rc;
            for my $dot_rc (@dot_rc) {
                my $dot_o = $dot_rc =~ m[^(.*)\.] ? $1 . $Config{'_o'} : next;
                push @obj, $dot_o;
                next if $self->up_to_date($dot_rc, $dot_o);
                chdir 'xs/rc';
                $self->do_system(sprintf "windres $dot_rc $dot_o");
                chdir $self->base_dir;
            }
            map { abs2rel($_) } @obj;
        }
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
        @obj = map { canonpath abs2rel($_) } @obj;
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
                 module_name        => 'FLTK',
                 extra_linker_flags => Alien::FLTK->ldflags(qw[gl images]),
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
        printf "%s -> %s (%s)\r\n", $xs, $cpp, $typemap;
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

    sub ACTION_changelog {
        my ($self) = @_;
        require Fcntl;
        require POSIX;
        require File::Spec::Functions;
        print 'Update Changes file... ';

        # open and lock the file
        sysopen(my ($CHANGES_R), 'Changes', Fcntl::O_RDONLY())
            || die 'Failed to open Changes for reading';
        flock $CHANGES_R, Fcntl::LOCK_EX();

        # Read the file's content and scroll back to the top
        sysread($CHANGES_R, my ($CHANGES_D), -s $CHANGES_R)
            || die 'Failed to read Changes';

        # Okay, we're done with this file for now
        flock $CHANGES_R, Fcntl::LOCK_UN();
        close $CHANGES_R;

        # gather various info
        my @bits = split ',', qx[git log --pretty=format:"%at,%H,%h" -n 1];
        my $Date = POSIX::strftime('%Y-%m-%d %H:%M:%SZ (%a, %d %b %Y)',
                                   gmtime($bits[0]));
        my $Commit = $bits[1];
        my $dist = sprintf('Version %s | %s | %s',
                           ($self->dist_version()->is_alpha()
                            ? ('0.0XX', 'Distant future')
                            : ($self->dist_version()->numify, $Date)
                           ),
                           $bits[2]
        );

        # start changing the data around
        $CHANGES_D =~ s[.+(\r?\n)][$dist$1];
        $CHANGES_D
            =~ s[(_ -.-. .... .- -. --. . ... _+).*][$1 . sprintf <<'END',
        $self->{'properties'}{'meta_merge'}{'resources'}{'ChangeLog'}||'',
        $self->dist_version , qw[$ $ $]
    ]se;

For more information, see the commit log:
    %s

$Ver$ from git $Rev%s
$Date%s
$Url%s
END

     # Keep a backup (just in case) and move the file so we can create it next
        rename('Changes', 'Changes.bak')
            || die sprintf 'Failed to rename Changes (%s)', $^E;

        # open and lock the file
        sysopen(my ($CHANGES_W),
                'Changes', Fcntl::O_WRONLY() | Fcntl::O_CREAT())
            || die 'Failed to open Changes for reading';
        sysseek($CHANGES_W, 0, Fcntl::SEEK_SET())
            || die 'Failed to seek in Changes';

        # hope all went well and save the new log to disk
        syswrite($CHANGES_W, $CHANGES_D)
            || die 'Failed to update Changes';

        # unlock the file and close it
        flock $CHANGES_W, Fcntl::LOCK_UN();
        close($CHANGES_W) || die 'Failed to close Changes';
        printf "Done.\r\n    (%s)\r\n", $dist;
    }

    sub ACTION_RCS {
        my ($self) = @_;
        require POSIX;
        print 'Fake RCS...';
        my @manifest_files = sort keys %{$self->_read_manifest('MANIFEST')};
    FILE: for my $file (@manifest_files) {
            print '.';

            #warn sprintf q[%s | %s | %s], $date, $commit, $file;
            my $mode = (stat $file)[2];
            chmod($mode | oct(222), $file)
                or die "Can't make $file writable: $!";

            # open and lock the file
            sysopen(my ($CHANGES_R), $file, Fcntl::O_RDONLY())
                || die sprintf 'Failed to open "%s" for reading', $file;
            flock $CHANGES_R, Fcntl::LOCK_EX();

            # Read the file's content and scroll back to the top
            sysread($CHANGES_R, my ($CHANGES_D), -s $CHANGES_R)
                || die "Failed to read $file";

            # Okay, we're done with this file for now
            flock $CHANGES_R, Fcntl::LOCK_UN();
            close $CHANGES_R;

            # gather various info
            my (@bits) = split q[,],
                qx[git log --pretty=format:"%at,%H,%x25%x73 %h %x25%x2E%x32%x30%x73 %ce" -n 1 $file];
            next FILE if !@bits;
            my $Mod  = qx[git log --pretty=format:"%cr" -n 1 $file];
            my $Date = POSIX::strftime('%Y-%m-%d %H:%M:%SZ (%a, %d %b %Y)',
                                       gmtime($bits[0]));
            my $Commit = $bits[1];
            my $Commit_short = substr($bits[1], 0, 7);
            my $Id$bits[2], (File::Spec->splitpath($file))[2],
                $Date;
            my $Repo = $self->{'properties'}{'meta_merge'}{'resources'}
                {'repository'} || '';

            # start changing the data around
            my $CHANGES_O = $CHANGES_D;
            $CHANGES_D =~ s[\$(Id)(:[^\$]*)?\$][\$$1: $Id$]ig;
            $CHANGES_D =~ s[\$(Date)(:[^\$]*)?\$][\$$1: $Date$]ig;
            $CHANGES_D =~ s[\$(Mod(ified)?)(:[^\$]*)?\$][\$$1: $Mod \$]ig;
            $CHANGES_D
                =~ s[\$(Url)(:[^\$]*)?\$][\$$1: $Repo/raw/$Commit/$file \$]ig
                if $Repo;
            $CHANGES_D
                =~ s[\$(Rev(ision)?)(?::[^\$]*)?\$]["\$$1: ". ($2?$Commit:$Commit_short)." \$"]ige;

            # Skip to the next file if this one wasn't updated
            next FILE if $CHANGES_D eq $CHANGES_O;

     #warn qq[Updated $file];
     #die $CHANGES_D;
     # Keep a backup (just in case) and move the file so we can create it next
            rename($file, $file . '.bak')
                || die sprintf 'Failed to rename %s (%s)', $file, $^E;

            # open and lock the file
            sysopen(my ($CHANGES_W),
                    $file, Fcntl::O_WRONLY() | Fcntl::O_CREAT())
                || warn(sprintf q[Failed to open %s for reading: %s], $file,
                        $^E)
                && next FILE;
            sysseek($CHANGES_W, 0, Fcntl::SEEK_SET())
                || warn 'Failed to seek in ' . $file && next FILE;

            # hope all went well and save the new log to disk
            syswrite($CHANGES_W, $CHANGES_D)
                || warn 'Failed to update ' . $file && next FILE;

            # unlock the file and close it
            flock $CHANGES_W, Fcntl::LOCK_UN();
            close($CHANGES_W) || die 'Failed to close Changes';
            chmod($mode, $file);
        }
        print "Done.\r\n";
        return 1;
    }

    sub ACTION_distmeta {
        my ($self) = @_;
        if ($self->notes('is_developer')) {
            $self->SUPER::depends_on('changelog');
            $self->SUPER::depends_on('RCS');
        }
        $self->SUPER::ACTION_distmeta(@_);
    }
    1;
}
__END__
$Rev$
$Revision$
$Date$Last $Modified$
$URL$
$ID$
