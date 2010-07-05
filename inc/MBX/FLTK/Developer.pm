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

    sub new {
        my $class = shift;
        my $self  = $class->SUPER::new(@_);
        $self->metafile('META.json') if $self->metafile eq 'META.yml';
        return $self;
    }

    sub write_metafile {
        my $s = shift;
        require CPAN::Meta::Converter;
        require CPAN::Meta::Validator;
        require JSON;
        JSON->VERSION(2);
        my $data = {};
        $s->prepare_metadata($data);
        $data->{'meta-spec'} = {    # In reality, it's probably a hybrid...
                 url     => 'http://search.cpan.org/perldoc?CPAN::Meta::Spec',
                 version => 2
        };
        my $metafile = $s->metafile;
        my $cmc      = CPAN::Meta::Converter->new($data);   # ...so we convert
        $data = $cmc->convert(version => 2);    # ...and clean it up here
        my $cmv = CPAN::Meta::Validator->new($data);
        say $_    # ...and double check the result
            for $cmv->is_valid
            ? ()
            : 'Invalid META structure. Errors found:', $cmv->errors;
        $data->{generated_by} = 'Conversion, Software version 7.0';
        open my ($fh), '>',    # ...and eventually save it to disk.
            $metafile || die "can't open $metafile for writing: $!";
        syswrite $fh, JSON->new->ascii(1)->pretty->canonical(1)->encode($data)
            || die "can't print metadata to $metafile: $!";
        close $fh || die "error closing $metafile: $!";
        $s->{'wrote_metadata'} = 1;
        $s->_add_to_manifest('MANIFEST', $metafile);
    }
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
                elsif ($line
                       =~ m[^\s*MODULE\s*=\s*\S+\s+PACKAGE\s*=\s*(\S+)\s*$])
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
        $CHANGES_D
            =~ s[(_ -.-. .... .- -. --. . ... _+).*][$1 . sprintf <<'END',
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
            my $_Repo
                = $self->{'properties'}{'meta_merge'}{'resources'}
                {'repository'}{'web'}
                || $self->{'properties'}{'meta_merge'}{'resources'}
                {'repository'}{'url'}
                || $self->{'properties'}{'meta_merge'}{'resources'}
                {'repository'}
                || '';

            # start changing the data around
            my $CHANGES_O = $CHANGES_D;
            $CHANGES_D =~ s[\$(Id)(:[^\$]*)?\$][\$$1: $_Id \$]ig;
            $CHANGES_D =~ s[\$(Date)(:[^\$]*)?\$][\$$1: $_Date \$]ig;
            $CHANGES_D =~ s[\$(Mod(ified)?)(:[^\$]*)?\$][\$$1: $_Mod \$]ig;
            $CHANGES_D
                =~ s[\$(Url)(:[^\$]*)?\$][\$$1: $_Repo/raw/master/$file \$]ig
                if $_Repo;
            $CHANGES_D
                =~ s[\$(Rev(ision)?)(?::[^\$]*)?\$]["\$$1: ". ($2?$_Commit:$_Commit_short)." \$"]ige;

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
        my $demo_files
            = -d 'examples' ? $self->rscan_dir('examples', qr[\.pl$]) : [];
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
}
1;

=pod

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

CPAN ID: SANKO

=head1 License and Legal

Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify it under
the terms of The Artistic License 2.0. See the F<LICENSE> file included with
this distribution or http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered by the
Creative Commons Attribution-Share Alike 3.0 License. See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

=for git $Id$

=cut
