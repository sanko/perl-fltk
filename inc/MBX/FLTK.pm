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

    sub ACTION_code {
        my ($self, $args) = @_;
        my (@xs, @rc, @obj);
        find(sub { push @xs, $File::Find::name if m[.+\.xs$]; }, 'xs');
        find(sub { push @rc, $File::Find::name if !m[.+\.o$]; }, 'xs/rc');
        if ($self->is_windowsish) {
            my @dot_rc = grep defined,
                map { m[\.(rc)$] ? rel2abs($_) : () } @rc;
            for my $dot_rc (@dot_rc) {
                my $dot_o = $dot_rc =~ m[^(.*)\.] ? $1 . $Config{'_o'} : next;
                push @obj, $dot_o;
                next if $self->up_to_date($dot_rc, $dot_o);
                print "Building Win32 resource: $dot_rc ...\n";
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
        printf "%s -> %s (%s)...", $xs, $cpp, $typemap;

        if (ExtUtils::ParseXS->process_file(filename   => $xs,
                                            output     => $cpp,
                                            'C++'      => 1,
                                            hiertype   => 1,
                                            typemap    => $typemap,
                                            prototypes => 1
            )
            )
        {   print "okay\n";
            return $cpp;
        }
        print "FAIL!\n";
        return;
    }
    {    # Includes apidoc

        sub ACTION_docs {
            my $self = shift;
            $self->depends_on('apidoc');
            return $self->SUPER::ACTION_docs(@_);
        }
        use File::Path qw[make_path];
        use File::Spec::Functions qw[splitpath];
        my %modules;
        {

            package Pod::APIDoc::FLTK;
            use Pod::Parser;
            use strict;
            use warnings;
            our @ISA = qw[Pod::Parser];
            my ($package, $function, $current) = ('FLTK');

            sub command {
                my ($self, $command, $paragraph, $lineno) = @_;
                if ($command eq 'head1') {
                    $paragraph =~ s|\s+||;
                    $current = \$modules{$package}{'section'}{$paragraph};
                    $$current = {line => $lineno,
                                 file => $self->input_file
                    };
                    return;
                }
                elsif ($command eq 'for') {
                    if ($paragraph =~ m[^(?:apidoc)\s+(.+)]) {
                        my ($flags, $prereq, $return, $sub, @args)
                            = split '\|', $1;
                        my $type = $flags =~ m[H] ? '_hide' : 'sub';
                        $current = \$modules{$package}{$type}{$sub}
                            ->[scalar @{$modules{$package}{$type}{$sub}}];
                        $$current = {flags  => $flags,
                                     prereq => $prereq,
                                     return => $return,
                                     args   => \@args,
                                     line   => $lineno,
                                     file   => $self->input_file
                        };
                        return;
                    }
                    elsif (
                         $paragraph =~ m[(license|author|version|git)\s+(.+)])
                    {   $modules{$package}{'.'}{$1}{$2}++;
                        return;
                    }
                }
                elsif ($paragraph =~ m[^apidoc]
                       && (($command eq 'begin') || ($command eq 'end')))
                {   return;
                }
                my $expansion = $self->interpolate($paragraph, $lineno);
                $expansion =~ s|\s+$||;
                $$current->{'text'} .= "=$command $expansion\n\n";
            }

            sub verbatim {
                my ($self, $paragraph, $line_num) = @_;
                $$current->{'text'} .= $paragraph;
            }

            sub textblock {
                my ($self, $paragraph, $line_num) = @_;
                my $expansion = $self->interpolate($paragraph, $line_num);
                $$current->{'text'} .= $expansion;
            }

            sub preprocess_paragraph {
                my ($self, $line, $lineno) = @_;
                if ($line =~ m[^INCLUDE: (.+\.xsi?)]) {
                    $self->parse_from_file('xs/' . $1);
                }
                elsif ($line =~ m[^MODULE\s*=\s*FLTK\s+PACKAGE\s*=\s*(.+)]) {
                    $package = $1;
                }
                return $line;
            }

            sub begin_input {
                my ($self) = @_;

                #warn 'Begin ' . $self->input_file;
                # XXX - Check that file is in MANIFEST
                # XXX - Mark file as seen
            }

            sub end_input {
                my ($self) = @_;

                #warn 'End   ' . $self->input_file;
            }
        }

        sub ACTION_apidoc {
            my ($self)=@_;
            my $parser = Pod::APIDoc::FLTK->new();
            $parser->parseopts(-want_nonPODs => 1);
            print 'Parsing XS files for documentation... ';
            $parser->parse_from_file('xs/FLTK.xs');
            print "okay\n";
            print 'Generating documentation... ';

            #dd \%modules;
            for my $package (sort keys %modules) {
                my $file = './blib/lib/' . $package . '.pod';
                $file =~ s|::|/|g;
                make_path((splitpath($file))[0 .. 1]);

                #warn sprintf '%-30s => %s', $package, $file;
                open my ($DOC), '>', $file;
                syswrite $DOC, "=pod\n\n";
                {
                    for my $section (qw[NAME Description Synopsis]) {
                        next if !$modules{$package}{'section'}{$section};
                        syswrite $DOC, "=head1 $section\n\n";
                        syswrite $DOC,
                            $modules{$package}{'section'}{$section}{'text'};
                    }
                    if (keys %{$modules{$package}{'sub'}}) {
                        syswrite $DOC, "=head1 Functions\n\n";
                        for my $sub (sort keys %{$modules{$package}{'sub'}}) {
                            syswrite $DOC, "=head2 C<$sub>\nX<$sub>\n\n";
                            if ($modules{$package}{'sub'}{$sub}[0]{'flags'}
                                =~ m[E])
                            {   syswrite $DOC,
                                    (
                                    $modules{$package}{'sub'}{$sub}[0]{'text'}
                                        || '');
                            }
                            else {
                                syswrite $DOC, "=over\n\n";
                                for my $use (
                                        0 .. scalar(
                                            @{$modules{$package}{'sub'}{$sub}}
                                        ) - 1
                                    )
                                {   my $call = sprintf '%s( %s )', $sub,
                                        join ', ',
                                        @{$modules{$package}{'sub'}{$sub}
                                            [$use]{'args'}};
                                    my $_call = $call;
                                    $_call =~ s|[^\w+]|_|g;
                                    syswrite $DOC,
                                        "=item C<$call>X<$_call>\n\n";
                                    #syswrite $DOC,
                                    #    pp(
                                    #    $modules{$package}{'sub'}{$sub}[$use])
                                    #    . "\n\n";
                                    syswrite $DOC,
                                        ($modules{$package}{'sub'}{$sub}[$use]
                                         {'text'} || '');
                                    syswrite $DOC,
                                        sprintf "=for hackers %s line %d\n\n",
                                        $modules{$package}{'sub'}{$sub}[$use]
                                        {'file'},
                                        $modules{$package}{'sub'}{$sub}[$use]
                                        {'line'};
                                }
                                syswrite $DOC, "=back\n\n";

                                #warn $sub;
                            }
                        }
                    }
                    {
                        if (scalar keys %{$modules{$package}{'.'}{'author'}})
                        {   syswrite $DOC, "=head1 Author\n\n";
                            for my $author (
                                    sort
                                    keys %{$modules{$package}{'.'}{'author'}})
                            {   syswrite $DOC, "$author\n\n";
                            }
                        }
                        else {
                            syswrite $DOC, "=head1 Authors\n\n=over\n\n";
                            for my $author (
                                    sort
                                    keys %{$modules{$package}{'.'}{'author'}})
                            {   syswrite $DOC, "=item $author\n\n";
                            }
                            syswrite $DOC, "=back\n\n";
                        }
                    }
                    syswrite $DOC, "=head1 License and Legal\n\n";
                    syswrite $DOC, <<'END';
Copyright (C) 2008-2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the terms of The Artistic License 2.0.  See the F<LICENSE> file included with
this distribution or http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered by the
Creative Commons Attribution-Share Alike 3.0 License. See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

END
                    for my $id (sort keys %{$modules{$package}{'.'}{'git'}}) {
                        syswrite $DOC, "=for git $id\n\n";
                    }
                }
                syswrite $DOC, "=cut\n";
                close $DOC;

                #dd $modules{$package};
                #die;
            }
            print "okay\n";
        }
    }
    1;
}

=pod

=for $Rev$

=for $Revision$

=for $Date$Last $Modified$

=for $URL$

=for $ID$

=cut
__DATA__
Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the terms of The Artistic License 2.0.  See the F<LICENSE> file included with
this distribution or http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all original POD documentation is
covered by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.
