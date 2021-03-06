#include "include/FLTK_pm.h"

MODULE = FLTK::Style               PACKAGE = FLTK::Style

#ifndef DISABLE_STYLE

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::Style - Simulate themes for the Fast Light Toolkit

=head1 Description

Each widget has a pointer to an instance of Style. Usually many widgets share
pointers to the same one. Styles are linked into a hierarchy tree by the
C<parent_> pointers.

When you look up a value from a style (such as when
L<C<box( )>|FLTK::Widget/"box"> is called) it looks at that style and each
parent up until it finds a non-zero value to return, or until there are no
more parents, in which case zero is returned. Thus changing a parent style
can make global changes as long as widgets do not have local values set.

When you "set" a style (such as by calling
L<C<box(UP_BOX)>|FLTK::Widget/"box">) then the local member variable is set.
Notice that by setting a zero value you will indicate that it should return
the parent value.

The method L<C<Widget::box(BOX)>|FLTK::Widget/"box"> will create a
L<C<dynamic( )>|FLTK::Style/"dynamic"> style for that widget, which is a child
of the original style, and set the box in that style. This "unique" style is
reused for any other changes to that widget and it is deleted when the widget
is deleted. Thus changes to a single widget do not affect other widgets, but
the majority of widgets all share a Style structure.

Occasionally it is useful to see if a field has been set. To do this you can
directly access the local member variables using names like C<box_>.

=cut

#include <fltk/Style.h>

#include <fltk/LabelType.h>

#include <fltk/Symbol.h>

=begin apidoc

=for apidoc ||FLTK::Style * style|new||

The constructor clears the style to entirely zeros, including the C<parent_>
pointer. You probably want to set the parent to
L<C<Widget::default_style>|FLTK::Widget/"default_style"> in order to inherit
the global settings.

=cut

fltk::Style *
fltk::Style::new( )

=for apidoc et[box,style]||FLTK::Box * box|UP_BOX||



=for apidoc et[box,style]||FLTK::Box * box|DOWN_BOX||



=for apidoc et[box,style]||FLTK::Box * box|THIN_UP_BOX||



=for apidoc et[box,style]||FLTK::Box * box|THIN_DOWN_BOX||



=for apidoc et[box,style]||FLTK::Box * box|DOWN_BOX||



=for apidoc et[box,style]||FLTK::Box * box|THIN_UP_BOX||



=for apidoc et[box,style]||FLTK::Box * box|THIN_DOWN_BOX||



=for apidoc et[box,style]||FLTK::Box * box|ENGRAVED_BOX||



=for apidoc et[box,style]||FLTK::Box * box|EMBOSSED_BOX||



=for apidoc et[box,style]||FLTK::Box * box|BORDER_BOX||



=for apidoc et[box,style]||FLTK::Box * box|FLAT_BOX||



=for apidoc et[box,style]||FLTK::Box * box|HIGHLIGHT_UP_BOX||



=for apidoc et[box,style]||FLTK::Box * box|HIGHLIGHT_DOWN_BOX||



=for apidoc et[box,style]||FLTK::Box * box|ROUND_UP_BOX||



=for apidoc et[box,style]||FLTK::Box * box|ROUND_DOWN_BOX||



=for apidoc et[box,style]||FLTK::Box * box|DIAMOND_UP_BOX||



=for apidoc et[box,style]||FLTK::Box * box|DIAMOND_DOWN_BOX||



=for apidoc et[box,style]||FLTK::Box * box|SHADOW_BOX||



=for apidoc et[box,style]||FLTK::Box * box|ROUNDED_BOX||



=for apidoc et[box,style]||FLTK::Box * box|RSHADOW_BOX||



=for apidoc et[box,style]||FLTK::Box * box|RFLAT_BOX||



=for apidoc et[box,style]||FLTK::Box * box|OVAL_BOX||



=for apidoc et[box,style]||FLTK::Box * box|OSHADOW_BOX||



=for apidoc et[box,style]||FLTK::Box * box|OFLAT_BOX||



=for apidoc et[box,style]||FLTK::Box * box|BORDER_FRAME||



=for apidoc et[box,style]||FLTK::Box * box|PLASTIC_UP_BOX||



=for apidoc et[box,style]||FLTK::Box * box|PLASTIC_DOWN_BOX||



=cut

MODULE = FLTK::Style               PACKAGE = FLTK

#if 0 // These are also defined in Box.xs

