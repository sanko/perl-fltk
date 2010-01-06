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
    use File::Path qw[make_path];
    use base 'Module::Build';
    {

        sub ACTION_code {
            require Alien::FLTK;    # Should be installed by now
            my ($self, $args) = @_;
            my $AF = Alien::FLTK->new();
            my (@xs, @rc, @obj);
            find(sub { push @xs, $File::Find::name if m[.+\.xs$]; }, 'xs');
            find(sub { push @rc, $File::Find::name if !m[.+\.o$]; }, 'xs/rc');
            if ($self->is_windowsish) {
                my @dot_rc = grep defined,
                    map { m[\.(rc)$] ? rel2abs($_) : () } @rc;
                for my $dot_rc (@dot_rc) {
                    my $dot_o
                        = $dot_rc =~ m[^(.*)\.] ? $1 . $Config{'_o'} : next;
                    push @obj, $dot_o;
                    next if $self->up_to_date($dot_rc, $dot_o);
                    printf 'Building Win32 resource: %s... ',
                        abs2rel($dot_rc);
                    chdir 'xs/rc';
                    print $self->do_system(sprintf 'windres %s %s',
                                      $dot_rc, $dot_o) ? "okay\n" : "fail!\n";
                    chdir $self->base_dir;
                }
                map { abs2rel($_) } @obj;
            }
        XS: for my $XS (@xs) {
                my $cpp = _xs_to_cpp($self, $XS)
                    or do { printf 'Cannot Parse %s', $XS; exit 0 };
                if ($self->up_to_date($cpp, $self->cbuilder->object_file($cpp)
                    )
                    )
                {   push @obj, $self->cbuilder->object_file($cpp);
                    next XS;
                }
                push @obj,
                    $self->cbuilder->compile(
                                       'C++'        => 1,
                                       source       => $cpp,
                                       include_dirs => [$AF->include_dirs()],
                                       extra_compiler_flags => $AF->cxxflags()
                    );
            }
            make_path(catdir(qw[blib arch auto FLTK]),
                      {verbose => !$self->quiet(), mode => 0711});
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
                                catdir(qw[blib arch auto FLTK],
                                       'FLTK.' . $Config{'so'}
                                ),
                            module_name        => 'FLTK',
                            extra_linker_flags => $AF->ldflags(qw[gl images]),
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
            find sub { push @xsi, $File::Find::name if m[\.xsi$] },
                catdir('xs');
            $self->add_to_cleanup($cpp);
            return $cpp
                if $self->up_to_date([@xsi, $xs, catdir('xs', $typemap)],
                                     $cpp);
            printf '%s -> %s (%s)... ', $xs, $cpp, $typemap;

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
    }
    {    # Includes apidoc

        sub ACTION_docs {
            my $self = shift;
            if ($self->notes('skip_apidoc')) {
                $self->notes('skip_apidoc' => 0);
            }
            else {
                $self->depends_on('apidoc');
            }
            return $self->SUPER::ACTION_docs(@_);
        }
        use File::Path qw[make_path];
        use File::Spec::Functions qw[splitpath];
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
                    $paragraph =~ s|\s+$||;
                    $current = \$self->{'apidoc_modules'}{$package}{'section'}
                        {$paragraph};
                    $$current = {line => $lineno,
                                 file => $self->input_file
                    };
                    push @{$self->{'apidoc_modules'}{$package}{'@section'}},
                        $paragraph;
                    return;
                }
                elsif ($command eq 'for') {
                    if ($paragraph =~ m[^(?:apidoc)\s+(.+)]) {
                        my ($flags, $prereq, $return, $sub, @args)
                            = split '\|', $1;
                        my $type = $flags =~ m[H] ? '_hide' : 'sub';
                        warn sprintf 'Malformed apidoc at %s line %d',
                            $self->input_file, $lineno
                            if !$sub;
                        $current
                            = \$self->{'apidoc_modules'}{$package}{$type}
                            {$sub}->[
                            scalar
                            @{$self->{'apidoc_modules'}{$package}{$type}
                                    {$sub}}
                            ];
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
                    {   $self->{'apidoc_modules'}{$package}{'.'}{$1}{$2}++;
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
            my ($self) = @_;
            my $parser = Pod::APIDoc::FLTK->new();
            $parser->parseopts(-want_nonPODs => 1);
            print 'Parsing XS files for documentation... ';
            $parser->parse_from_file('xs/FLTK.xs');
            print "okay\nGenerating documentation... ";
            for my $package (sort keys %{$self->{'apidoc_modules'}}) {
                my $file = './blib/lib/' . $package . '.pod';
                $file =~ s|::|/|g;
                make_path((splitpath($file))[0 .. 1]);
                $self->add_to_cleanup($file);
                open my ($DOC), '>', $file;
                syswrite $DOC, "=pod\n\n";
                {
                    for my $section (qw[NAME Description Synopsis]) {
                        next
                            if !$parser->{'apidoc_modules'}{$package}
                                {'section'}{$section};
                        syswrite $DOC, "=head1 $section\n\n";
                        syswrite $DOC,
                            $parser->{'apidoc_modules'}{$package}{'section'}
                            {$section}{'text'};
                    }
                    if (keys %{$parser->{'apidoc_modules'}{$package}{'sub'}})
                    {   syswrite $DOC, "=head1 Functions\n\n";
                        for my $sub (
                              sort keys
                              %{$parser->{'apidoc_modules'}{$package}{'sub'}})
                        {   syswrite $DOC, "=head2 C<$sub>\nX<$sub>\n\n";
                            syswrite $DOC, "=over\n\n";
                            for my $use (
                                 0 .. scalar(
                                     @{  $parser->{'apidoc_modules'}{$package}
                                             {'sub'}{$sub}
                                         }
                                 ) - 1
                                )
                            {   my $call
                                    = $self->_document_function(
                                         $package,
                                         $sub,
                                         $parser->{'apidoc_modules'}{$package}
                                             {'sub'}{$sub}[$use]
                                    );
                                my $_call = $call;
                                $_call =~ s|[^\w]+|_|g;
                                syswrite $DOC, "=item C<$call>X<$_call>\n\n";
                                syswrite $DOC,
                                    ($parser->{'apidoc_modules'}{$package}
                                     {'sub'}{$sub}[$use]{'text'} || '');
                                syswrite $DOC,
                                    sprintf "=for hackers %s line %d\n\n",
                                    $parser->{'apidoc_modules'}{$package}
                                    {'sub'}{$sub}[$use]{'file'},
                                    $parser->{'apidoc_modules'}{$package}
                                    {'sub'}{$sub}[$use]{'line'};
                            }
                            syswrite $DOC, "=back\n\n";
                        }
                    }
                    for my $section (
                        grep {
                            !m[(?:NAME|Description|Synopsis)]
                        } @{$parser->{'apidoc_modules'}{$package}{'@section'}}
                        )
                    {   next
                            if !$parser->{'apidoc_modules'}{$package}
                                {'section'}{$section};
                        syswrite $DOC, "=head1 $section\n\n";
                        syswrite $DOC,
                            $parser->{'apidoc_modules'}{$package}{'section'}
                            {$section}{'text'};
                    }
                    {
                        if (scalar keys %{
                                $parser->{'apidoc_modules'}{$package}{'.'}
                                    {'author'}
                            }
                            )
                        {   syswrite $DOC, "=head1 Author\n\n";
                            for my $author (
                                sort
                                keys %{
                                    $parser->{'apidoc_modules'}{$package}{'.'}
                                        {'author'}
                                }
                                )
                            {   syswrite $DOC, "$author\n\n";
                            }
                        }
                        else {
                            syswrite $DOC, "=head1 Authors\n\n=over\n\n";
                            for my $author (
                                sort
                                keys %{
                                    $parser->{'apidoc_modules'}{$package}{'.'}
                                        {'author'}
                                }
                                )
                            {   syswrite $DOC, "=item $author\n\n";
                            }
                            syswrite $DOC, "=back\n\n";
                        }
                    }
                    syswrite $DOC, "=head1 License and Legal\n\n";
                    syswrite $DOC, $self->LICENSE() . "\n\n";
                    for my $id (
                         sort keys
                         %{$parser->{'apidoc_modules'}{$package}{'.'}{'git'}})
                    {   syswrite $DOC, "=for git $id\n\n";
                    }
                }
                syswrite $DOC, "=cut\n";
                close $DOC;
            }
            print "okay\n";
        }

        sub _document_function {
            my ($self, $package, $sub, $use) = @_;

            # TODO:
            #   write documentation in here
            #   mention defaults/types/import tags
            my ($return, $call, @args) = ('', '', ());
            my %types = ('AV *' => '@', 'CV *' => '\&', 'HV *' => "\%");
            for my $arg (@{$use->{'args'}}) {
                my ($type, $name, $default)
                    = ($arg
                     =~ m[^([\w:\s\*]+)\s+([(?:\w_|\.{3})]+)(?:\s+=\s+(.+))?]s
                    );
                if (!(defined $type && defined $name)) {
                    printf
                        "Malformed apidoc: Missing parameter type in %s at %s line %d\n",
                        $arg, $use->{file},
                        $use->{line};
                }
                else {
                    push @args,
                        ($name eq '...'
                         ? ''
                         : ($types{$type} ? $types{$type} : '$')
                        ) . $name;
                }
            }
            if ($use->{'return'}) {
                my ($type, $name, $default)
                    = ($use->{'return'}
                       =~ m[^([\w:\s\*]+)\s+([\w_]+)(?:\s+=\s+(.+))?]s);
                if (!(defined $type && defined $name)) {
                    printf
                        "Malformed apidoc: Missing return type in %s at %s line %d\n",
                        $use->{'return'}, $use->{file}, $use->{line};
                }
                elsif ($use->{'flags'} !~ m[E]) {
                    $return
                        = 'my '
                        . ($types{$type} ? $types{$type} : '$')
                        . $name . ' = ';
                }
            }
            $call
                = $use->{'flags'} =~ m[E] ? ''
                : $use->{'flags'} =~ m[F] ? $package . '::'
                : sub {
                my $p = shift;
                $p =~ s|^.*:|\$|g;
                return lc($p) . '-E<gt>';
                }
                ->($package);
            my $usage = sprintf '%s%s%s(%s%s );', $return, $call, $sub,
                (@args ? ' ' : ''), (join ', ', @args);
            return $usage;
        }
    }
    1;
}

=pod

=for $Rev$

=for $Revision$

=for $Date$ | Last $Modified$

=for $URL$

=for $ID$

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=cut

sub LICENSE {
    <<'ARTISTIC_TWO' }
Copyright (C) 2008-2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the terms of The Artistic License 2.0.  See the F<LICENSE> file included with
this distribution or http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all original POD documentation is
covered by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.
ARTISTIC_TWO
