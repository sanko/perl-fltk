package FLTK::Version;
{
    use strict;
    use warnings;
    use version qw[qv];
    our $VERSION_BASE = 0; our $FLTK_SVN = 6671; our $UNSTABLE_RELEASE = 4; our $VERSION = sprintf(($UNSTABLE_RELEASE ? q[%1d.%04d_%03d] : q[%1d.%04d]), $VERSION_BASE, $FLTK_SVN, $UNSTABLE_RELEASE);
    our $PRODUCT_TOKEN
        = sprintf
        'FLTK.pm %s based on the Feather Light Toolkit <http://fltk.org/>.',
        $VERSION;
    1;
}

=pod

=head1 NAME

FLTK::Version - FLTK's project-wide version numbers

=head1 Description

Because of the problems coordinating revision numbers in a distributed
version control system and across a directory full of Perl modules, this
module provides a central location for the project's overall release
number.

=head1 Versioning Specification

This module is based on the experimental 2.0.x branch of the Feather Light
Tool Kit. Our version numbers are generated to reflect the SVN revision of
the bundled FLTK source. These will most likely be the most recent weekly
checkouts.

The distribution's name is taken from FLTK's version number. For example,
a distribution bundled and built on FLTK C<r6543> would look look like
C<FLTK-0.6543.tar.gz> and the distribution's version would obviously be
C<0.6543>. When present, the three minor digits will represent how stable
I deem my module:

 _0xx may lead to sterility
 _1xx is risky business
 _2xx is pretty stable
 _3xx is slightly less stable
 _4xx is solid
 _5xx is stable enough
 _6xx is without a doubt really stable
 _7xx may contain new code for the next .0 release, so it's less stable
 _8xx probably contains new, stable code for the next .0 release
 _9xx uploaded only to get tester data before the next .0 release

Even numbers should be fairly stable so unless you enjoy broken software
stick with those.

=head1 See Also

PAUSE FAQ sub-section entitled "Developer Releases"
(http://www.cpan.org/modules/04pause.html)

http://slashdot.org/comments.pl?sid=997033&cid=25390887

=head1 Disclaimer

This document and the specification behind it are subject to change.
All modifications will be documented in the Changes file included with
this distribution.  All versions of this file can be found in the
project's git repository.

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

CPAN ID: SANKO

=head1 License and Legal

Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify
it under the terms of The Artistic License 2.0.  See the F<LICENSE>
file included with this distribution or
http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered
by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

=for git $Id$ for got=

=cut
