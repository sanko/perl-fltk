#!perl
package FLTK;

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Perl interface to the Fast Light Toolkit

=for git $Id$

=cut
use strict;
use warnings;
our $VERSION_BASE = 530; our $UNSTABLE_RELEASE = 1; our $VERSION = sprintf(($UNSTABLE_RELEASE ? '%.3f_%03d' : '%.3f'), $VERSION_BASE / 1000, $UNSTABLE_RELEASE);
use XSLoader;
use vars qw[@EXPORT_OK @EXPORT %EXPORT_TAGS];
use Exporter qw[import];

#
our $NOXS ||= $0 eq __FILE__;    # for testing
XSLoader::load 'FLTK', $VERSION if !$FLTK::NOXS;

#
@EXPORT_OK = sort map { @$_ = sort @$_; @$_ } values %EXPORT_TAGS;
$EXPORT_TAGS{'all'} = \@EXPORT_OK;
@{$EXPORT_TAGS{'style'}}
    = sort map { defined $EXPORT_TAGS{$_} ? @{$EXPORT_TAGS{$_}} : () }
    qw[box font label]
    if 1 < scalar keys %EXPORT_TAGS;
@EXPORT    # Export these tags (if prepended w/ ':') or functions by default
    = sort map { m[^:(.+)] ? @{$EXPORT_TAGS{$1}} : $_ } qw[:style :default]
    if 1 < scalar keys %EXPORT_TAGS;
1;
