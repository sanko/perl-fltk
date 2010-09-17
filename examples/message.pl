
=pod

=for abstract Based on message.cxx

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=cut

use strict;
use warnings;
use FLTK qw[:dialog];
$|++;
if (!ask('Do you want to disable beep sounds?')) {
    beep_on_dialog(1);
}
message(
     'Spelling check sucessfull, 1002 errors found with 19.4805% confidence');
alert(
    'Quantum fluctuations in the space-time continuum detected, you have 10 seconds to comply.'
);
printf "FLTK::ask returned %d\n", ask('Do you really want to continue?');
printf "FLTK::choice returned %d\n",
    choice('Choose one of the following:', 'choice0', 'choice1', 'choice2');
my $r = input('Please enter a string for "testing":',
              'this is the default value');
printf qq[FLTK::input returned "%s"\n], $r ? $r : 'NULL';
$r = password(q[Enter sombody's password:]);
printf qq[FLTK::password returned "%s"\n], $r ? $r : 'NULL';
