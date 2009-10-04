
=pod

=for abstract OpenGL example

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=cut

use strict;
use warnings;
use FLTK;
$|++;
my $theta     = 0.0;
my $speed     = 0.0;
my $direction = -1;
my $range     = 12;
{

    package MyGlWindow;
    our @ISA = 'FLTK::GlWindow';
    use FLTK qw[:gl];
    use OpenGL;

    sub draw {
        my ($self) = @_;
        if (!$self->valid()) {
            $self->valid(1);
            glLoadIdentity();
            glViewport(0, 0, $self->w(), $self->h());
        }
        glClearColor(0, 0, 0, 0);
        glClear(GL_COLOR_BUFFER_BIT);
        glPushMatrix();
        glRotatef($theta, 0.0, 0.0, 1.0);
        glBegin(GL_TRIANGLES);
        glColor3f(1.0, 0.0, 0.0);
        glVertex2f(0.0, 1.0);
        glColor3f(0.0, 1.0, 0.0);
        glVertex2f(0.87, -0.5);
        glColor3f(0.0, 0.0, 1.0);
        glVertex2f(-0.87, -0.5);
        glEnd();
        glPopMatrix();
        $theta += $speed;
        glsetcolor(FLTK::WHITE());
        glsetfont($self->labelfont(), $self->labelsize() * 3);
        gldrawtext("Hello, World!", -.4, 0);
    }
}
my $gl = MyGlWindow->new(100, 100, 500, 500, 'FLTK OpenGL Window');
$gl->resizable($gl);
$gl->show(1, [qw[T hi s]]);    # this actually opens the window

sub tick {
    my ($v) = @_;
    if ($speed > $range) {
        $direction = -1;
    }
    elsif ($speed < -$range) {
        $direction = 1;
    }
    $speed += (0.1 * $direction);
    $gl->redraw();
    FLTK::add_timeout(0.01, \&tick, $v);
}
FLTK::add_timeout(0.01, \&tick, $gl);
FLTK::run();
$gl->destroy();
