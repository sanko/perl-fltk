
#include "include/FLTK_pm.h"

MODULE = FLTK::TabGroupPager               PACKAGE = FLTK::TabGroupPager

#ifndef DISABLE_TABGROUPPAGER

=pod

=for license Artistic License 2.0 | Copyright (C) 2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::TabGroupPager - Class based FLTK::TabGroup behavior definition

=head1 Description

This helper class generically defines the L<TabGroup|FLTK::TabGroup> behavior
when there are more tabs than available horizontal width, i.e it can generates
a popup menu or shrink It opens the door to new Pagers creation as left-
rights arrows scrolling pagers and others

To create a new pager, inherits from L<TabGroupPager|FLTK::TabGroupPager> and
redefine the following methods:

=over

=item C<which( $tabgroup, $x, $y )>

Determines and returns the index of the child group at the corresponding
position.

=item C<>


=back

=begin apidoc

=cut

#include <fltk/TabGroup.h>

=for apidoc ||FLTK::TabGroupPager * group|new||

Creates a new L<TabGroupPager|FLTK::TabGroupPager> object.

=cut

#include "include/TabGroupPagerSubclass.h"

fltk::TabGroupPager *
fltk::TabGroupPager::new( )
    CODE:
        RETVAL = new TabGroupPagerSubclass<fltk::TabGroupPager>(CLASS);
    OUTPUT:
        RETVAL

=pod

=head1 Subclassing

To create a new L<TabGroupPager|FLTK::TabGroupPager> object, you must create a
subclass


    /*! this method must update the tab positions and width array, returns the s
elected tab    */


=cut

#endif // #ifndef DISABLE_TABGROUPPAGER





































