
=pod

=for abstract Demonstrates how to update a progress bar within a cpu intensive
operation

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for author Greg Ercolano - http://seriss.com/people/erco/fltk/

=for git $Id$

=cut

use strict;
use warnings;
use FLTK qw[check run];

# Button callback
sub btn_cb {
    my ($self, $w) = @_;

    # Deactivate the button
    $self->deactivate();    # prevent button from being pressed again
    check();                # give fltk some cpu to gray out button

    # Make the progress bar
    $w->begin();            # add progress bar to parent window.
    my $progress = FLTK::ProgressBar->new(10, 50, 200, 30);
    $progress->minimum(0);    # set progress bar attribs.
    $progress->maximum(1);
    $w->end();                # end of adding to window

    # Computation loop..
    for my $t (1 .. 20) {
        $progress->position($t / 20);    # update progress bar
        check();     # give fltk some cpu to update the screen
        sleep(1);    # 'your stuff' that's compute intensive
        last if !$w->visible;  # stop processing if the window has been closed
    }

    # Cleanup
    $progress->destroy;    # remove progress bar from window and deallocate it
    $self->activate();     # reactivate button
    $w->redraw();          # tell window to redraw now that progress removed
}

# main
my $win = FLTK::Window->new(220, 90);
my $btn = FLTK::Button->new(10, 10, 100, 25, 'Press');
$btn->callback(\&btn_cb, $win);
$win->add($btn);
$win->resizable($win);
$win->show();
exit run();
