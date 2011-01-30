#!perl

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Tests for add_fd( ... ) and related functions

=for git $Id$

=cut

use strict;
use warnings;
use Test::More 0.82;
plan tests => 18;
use Module::Build qw[];
use Time::HiRes qw[];
use Socket;
my $test_builder = Test::More->builder;
BEGIN { chdir '../..' if not -d '_build'; }
use lib 'inc', 'blib/lib', 'blib/arch', 'lib';
my $build           = Module::Build->current;
my $release_testing = $build->notes('release_testing');
my $verbose         = $build->notes('verbose');
my $interactive     = $build->notes('interactive');

#
use FLTK qw[:fd :default];
my $i;

#
SKIP: {
    my ($client, $server);
    my $port = 0;
    skip "socket: $!", 18
        if !socket $server, PF_INET, SOCK_STREAM, getprotobyname 'tcp';
    skip "bind: $!", 17 if !bind $server, sockaddr_in $port, INADDR_ANY;
    skip "listen: $!", 16 if !listen $server, 3;
    ($port, my $iaddr) = sockaddr_in getsockname($server);
    note "echo server started on port $port\n";
    ok add_fd(
        $server, READ,
        sub {
            my $fh = shift;
            my $paddr = accept(my ($peer), $fh);
            return remove_fd $server if !$paddr;
            my ($port, $iaddr) = sockaddr_in $paddr;
            my $name = gethostbyaddr $iaddr, AF_INET;
            note "connection from $name [", inet_ntoa($iaddr),
                "] at port $port\n";
            ok add_fd(
                $peer, READ,
                sub {
                    my $p = shift;
                    my $read = sysread $p, my $data, 16384;
                    ok $read, "read $read bytes from peer";
                    return remove_fd $peer if !$read;
                    my $wrote = syswrite $p, $data;
                    ok $wrote, "wrote $wrote bytes to peer ($wrote)";
                    return if $data !~ m[^quit\b]i;
                    ok remove_fd($p),
                        'removed peer from list of watched file descriptors';
                    shutdown $p, 2;
                    close $p;
                    $i++;
                }
                ),
                'added new peer to list of watched file descriptors';
        }
        ),
        'added server to watch list for reading (accept)';
    {

        # Client
        my $iaddr = inet_aton('127.0.0.1')
            || skip 'cannot resolve localhost?!?', 15;
        my $paddr = sockaddr_in($port, $iaddr);
        socket($client, PF_INET, SOCK_STREAM, getprotobyname('tcp'))
            || skip "socket: $!", 14;
        connect($client, $paddr) || skip "connect: $!", 13;
        ok add_fd(
            fileno $client,    # Use the fileno for this... just to test
            WRITE,
            sub {
                is syswrite(shift, "Test!\n"), 6,
                    'wrote 6 bytes to server (Test\\n)';
            }
            ),
            'added fileno($client) for write (checks connect)';
        ok add_fd(
            fileno $client,    # Use the fileno for this... just to test
            READ,
            sub {
                my $data;
                is sysread(shift, $data, 1024), 12,
                    'read 12 bytes from $server';
                ok remove_fd($client), 'removed $client from watch list';
                ok add_fd(
                    fileno $client,  # Use the fileno for this... just to test
                    WRITE,
                    sub {
                        is syswrite(shift, "quit\n"), 5,
                            'wrote 5 bytes to client (quit\\n)';
                    }
                    ),
                    'added fileno( $client ) to watch list';
            }
            ),
            'added $client to watch list for read';
    }
}
for (1 .. 60) { FLTK::wait(1); last if $i; }
