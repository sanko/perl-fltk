#include "include/FLTK_pm.h"

#ifndef DISABLE_THEME

SV * fltk_theme_CV;
fltk::Theme * original_theme = &fltk::theme_;

bool _fltk_theme( ) {
    dTHX;
    warn ("Here");
    if ( fltk_theme_CV && SvOK( fltk_theme_CV ) ) {
        warn ("Trying to call fltk_theme sub...");
        int count, ret_val;
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
            PUTBACK;
    count = call_sv( fltk_theme_CV, G_SCALAR );
            SPAGAIN;
    ret_val = ( bool ) ( ( count != 1 ) ? 0 : POPi );
        FREETMPS;
    LEAVE;
        return ret_val;
    }
    return (*original_theme)();
}

#endif // #ifndef DISABLE_THEME

MODULE = FLTK::Theme               PACKAGE = FLTK::Theme

#ifndef DISABLE_THEME

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Theme -

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


=cut

#include <fltk/Style.h>

MODULE = FLTK::Theme               PACKAGE = FLTK

SV *
theme( theme = NO_INIT )
    CASE: items == 0
        CODE:
            RETVAL = SvOK( fltk_theme_CV ) ? newSVsv( fltk_theme_CV ) : &PL_sv_undef;
        OUTPUT:
            RETVAL
    CASE: items == 1 && (SvROK( ST( 0 ) ) ) && ( SvTYPE(SvRV(ST(0))) == SVt_PVCV )
        CV * theme
        CODE:
            fltk_theme_CV = newSVsv( ST( 0 ) );
            fltk::theme( _fltk_theme );
    CASE: items == 1
        const char * theme
        CODE:
            warn ("#include <win32/fltk_theme.cxx>  ...or something." );

void
load_theme( )
    CODE:
        fltk::load_theme( );

void
reload_theme( )
    CODE:
        fltk::reload_theme( );

bool
reset_theme( )
    CODE:
        RETVAL = fltk::reset_theme( );
    OUTPUT:
        RETVAL

BOOT:
    export_tag( "load_theme", "theme" );
    export_tag( "reload_theme", "theme" );
    export_tag( "reset_theme", "theme" );

#endif // ifndef DISABLE_THEME
