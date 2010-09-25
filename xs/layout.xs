#include "include/FLTK_pm.h"

MODULE = FLTK::Layout               PACKAGE = FLTK::Layout

#ifndef DISABLE_LAYOUT

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::Layout - Values of the bits stored in C<FLTK::Widget::layout_damage( )>

=head1 Description

When a widget resized or moved (or when it is initially created), flags are
set in L<C<Widget::layout_damage()>|FLTK::Widget/"layout_damage"> to indicate
the layout is damaged. This will cause the
L<C<Widget::layout()>|FLTK::Widget/"layout"> function to be called just before
fltk attempts to draw the windows on the screen. This is useful because often
calculating the new layout is quite expensive, this expense is now deferred
until the user will actually see the new size.

Some L<Group|FLTK::Group> widgets such as L<PackedGroup|FLTK::PackedGroup>
will also use the L<C<Widget::layout()>|FLTK::Widget/"layout"> function to
find out how big a widget should be. A L<Widget|FLTK::Widget> is allowed to
change it's own dimensions in L<C<layout()>|FLTK::Widget/"layout"> (except it
is not allowed to change it if called a second time with no changes other than
it's x/y position). This allows widgets to resize to fit their contents.

The layout bits are turned on by calling
L<C<Widget::relayout()>|FLTK::Widget/"relayout">.

Values are imported with the C<layout> tag and include the following:

=over

=item C<LAYOUT_X>

L<C<Widget::x()>|FLTK::Widget/"x"> changed by
L<C<resize()>|FLTK::Widget/"resize">.

=item C<LAYOUT_Y>

L<C<Widget::y()>|FLTK::Widget/"y"> changed by
L<C<resize()>|FLTK::Widget/"resize">.

=item C<LAYOUT_XY>

Same as C<LAYOUT_X|LAYOUT_Y>.

=item CLAYOUT_W>

L<C<Widget::w()>|FLTK::Widget/"w"> changed by
L<C<resize()>|FLTK::Widget/"resize">.

=item C<LAYOUT_H>

L<C<Widget::h()>|FLTK::Widget/"h"> changed by
L<C<resize()>|FLTK::Widget/"resize">.

=item C<LAYOUT_WH>

Same as C<LAYOUT_W|LAYOUT_H>.

=item C<LAYOUT_XYWH>

Same as C<LAYOUT_XY|LAYOUT_WH>.

=item C<LAYOUT_CHILD>

L<C<Widget::layout()>|FLTK::Widget/"layout"> needs to be called on a child of
this group widget.

=item C<LAYOUT_USER>

The moving/resizing is being caused by the user and not internal code.

=item C<LAYOUT_DAMAGE>

L<C<Widget::relayout()>|FLTK::Widget/"relayout"> was called.

=back

=cut

#include <fltk/layout.h>

BOOT:
    register_constant( "LAYOUT_X", newSViv( fltk::LAYOUT_X ));
    export_tag( "LAYOUT_X", "layout" );
    register_constant( "LAYOUT_Y", newSViv( fltk::LAYOUT_Y ));
    export_tag( "LAYOUT_Y", "layout" );
    register_constant( "LAYOUT_XY", newSViv( fltk::LAYOUT_XY ));
    export_tag( "LAYOUT_XY", "layout" );
    register_constant( "LAYOUT_W", newSViv( fltk::LAYOUT_W ));
    export_tag( "LAYOUT_W", "layout" );
    register_constant( "LAYOUT_H", newSViv( fltk::LAYOUT_H ));
    export_tag( "LAYOUT_H", "layout" );
    register_constant( "LAYOUT_WH", newSViv( fltk::LAYOUT_WH ));
    export_tag( "LAYOUT_WH", "layout" );
    register_constant( "LAYOUT_XYWH", newSViv( fltk::LAYOUT_XYWH ));
    export_tag( "LAYOUT_XYWH", "layout" );
    register_constant( "LAYOUT_CHILD", newSViv( fltk::LAYOUT_CHILD ));
    export_tag( "LAYOUT_CHILD", "layout" );
    register_constant( "LAYOUT_USER", newSViv( fltk::LAYOUT_USER ));
    export_tag( "LAYOUT_USER", "layout" );
    register_constant( "LAYOUT_DAMAGE", newSViv( fltk::LAYOUT_DAMAGE ));
    export_tag( "LAYOUT_DAMAGE", "layout" );

#endif // ifndef DISABLE_LAYOUT
