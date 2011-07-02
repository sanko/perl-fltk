
=pod

=for abstract Simple echo server

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=cut

use strict;
use warnings;
use FLTK qw[:default :fd];
use Socket;

#
my $window = FLTK::Window->new(100, 100);
$window->add(FLTK::Button->new(0, 0, 100, 100, 'Exit'))
    ->callback(sub { $window->hide() });
my ($fd_s, $fd_c);
{
    my ($port) = @_ ? (shift =~ /^(\d+)$/) : 2345 || die 'invalid port';
    die "socket: $!"
        if !socket my $sock, PF_INET, SOCK_STREAM, getprotobyname 'tcp';
    die "setsockopt: $!"
        if !setsockopt $sock, SOL_SOCKET, SO_REUSEADDR, pack 'l', 1;
    die "bind: $!" if !bind $sock, sockaddr_in $port, INADDR_ANY;
    die "listen: $!" if !listen $sock, 3;
    warn "echo server started on port $port\n";
    $fd_s = add_fd(
        $sock, READ,
        sub {
            my $fh = shift;
            my $paddr = accept(my $peer, $fh);
            return remove_fd $sock if !$paddr;
            my ($port, $iaddr) = sockaddr_in $paddr;
            my $name = gethostbyaddr $iaddr, AF_INET;
            warn "connection from $name [", inet_ntoa($iaddr),
                "] at port $port\n";
            $fd_c = add_fd(
                $peer, READ,
                sub {
                    my $p = shift;
                    return remove_fd $peer if !sysread $p, my $data, 16384;
                    syswrite $p, $data;
                    return if $data !~ m[^q(uit\b)?]i;
                    remove_fd $p;
                    shutdown $p, 2;
                    close $p;
                }
            );
        }
    );
}
$window->show();
exit run();
