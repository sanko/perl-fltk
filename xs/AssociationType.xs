#include "include/FLTK_pm.h"

MODULE = FLTK::AssociationType               PACKAGE = FLTK::AssociationType

#ifndef DISABLE_ASSOCIATIONTYPE

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::AssociationType - Base class for the association type

=head1 Description

Base class for the association type.

FLTK allows you to attach any kind of user data to a widget. This data is
automatically freed when the widget to which it is attached is destroyed.
Internally an association table is used to connect the widget pointer with the
data pointer that is why all the functions concerned with this feature contain
"association" in their name. The advantage of this is that no space is taken
on widgets that do not contain the data (or that have the "default value"),
and that the destructor code is not linked in if the association is not used.

To be able to associate data and to be able to have a customized way of
freeing the data you need to derive from this class and then create an
instance of that class. With the pointer to that instance the type of the data
is identified.

possible uses:

=over 8

=item assign key shortcuts to certain widgets

=item assign a tooltip to some widgets

=item assign a help-index to widgets

=item assign a unique identifier to widgets to remote controlling

=item assign additional layouting data for new container widgets

=item assign data needed by typesafe callback mechanisms

=item assign all kind of data not always required within a widget / each widget

=back

=begin apidoc

=cut

=for apidoc xH||bool|foreach|at|widget|af

This function allows traversing all associations of a certain association
type, a certain widget, both, or none of the constraints. For each found
widget the handle function in the associaionFunctor class is called. If that
function returns true the scan is aborted and the data for the current widget
is returned A C<NULL> pointer for the
L<AssociationType|FLTK::AssociationType> or the L<Widget|FLTK::Widget> pointer
means to call the functor for all L<AssociationTypes|FLTK::AssociationType>
AssociationTypes and/or all L<Widgets|FLTK::Widget>.

The function either returns the first associated data for which the functor
returns C<true>, or <undef>.

See also L<Widget::foreach()|FLTK::Widget/"foreach"> and
L<AssociationType::foreach()|FLTK::AssociationType/"foreach">.

=end apidoc

=cut

#include <fltk/WidgetAssociation.h>

SV *
fltk::AssociationType::foreach( fltk::AssociationType * at, fltk::Widget * widget, fltk::AssociationFunctor af )
    CODE:
        RETVAL = (SV*) THIS->foreach( at, widget, at );

#endif // #ifndef DISABLE_ASSOCIATIONTYPE
