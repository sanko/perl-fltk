
=pod

=for abstract Basic xpmImage example

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=cut
use strict;
use warnings;
use FLTK;

#
my $win = FLTK::Window->new(100, 50, 'Purr');
$win->image(
    FLTK::xpmImage->new(

        # width height ncolors chars_per_pixel
        '50 34 4 1',

        # colormap
        '  c black',
        'o c #ff9900',
        '@ c #ffffff',
        '# c None',

        # pixels
        '##################################################',
        '###      ##############################       ####',
        '### ooooo  ###########################  ooooo ####',
        '### oo  oo  #########################  oo  oo ####',
        '### oo   oo  #######################  oo   oo ####',
        '### oo    oo  #####################  oo    oo ####',
        '### oo     oo  ###################  oo     oo ####',
        '### oo      oo                     oo      oo ####',
        '### oo       oo  ooooooooooooooo  oo       oo ####',
        '### oo        ooooooooooooooooooooo        oo ####',
        '### oo     ooooooooooooooooooooooooooo    ooo ####',
        '#### oo   ooooooo ooooooooooooo ooooooo   oo #####',
        '####  oo oooooooo ooooooooooooo oooooooo oo  #####',
        '##### oo oooooooo ooooooooooooo oooooooo oo ######',
        '#####  o ooooooooooooooooooooooooooooooo o  ######',
        '###### ooooooooooooooooooooooooooooooooooo #######',
        '##### ooooooooo     ooooooooo     ooooooooo ######',
        '##### oooooooo  @@@  ooooooo  @@@  oooooooo ######',
        '##### oooooooo @@@@@ ooooooo @@@@@ oooooooo ######',
        '##### oooooooo @@@@@ ooooooo @@@@@ oooooooo ######',
        '##### oooooooo  @@@  ooooooo  @@@  oooooooo ######',
        '##### ooooooooo     ooooooooo     ooooooooo ######',
        '###### oooooooooooooo       oooooooooooooo #######',
        '###### oooooooo@@@@@@@     @@@@@@@oooooooo #######',
        '###### ooooooo@@@@@@@@@   @@@@@@@@@ooooooo #######',
        '####### ooooo@@@@@@@@@@@ @@@@@@@@@@@ooooo ########',
        '######### oo@@@@@@@@@@@@ @@@@@@@@@@@@oo ##########',
        '########## o@@@@@@ @@@@@ @@@@@ @@@@@@o ###########',
        '########### @@@@@@@     @     @@@@@@@ ############',
        '############  @@@@@@@@@@@@@@@@@@@@@  #############',
        '##############  @@@@@@@@@@@@@@@@@  ###############',
        '################    @@@@@@@@@    #################',
        '####################         #####################',
        '##################################################'
    )
);
$win->show;
exit FLTK::run;
