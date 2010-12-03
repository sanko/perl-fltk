package FLTK;
{

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Perl bindings to the Fast Light Toolkit

=for git $Id$

=cut

    use strict;
    use warnings;
    our $MAJOR = 532; our $MINOR = 6; our $DEV = 1; our $VERSION = sprintf('%1.3f%03d' . ($DEV ? (($DEV < 0 ? '' : '_') . '%03d') : ('')), $MAJOR / 1000, $MINOR, abs $DEV);
    use XSLoader;
    use vars qw[@EXPORT_OK @EXPORT %EXPORT_TAGS];
    use Exporter qw[import];

    #
    our $NOXS ||= $0 eq __FILE__;    # for testing
    XSLoader::load 'FLTK', $VERSION
        if !$FLTK::NOXS;             # Fills %EXPORT_TAGS on BOOT

    #
    @EXPORT_OK = sort map { @$_ = sort @$_; @$_ } values %EXPORT_TAGS;
    $EXPORT_TAGS{'all'} = \@EXPORT_OK;    # When you want to import everything
    @{$EXPORT_TAGS{'style'}}              # Merge these under a single tag
        = sort map { defined $EXPORT_TAGS{$_} ? @{$EXPORT_TAGS{$_}} : () }
        qw[box font label]
        if 1 < scalar keys %EXPORT_TAGS;
    @EXPORT  # Export these tags (if prepended w/ ':') or functions by default
        = sort map { m[^:(.+)] ? @{$EXPORT_TAGS{$1}} : $_ }
        qw[:style :default]
        if 0 && keys %EXPORT_TAGS > 1;
}
1;

=encoding utf8

=head1 NAME

FLTK - Perl bindings to the 2.0.x branch of the Fast Light Toolkit

=head1 Synopsis

=for markdown {%highlight perl linenos%}

    use strict;
    use warnings;
    use FLTK qw[:style];

    my $window = FLTK::Window->new(300, 180);
    $window->begin();
    my $box = FLTK::Widget->new(20, 40, 260, 100, "Hello, World!");
    $box->box(UP_BOX);
    $box->labelfont(HELVETICA_BOLD_ITALIC);
    $box->labelsize(36);
    $box->labeltype(SHADOW_LABEL);
    $window->end();
    $window->show();
    exit FLTK::run();

=for markdown {%endhighlight%}

=head1 Description
FLTK is a graphical user interface toolkit for X (UNIX®), Microsoft® Windows®,
OS/X, and several other platforms. FLTK provides modern GUI functionality
without the bloat and supports 3D graphics via OpenGL® and its built-in GLUT
emulation.

This module, L<FLTK|FLTK>, exposes bindings to the experimental 2.0.x branch
of the Fast Light Toolkit.

=head1 See Also

L<FLTK::Notes|FLTK::Notes>, L<FLTK::Basics|FLTK::Basics>,
L<FLTK::Cookbook|FLTK::Cookbook>, and L<FLTK::CheatSheet|FLTK::CheatSheet>

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
