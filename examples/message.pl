#!perl -w -I../blib/arch/ -I../blib/lib
# based on message.cxx
#
use strict;
use warnings;
use FLTK;
$|++;
if (!FLTK::ask('Do you want to disable beep sounds?')) {
    FLTK::beep_on_dialog(1);
}
FLTK::message(
     'Spelling check sucessfull, 1002 errors found with 19.4805% confidence');
FLTK::alert(
    'Quantum fluctuations in the space-time continuum detected, you have 10 seconds to comply.'
);
printf "FLTK::ask returned %d\n",
    FLTK::ask('Do you really want to continue?');
printf "FLTK::choice returned %d\n",
    FLTK::choice('Choose one of the following:', 'choice0',
                 'choice1',                      'choice2');
my $r = FLTK::input('Please enter a string for "testing":',
                    'this is the default value');
printf qq[FLTK::input returned "%s"\n], $r ? $r : 'NULL';
$r = FLTK::password(q[Enter sombody's password:]);
printf qq[FLTK::password returned "%s"\n], $r ? $r : 'NULL';
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
