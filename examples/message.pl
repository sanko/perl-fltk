#!perl -w -I../blib/arch/ -I../blib/lib
# based on message.cxx
#
use strict;
use warnings;
use FLTK;
$|++;
if (!FLTK::ask("Do you want to disable beep sounds ?", "continue")) {
    FLTK::beep_on_dialog(1);
}
FLTK::message(
            "Spelling check sucessfull, %d errors found with %g%% confidence",
            1002, 100 * (15 / 77.0));
FLTK::alert("Quantum fluctuations in the space-time continuum detected, "
                . "you have %g seconds to comply.",
            10.0
);
printf("FLTK::ask returned %d\n",
       FLTK::ask("Do you really want to %s?", "continue"));
printf("FLTK::choice returned %d\n",
       FLTK::choice("Choose one of the following:", "choice0",
                    "choice1",                      "choice2"
       )
);
my $r = FLTK::input("Please enter a string for '%s':",
                    "this is the default value",
                    "testing"
);
printf("FLTK::input returned \"%s\"\n", $r ? $r : "NULL");
$r = FLTK::password("Enter %s's password:", 0, "somebody");
printf("FLTK::password returned \"%s\"\n", $r ? $r : "NULL");
__END__
Copyright (C) 2009 by Sanko Robinson <sanko@cpan.org>

This program is free software; you can redistribute it and/or modify it
under the terms of The Artistic License 2.0.  See the LICENSE file
included with this distribution or
http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered by
the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

$Id$
