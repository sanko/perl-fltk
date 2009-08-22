package MBX::FLTK::Developer;
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
    use base 'MBX::FLTK';
    use Alien::FLTK;

    sub make_tarball {
        my ($self, $dir, $file, $quiet) = @_;
        $file ||= $dir;
        $self->do_system(
            'tar --mode=0755 -c' . ($quiet ? q[] : 'v') . "f $file.tar $dir");
        $self->do_system("gzip -9 -f -n $file.tar");
        return 1;
    }

    sub ACTION_distdir {
        my ($self, $args) = @_;
        if (!$self->notes('no_rcs')) {
            $self->SUPER::depends_on('changelog');
            $self->SUPER::depends_on('RCS');
        }
        $self->SUPER::ACTION_distdir(@_);
    }

    sub ACTION_dist {
        my ($self, $args) = @_;
        require Devel::PPPort;
        my $ppp = rel2abs(catdir(qw[xs ppport.pl]));
        Devel::PPPort::WriteFile($ppp) if !-e $ppp;
        $self->SUPER::ACTION_dist(@_);
    }

    sub ACTION_changelog {
        my ($self) = @_;
        require POSIX;
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
            my $Repo
                = $self->{'properties'}{'meta_merge'}{'resources'}
                {'repository'}
                || '';

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
}
1;
