#include "include/FLTK_pm.h"

MODULE = FLTK::AlignGroup               PACKAGE = FLTK::AlignGroup

#ifndef DISABLE_ALIGNGROUP

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::AlignGroup - Align layout manager

=head1 Description

The L<AlignGroup|FLTK::AlignGroup> overrides all group's children's label
alignments to it's own L<C<align()>|FLTK::Group/"align"> value, tiles and
L<C<resize()>|FLTK::Group/"resize">s the children to fit in the space not
required by the (outsize) labels.

=cut

#include <fltk/AlignGroup.h>

=head1 Constructor

=for apidoc d||FLTK::AlignGroup self|new|int x|int y|int width|int height|char * label = ''|uchar n_to_break = 0|bool vertical = 1|FLTK::Flags align = FLTK::ALIGN_LEFT|uchar dw = 0|uchar dh = 0|

Creates a new C<FLTK::AlignGroup> object. This constructor expects integers
for C<$x, $y, $w, $h> and accepts an optional string for C<$label>. Other
optional arguments include:

=over

=item * C<$n_to_break>

Default value is an empty string.

=item * C<$vertical>

A boolean who's default value is a true value.

=item * C<$align>

L<FLTK::Flags|FLTK::Flags> value which defaults to
L<FLTK::ALIGN_LEFT|FLTK::Flags/"FLTK::ALIGN_LEFT">

=item * C<$dw>

=item * C<$dh>

=back

=head2 Usage

=for markdown {%highlight perl%}

  my $group_1 = FLTK::AlignGroup->new( $x, $y, $w, $h, $label );
  my $group_2 = FLTK::AlignGroup->new( 40, 40, 150, 40);

=for markdown {%endhighlight%}

=cut

#include "include/RectangleSubclass.h"

fltk::AlignGroup *
fltk::AlignGroup::new( int x, int y, int w, int h, const char * label = 0, uchar n_to_break = 0, bool vertical = 1, fltk::Flags align = fltk::ALIGN_LEFT, uchar dw = 0, uchar dh = 0 )
    CODE:
        RETVAL = new RectangleSubclass<fltk::AlignGroup>(CLASS,x,y,w,h,label,
                                        n_to_break, vertical, align, dw, dh );
    OUTPUT:
        RETVAL

=head1 Methods
X<layout>

=head2 C<$group_1-E<gt>layout( )>

=for apidoc |||layout|

=cut

void
fltk::AlignGroup::layout( )

=pod X<vertical>

=head2 C<$v = $group_1-E<gt>vertical( )>

=for apidoc ||bool vert|vertical||

=head2 C<$group_1-E<gt>vertical( $value )>

=for apidoc |||vertical|bool vert|

=cut

bool
fltk::AlignGroup::vertical ( bool v = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->vertical( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->vertical( v );

=pod X<n_to_break>

=head2 C<my $n = $group_1-E<gt>n_to_break( )>

=for apidoc ||uchar n|n_to_break||



=head2 C<$group_1-E<gt>n_to_break( $value )>

=for apidoc |||n_to_break|uchar value|


=pod X<dw>

=for apidoc ||uchar w|dw||



=for apidoc |||dw|uchar value|



=pod X<dh>

=for apidoc ||uchar h|dh||



=for apidoc |||dh|uchar value|



=cut

uchar
fltk::AlignGroup::n_to_break( uchar value = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->n_to_break( ); break;
                case 1: RETVAL = THIS->dw( ); break;
                case 2: RETVAL = THIS->dh( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->n_to_break( value ); break;
                case 1: THIS->dw( value ); break;
                case 2: THIS->dh( value ); break;
            }
    ALIAS:
        dw = 1
        dh = 2

=pod

X<align>

=for apidoc ||FLTK::Flags flags|align||



=for apidoc |||align|FLTK::Flags flags|



=cut

fltk::Flags
fltk::AlignGroup::align( fltk::Flags a = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->align( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->align( a );

#endif // ifndef DISABLE_ALIGNGROUP

BOOT:
    isa("FLTK::AlignGroup", "FLTK::Group");
