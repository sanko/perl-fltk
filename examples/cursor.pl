
=pod

=for name cursor.pl

=for abstract Tests Widget::cursor()

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=cut
use strict;
use warnings;
use FLTK qw[:cursor :events run];
$|++;

#
my %cursors = ('CURSOR_ARROW'  => CURSOR_ARROW,
               'CURSOR_CROSS'  => CURSOR_CROSS,
               'CURSOR_WAIT'   => CURSOR_WAIT,
               'CURSOR_INSERT' => CURSOR_INSERT,
               'CURSOR_HAND'   => CURSOR_HAND,
               'CURSOR_HELP'   => CURSOR_HELP,
               'CURSOR_MOVE'   => CURSOR_MOVE,
               'CURSOR_NS'     => CURSOR_NS,
               'CURSOR_WE'     => CURSOR_WE,
               'CURSOR_NWSE'   => CURSOR_NWSE,
               'CURSOR_NESW'   => CURSOR_NESW,
               'CURSOR_NO'     => CURSOR_NO,
               'CURSOR_NONE'   => CURSOR_NONE
);
{

    package CursorBox;
    our @ISA = qw[FLTK::Widget];

    sub handle {
        my ($self, $event) = @_;
        if ($event == ::ENTER) {
            $self->cursor($cursors{$self->label()});
            return 0;
        }
        return 1 if ($event == ::PUSH);    # drag the cursor around
        return 0;
    }
}

#
my $window
    = new FLTK::Window(200 + 2 * 5, (25 + 5) * (scalar keys %cursors) + 5);
$window->begin();
my $i = 0;
for my $label (sort keys %cursors) {
    new CursorBox(5, 5 + $i++ * (25 + 5), 200, 25, $label)
        ->tooltip('Click and drag this cursor around.');
}
$window->end();
$window->show();
exit run();
