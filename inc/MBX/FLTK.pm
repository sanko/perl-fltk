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
    {

        sub ACTION_docs {
            my $self = shift;
            $self->depends_on('apidoc');
            return $self->SUPER::ACTION_docs( @_ );
        }
        use File::Spec::Functions
            qw[abs2rel rel2abs splitpath canonpath catpath];
        use File::Path qw[mkpath];
        use File::Basename qw[dirname];
        use Fcntl ':flock';
        use Cwd qw[cwd];
        use Carp qw[carp];

        # Globals
        my $outdir = rel2abs './blib/lib';
        my %defaults;
        my @files;
        my (%moddocs, %ISA, %seen);
        my $home  = cwd;
        my $DEPTH = 0;

        sub Write {
            my ($fh, $form) = (shift, shift);
            my $line = scalar @_ ? (sprintf $form, grep defined, @_) : $form;
            $line =~ s'(^[\r\n]*|[\r\n]*$)''g;
            return syswrite $fh, $line . "\n\n";
        }

        sub ACTION_apidoc {
            my ($self) = @_;

            $self->depends_on('code'); # So we can load @ISA

            use lib './blib/lib';
            require FLTK;
            read DATA, $defaults{'License and Legal'}, -s DATA;
            @files
                = sort map { canonpath(rel2abs($_)) }
                grep       {m[.+\.xsi?]gm}
                keys %{$self->_read_manifest('MANIFEST')};
            for my $file (grep {m[\.xs$]} @files) {
                autodoc($file);
            }
            for my $mod_key (sort { uc($a) cmp uc($b) || $a cmp $b }
                             keys %moddocs)
            {   my $mod      = $moddocs{$mod_key};
                my $filename = canonpath $outdir . '/' . $mod_key . '.pod';
                $filename =~ s|::|/|g;
                my $dirname = dirname($filename);
                mkpath($dirname) if !-d $dirname;
                die "Cannot open $filename: $!"
                    if !open(my $DOC, '>', $filename);
                warn "Cannot lock $filename: $!" if !flock($DOC, LOCK_EX);
                printf "++ Tossing together '%s'...\n", rel2abs $filename;
                Write $DOC, '=pod';
                Write $DOC, '=head1 NAME';
                Write $DOC, delete $mod->{'NAME'};

                if ($mod->{'Synopsis'}) {
                    Write $DOC, '=head1 Synopsis';
                    Write $DOC, delete $mod->{'Synopsis'};
                }
                Write $DOC, "=head1 Description";
                Write $DOC, delete $mod->{'Description'} || 'TODO';
                if (keys %{$mod->{'~functions'}}) {
                    my $functions;
                    $functions .= delete $mod->{'Functions'}
                        if $mod->{'Functions'};
                    if ($mod->{'~functions'}{'new'}) {
                        my $docs = document_function($mod_key, 'new',
                                          delete $mod->{'~functions'}{'new'});
                        if ($docs) {
                            $functions .= "=head2 Constructor\n\n$docs";
                        }
                    }
                    for my $func (sort { uc($a) cmp uc($b) || $a cmp $b }
                                  keys %{$mod->{'~functions'}})
                    {   my $docs = document_function($mod_key, $func,
                                          delete $mod->{'~functions'}{$func});
                        $functions .= sprintf "=head2 C<%s>\n\n%s", $func,
                            $docs
                            if $docs;
                    }
                    if ($functions) {
                        Write $DOC, "=head1 Functions/Methods";
                        Write $DOC, $functions;
                    }
                }
                my $_dump_section = sub {
                    my ($sec) = @_;
                    $mod->{$sec} = $defaults{$sec} if $defaults{$sec};
                    return if !$mod->{$sec};
                    $mod->{$sec} =~ s[(?:\s$|^\s)*][]g;
                    return if !$mod->{$sec};
                    Write $DOC, '=head1 %s', $sec;
                    Write $DOC, delete $mod->{$sec};
                };
                map { $_dump_section->($_) }
                    sort
                    grep { !m[(Bugs|See Also|Authors?|License and Legal)] }
                    grep {m[^[a-z]]i} keys %$mod;
                $_dump_section->($_) for ('Bugs', 'See Also');
                $mod->{'Author'
                        . ($#{delete $mod->{'.author'}} > 0 ? 's' : '')}
                    = join "\n\n", @{$mod->{'.author'}};
                $_dump_section->($_)
                    for ('Author', 'Authors', 'License and Legal');
                Write $DOC, '=for git %s', $_ for @{delete $mod->{'.git'}};
                syswrite $DOC, '=cut';
                warn "Cannot unlock $filename: $!" if !flock($DOC, LOCK_UN);
                close $DOC;
            }
            chdir $self->base_dir;
        }

        sub autodoc {
            my ($inc) = @_;
            my ($abs) = canonpath rel2abs($inc);
            my ($dir) = canonpath dirname($abs);
            my ($rel) = canonpath abs2rel($abs);
            return !warn "We've already parsed '$abs'!" if $seen{$abs}++;
            printf "%s Parsing apidoc for '%s'...\n", ('-' x ($DEPTH * 2)),
                $abs;
            my ($LI, $cut_mode, $PACKAGE, $sec, $current)
                = qw[0 1 FLTK ~functions];
            return !warn "Cannot open $rel: $!" if !open(my $FH, '<', $abs);
            return !warn "Cannot lock $rel: $!" if !flock($FH, LOCK_EX);
            my $read_paragraph = sub {
                my $line = '';
            LINE: while (<$FH>) {    # Read an entire paragraph
                    $LI++;
                    last LINE if !m'\w';
                    $line .= $_;
                }
                return $line;
            };
        PARA: while (my $para = <$FH>) {
                $LI++;
                chdir $dir;
                if ($cut_mode) {
                    if ($para =~ m[^\s*INCLUDE:\s*(.+\.xsi?)\s*$]) {
                        die "$1 is not in MANIFEST"
                            if !grep { $_ eq rel2abs($1) } @files;
                        $DEPTH++;
                        autodoc(canonpath rel2abs $1);
                    }
                    elsif ($para
                         =~ m[^\s*MODULE\s*=\s*\S+\s+PACKAGE\s*=\s*(\S+)\s*$])
                    {   $PACKAGE = $1;
                        _isa($PACKAGE);
                    }
                }
                if ($para =~ m[^=\w+\s*\S+?\s*.+]) {
                    $para .= $read_paragraph->();
                    $para =~ m[^=(\w+)\s*(\S+)?\s*(.+)$]s;
                    my ($type, $kind, $data) = ($1, $2, $3);
                    if ($type eq 'cut') { $cut_mode = 1; next PARA; }
                    $cut_mode = 0;
                    if ($kind && $kind eq 'apidoc') {
                        if ($type eq 'begin' || $type eq 'end') { }
                        elsif ($type eq 'for') {
                            $para =~ m[^=for\s*(\w+)?\s*(.+)];
                            my ($flags, $prereq, $ret, $name, @args)
                                = split '\|', $2;
                            warn "Error at $abs line $LI" if !$name;
                            push @{$moddocs{$PACKAGE}{$sec}{$name}},
                                {flags => $flags,
                                 docs  => '',
                                 ret   => $ret,
                                 file  => $abs,
                                 line  => $LI,
                                 args  => \@args
                                };
                            $current = \$moddocs{$PACKAGE}{$sec}{$name}[-1]
                                {'docs'};
                        }
                        next PARA;
                    }
                    elsif (   ($type eq 'for')
                           && ($kind =~ m[^(license|author|version|git)$]))
                    {   my ($for, $data) = ('.' . $kind, $data);
                        chomp $data;
                        push @{$moddocs{$PACKAGE}{$for}}, $data
                            if !grep { $_ =~ qr[^$data$]i }
                                @{$moddocs{$PACKAGE}{$for}};
                        next PARA;
                    }
                    elsif ($type eq 'head1') {
                        $para =~ m[^=head1\s*(.+)$];
                        $current = \$moddocs{$PACKAGE}{$1};
                        next PARA;
                    }
                    else { $para .= "\n" }
                    Warn('%s at %s line %d.', $para, $abs, $LI)
                        if ($type eq 'for' && $para =~ m[\|]);
                }
                $$current .= $para if !$cut_mode;
            }
            flock($FH, LOCK_UN);
            close $FH;
            $DEPTH--;
            return 1;
        }

        sub document_function {
            my ($package, $sub, $types) = @_;
            my $return;
        DOC: for my $doc (@$types) {
                if (scalar @$types > 1) {
                    my $args;
                    if ($sub eq 'new') {
                        $args = sprintf(
                            "$package->new( %s );\n",
                            join(', ',
                                 map { s|\s+.*$||; '$' . $_ } @{$doc->{args}})
                        );
                    }
                    else {
                        $args = sprintf("%s( %s );",
                                $sub,
                                join(', ', map { '$' . $_ } @{$doc->{args}}));
                    }
                    $return .= "=item C<$args>\n";
                    $args =~ s|[^a-z]+|_|ig;
                    $return .= "X<$args>\n\n";
                }
                next DOC if $doc->{'flags'} =~ m[H];
                $sub =~ s|\s*$||;
                $doc->{docs} =~ s[(:?\s$|^\s)][]g;
                $return .= $doc->{docs} || 'TODO';
                my $_ret = $doc->{'ret'};
                my $_obj = $package;
                $package =~ s[::[a-z].*][];
                $_obj    =~ s[^.*::][];
                my $_flags = $doc->{'flags'};
                my @tags   = split ',',
                    $_flags =~ s|\s*t\[(.+)\]\s*|| ? $1 : '';
                $return .=
                    sprintf
                    "\n\nThis %s may be imported using the following tag%s: %s.",
                    $_flags =~ m[[ev]]
                    ? 'variable'
                    : 'function', ($#tags ? 's' : ''), join ', ', @tags
                    if @tags;

                if ($_flags =~ m[[Ue]]) {

                    # no usage
                }
                elsif ($sub eq 'new') {
                    $return .= sprintf(
                        "\n\nUsage:\n\n  %s = $package->new( %s );\n",
                        sub { $_ = shift; s|::|_|g; '$' . lc $_ }
                            ->($package),
                        join(', ',
                             map { s|\s+.*$||; '$' . $_ } @{$doc->{args}})
                    );
                }
                else {
                    $return .= sprintf(
                        "\n\nUsage:\n\n  %s%s%s( %s );",
                        (  ($_flags =~ m[e]) ? (('', $package . '::', ''))
                         : ($_flags =~ m[F]) ? ('', $package . '::')
                         : (($doc->{ret} ? '$' . sub {
                                 $_ = shift;
                                 s|::|_|g;
                                 lc $_;
                                 }
                                 ->($doc->{'ret'}) . ' = '
                             : ''
                            ),
                            '$' . lc($_obj) . '->'
                         )
                        ),
                        $sub,
                        join(', ', map { '$' . $_ } @{$doc->{args}})
                    );
                }
                $return
                    .= "\n\nB<NOTE>: This is experimental and subject to change.\n"
                    if $doc->{flags} =~ m[x];
                $return =~ s'(\s*$|^\s*)''g;
                $return
                    .= sprintf "\n\n=for hackers Found at '%s' line %d.\n\n",
                    $doc->{file},
                    $doc->{line};
            }
            if ($return) {
                if (scalar @$types > 1) {
                    $return = "\n=over\n\n$return\n\n=back\n\n";
                }
                $return = "X<$sub>\n$return\n";
            }
            return $return;
        }

        sub _isa {
            my ($class) = @_;
            for (eval sprintf '@%s::ISA', $class) {
                if (!$ISA{$class}) { _isa($_); }
                $ISA{$class} = $_;
            }
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
