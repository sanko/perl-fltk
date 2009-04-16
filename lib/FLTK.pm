#!perl -I../blib/lib -I../blib/arch -I../blib/arch/FLTK/FLTK
package FLTK;
use strict;
use warnings;

#
use FLTK::Version;
use version qw[qv];
our $VERSION_BASE = 0; our $UNSTABLE_RELEASE = 1; our $VERSION = sprintf(($UNSTABLE_RELEASE ? q[%.3f_%03d] : q[%.3f]), (version->new(($VERSION_BASE))->numify / 1000), $UNSTABLE_RELEASE);

#
#use parent 'DynaLoader';
use base 'DynaLoader';    # Testing for clean perl5.8

#
use vars qw[@EXPORT_OK @EXPORT %EXPORT_TAGS];
use Exporter qw[import];
%EXPORT_TAGS = (
    flags => [
        qw[ NO_FLAGS
            ALIGN_TOP ALIGN_BOTTOM ALIGN_LEFT ALIGN_RIGHT ALIGN_CENTER
            ALIGN_INSIDE ALIGN_CLIP ALIGN_WRAP ALIGN_MASK
            ALIGN_POSITIONMASK
            ALIGN_TOPLEFT ALIGN_BOTTOMLEFT ALIGN_TOPRIGHT
            ALIGN_BOTTOMRIGHT ALIGN_CENTERLEFT ALIGN_CENTERRIGHT
            ALIGN_INSIDE_TOP ALIGN_INSIDE_BOTTOM ALIGN_INSIDE_LEFT
            ALIGN_INSIDE_TOPLEFT ALIGN_INSIDE_BOTTOMLEFT
            ALIGN_INSIDE_RIGHT ALIGN_INSIDE_TOPRIGHT
            ALIGN_INSIDE_BOTTOMRIGHT ALIGN_MENU ALIGN_BROWSER
            INACTIVE OUTPUT STATE SELECTED INVISIBLE HIGHLIGHT CHANGED
            COPIED_LABEL RAW_LABEL LAYOUT_VERTICAL TAB_TO_FOCUS
            CLICK_TO_FOCUS INACTIVE_R FOCUSED PUSHED RESIZE_NONE
            RESIZE_FIT RESIZE_FILL OPENED ]
    ],
    ask => [
        qw[ BEEP_DEFAULT BEEP_MESSAGE BEEP_ERROR BEEP_QUESTION BEEP_PASSWORD
            BEEP_NOTIFICATION
            alert ask beep beep_on_dialog choice choice_alert input message
            password
            ok yes no cancel message_window_timeout message_window_scrollable
            message_window_label message_style icon_style
            ]
    ],
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
    cursor => [
        qw[ CURSOR_DEFAULT  CURSOR_ARROW    CURSOR_CROSS    CURSOR_WAIT
            CURSOR_INSERT   CURSOR_HAND     CURSOR_HELP     CURSOR_MOVE
            CURSOR_NS       CURSOR_WE       CURSOR_NWSE     CURSOR_NESW
            CURSOR_NO       CURSOR_NONE
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
    default => [qw[run message alert ask input password %FLTK]],
    run     => [
        qw[ READ WRITE EXCEPT
            help
            awake
            ready
            flush
            run
            ]
    ],
    visual => [
        qw[ RGB_COLOR INDEXED_COLOR SINGLE_BUFFER DOUBLE_BUFFER ACCUM_BUFFER
            ALPHA_BUFFER DEPTH_BUFFER STENCIL_BUFFER RGB24_COLOR MULTISAMPLE
            STEREO
            glVisual own_colormap visual ]
    ]
);
@EXPORT_OK = sort map {@$_} values %EXPORT_TAGS;
$EXPORT_TAGS{'all'} = \@EXPORT_OK;
@EXPORT = sort map { m[^:(.+)] ? @{$EXPORT_TAGS{$1}} : $_ }
    qw[:box :label :font :default];

#use Data::Dump qw[pp];
#warn pp \@EXPORT;
bootstrap FLTK $VERSION if !($FLTK::NOXS && $FLTK::NOXS);    # for testing

#sub END { warn "..." }
# Classes ####################################################################
@FLTK::Aduster::ISA            = qw[FLTK::Valuator];
@FLTK::AssociationFunctor::ISA = qw[];
@FLTK::AssociationType::ISA    = qw[];
@FLTK::Box::ISA                = qw[FLTK::Symbol];
@FLTK::Browser::ISA            = qw[FLTK::Menu];
@FLTK::Button::ISA             = qw[FLTK::Widget];
@FLTK::CheckButton::ISA        = qw[FLTK::Button];
@FLTK::Choice::ISA             = qw[FLTK::Menu];
@FLTK::Clock::ISA              = qw[FLTK::ClockOutput];
@FLTK::ClockOutput::ISA        = qw[FLTK::Widget];
@FLTK::CreatedWindow::ISA      = qw[];
@FLTK::CycleButton::ISA        = qw[FLTK::Menu];
@FLTK::Dial::ISA               = qw[FLTK::Valuator];
@FLTK::Divider::ISA            = qw[FLTK::Widget];
@FLTK::FillDial::ISA           = qw[FLTK::Dial];
@FLTK::FillSlider::ISA         = qw[FLTK::Slider];
@FLTK::FlatBox::ISA            = qw[FLTK::Symbol];
@FLTK::FloatInput::ISA         = qw[FLTK::NumericInput];
@FLTK::Font::ISA               = qw[];
@FLTK::FrameBox::ISA           = qw[FLTK::Symbol];
@FLTK::gifImage::ISA           = qw[FLTK::SharedImage];
@FLTK::GlutWindow::ISA         = qw[FLTK::GlWindow];
@FLTK::GlWindow::ISA           = qw[FLTK::Window];
@FLTK::Group::ISA              = qw[FLTK::Widget];
@FLTK::GSave::ISA              = qw[];
@FLTK::Guard::ISA              = qw[];
@FLTK::HighlightBox::ISA       = qw[FLTK::FlatBox];
@FLTK::HighlightButton::ISA    = qw[FLTK::Button];
@FLTK::Image::ISA              = qw[FLTK::Symbol];
@FLTK::ImageType::ISA          = qw[];
@FLTK::Input::ISA              = qw[FLTK::Widget];
@FLTK::IntInput::ISA           = qw[FLTK::FloatInput];
@FLTK::InvisibleBox::ISA       = qw[FLTK::Widget];
@FLTK::Item::ISA               = qw[FLTK::Widget];
@FLTK::ItemGroup::ISA          = qw[FLTK::Menu];
@FLTK::LightButton::ISA        = qw[FLTK::CheckButton];
@FLTK::LineDial::ISA           = qw[FLTK::Dial];
@FLTK::Menu::ISA               = qw[FLTK::Group];
@FLTK::MenuBar::ISA            = qw[FLTK::Menu];
@FLTK::MenuSection::ISA        = qw[];

#
#
# According to fltk's docs
@FLTK::GlueFunctor::ISA             = qw[FLTK::AssociationFunctor];
@FLTK::keyCompareFunctor::ISA       = qw[FLTK::AssociationFunctor];
@FLTK::shortcutAssociationType::ISA = qw[FLTK::AssociationType];
@FLTK::ComboBrowser::ISA            = qw[FLTK::Browser];
@FLTK::FileBrowser::ISA             = qw[FLTK::Browser];
@FLTK::MultiBrowser::ISA            = qw[FLTK::Browser];
@FLTK::BButton::ISA                 = qw[FLTK::Button];
@FLTK::RepeatButton::ISA            = qw[FLTK::Button];
@FLTK::ReturnButton::ISA            = qw[FLTK::Button];
@FLTK::ToggleButton::ISA            = qw[FLTK::Button];
@FLTK::LightButton::ISA             = qw[FLTK::CheckButton];
@FLTK::RadioButton::ISA             = qw[FLTK::CheckButton];
@FLTK::ComboBox::ISA                = qw[FLTK::Choice];
@FLTK::LineDial::ISA                = qw[FLTK::Dial];
@FLTK::PlasticBox::ISA              = qw[FLTK::FrameBox];
@FLTK::RoundBox::ISA                = qw[FLTK::FrameBox];
@FLTK::AlignGroup::ISA              = qw[FLTK::Group];
@FLTK::BarGroup::ISA                = qw[FLTK::Group];
@FLTK::ColorChooser::ISA            = qw[FLTK::Group];
@FLTK::HelpView::ISA                = qw[FLTK::Group];
@FLTK::PackedGroup::ISA             = qw[FLTK::Group];
@FLTK::ScrollGroup::ISA             = qw[FLTK::Group];
@FLTK::StatusBarGroup::ISA          = qw[FLTK::Group];
@FLTK::TabGroup::ISA                = qw[FLTK::Group];
@FLTK::TextDisplay::ISA             = qw[FLTK::Group];
@FLTK::TiledGroup::ISA              = qw[FLTK::Group];
@FLTK::Window::ISA                  = qw[FLTK::Group];
@FLTK::WizardGroup::ISA             = qw[FLTK::Group];
@FLTK::rgbImage::ISA                = qw[FLTK::Image];
@FLTK::SharedImage::ISA             = qw[FLTK::Image];
@FLTK::xbmImage::ISA                = qw[FLTK::Image];
@FLTK::xpmImage::ISA                = qw[FLTK::Image];
@FLTK::FileInput::ISA               = qw[FLTK::Input];
@FLTK::MultiLineInput::ISA          = qw[FLTK::Input];
@FLTK::NumericInput::ISA            = qw[FLTK::Input];
@FLTK::Output::ISA                  = qw[FLTK::Input];
@FLTK::SecretInput::ISA             = qw[FLTK::Input];
@FLTK::WordwrapInput::ISA           = qw[FLTK::Input];
@FLTK::FileItem::ISA                = qw[FLTK::Item];
@FLTK::RadioItem::ISA               = qw[FLTK::Item];
@FLTK::ToggleItem::ISA              = qw[FLTK::Item];
@FLTK::RadioLightButton::ISA        = qw[FLTK::LightButton];
@FLTK::StringHierarchy::ISA         = qw[FLTK::List];
@FLTK::Share_List::ISA              = qw[FLTK::List];
@FLTK::InputBrowser::ISA            = qw[FLTK::Menu];
@FLTK::PopupMenu::ISA               = qw[FLTK::Menu];

=pod


#
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
################################################################# FLTK::Dial #
@FLTK::FillDial::ISA = @FLTK::LineDial::ISA = qw[FLTK::Dial];
############################################################### FLTK::Slider #
@FLTK::FillSlider::ISA = qw[FLTK::Slider];
######################################################### FLTK::NumericInput #
@FLTK::FloatInput::ISA = qw[FLTK::NumericInput];
########################################################### FLTK::FloatInput #
@FLTK::IntInput::ISA = qw[FLTK::FloatInput];
# Depreciated Widgets ########################################################
############################################################# FLTK::Valuator #
@FLTK::Adjuster::ISA = qw[FLTK::Valuator];
##########

=cut

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
__END__

=pod

=begin comments


# Magic? Abuse of C pointers? Yes. ###########################################
for my $what (qw[no ok cancel yes
                message_window_label
                message_window_scrollable
                message_window_timeout], # Read/Write
              qw[help] # Read only
    )
{   eval sprintf '$FLTK::%s = FLTK::_%s();
    FLTK::_%s($FLTK::%s) if $FLTK::%s;', $what, $what,
        $what,
        $what, $what;
}

=end comments

=cut

################################
for my $var (qw[yes no ok cancel]) {
    eval sprintf q[tie our $%s, 'FLTK::Variable', $var;], $var, $var;
}
for my $var (qw[help]) {
    eval sprintf q[tie our $%s, 'FLTK::Variable::ReadOnly', $var;], $var,
        $var;
}
{

    package FLTK::Variable;
    use strict;
    use warnings;
    use Carp;
    sub TIESCALAR { my ($class, $what) = @_; return bless \$what, $class; }

    sub FETCH {
        my $self = shift;
        confess "wrong type" unless ref $self;
        croak "usage error" if @_;
        my $return;
        local ($!) = 0;
        my $line = sprintf 'FLTK::%s();', $$self;
        $return = eval $line;
        if ($!) { croak sprintf 'FETCH %s failed: %s', $$self, $! }
        return $return;
    }

    sub STORE {
        my ($self, $value) = @_;
        confess "wrong type" unless ref $self;
        croak "usage error" if scalar @_ > 2;
        local ($!) = 0;
        my $line = sprintf 'FLTK::%s("%s");', $$self, $value;
        warn $line;
        my $return = eval $line;
        if ($!) { croak sprintf 'FETCH %s failed: %s', $$self, $! }
        return $return;
    }

    sub DESTROY {
        my $self = shift;
        confess "wrong type" unless ref $self;
    }
}
{

    package FLTK::Variable::ReadOnly;
    use strict;
    use warnings;
    BEGIN { our @ISA = qw[FLTK::Variable]; }
    sub STORE { return 0 }
}
1;

#
# Copyright (C) 2009 by Sanko Robinson <sanko@cpan.org>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of The Artistic License 2.0.  See the LICENSE file
# included with this distribution or
# http://www.perlfoundation.org/artistic_license_2_0.  For
# clarification, see http://www.perlfoundation.org/artistic_2_0_notes.
#
# When separated from the distribution, all POD documentation is covered by
# the Creative Commons Attribution-Share Alike 3.0 License.  See
# http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
# clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.
#
# $Id: FLTK.pm 9b2bc67 2009-04-14 02:18:15Z sanko@cpan.org $
#
