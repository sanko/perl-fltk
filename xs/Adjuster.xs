#include "include/FLTK_pm.h"

MODULE = FLTK::Adjuster               PACKAGE = FLTK::Adjuster

#ifndef DISABLE_ADJUSTER

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Adjuster - FLTK::Valuator subclass

=head1 Description

L<Valuator|FLTK::Valuator> widget that displays three buttons. The user pushes
down the button and drags left/right to adjust, or clicks the button to step,
or shift-clicks to step backwards. One button moves in the
L<C<step()>|FLTK::Valuator/"step"> values, the next in
C<10 * >L<C<step()>|FLTK::Valuator/"step">, and the third in
C<100 * >L<C<step()>|FLTK::Valuator/"step">. Holding down shift makes the
buttons move in the opposite way.

B<Note: This is a depreciated widget. Please see
L<FLTK::Notes|FLTK::Notes/"NotesDepPol">.>

=cut

#include <fltk/Adjuster.h>

=head1 C<Constructor>

=for apidoc d||FLTK::Adjuster self|new|int x|int y|int w|int h|char * label = ''|

Creates a new C<FLTK::Adjuster> object. This constructor expects integers for
C<$x, $y, $w, $h> and accepts an optional string for C<$label>.

Usage:

=for markdown {%highlight perl%}

  my $adjustor_1 = FLTK::Adjuster->new( $x, $y, $w, $h, $label );
  my $adjustor_2 = FLTK::Adjuster->new( 40, 40, 150, 40);

=for markdown {%endhighlight%}

=cut

#include "include/RectangleSubclass.h"

fltk::Adjuster *
fltk::Adjuster::new( int x, int y, int w, int h, char * label = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::Adjuster>(CLASS,x,y,w,h,label);
    OUTPUT:
        RETVAL

=head1 Methods

=head2 default_style

=head3 C<$style = $adjuster-E<gt>default_style( )>

=for apidoc ||FLTK::NamedStyle * style|default_style||

Returns the current L<style|FLTK::NamedStyle>.

=head3 C<$adjuster-E<gt>default_style( $new_style )>

=for apidoc |||default_style|FLTK::NamedStyle * style|

Sets the current L<style|FLTK::NamedStyle>.

=cut

fltk::NamedStyle *
fltk::Adjuster::default_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->default_style;
        OUTPUT:
            RETVAL
    CASE: items == 2
        CODE:
            THIS->default_style = style;

=head2 soft

=head3 C<$adjuster-E<gt>soft( $x )>

=for apidoc d|||soft|int x|

TODO

=head3 C<my $x = $adjuster-E<gt>soft( )>

=for apidoc d||int x|soft||

TODO

=cut

int
fltk::Adjuster::soft ( int x = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->soft( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->soft( X );

#endif // ifndef DISABLE_ADJUSTER

BOOT:
    isa("FLTK::Adjuster", "FLTK::Valuator");
