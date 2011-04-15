package inc::MBX::FLTK::Developer;
{
    use strict;
    use warnings;
    $|++;
    use Config qw[%Config];
    use ExtUtils::ParseXS qw[];
    use ExtUtils::CBuilder qw[];
    use File::Spec::Functions qw[catdir rel2abs abs2rel canonpath];
    use File::Basename qw[dirname];
    use File::Find qw[find];
    use File::Path 2.07 qw[make_path];
    use lib '../../..';
    use parent 'inc::MBX::FLTK';
    use Cwd qw[cwd];
    use 5.010;
    {
        my ($cwd, %seen, %packages, @xsi_files);

        sub find_dist_packages {
            my $self      = shift;
            my @all_files = keys %{$self->_read_manifest('MANIFEST')};
            my @xs_files  = sort grep {m[\.xs$]} @all_files;
            @xsi_files = sort grep {m[\.xsi$]} @all_files;
            %packages  = %{$self->SUPER::find_dist_packages()};
            $cwd       = rel2abs cwd;
            for my $file (@xs_files) { $self->_grab_metadata($file); }
            chdir $cwd;
            return \%packages;
        }

        sub _grab_metadata {
            my ($self, $inc) = @_;
            my ($abs) = canonpath rel2abs($inc);
            my ($dir) = canonpath dirname($abs);
            my ($rel) = canonpath abs2rel($abs);

            #return !warn "We've already parsed '$abs'!" if $seen{$abs}++;
            return !warn "Cannot open $rel: $!" if !open(my $FH, '<', $abs);
            my ($package, $version, $_package);
        PARA: while (my $line = <$FH>) {
                if ($line =~ m[^\s*INCLUDE:\s*(.+\.xsi?)\s*$]) {
                    chdir $dir;
                    $self->_grab_metadata(canonpath rel2abs $1);
                }
                elsif ($line =~
                       m[^\s*MODULE\s*=\s*\S+\s+PACKAGE\s*=\s*(\S+)\s*$])
                {   $package = $1;
                }
                elsif ($line =~ m[^=for version ([\d\.\_]+)$]) {
                    $version  = $1;
                    $_package = $package;
                }
                if ($package and $version and (!defined $packages{$package}))
                {   chdir $cwd;
                    $packages{$_package}{'file'} = abs2rel($abs);
                    $packages{$_package}{'file'} =~ s|\\|/|g;
                    $packages{$_package}{'version'} = $version;
                }
            }
        }
    }

    sub make_tarball {
        my ($self, $dir, $file, $quiet) = @_;
        $file ||= $dir;
        if (0 && 'bzip') {
            $self->do_system(  'tar --mode=0755 -cj'
                             . ($quiet ? q[] : 'v')
                             . "f $file.tar.bz2 $dir");
        }
        elsif (0 && 'gzip') {
            $self->do_system(  'tar --mode=0755 -cz'
                             . ($quiet ? q[] : 'v')
                             . "f $file.tar.gz $dir");
        }
        else {
            $self->do_system(  'tar --mode=0755 -c'
                             . ($quiet ? q[] : 'v')
                             . "f $file.tar $dir");
            $self->do_system("gzip -9 -f -n $file.tar");
        }
        return 1;
    }

    sub ACTION_distdir {
        my ($self, $args) = @_;
        if ($self->notes('skip_rcs')) {
            $self->notes('skip_rcs' => 0);
        }
        else {
            $self->SUPER::depends_on('changelog');
            $self->SUPER::depends_on('RCS');
        }
        $self->SUPER::ACTION_distdir(@_);

        #
        if ($self->notes('skip_apidoc')) {
            $self->notes('skip_apidoc' => 0);
        }
        else {
            $self->depends_on('apidoc');
        }
        print 'Saving skinny XS files... ';
        for my $file (keys %{$self->{'_apidoc_parser'}{'_xs'}}) {
            my $_file = File::Spec->catdir($self->dist_dir, $file);
            my $mode = (stat $_file)[2];
            next if !chmod($mode | oct(222), $_file);
            next if !open my $XS, '>', $_file;
            next if !syswrite $XS, $self->{'_apidoc_parser'}{'_xs'}{$file};
            next if !close $XS;
            chmod $mode, $_file;
        }
    }

    sub ACTION_dist {
        my ($self, $args) = @_;
        require Devel::PPPort;
        my $ppp = abs2rel(rel2abs(catdir(qw[xs include ppport.h])));
        if (!-e $ppp) {
            printf "Creating %s with Devel::PPPort v%s... ", $ppp,
                $Devel::PPPort::VERSION;
            Devel::PPPort::WriteFile($ppp);
            printf "done\nStripping $ppp... ";
            system($^X, $ppp, '--strip');
            print "done\n";
        }
        $self->SUPER::ACTION_dist(@_);
    }

    sub ACTION_changelog {
        my ($self) = @_;
        require POSIX;
        print 'Updating Changes file... ';

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
        my $_Date = POSIX::strftime('%Y-%m-%d %H:%M:%SZ (%a, %d %b %Y)',
                                    gmtime($bits[0]));
        my $_Commit = $bits[1];
        my $dist = sprintf(
            'Version %s | %s | %s',
            ($self->dist_version() =~ m[_]   # $self->dist_version()->is_alpha
             ? ('0.XXXXX', 'Next Sunday AD')
             : ($self->dist_version(), $_Date) # $self->dist_version()->numify
            ),
            $bits[2]
        );

        # start changing the data around
        $CHANGES_D =~ s[.+(\r?\n)][$dist$1];
        $CHANGES_D =~
            s[(_ -.-. .... .- -. --. . ... _+).*][$1 . sprintf <<'END',
        $self->{'properties'}{'meta_merge'}{'resources'}{'ChangeLog'}||'', '$',
        $self->dist_version , qw[$ $ $ $ $ $ $]
    ]se;

For more information, see the commit log:
    %s

%sVer: %s %s from git %sRev%s
%sDate%s
%sUrl%s
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
        printf "okay (%s)\n", $dist;
    }

    sub ACTION_RCS {
        my ($self) = @_;
        require POSIX;
        require File::Spec;
        print 'Running fake RCS...';
        my @manifest_files = sort keys %{$self->_read_manifest('MANIFEST')};
    FILE: for my $file (@manifest_files, __FILE__) {
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
            my $_Mod  = qx[git log --pretty=format:"%cr" -n 1 $file];
            my $_Date = POSIX::strftime('%Y-%m-%d %H:%M:%SZ (%a, %d %b %Y)',
                                        gmtime($bits[0]));
            my $_Commit = $bits[1];
            my $_Commit_short = substr($bits[1], 0, 7);
            my $_Id = sprintf $bits[2], (File::Spec->splitpath($file))[2],
                $_Date;
            my $_Repo = (
                       ref $self->{'properties'}{'meta_merge'}{'resources'}
                           {'repository'}
                       ? $self->{'properties'}{'meta_merge'}{'resources'}
                           {'repository'}{'web'}
                           // $self->{'properties'}{'meta_merge'}{'resources'}
                           {'repository'}{'url'}
                       : $self->{'properties'}{'meta_merge'}{'resources'}
                           {'repository'}) // '';

            # start changing the data around
            my $CHANGES_O = $CHANGES_D;
            $CHANGES_D =~ s[\$(Id)(:[^\$]*)?\$][\$$1: $_Id \$]ig;
            $CHANGES_D =~ s[\$(Date)(:[^\$]*)?\$][\$$1: $_Date \$]ig;
            $CHANGES_D =~ s[\$(Mod(ified)?)(:[^\$]*)?\$][\$$1: $_Mod \$]ig;
            $CHANGES_D =~
                s[\$(Url)(:[^\$]*)?\$][\$$1: $_Repo/raw/master/$file \$]ig
                if $_Repo;
            $CHANGES_D =~
                s[\$(Rev(ision)?)(?::[^\$]*)?\$]["\$$1: ". ($2?$_Commit:$_Commit_short)." \$"]ige;

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
        print "okay\n";
        return 1;
    }

    sub ACTION_tidy {
        my ($self) = @_;
        unless (Module::Build::ModuleInfo->find_module_by_name('Perl::Tidy'))
        {   warn("Cannot run tidy action unless Perl::Tidy is installed.\n");
            return;
        }
        require Perl::Tidy;
        require File::Spec;
        my $demo_files =
            -d 'examples' ? $self->rscan_dir('examples', qr[\.pl$]) : [];
        my $inst_files = -d 'inc' ? $self->rscan_dir('inc', qr[\.pm$]) : [];
        for my $files ([keys(%{$self->script_files})],       # scripts first
                       [values(%{$self->find_pm_files})],    # modules
                       [@{$self->find_test_files}],          # test suite next
                       [@{$inst_files}],                     # installer files
                       [@{$demo_files}]                      # demos last
            )
        {   $files = [sort map { File::Spec->rel2abs($_) } @{$files}];

            # One at a time...
            for my $file (@$files) {
                printf "Running perltidy on '%s' ...\n",
                    File::Spec->abs2rel($file);
                $self->add_to_cleanup($file . '.tidy');
                Perl::Tidy::perltidy(argv => <<'END' . $file); } }
--brace-tightness=2
--block-brace-tightness=1
--block-brace-vertical-tightness=2
--paren-tightness=2
--paren-vertical-tightness=2
--square-bracket-tightness=2
--square-bracket-vertical-tightness=2
--brace-tightness=2
--brace-vertical-tightness=2

--delete-old-whitespace
--no-indent-closing-brace
--line-up-parentheses
--no-outdent-keywords
--no-outdent-long-quotes
--no-space-for-semicolon
--swallow-optional-blank-lines

--continuation-indentation=4
--maximum-line-length=78

--want-break-before='% + - * / x != == >= <= =~ !~ < > | & >= < = **= += *= &= <<= &&= -= /= |= \ >>= ||= .= %= ^= x= ? :'

--standard-error-output
--warning-output

--backup-and-modify-in-place
--backup-file-extension=tidy

END
        $self->depends_on('code');
        return 1;
    }
    {    # Includes apidoc
        use File::Path qw[make_path];
        use File::Spec::Functions qw[splitpath];
        {

            package Pod::APIDoc::FLTK;
            use base 'Pod::Parser';
            use strict;
            use warnings;
            my ($package, $function, $current) = ('FLTK');

            sub command {
                my ($self, $command, $paragraph, $lineno) = @_;
                if ($command eq 'head1') {
                    $paragraph =~ s|\s+$||;
                    $current =
                        \$self->{'apidoc_modules'}{$package}{'section'}
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
                        my ($flags, $prereq, $return, $sub, @args) =
                            split '\|', $1;
                        my $type = $flags =~ m[H] ? '_hide' : 'sub';
                        warn sprintf 'Malformed apidoc at %s line %d',
                            $self->input_file, $lineno
                            if !$sub;
                        $current =
                            \$self->{'apidoc_modules'}{$package}{$type}{$sub}
                            ->[
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
                        $self->{'_xs'}{$self->input_file} .=

                            #sprintf qq[#line %d "%s"\n\n%s], $lineno,
                            #$self->input_file,
                            $paragraph
                            if $self->cutting;
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
                elsif ($line =~
                    /^MODULE\s*=\s*([\w:]+)(?:\s+PACKAGE\s*=\s*([\w:]+))?(?:\s+PREFIX\s*=\s*(\S+))?\s*$/
                    )
                {   $package = $2 || $1;
                }
                $self->{'_xs'}{$self->input_file} .=

                 #sprintf qq[#line %d "%s"\n\n%s], $lineno, $self->input_file,
                    $line
                    if $self->cutting;
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
            $self->{'_apidoc_parser'} = Pod::APIDoc::FLTK->new();
            $self->{'_apidoc_parser'}->parseopts(-want_nonPODs => 1);
            my @xs;
            find(sub { push @xs, $File::Find::name if m[.+\.xs$]; }, 'xs');
            print 'Parsing XS for documentation... ';
            for my $xs (sort { lc $a cmp lc $b } @xs) {

                #printf q[Parsing '%s' for documentation... ], $xs;
                $self->{'_apidoc_parser'}->parse_from_file($xs);

                #print "\n";
            }
            print "done\nGenerating documentation... ";
            for my $package (
                   sort keys %{$self->{'_apidoc_parser'}->{'apidoc_modules'}})
            {   my $file = 'lib/' . $package . '.pod';
                $file =~ s|::|/|g;
                $self->_add_to_manifest(
                             File::Spec->catfile($self->dist_dir, 'MANIFEST'),
                             sprintf '%-50s Added by APIdoc', $file);
                $file = File::Spec->catfile($self->dist_dir, $file);
                make_path((splitpath($file))[0 .. 1]);
                open my ($DOC), '>', $file;
                syswrite $DOC, "=pod\n\n";
                {

                    for my $section (qw[NAME Description Synopsis]) {
                        next
                            if !$self->{'_apidoc_parser'}
                                ->{'apidoc_modules'}{$package}{'section'}
                                {$section};
                        syswrite $DOC, "=head1 $section\n\n";
                        syswrite $DOC,
                            $self->{'_apidoc_parser'}
                            ->{'apidoc_modules'}{$package}{'section'}
                            {$section}{'text'};
                    }
                    if (keys %{
                            $self->{'_apidoc_parser'}
                                ->{'apidoc_modules'}{$package}{'sub'}
                        }
                        )
                    {   syswrite $DOC, "=head1 Functions\n\n";
                        for my $sub (
                                 sort keys %{
                                     $self->{'_apidoc_parser'}
                                         ->{'apidoc_modules'}{$package}{'sub'}
                                 }
                            )
                        {   syswrite $DOC, "=head2 C<$sub>\nX<$sub>\n\n";
                            syswrite $DOC, "=over\n\n";
                            for my $use (
                                    0 .. scalar(
                                        @{  $self->{'_apidoc_parser'}
                                                ->{'apidoc_modules'}{$package}
                                                {'sub'}{$sub}
                                            }
                                    ) - 1
                                )
                            {   my $call =
                                    $self->_document_function(
                                     $package,
                                     $sub,
                                     $self->{'_apidoc_parser'}
                                         ->{'apidoc_modules'}{$package}{'sub'}
                                         {$sub}[$use]
                                    );
                                my $_call = $call;
                                $_call =~ s|[^\w]+|_|g;
                                syswrite $DOC, "=item C<$call>X<$_call>\n\n";
                                syswrite $DOC,
                                    ($self->{'_apidoc_parser'}
                                     ->{'apidoc_modules'}{$package}{'sub'}
                                     {$sub}[$use]{'text'} || '');
                                {
                                    my $tags =
                                        ($self->{'_apidoc_parser'}
                                         ->{'apidoc_modules'}{$package}
                                         {'sub'}{$sub}[$use]{'flags'} =~
                                         m|T\[(.+?)\]|) ? $1 : '';
                                    if ($tags) {
                                        my @tags
                                            = map {"C<:$_>"} split m[\s*,\s*],
                                            $tags;
                                        syswrite $DOC,
                                            sprintf
                                            "Import this function with the %s tag%s.\n\n",
                                            (  @tags == 1
                                             ? $tags[0]
                                             : join(', ',
                                                    @tags[0 ... (@tags - 2)])
                                                 . ' or '
                                                 . $tags[-1]
                                            ),
                                            $#tags ? 's' : '';

                #warn sprintf 'XXX - Import %s with %s', $sub, $tags if $tags;
                                    }
                                }
                                syswrite $DOC,
                                    sprintf "=for hackers %s line %d\n\n",
                                    $self->{'_apidoc_parser'}
                                    ->{'apidoc_modules'}{$package}{'sub'}
                                    {$sub}[$use]{'file'},
                                    $self->{'_apidoc_parser'}
                                    ->{'apidoc_modules'}{$package}{'sub'}
                                    {$sub}[$use]{'line'};
                            }
                            syswrite $DOC, "=back\n\n";
                        }
                    }
                    for my $section (
                        grep {
                            !m[(?:NAME|Description|Synopsis)]
                        }
                        @{  $self->{'_apidoc_parser'}
                                ->{'apidoc_modules'}{$package}{'@section'}
                        }
                        )
                    {   next
                            if !$self->{'_apidoc_parser'}
                                ->{'apidoc_modules'}{$package}{'section'}
                                {$section};
                        syswrite $DOC, "=head1 $section\n\n";
                        syswrite $DOC,
                            $self->{'_apidoc_parser'}
                            ->{'apidoc_modules'}{$package}{'section'}
                            {$section}{'text'} || '';
                    }
                    {
                        if (scalar keys %{
                                $self->{'_apidoc_parser'}
                                    ->{'apidoc_modules'}{$package}{'.'}
                                    {'author'}
                            }
                            )
                        {   syswrite $DOC, "=head1 Author\n\n";
                            for my $author (
                                   sort
                                   keys %{
                                       $self->{'_apidoc_parser'}
                                           ->{'apidoc_modules'}{$package}{'.'}
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
                                       $self->{'_apidoc_parser'}
                                           ->{'apidoc_modules'}{$package}{'.'}
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
                            sort keys %{
                                $self->{'_apidoc_parser'}
                                    ->{'apidoc_modules'}{$package}{'.'}{'git'}
                            }
                        )
                    {   syswrite $DOC, "=for git $id\n\n";
                    }
                }
                syswrite $DOC, "=cut\n";
                close $DOC;
            }
            print "done\n";
        }

        sub _document_function {
            my ($self, $package, $sub, $use) = @_;

            # TODO:
            #   write documentation in here
            #   mention defaults/types/import tags
            my ($return, $call, @args) = ('', '', ());
            my %types = ('AV *' => '@', 'CV *' => '\&', 'HV *' => "\%");
            for my $arg (@{$use->{'args'}}) {
                my ($type, $name, $default) =
                    ($arg =~
                     m[^([\w:\s\*]+)\s+([(?:\w_|\.{3})]+)(?:\s+=\s+(.+))?]s
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
                my ($type, $name, $default) =
                    ($use->{'return'} =~
                     m[^([\w:\s\*]+)\s+([\w_]+)(?:\s+=\s+(.+))?]s);
                if (!(defined $type && defined $name)) {
                    printf
                        "Malformed apidoc: Missing return type in %s at %s line %d\n",
                        $use->{'return'}, $use->{file}, $use->{line};
                }
                elsif ($use->{'flags'} !~ m[E]) {
                    $return = 'my '
                        . ($types{$type} ? $types{$type} : '$')
                        . $name . ' = ';
                }
            }
            $call =
                $use->{'flags'} =~ m[E]
                ? ''
                : $use->{'flags'} =~ m[F] ? 'FLTK::'    #$package . '::'
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
}
1;

=pod

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

CPAN ID: SANKO

=head1 License and Legal

Copyright (C) 2008-2010 by Sanko Robinson <sanko@cpan.org>

This program is free software; you can redistribute it and/or modify it under
the terms of
L<The Artistic License 2.0|http://www.perlfoundation.org/artistic_license_2_0>.
See the F<LICENSE> file included with this distribution or
L<notes on the Artistic License 2.0|http://www.perlfoundation.org/artistic_2_0_notes>
for clarification.

When separated from the distribution, all original POD documentation is
covered by the
L<Creative Commons Attribution-Share Alike 3.0 License|http://creativecommons.org/licenses/by-sa/3.0/us/legalcode>.
See the
L<clarification of the CCA-SA3.0|http://creativecommons.org/licenses/by-sa/3.0/us/>.

=for git $Id$

=cut
