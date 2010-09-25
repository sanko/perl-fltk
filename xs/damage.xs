#include "include/FLTK_pm.h"

MODULE = FLTK::damage               PACKAGE = FLTK::damage

#ifndef DISABLE_DAMAGE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::damage - Values of the bits stored in C<FLTK::Widget::damage( )>

=pod

=head1 Description

When redrawing your widgets you should look at the damage bits to see what
parts of your widget need redrawing. The
L<C<Widget::handle()>|FLTK::Widget/"handle"> method can then set individual
damage bits to limit the amount of drawing that needs to be done, and the
L<C<Widget::draw()>|FLTK::Widget/"draw"> method can test these bits to decide
what to draw:

=for markdown {%highlight perl linenos%}

  package MyClass;

  sub handle {
      my ($self, $event) =@_;
      $self->damage(1) if change_to_part1();
      $self->damage(2) if change_to_part2();
      $self->damage(3) if change_to_part3();
  }

  sub draw {
      my ($self) = @_;
      if ($self->damage() & DAMAGE_ALL()) {
          # draw frame/box and other static stuff...
      }
      draw_part1() if ($self->damage() & (DAMAGE_ALL() | 1));
      draw_part2() if ($self->damage() & (DAMAGE_ALL() | 2));
      draw_part3() if ($self->damage() & (DAMAGE_ALL() | 4));
  }

=for markdown {%endhighlight%}

Except for C<DAMAGE_ALL>, each widget is allowed to assign any meaning to any
of the bits it wants. The enumerations are just to provide suggested meanings.

The folowing default may be imported using the C<damage> tag:

=over

=item C<DAMAGE_VALUE>

=item C<DAMAGE_PUSHED>

=item C<DAMAGE_SCROLL>

=item C<DAMAGE_OVERLAY>

=item C<DAMAGE_HIGHLIGHT>

=item C<DAMAGE_CHILD>

=item C<DAMAGE_CHILD_LABEL>

=item C<DAMAGE_EXPOSE>

=item C<DAMAGE_CONTENTS>

=item C<DAMAGE_ALL>

=back

=cut

#include <fltk/damage.h>

BOOT:
    register_constant( "DAMAGE_VALUE", newSViv(fltk::DAMAGE_VALUE));
    export_tag( "DAMAGE_VALUE", "damage" );
    register_constant( "DAMAGE_PUSHED", newSViv(fltk::DAMAGE_PUSHED));
    export_tag( "DAMAGE_PUSHED", "damage" );
    register_constant( "DAMAGE_SCROLL", newSViv(fltk::DAMAGE_SCROLL));
    export_tag( "DAMAGE_SCROLL", "damage" );
    register_constant( "DAMAGE_OVERLAY", newSViv(fltk::DAMAGE_OVERLAY));
    export_tag( "DAMAGE_OVERLAY", "damage" );
    register_constant( "DAMAGE_HIGHLIGHT", newSViv(fltk::DAMAGE_HIGHLIGHT));
    export_tag( "DAMAGE_HIGHLIGHT", "damage" );
    register_constant( "DAMAGE_CHILD", newSViv(fltk::DAMAGE_CHILD));
    export_tag( "DAMAGE_CHILD", "damage" );
    register_constant( "DAMAGE_CHILD_LABEL", newSViv(fltk::DAMAGE_CHILD_LABEL));
    export_tag( "DAMAGE_CHILD_LABEL", "damage" );
    register_constant( "DAMAGE_EXPOSE", newSViv(fltk::DAMAGE_EXPOSE));
    export_tag( "DAMAGE_EXPOSE", "damage" );
    register_constant( "DAMAGE_CONTENTS", newSViv(fltk::DAMAGE_CONTENTS));
    export_tag( "DAMAGE_CONTENTS", "damage" );
    register_constant( "DAMAGE_ALL", newSViv(fltk::DAMAGE_ALL));
    export_tag( "DAMAGE_ALL", "damage" );

#endif // ifndef DISABLE_DAMAGE
