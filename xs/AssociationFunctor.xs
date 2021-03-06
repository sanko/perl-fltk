#include "include/FLTK_pm.h"

MODULE = FLTK::AssociationFunctor               PACKAGE = FLTK::AssociationFunctor

#ifndef DISABLE_ASSOCIATIONFUNCTOR

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::AssociationFunctor -

=head1 Description

Class used by the L<foreach()|FLTK::AssociationType/"foreach"> functions. Base
class for the association functor that is used in
L<foreach()|FLTK::AssociationType/"foreach">. If you want to supply your
specific actions to do with the associated data found by the
L<foreach()|FLTK::AssociationType/"foreach"> functions you need to derive from
this class and provide a new handle function.

=begin apidoc

=for apidoc xH||bool|handle|at|widget|coderef

For each found association this function is called. If the function returns
true the loop is aborted and the data pointer for the current association is
returned.

=end apidoc

=cut

#include <fltk/WidgetAssociation.h>

bool
fltk::AssociationFunctor::handle( fltk::AssociationType at, fltk::Widget * widget, CV * coderef)
    CODE:
        THIS->handle(at, widget, _cb_w);

#endif // #ifndef DISABLE_ASSOCIATIONFUNCTOR
