#!perl -I../blib/lib -I../blib/arch -I../blib/arch/FLTK/FLTK
package FLTK;
use strict;
use warnings;

#
use FLTK::Version;
use version qw[qv];
our $VERSION_BASE = 0; our $UNSTABLE_RELEASE = 1; our $VERSION = sprintf(($UNSTABLE_RELEASE ? q[%.3f_%03d] : q[%.3f]), (version->new(($VERSION_BASE))->numify / 1000), $UNSTABLE_RELEASE);

#
use parent 'DynaLoader';

#
use vars qw[@EXPORT_OK @EXPORT %EXPORT_TAGS];
use Exporter qw[import];
%EXPORT_TAGS = (
    box => [
        qw[ UP_BOX  DOWN_BOX    THIN_UP_BOX THIN_DOWN_BOX   ENGRAVED_BOX
            EMBOSSED_BOX    BORDER_BOX  FLAT_BOX    HIGHLIGHT_UP_BOX
            HIGHLIGHT_DOWN_BOX  ROUND_UP_BOX    ROUND_DOWN_BOX  DIAMOND_UP_BOX
            DIAMOND_DOWN_BOX    NO_BOX  SHADOW_BOX  ROUNDED_BOX RSHADOW_BOX
            RFLAT_BOX   OVAL_BOX    OSHADOW_BOX OFLAT_BOX   BORDER_FRAME
            PLASTIC_UP_BOX  PLASTIC_DOWN_BOX]
    ],
    color => [
        qw[ NO_COLOR    FREE_COLOR  NUM_FREE_COLOR  GRAY00  GRAY05  GRAY10
            GRAY15      GRAY20      GRAY25          GRAY30  GRAY33  GRAY35
            GRAY40      GRAY45      GRAY50          GRAY55  GRAY60  GRAY65
            GRAY66      GRAY70      GRAY75          GRAY80  GRAY85  GRAY90
            GRAY95      GRAY99      BLACK           RED     GREEN   YELLOW
            BLUE        MAGENTA     CYAN            WHITE   DARK_RED
            DARK_GREEN  DARK_YELLOW DARK_BLUE       DARK_MAGENTA    DARK_CYAN
            WINDOWS_BLUE
            color   parsecolor  lerp    inactive    contrast split_color
            set_color_index get_color_index set_background nearest_index
            color_chooser
            ]
    ],
    draw => [
        qw[push_matrix pop_matrix scale translate
            setcolor
            addvertex
            drawtext
            fillstrokepath fillrect
            ]
    ],
    font => [
        qw[ HELVETICA HELVETICA_BOLD HELVETICA_ITALIC HELVETICA_BOLD_ITALIC
            COURIER   COURIER_BOLD   COURIER_ITALIC   COURIER_BOLD_ITALIC
            TIMES     TIMES_BOLD     TIMES_ITALIC     TIMES_BOLD_ITALIC
            SYMBOL_FONT
            SCREEN_FONT SCREEN_BOLD_FONT
            ZAPF_DINGBATS ]
    ],
    label => [
        qw[ NO_LABEL NORMAL_LABEL SYMBOL_LABEL SHADOW_LABEL ENGRAVED_LABEL
            EMBOSSED_LABEL ]
    ],
    default => [qw[run message alert ask input password ]]
);
@EXPORT_OK = sort map {@$_} values %EXPORT_TAGS;
$EXPORT_TAGS{'all'} = \@EXPORT_OK;
@EXPORT = sort map { m[^:(.+)] ? @{$EXPORT_TAGS{$1}} : $_ }
    qw[:box :label :font :default];

#use Data::Dump qw[pp];
#warn pp \@EXPORT;
bootstrap FLTK $VERSION;

#sub END { warn "..." }
# Classes ####################################################################
################################################ FLTK::Rectangle (top level) #
@FLTK::Monitor::ISA = @FLTK::Widget::ISA = qw[FLTK::Rectangle];
############################################################### FLTK::Widget #
@FLTK::Button::ISA = @FLTK::ClockOutput::ISA = @FLTK::Divider::ISA
    = @FLTK::Group::ISA = qw[FLTK::Widget];
############################################################### FLTK::Button #
@FLTK::CheckButton::ISA = @FLTK::HighlightButton::ISA
    = @FLTK::RepeatButton::ISA = @FLTK::ReturnButton::ISA
    = @FLTK::ToggleButton::ISA = qw[FLTK::Button];
########################################################## FLTK::CheckButton #
@FLTK::LightButton::ISA = @FLTK::RadioButton::ISA = qw[FLTK::CheckButton];
########################################################## FLTK::ClockOutput #
@FLTK::Clock::ISA = qw[FLTK::ClockOutput];
################################################################ FLTK::Group #
@FLTK::Menu::ISA = @FLTK::PackedGroup::ISA = @FLTK::ScrollGroup::ISA
    = @FLTK::StatusBarGroup::ISA = @FLTK::TabGroup::ISA
    = @FLTK::TextDisplay::ISA = @FLTK::Window::ISA = @FLTK::WizardGroup::ISA
    = qw[FLTK::Group];
################################################################# FLTK::Menu #
@FLTK::Browser::ISA = @FLTK::Choice::ISA = @FLTK::CycleButton::ISA
    = @FLTK::ItemGroup::ISA = @FLTK::MenuBar::ISA = @FLTK::PopupMenu::ISA
    = qw[FLTK::Menu];
