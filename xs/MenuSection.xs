#include "include/FLTK_pm.h"

MODULE = FLTK::MenuSection               PACKAGE = FLTK::MenuSection

#ifndef DISABLE_MENUSECTION

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::MenuSection - Makes dynamic (& hand-made) menu code less painful

=head1 Description

This class will elegantly facilitate dynamic (& hand-made) menu code writing
by creating and calling L<C<begin()>|FLTK::Group/"begin"> on an ItemGroup in
the constructor and calling L<C<end()>|FLTK::Group/"end"> in the destructor:

  $mymenu->begin( );
  FLTK::Item->new('in main menu');
  {
    FLTK::MenuSection->new('submenu title');
    FLTK::Item->new('in submenu');
    FLTK::Item->new('also in submenu');
  } # destructor ends the submenu

=cut

#include <fltk/ItemGroup.h>

=begin apidoc

=for apidoc ||FLTK::ItemGroup * group|new|char * label = ''|

Builds a typical submenu group section, then calls
L<C<begin()>|FLTK::Group/"begin">.

=for apidoc ||FLTK::ItemGroup * group|new|char * label|FLTK::Symbol * symbol|

This constructor also sets L<C<image()>|FLTK::Widget/"image">.

=cut

#include "include/WidgetSubclass.h"

void
fltk::MenuSection::new( char * label = 0, fltk::Symbol * symbol = NO_INIT )
    PPCODE:
        void * RETVAL = NULL;
        if ( items == 2)
            RETVAL = (void *) new WidgetSubclass<fltk::MenuSection>(CLASS,label);
        else
	        RETVAL = (void *) new WidgetSubclass<fltk::MenuSection>(CLASS,label,symbol);
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=for apidoc H||bool done|DESTROY||

Unlike most widgets, the basic function of L<MenuSection|FLTK::MenuSection>s
requires it being destroied.

=cut

bool
fltk::MenuSection::DESTROY( )

=for apidoc ||FLTK::ItemGroup * group|group||

Returns the L<ItemGroup>|FLTK::ItemGroup> created by this.

=cut

fltk::ItemGroup *
fltk::MenuSection::group( )

#endif // ifndef DISABLE_MENUSECTION
