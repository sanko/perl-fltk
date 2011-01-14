
=pod

=for abstract Based on helloask.cxx (example2a)

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
$window->begin();
FLTK::Button->new(0, 0, 100, 100, 'Exit')->callback(sub { $window->hide() });
$window->end();
{
    my $sock;
    my $port = shift || 2345;
    my $proto = getprotobyname('tcp');
    ($port) = $port =~ /^(\d+)$/ or die "invalid port";
    socket($sock, PF_INET, SOCK_STREAM, $proto) || die "socket: $!";
    setsockopt($sock, SOL_SOCKET, SO_REUSEADDR, pack("l", 1))
        || die "setsockopt: $!";
    bind($sock, sockaddr_in($port, INADDR_ANY)) || die "bind: $!";
    listen($sock, 3) || die "listen: $!";
    warn "echo server started on port $port";
    add_fd(
        $sock,
        FLTK::READ(),
        sub {
            my ($fh) = @_;
            my $paddr = accept(my($peer), $fh);
            return remove_fd($sock) if !$paddr;
            my ($port, $iaddr) = sockaddr_in($paddr);
            my $name = gethostbyaddr($iaddr, AF_INET);
            warn "connection from $name [", inet_ntoa($iaddr),
                "] at port $port";
            add_fd(
                $peer,
                FLTK::READ,
                sub {
                    sysread($peer, my ($data), 1024 * 16)
                        || return remove_fd($peer);
                    syswrite($peer, $data);
                    return if ord $data != 3;    # Close connection on Ctrl-C
                    remove_fd($peer);
                    shutdown $peer, 2;
                    close $peer;
                }
            );
        }
    );
}
$window->show();
exit run();
__END__


use strict;
use warnings;
use Data::Dump;
$|++;
use FLTK qw[:default :dialog :all];    #ddx \%FLTK::;
{
    add_timeout(4, sub { warn 'pong' });
    add_timeout(2, sub { warn 'ping' });
}
my $w = FLTK::Window->new(500, 215, 'Title');
$w->begin;
{
    my $tabs = FLTK::TabGroup->new(5, 5, 500 - 10, 180);

    #$w->resizable($tabs);
    $tabs->begin;
    $tabs->callback(
        sub {
            my $self = shift;
            printf <<'END',
Tab change!
Current tab index: %d
Current tab label: %s
END
                $self->value,                   # zero based index
                $self->selected_child->label;   # selected_child() is a Widget
        }
    );
    {                                           # Aaa tab
        my $aaa = FLTK::Group->new(10, 20, 500 - 20, 200 - 45, "Aaa");
        $aaa->begin;
        {
            my $b1 = FLTK::Button->new(10, 20, 90, 25, "Button A1");
            my $b2 = FLTK::Button->new(10, 50, 90, 25, "Button A2");
            my $b3 = FLTK::Button->new(10, 80, 90, 25, "Button A3");
        }
        $aaa->end();

        # Bbb tab
        my $bbb = FLTK::Group->new(10, 35, 500 - 10, 200 - 35, "Bbb");
        $bbb->begin;
        {
            my $b1 = FLTK::Button->new(10,  20, 90, 25, "Button B1");
            my $b2 = FLTK::Button->new(110, 20, 90, 25, "Button B2");
            my $b3 = FLTK::Button->new(210, 20, 90, 25, "Button B3");
            my $b4 = FLTK::Button->new(10,  50, 90, 25, "Button B4");
            my $b5 = FLTK::Button->new(110, 50, 90, 25, "Button B5");
            my $b6 = FLTK::Button->new(210, 50, 90, 25, "Button B6");
            my $b7 = FLTK::Button->new(310, 35, 90, 25, "Goto first tab");
            $b7->callback(
                sub {
                    $tabs->value(0)    # does not trigger TabGroup callback
                }
            );
        }
        $bbb->end();
    }
    $tabs->end();
}
{
    my $status_bar = FLTK::StatusBarGroup->new();
    $status_bar->child_box(THIN_DOWN_BOX, FLTK::StatusBarGroup::SBAR_RIGHT());

    # ... more code ...
    # sets a right-aligned formatted text :
    $status_bar->set('8 items', FLTK::StatusBarGroup::SBAR_RIGHT());

    # sets a centered text:
    $status_bar->set('Hi', FLTK::StatusBarGroup::SBAR_CENTER());

    # ... more code ...
    # undef or 0-len text removes the text box:
    $status_bar->set('', FLTK::StatusBarGroup::SBAR_CENTER());
};

#
my $sock;
use Socket;
use Carp;
my $EOL   = "\015\012";
my $port  = shift || 2345;
my $proto = getprotobyname('tcp');
($port) = $port =~ /^(\d+)$/ or die "invalid port";
socket($sock, PF_INET, SOCK_STREAM, $proto) || die "socket: $!";
setsockopt($sock, SOL_SOCKET, SO_REUSEADDR, pack("l", 1))
    || die "setsockopt: $!";
bind($sock, sockaddr_in($port, INADDR_ANY)) || die "bind: $!";
listen($sock, 3) || die "listen: $!";
warn "server started on port $port";
binmode $sock;
my $client;

if (0) {
    for (; my $paddr = accept($client, $sock); close $client) {
        my ($port, $iaddr) = sockaddr_in($paddr);
        my $name = gethostbyaddr($iaddr, AF_INET);
        warn "connection from $name [", inet_ntoa($iaddr), "] at port $port";
        print $client "Hello there, $name, it's now ", scalar localtime, $EOL;
    }
}
elsif (1) {
    #ioctl($sock, 0x8004667e, pack("I", 1));
    warn add_fd(
        $sock,
        FLTK::READ(),
        sub {
            my ($fh) = @_;
            warn join ', ', @_;
            my $peer;
            my $paddr = accept($peer, $fh);
            return remove_fd($sock) if !$paddr;
            my ($port, $iaddr) = sockaddr_in($paddr);
            my $name = gethostbyaddr($iaddr, AF_INET);
            warn "connection from $name [", inet_ntoa($iaddr),
                "] at port $port";
            syswrite $peer,
                "Hello there, $name, it's now " . scalar localtime . $EOL;
            shutdown($peer, 2);
            close $peer;
        }
    );
    remove_fd( $sock );
 #FLTK::add_fd( $sock, FLTK::WRITE,  sub { warn 'Y' });
 #FLTK::add_fd(    $sock,    FLTK::EXCEPT(), sub { warn 'Z'; warn $!; die; });
    #close $sock;
}
else {
    FLTK::new_server(
        1234,
        sub {
            my $peer;
            warn 'Ready';
            my $paddr = accept($peer, $sock);
            return if !$paddr;
            warn 'EH!';
            my ($port, $iaddr) = sockaddr_in($paddr);
            my $name = gethostbyaddr($iaddr, AF_INET);
            warn "connection from $name [", inet_ntoa($iaddr),
                "] at port $port";
            print $peer "Hello there, $name, it's now ", scalar localtime,
                $EOL;
            close $peer;
        },
        sub { warn join ', ', @_ }
    );
}
$w->end;
ddx $w->children;
$w->show;
run();

#warn ask("Test");
#warn $w;