############################################################## FLTK::Browser #
@FLTK::MultiBrowser::ISA = qw[FLTK::Browser];
################################################################ FLTK::Style #
@FLTK::NamedStyle::ISA = qw[FLTK::Style];
############################################################### FLTK::Symbol #
@FLTK::FlatBox::ISA = @FLTK::FrameBox::ISA = @FLTK::Image::ISA
    = @FLTK::MultiImage::ISA = @FLTK::TiledImage::ISA = qw[FLTK::Symbol];
############################################################## FLTK::FlatBox #
@FLTK::HighlightBox::ISA = qw[FLTK::FlatBox];
################################################################ FLTK::Image #
@FLTK::SharedImage::ISA = @FLTK::xbmImage::ISA = @FLTK::xpmImage::ISA
    = qw[FLTK::Image];
########################################################## FLTK::SharedImage #
@FLTK::gifImage::ISA = @FLTK::xpmFileImage::ISA = qw[FLTK::SharedImage];
##########
sub message ($;@) {    # XXX - translate to C
    my $l = sprintf(shift, @_);
    $l =~ s[%][\%\%]g;
    _message($l);
}

sub alert ($;@) {      # XXX - translate to C
    my $l = sprintf(shift, @_);
    $l =~ s[%][\%\%]g;
    _alert($l);
}

sub ask ($;@) {        # XXX - translate to C
    my $l = sprintf(shift, @_);
    $l =~ s[%][\%\%]g;
    _ask($l);
}

sub input ($;$@) {     # XXX - translate to C
    my ($format, $default, @sprintf) = @_;
    my $l = sprintf($format, @sprintf);
    $l =~ s[%][\%\%]g;
    _input($l, $default ? $default : ());
}

sub password ($;$@) {    # XXX - translate to C
    my ($format, $default, @sprintf) = @_;
    my $l = sprintf($format, @sprintf);
    $l =~ s[%][\%\%]g;
    _password($l, $default ? $default : ());
}
##########

=pod

=head1 NAME

FLTK - Perl interface to the (experimental) 2.0.x branch of the FLTK GUI toolkit

=head1 Description

Uh... Stuff goes here.

=head1 Functions


=over

=item C<FLTK::message ( STRING )>

Displays a message in a pop-up box with an "OK" button and waits for the
user to hit the button. The message will wrap to fit the window, or may
be many lines by putting C<\n> characters into it. The enter key is a
shortcut for the OK button.

=for Comments | This is a cheap interace to fltk::message( STRING )

=item C<FLTK::alert ( STRING )>

Same as L<C<FLTK::message( )>|/"FLTK::message ( STRING )"> except for the
"!" symbol.

=for Comments | This is a cheap interace to fltk::alert(fmt, ...)

=item C<FLTK::ask( STRING )>

Displays a message in a pop-up box with "Yes" and "No" buttons and waits
for the user to hit a button. The return value is C<1> if the user hits
Yes, C<0> if they pick No. The enter key is a shortcut for Yes and C<ESC>
is a shortcut for No.

If L<C<FLTK::message_window_timeout>|/"message_window_timeout"> is used,
then C<-1> will be returned if the timeout expires.

=item C<FLTK::choice( QUERY, CHOICE1, CHOICE2, CHOICE3 )>

Shows the message with three buttons below it marked with the strings
C<CHOICE1>, C<CHOICE2>, and C<CHOICE3>. Returns C<0>, C<1>, or C<2>
depending on which button is hit. If one of the strings begins with the
special character 'C<*>' then the associated button will be the default
which is selected when the enter key is pressed. C<ESC> is a shortcut for
C<CHOICE2>.

If L<C<FLTK::message_window_timeout>|/"message_window_timeout"> is used,
then C<-1> will be returned if the timeout expires.

=item C<FLTK::choice_alert( QUERY, CHOICE1, CHOICE2, CHOICE3  )>

Same as
L<C<choice( )>|/"FLTK::choice( QUERY, CHOICE1, CHOICE2, CHOICE3 )">
except a "!" icon is used instead of a "?".

=item C<FLTK::input( QUERY, [DEFAULT] [, ... ] )>

Pops up a window displaying a string, lets the user edit it, and return
the new value. The cancel button returns C<undef>. The returned pointer
is only valid until the next time C<FLTK::input( )> is called. Due to
back-compatibility, the arguments to any printf commands in the label are
after the default value.

If L<C<FLTK::message_window_timeout>|/"message_window_timeout"> is used,
then C<-1> will be returned if the timeout expires.

=item C<FLTK::password( QUERY, [DEFAULT] [, ... ] )>

Same as L<C<FLTK::input( )>|/FLTK::input( QUERY, [DEFAULT] [, ... ] )>
except an L<FLTK::SecretInput|FLTK::SecretInput> field is used.

=item C<FLTK::beep( [TYPE] )>

Generates a simple beep message.

=item C<beep_on_dialog( [BEEP] )>

You get the enable state of beep on default message dialogs (like
L<ask|/"FLTK::ask( STRING )">,
L<ask|/"FLTK::choice( QUERY, CHOICE1, CHOICE2, CHOICE3 )">,
L<ask|/"FLTK::input( QUERY, [DEFAULT] [, ... ] )">, ...) by using this
function with C<true> (default is C<false>).

If C<BEEP> is defined, you set the enable state.

=back

=head1 Constants

TODO

=head1 Installation

More stuff goes here.

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

CPAN ID: SANKO

=head1 License and Legal

Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify
it under the terms of The Artistic License 2.0.  See the F<LICENSE>
file included with this distribution or
http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered
by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

=for git $Id: FLTK.pm 43c1956 2009-03-24 16:25:46Z sanko@cpan.org $ for got=

=cut
