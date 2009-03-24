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
use vars qw[@EXPORT_OK %EXPORT_TAGS];
use Exporter qw[];
*import = *import = *Exporter::import;
%EXPORT_TAGS        = ();
@EXPORT_OK          = sort map {@$_} values %EXPORT_TAGS;
$EXPORT_TAGS{'all'} = \@EXPORT_OK;
bootstrap FLTK $VERSION;

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
@FLTK::FlatBox::ISA = @FLTK::FrameBox::ISA = @FLTK::Image::ISA = @FLTK::MultiImage::ISA = @FLTK::TiledImage::ISA = qw[FLTK::Symbol];
############################################################## FLTK::FlatBox #
@FLTK::HighlightBox::ISA = qw[FLTK::FlatBox];
################################################################ FLTK::Image #
@FLTK::SharedImage::ISA = @FLTK::xbmImage::ISA = @FLTK::xpmImage::ISA  = qw[FLTK::Image];
########################################################## FLTK::SharedImage #
@FLTK::gifImage::ISA = @FLTK::xpmFileImage::ISA = qw[FLTK::SharedImage];

=pod

=head1 NAME

FLTK - Perl interface to the (experimental) 2.0.x branch of the FLTK GUI toolkit

=head1 Description

Uh... Stuff goes here.

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

=for git $Id: FLTK.pm a404412 2009-03-24 05:36:10Z sanko@cpan.org $ for got=

=cut