fltk::Box *
UP_BOX ( )
    CODE:
        switch ( ix ) {
            case  0: RETVAL =             fltk::UP_BOX; break;
            case  1: RETVAL =           fltk::DOWN_BOX; break;
            case  2: RETVAL =        fltk::THIN_UP_BOX; break;
            case  3: RETVAL =      fltk::THIN_DOWN_BOX; break;
            case  4: RETVAL =       fltk::ENGRAVED_BOX; break;
            case  5: RETVAL =       fltk::EMBOSSED_BOX; break;
            case  6: RETVAL =         fltk::BORDER_BOX; break;
            case  7: RETVAL =           fltk::FLAT_BOX; break;
            case  8: RETVAL =   fltk::HIGHLIGHT_UP_BOX; break;
            case  9: RETVAL = fltk::HIGHLIGHT_DOWN_BOX; break;
            case 10: RETVAL =       fltk::ROUND_UP_BOX; break;
            case 11: RETVAL =     fltk::ROUND_DOWN_BOX; break;
            case 12: RETVAL =     fltk::DIAMOND_UP_BOX; break;
            case 13: RETVAL =   fltk::DIAMOND_DOWN_BOX; break;
            case 14: RETVAL =         fltk::SHADOW_BOX; break;
            case 15: RETVAL =        fltk::ROUNDED_BOX; break;
            case 16: RETVAL =        fltk::RSHADOW_BOX; break;
            case 17: RETVAL =          fltk::RFLAT_BOX; break;
            case 18: RETVAL =           fltk::OVAL_BOX; break;
            case 19: RETVAL =        fltk::OSHADOW_BOX; break;
            case 20: RETVAL =          fltk::OFLAT_BOX; break;
            case 21: RETVAL =       fltk::BORDER_FRAME; break;
            case 22: RETVAL =     fltk::PLASTIC_UP_BOX; break;
            case 23: RETVAL =   fltk::PLASTIC_DOWN_BOX; break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
                  DOWN_BOX = 1
               THIN_UP_BOX = 2
             THIN_DOWN_BOX = 3
              ENGRAVED_BOX = 4
              EMBOSSED_BOX = 5
                BORDER_BOX = 6
                  FLAT_BOX = 7
          HIGHLIGHT_UP_BOX = 8
        HIGHLIGHT_DOWN_BOX = 9
              ROUND_UP_BOX = 10
            ROUND_DOWN_BOX = 11
            DIAMOND_UP_BOX = 12
          DIAMOND_DOWN_BOX = 13
                SHADOW_BOX = 14
               ROUNDED_BOX = 15
               RSHADOW_BOX = 16
                 RFLAT_BOX = 17
                  OVAL_BOX = 18
               OSHADOW_BOX = 19
                 OFLAT_BOX = 20
              BORDER_FRAME = 21
            PLASTIC_UP_BOX = 22
          PLASTIC_DOWN_BOX = 23

#endif // #if 0 // These are also defined in Box.xs

BOOT:
    export_tag("PLASTIC_DOWN_BOX","box" );
    export_tag("PLASTIC_UP_BOX","box" );
    export_tag("BORDER_FRAME","box" );
    export_tag("OFLAT_BOX","box" );
    export_tag("OSHADOW_BOX","box" );
    export_tag("OVAL_BOX","box" );
    export_tag("RFLAT_BOX","box" );
    export_tag("RSHADOW_BOX","box" );
    export_tag("ROUNDED_BOX","box" );
    export_tag("SHADOW_BOX","box" );
    export_tag("DIAMOND_DOWN_BOX","box" );
    export_tag("DIAMOND_UP_BOX","box" );
    export_tag("ROUND_DOWN_BOX","box" );
    export_tag("ROUND_UP_BOX","box" );
    export_tag("HIGHLIGHT_DOWN_BOX","box" );
    export_tag("HIGHLIGHT_UP_BOX","box" );
    export_tag("FLAT_BOX","box" );
    export_tag("BORDER_BOX","box" );
    export_tag("EMBOSSED_BOX","box" );
    export_tag("ENGRAVED_BOX","box" );
    export_tag("THIN_DOWN_BOX","box" );
    export_tag("THIN_UP_BOX","box" );
    export_tag("DOWN_BOX","box" );
    export_tag("BOX_UP","box" );

MODULE = FLTK::Style               PACKAGE = FLTK::Style

=for apidoc et[font,style]||FLTK::Font * font|HELVETICA||



=for apidoc et[font,style]||FLTK::Font * font|HELVETICA_BOLD||



=for apidoc et[font,style]||FLTK::Font * font|HELVETICA_ITALIC||



=for apidoc et[font,style]||FLTK::Font * font|HELVETICA_BOLD_ITALIC||



=for apidoc et[font,style]||FLTK::Font * font|COURIER||



=for apidoc et[font,style]||FLTK::Font * font|COURIER_BOLD||



=for apidoc et[font,style]||FLTK::Font * font|COURIER_ITALIC||



=for apidoc et[font,style]||FLTK::Font * font|COURIER_BOLD_ITALIC||



=for apidoc et[font,style]||FLTK::Font * font|TIMES||



=for apidoc et[font,style]||FLTK::Font * font|TIMES_BOLD||



=for apidoc et[font,style]||FLTK::Font * font|TIMES_ITALIC||



=for apidoc et[font,style]||FLTK::Font * font|TIMES_BOLD_ITALIC||



=for apidoc et[font,style]||FLTK::Font * font|SYMBOL_FONT||



=for apidoc et[font,style]||FLTK::Font * font|SCREEN_FONT||



=for apidoc et[font,style]||FLTK::Font * font|SCREEN_BOLD_FONT||



=for apidoc et[font,style]||FLTK::Font * font|ZAPF_DINGBATS||



=cut

MODULE = FLTK::Style               PACKAGE = FLTK

fltk::Font *
HELVETICA ( )
    CODE:
        switch ( ix ) {
            case  0: RETVAL = fltk::HELVETICA;             break;
            case  1: RETVAL = fltk::HELVETICA_BOLD;        break;
            case  2: RETVAL = fltk::HELVETICA_ITALIC;      break;
            case  3: RETVAL = fltk::HELVETICA_BOLD_ITALIC; break;
            case  4: RETVAL = fltk::COURIER;               break;
            case  5: RETVAL = fltk::COURIER_BOLD;          break;
            case  6: RETVAL = fltk::COURIER_ITALIC;        break;
            case  7: RETVAL = fltk::COURIER_BOLD_ITALIC;   break;
            case  8: RETVAL = fltk::TIMES;                 break;
            case  9: RETVAL = fltk::TIMES_BOLD;            break;
            case 10: RETVAL = fltk::TIMES_ITALIC;          break;
            case 11: RETVAL = fltk::TIMES_BOLD_ITALIC;     break;
            case 12: RETVAL = fltk::SYMBOL_FONT;           break;
            case 13: RETVAL = fltk::SCREEN_FONT;           break;
            case 14: RETVAL = fltk::SCREEN_BOLD_FONT;      break;
            case 15: RETVAL = fltk::ZAPF_DINGBATS;         break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
               HELVETICA_BOLD = 1
             HELVETICA_ITALIC = 2
        HELVETICA_BOLD_ITALIC = 3
                      COURIER = 4
                 COURIER_BOLD = 5
               COURIER_ITALIC = 6
          COURIER_BOLD_ITALIC = 7
                        TIMES = 8
                   TIMES_BOLD = 9
                 TIMES_ITALIC = 10
            TIMES_BOLD_ITALIC = 11
                  SYMBOL_FONT = 12
                  SCREEN_FONT = 13
             SCREEN_BOLD_FONT = 14
                ZAPF_DINGBATS = 15

BOOT:
    export_tag( "HELVETICA", "font" );
    export_tag( "HELVETICA_BOLD", "font" );
    export_tag( "HELVETICA_ITALIC", "font" );
    export_tag( "HELVETICA_BOLD_ITALIC", "font" );
    export_tag( "COURIER", "font" );
    export_tag( "COURIER_BOLD", "font" );
    export_tag( "COURIER_ITALIC", "font" );
    export_tag( "COURIER_BOLD_ITALIC", "font" );
    export_tag( "TIMES", "font" );
    export_tag( "TIMES_BOLD", "font" );
    export_tag( "TIMES_ITALIC", "font" );
    export_tag( "TIMES_BOLD_ITALIC", "font" );
    export_tag( "SYMBOL_FONT", "font" );
    export_tag( "SCREEN_FONT", "font" );
    export_tag( "SCREEN_BOLD_FONT", "font" );
    export_tag( "ZAPF_DINGBATS", "font" );

MODULE = FLTK::Style               PACKAGE = FLTK::Style

=for apidoc et[label,style]||FLTK::LabelType * type|NO_LABEL||



=for apidoc et[label,style]||FLTK::LabelType * type|NORMAL_LABEL||



=for apidoc et[label,style]||FLTK::LabelType * type|SYMBOL_LABEL||



=for apidoc et[label,style]||FLTK::LabelType * type|SHADOW_LABEL||



=for apidoc et[label,style]||FLTK::LabelType * type|ENGRAVED_LABEL||



=for apidoc et[label,style]||FLTK::LabelType * type|EMBOSSED_LABEL||



=cut

MODULE = FLTK::Style               PACKAGE = FLTK

fltk::LabelType *
NO_LABEL ( )
    CODE:
        switch ( ix ) {
            case 0: RETVAL = fltk::NO_LABEL;       break;
            case 1: RETVAL = fltk::NORMAL_LABEL;   break;
            case 2: RETVAL = fltk::SYMBOL_LABEL;   break; // same as NORMAL_LABEL
            case 3: RETVAL = fltk::SHADOW_LABEL;   break;
            case 4: RETVAL = fltk::ENGRAVED_LABEL; break;
            case 5: RETVAL = fltk::EMBOSSED_LABEL; break;
        }
    OUTPUT:
        RETVAL
    ALIAS:
          NORMAL_LABEL = 1
          SYMBOL_LABEL = 2
          SHADOW_LABEL = 3
        ENGRAVED_LABEL = 4
        EMBOSSED_LABEL = 5

BOOT:
    export_tag( "NO_LABEL", "label" );
    export_tag( "NORMAL_LABEL", "label" );
    export_tag( "SYMBOL_LABEL", "label" );
    export_tag( "SHADOW_LABEL", "label" );
    export_tag( "ENGRAVED_LABEL", "label" );
    export_tag( "EMBOSSED_LABEL", "label" );

MODULE = FLTK::Style               PACKAGE = FLTK::Style

=for apidoc ||bool unique|dynamic||

True if this Style is unique to the Widget that owns it, and is not shared
with other Widgets.

=cut

bool
fltk::Style::dynamic( )

=for apidoc F||FLTK::NamedStyle * style|find|char * name|


=cut

fltk::NamedStyle *
find ( char * name )
   CODE:
        RETVAL = (fltk::NamedStyle *) fltk::Style::find( name );
    OUTPUT:
        RETVAL

=for apidoc ||FLTK::Box * box|box||

The type of box to draw around the outer edge of the widget (for the majority
of widgets, some classes ignore this or use it to draw only text fields inside
the widget). The default is C<FLTK::DOWN_BOX>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||box|FLTK::Box * box|

Sets the type of box to draw around the outer edge of widget.

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Box * box|buttonbox||

The type of box to draw buttons internal the widget (notice that
L<FLTK::Button|FLTK::Button> uses box, however). The default is
C<FLTK::UP_BOX>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||buttonbox|FLTK::Box * box|

Returns the type of box to draw buttions internal the widget.

=for hackers Found in F<src/Style.cxx>

=cut

fltk::Box *
fltk::Style::box( fltk::Box * box = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL =       THIS->box( ); break;
                case 1: RETVAL = THIS->buttonbox( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch( ix ) {
                case 0:       THIS->box( box ); break;
                case 1: THIS->buttonbox( box ); break;
            }
    ALIAS:
        buttonbox = 1

=for apidoc ||FLTK::Symbol * image|glyph||

A small image that some Widgets use to draw part of themselves. For instance
the L<FLTK::CheckButton|FLTK::CheckButton> class has this set to a Symbol that
draws the white box and the checkmark if C<VALUE> is true.

Im most cases the L<C<FLTK::drawflags( )>|FLTK/"drawflags"> are examined to
decide between differnt symbols. The default value draws empty squares and
arrow buttons if C<ALIGN> flags are on, see
L<Widget::default_glpyh|FLTK::Widget/"default_glyph">.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||glyph|FLTK::Symbol * image|

Sets a small image that some Widgets use to draw part of themselves.

=for hackers Found in F<src/Style.cxx>

=cut

fltk::Symbol *
fltk::Style::glyph( fltk::Symbol * symbol = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->glyph( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->glyph( symbol );

=for apidoc ||FLTK::Font * font|labelfont||

The font used to draw the label. Default is C<FLTK::HELVETICA>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||labelfont|FLTK::Font * font|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Font * font|textfont||

Font to use to draw information inside the widget, such as the text in a text
editor or menu or browser. Default is C<FLTK::HELVETICA>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||textfont|FLTK::Font * font|

=for hackers Found in F<src/Style.cxx>

=cut

fltk::Font *
fltk::Style::labelfont ( fltk::Font * font = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->labelfont( ); break;
                case 1: RETVAL =  THIS->textfont( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->labelfont( font ); break;
                case 1:  THIS->textfont( font ); break;
            }
    ALIAS:
        textfont = 1

=for apidoc ||FLTK::LabelType * type|labeltype||

How to draw the label. This provides things like inset, shadow, and the
symbols. C<FLTK::NORMAL_LABEL>.

=for apidoc |||labeltype|FLTK::LabelType * type|

=cut

fltk::LabelType *
fltk::Style::labeltype( fltk::LabelType * type = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->labeltype( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->labeltype( type );

=for apidoc ||FLTK::Color color|color||

Color of the widgets. The default is C<FLTK::WHITE>. You may think most
widgets are gray, but this is because L<Group|FLTK::Group> and
L<Window|FLTK::Window> have their own L<Style|FLTK::Style> with this set to
C<FLTK::GRAY75>, and also because many parts of widgets are drawn with the
L<C<buttoncolor( )>|/"buttoncolor">.

If you want to change the overall color of all the gray parts of the interface
you want to call L<C<FLTK::set_background(color)>|FLTK/"set_background">
instead, as this will set the entry for C<FLTK::GRAY75> and also set the "gray
ramp" so that the edges of buttons are the same color.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||color|FLTK::Color color|


=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|textcolor||

Color to draw text inside the widget. Default is black. This is also used by
many widgets to control the color when they draw the L<C<glyph( )>|/"glyph">,
thus it can control the color of checkmarks in
L<FLTK::CheckButton|FLTK::CheckButton>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||textcolor|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|selection_color||

Color drawn behind selected text in inputs, or selected browser or menu items,
or lit light buttons. The default is C<FLTK::WINDOWS_BLUE>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||selection_color|FLTK::Color color|

=for apidoc ||FLTK::Color color|selection_textcolor||

The color to draw text atop the L<C<selection_color>|/"selection_color">. The
default of zero indicates that fltk will choose a contrasting color (either
the same as the original color or white or black). I recommend you use the
default if possible.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||selection_textcolor|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|buttoncolor||

Color used when drawing buttons. Default is C<FLTK::GRAY75>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||buttoncolor|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|labelcolor||

Color used to draw labels. Default is C<FLTK::BLACK>.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||labelcolor|FLTK::Color color|

=for apidoc ||FLTK::Color color|highlight_color||

The color to draw the widget when the mouse is over it (for scrollbars and
sliders this is used to color the buttons). Depending on the widget this will
either recolor the buttons that are normally colored with
L<C<buttoncolor( )>|/"buttoncolor">, or will recolor the main area that is
normally colored with L<C<color( )>|/"color">.

The default value is zero, which indicates that highlighting is disabled.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||highlight_color|FLTK::Color color|

=for hackers Found in F<src/Style.cxx>

=for apidoc ||FLTK::Color color|highlight_textcolor||

Color used to draw the labels or text when the background is drawn in the
L<C<highlight_color>|/"highlight_color">. The default of zero indicates that
fltk will choose a contrasting color (either the same as the original color or
white or black). I recommend you use the default if possible.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||highlight_textcolor|FLTK::Color color|

=cut

fltk::Color
fltk::Style::color ( fltk::Color color = NO_INIT )
    CASE: items == 1
        CODE:
            switch( ix ) {
                case 0:               RETVAL = THIS->color( ); break;
                case 1:           RETVAL = THIS->textcolor( ); break;
                case 2:     RETVAL = THIS->selection_color( ); break;
                case 3: RETVAL = THIS->selection_textcolor( ); break;
                case 4:         RETVAL = THIS->buttoncolor( ); break;
                case 5:          RETVAL = THIS->labelcolor( ); break;
                case 6:     RETVAL = THIS->highlight_color( ); break;
                case 7: RETVAL = THIS->highlight_textcolor( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch( ix ) {
                case 0:               THIS->color( color ); break;
                case 1:           THIS->textcolor( color ); break;
                case 2:     THIS->selection_color( color ); break;
                case 3: THIS->selection_textcolor( color ); break;
                case 4:         THIS->buttoncolor( color ); break;
                case 5:          THIS->labelcolor( color ); break;
                case 6:     THIS->highlight_color( color ); break;
                case 7: THIS->highlight_textcolor( color ); break;
            }
    ALIAS:
                  textcolor = 1
            selection_color = 2
        selection_textcolor = 3
                buttoncolor = 4
                 labelcolor = 5
            highlight_color = 6
        highlight_textcolor = 7

=for apidoc ||float size|labelsize||

Size of L<C<labelfont( )>|/"labelfont">. Default is 12.

=for hackers Found in F<src/Style.cxx>

=for apidoc ||float size|textsize||

Size of L<C<textfont( )>|/"textfont">. This is also used by many Widgets to
control the size they draw the L<C<glyph( )>|/"glyph">. Default is 12.

=for hackers Found in F<src/Style.cxx>

=for apidoc ||float size|leading||

Extra spacing added between text lines or other things that are stacked
vertically. The default is 2. The function
L<C<FLTK::drawtext( )>|FLTK/"drawtext"> will use the value from
L<C<Widget::default_style>|FLTK::Widget/"default_style">, but text editors and
browsers and menus and similar widgets will use the local value.

=for hackers Found in F<src/Style.cxx>

=for apidoc |||labelsize|float size|

=for hackers Found in F<src/Style.cxx>

=for apidoc |||textsize|float size|

=for hackers Found in F<src/Style.cxx>

=for apidoc |||leading|float size|

=for hackers Found in F<src/Style.cxx>

=cut

float
fltk::Style::labelsize( float size = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->labelsize( ); break;
                case 1:  RETVAL = THIS->textsize( ); break;
                case 2:   RETVAL = THIS->leading( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->labelsize( size ); break;
                case 1:  THIS->textsize( size ); break;
                case 2:   THIS->leading( size ); break;
             }
    ALIAS:
        textsize = 1
         leading = 2

=for apidoc ||char location|scrollbar_align||

Where to place scrollbars around a L<Browser|FLTK::Browser> or other scrolling
widget. The default is C<FLTK::ALIGN_RIGHT|FLTK::ALIGN_BOTTOM>.

=for apidoc ||char width|scrollbar_width||

How wide the scrollbars are around a Browser or other scrolling widget. The
default is 15.

=for apidoc |||scrollbar_align|char value|

=for apidoc |||scrollbar_width|char value|

=cut

unsigned char
fltk::Style::scrollbar_align ( unsigned char value = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->scrollbar_align( ); break;
                case 1: RETVAL = THIS->scrollbar_width( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch ( ix ) {
                case 0: THIS->scrollbar_align( value ); break;
                case 1: THIS->scrollbar_width( value ); break;
            }
    ALIAS:
        scrollbar_width = 1

=for apidoc ||bool looks_awesome|hide_underscore||

If false, draw C<&x> in labels as an underscore. If true (the default) then
the underscores are not drawn. In this case you should limit your C<&x>
hotkeys to menubar items, as underscores in buttons are not visible. The
menubar will show them when C<Alt> is held down.

=for apidoc |||hide_underscore|bool value|

=for apidoc ||bool drawn|draw_boxes_inactive||

If false then most of the built-in box types draw the same even if
C<FLTK::INACTIVE_R> is passed to them. This repliates Windows appearance. If
true (the default) then the boxes themselves gray out.

=for apidoc |||draw_boxes_inactive|bool value|

=cut

bool
fltk::Style::hide_underscore ( bool value = NO_INIT )
    CASE: items == 1
        CODE:
            switch ( ix ) {
                case 0: RETVAL = THIS->hide_underscore( ); break;
                case 1: RETVAL = THIS->draw_boxes_inactive( ); break;
            }
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            switch( ix ) {
                case 0: THIS->hide_underscore( value ); break;
                case 1: THIS->draw_boxes_inactive( value ); break;
            }
    ALIAS:
        draw_boxes_inactive = 1

=for apidoc ||int lines|wheel_scroll_lines||

How many lines to move for one click of a mouse wheel. The default is 3.

=for apidoc |||wheel_scroll_lines|int lines|



=cut

int
fltk::Style::wheel_scroll_lines ( int value = NO_INIT )
    CASE: items == 1
        CODE:
            RETVAL = THIS->wheel_scroll_lines( );
        OUTPUT:
            RETVAL
    CASE:
        CODE:
            THIS->wheel_scroll_lines( value );

    # Children

#INCLUDE: NamedStyle.xsi

#endif // #ifndef DISABLE_STYLE
