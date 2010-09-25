#include "include/FLTK_pm.h"

MODULE = FLTK::TextSelection               PACKAGE = FLTK::TextSelection

#ifndef DISABLE_TEXTSELECTION

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532

=for git $Id$

=head1 NAME

FLTK::TextSelection -

=head1 Description



=cut

#include <fltk/TextBuffer.h>

=head1 Constructor

=for apidoc d||FLTK::TextSelection selection|new||



=head2 Usage

=for markdown {%highlight perl%}

  my $selection = FLTK::TextSelection->new( );

=for markdown {%endhighlight%}

=cut

#include "include/WidgetSubclass.h"

void
fltk::TextSelection::new( )
    PPCODE:
        void * RETVAL = NULL;
        RETVAL = (void *) new fltk::TextSelection( );
        if (RETVAL != NULL) {
            ST(0) = sv_newmortal();
            sv_setref_pv(ST(0), CLASS, RETVAL); /* -- hand rolled -- */
            XSRETURN(1);
        }

=head1 Methods

=head2 C<< $selection->set( $start, $end ) >>

=for apidoc |||set|int start|int end|


=head2 C<< $selection->set_rectangular( $start, $end, $rectstart, $rectend ) >>

=for apidoc |||set_rectangular|int start|int end|int rectstart|int rectend|


=cut

void
fltk::TextSelection::set( int start, int end )

void
fltk::TextSelection::set_rectangular( int start, int end, int rectstart, int rectend )

=head2 C<< $selection->update( position, ndeleted, ninserted ) >>

=for apidoc |||update|int pos|int ndeleted|int ninserted|


=cut

void
fltk::TextSelection::update( int pos, int ndeleted, int ninserted )

=head2 C<< my $is_rect = $selection->rectangular( ) >>

=for apidoc ||bool is_rect|rectangular||

Returns a true value if the selection is rectangular.

=cut

bool
fltk::TextSelection::rectangular( )

=head2 C<< my $start = $selection->start( ) >>

=for apidoc ||int start|start||

Position of start selection or, if rectangular, selections from keyboard.

=head2 C<< my $end = $selection->end( ) >>

=for apidoc ||int end|end||

Position of end of selection or, if rectangular, selections from keyboard.

=head2 C<< my $rectstart = $selection->rectstart( ) >>

=for apidoc ||int rectstart|rectstart||

Indent of left edge of rectangular selection.

=head2 C<< my $rectend = $selection->rectend( ) >>

=for apidoc ||int rectend|rectend||

Ident of right edge of rectangular selection.

=cut

int
fltk::TextSelection::start( )

int
fltk::TextSelection::end( )

int
fltk::TextSelection::rectstart( )

int
fltk::TextSelection::rectend( )

=head2 C<< my $bool = $selection->selected( ) >>

=for apidoc ||bool bool|selected||

Returns a true value if the selection is active.

=head2 C<< $selection->selected( $bool ) >>

=for apidoc |||selected|bool bool|

Sets the selection as active or inactive.

=cut

bool
fltk::TextSelection::selected( bool b = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->selected( b );
    CASE:
        CODE:
            RETVAL = THIS->selected( );
        OUTPUT:
            RETVAL

=head2 C<< my $bool = $selection->zerowidth( ) >>

=for apidoc ||bool bool|zerowidth||

Zero width selctions aren't I<real> selections, but they can be useful when
creating rectangular selections from the keyboard.

=head2 C<< $selection->zerowidth( $bool ) >>

=for apidoc |||zerowidth|bool bool|

=cut

bool
fltk::TextSelection::zerowidth( bool b = NO_INIT )
    CASE: items == 2
        CODE:
            THIS->zerowidth( b );
    CASE:
        CODE:
            RETVAL = THIS->zerowidth( );
        OUTPUT:
            RETVAL

=head2 C<< my $bool = $selection->includes( $pos, $lineStartPos, $dispIndex ) >>

=for apidoc ||bool bool|includes|int pos|int lineStartPos|int dispIndex|

=cut

bool
fltk::TextSelection::includes( int pos, int lineStartPos, int dispIndex )

=head2 C<< my $pos = $selection->position( $start, $end ) >>

=for apidoc ||int pos|position|int * start|int * end|

=head2 C<< my $pos = $selection->position( $start, $end, $isrect, $rectstart, $rectend ) >>

=for apidoc ||int pos|position|int * start|int * end|int * isrect|int * rectstart|int * rectend|

=cut

int
fltk::TextSelection::position( IN_OUTLIST int start, IN_OUTLIST int end, IN_OUTLIST int isrect = NO_INIT, IN_OUTLIST int rectstart = NO_INIT, IN_OUTLIST int rectend = NO_INIT )
    CASE: items == 3
        CODE:
            RETVAL = THIS->position( &start, &end );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            RETVAL = THIS->position( &start, &end, &isrect, &rectstart, &rectend );
        OUTPUT:
            RETVAL

#endif // ifndef DISABLE_TEXTSELECTION
