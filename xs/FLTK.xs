=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK - Perl Interface to the Fast Light Toolkit

=head1 Description

FLTK is-

=for html <span style="color:#F00;font-size:2em;">

B<This project has a long way to go so I am seeking volunteers to help with
testing and development.>

Please see the L<TODO list|FLTK::Todo> and the notes on
L<getting started|FLTK::Notes/"Join the Team">.

=for html </span>

Ahem. FLTK is a graphical user interface toolkit for X (UNIX®),
Microsoft® Windows®, OS/X, and several other platforms. FLTK provides modern
GUI functionality without the bloat and supports 3D graphics via OpenGL® and
its built-in GLUT emulation.

=cut

#define PERL_NO_GET_CONTEXT 1
#include <EXTERN.h>
#include <perl.h>
#define NO_XSLOCKS // XSUB.h will otherwise override various things we need
#include <XSUB.h>
#define NEED_newCONSTSUB
#include "./ppport.pl"

#include <fltk/Widget.h>

using namespace fltk; // TODO: Remove this and use fully qualified names

#define DISABLE_DEPRECATED          // Depreciated widgets, and other junk
#define DISABLE_ASSOCIATIONFUNCTOR  // Requires subclass
#define DISABLE_ASSOCIATIONTYPE     // Requires subclass

#include <config.h> // created in / during fltk2's configure stage and
                         // installed to /fltk/include/ by Alien::FLTK

#if HAVE_GL == 0
#define DISABLE_GL       1
#define DISABLE_GLWINDOW 1
#endif

#ifndef ENABLE_DEPRECATED
#define DISABLE_ADJUSTER
#endif // #ifndef ENABLE_DEPRECATED

HV * FLTK_stash,  // For inserting stuff directly into FLTK's namespace
   * FLTK_export; // For inserting stuff directly into FLTK's exports

=begin apidoc

=for apidoc Hx|||_cb_w|WIDGET|(void*)CODE

This is the callback for all widgets. It expects an C<fltk::Widget> object and
the C<CODE> should be an HV* containing data that looks a little like this...
This will eventually replace the AV* based callback system in L<C<_cb_w>>.

  {
    coderef => CV *, # coderef to call
    class   => SV *, # string to (re-)bless WIDGET
    args    => SV *  # optional arguments sent after blessed WIDGET
  }

=cut

void _cb_w ( fltk::Widget * WIDGET, void * CODE ) {
    dTHX;
    if ( CODE == NULL )     return;
    HV * cb       = ( HV * ) CODE;
    if ( cb       == NULL ) return;
    SV ** cb_code  = hv_fetch( cb, "coderef", 7, FALSE );
    if ( cb_code  == ( SV ** ) NULL ) return;
    SV ** cb_args  = hv_fetch( cb, "args",    4, FALSE );
    SV ** cb_class = hv_fetch( cb, "class",   5, FALSE );
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    SV * widget = sv_newmortal( );
    sv_setref_pv( widget, SvPV_nolen( * cb_class ), ( void * ) WIDGET );
    XPUSHs( widget );
    if ( cb_args != NULL ) XPUSHs( * cb_args );
            PUTBACK;
    call_sv( * cb_code, G_DISCARD );
        FREETMPS;
    LEAVE;
}

=for apidoc H|||_cb_t|(void*)CODE

This is the generic callback for just about everything. It expects a single
C<(void*) CODE> parameter which should be an AV* holding data that looks a
little like this...

  [
    SV * coderef,
    SV * args  # optional arguments sent along to coderef
  ]

=cut

void _cb_t (void * CODE) { // Callbacks for timers, etc.
    dTHX;
    if ( CODE == NULL )     return;
    HV * cb       = ( HV * ) CODE;
    if ( cb       == NULL ) return;
    SV ** cb_code  = hv_fetch( cb, "coderef", 7, FALSE );
    if ( cb_code  == ( SV ** ) NULL ) return;
    SV ** cb_args  = hv_fetch( cb, "args",    4, FALSE );
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    if ( cb_args != NULL ) XPUSHs( * cb_args );
            PUTBACK;
    call_sv( * cb_code, G_DISCARD );
        FREETMPS;
    LEAVE;
}

=for apidoc H|||isa|package|parent|

This pushes C<parent> onto C<package>'s C<@ISA> list for inheritance.

=cut

void isa ( const char * package, const char * parent ) {
    dTHX;
    av_push( get_av( form( "%s::ISA", package ), TRUE ),
             newSVpv( parent, 0 ) );
    // TODO: make this spider up the list and make deeper connections?
}

void export_tag (const char * what, const char * _tag ) {
    dTHX;
    SV ** tag = hv_fetch( FLTK_export, _tag, strlen(_tag), TRUE );
    if (tag && SvOK(* tag) && SvROK(* tag ) && (SvTYPE(SvRV(*tag))) == SVt_PVAV)
        av_push((AV*)SvRV(*tag), newSVpv(what, 0));
    else {
        SV * av;
        av = (SV*) newAV( );
        av_push((AV*)av, newSVpv(what, 0));
        tag = hv_store( FLTK_export, _tag, strlen(_tag), newRV_noinc(av), 0 );
    }
}

#ifdef WIN32
#include <windows.h>
HINSTANCE dllInstance; // Global library instance handle.
extern "C" BOOL WINAPI DllMain (HINSTANCE hInst, DWORD reason, LPVOID lpRes) {
    switch ( reason ) {
        case DLL_PROCESS_ATTACH:
        case DLL_THREAD_ATTACH:
            dllInstance = hInst;
            break;
    }
    return TRUE;
}
#endif // #ifdef WIN32

=end apidoc

=head1 Synopsis

    use strict;
    use warnings;
    use FLTK;

    my $window = FLTK::Window->new(300, 180);
    $window->begin();
    my $box = FLTK::Widget->new(20, 40, 260, 100, "Hello, World!");
    $box->box(UP_BOX);
    $box->labelfont(HELVETICA_BOLD_ITALIC);
    $box->labelsize(36);
    $box->labeltype(SHADOW_LABEL);
    $window->end();
    $window->show();
    exit run();

=head1 See Also

L<FLTK::Notes|FLTK::Notes>

=cut

// Alright, let's get things started, shall we?

MODULE = FLTK               PACKAGE = FLTK

BOOT:
    FLTK_stash  = Perl_gv_stashpv(aTHX_ "FLTK", TRUE );
    FLTK_export = Perl_get_hv(aTHX_ "FLTK::EXPORT_TAGS", TRUE );

    # Functions (Exported)

INCLUDE: ask.xsi

INCLUDE: damage.xsi

INCLUDE: draw.xsi

INCLUDE: events.xsi

INCLUDE: Flags.xsi

INCLUDE: GL.xsi

INCLUDE: layout.xsi

INCLUDE: run.xsi

INCLUDE: Version.xsi

    # Objects (Widgets, Types, etc.)

INCLUDE: Adjuster.xsi

INCLUDE: AlignGroup.xsi

INCLUDE: AnsiWidget.xsi

#ifndef DISABLE_WIDGETASSOCIATION

INCLUDE: AssociationFunctor.xsi

INCLUDE: AssociationType.xsi

#endif // #ifndef DISABLE_WIDGETASSOCIATION

INCLUDE: BarGroup.xsi

INCLUDE: Box.xsi

INCLUDE: Browser.xsi

INCLUDE: Button.xsi

INCLUDE: Choice.xsi

INCLUDE: Color.xsi

INCLUDE: ColorChooser.xsi

INCLUDE: ComboBox.xsi

INCLUDE: Cursor.xsi

INCLUDE: CycleButton.xsi

INCLUDE: Dial.xsi

INCLUDE: Divider.xsi

INCLUDE: FileBrowser.xsi

INCLUDE: FileIcon.xsi

INCLUDE: FileInput.xsi

INCLUDE: FillDial.xsi

INCLUDE: FillSlider.xsi

INCLUDE: Font.xsi

INCLUDE: Group.xsi

INCLUDE: HelpDialog.xsi

INCLUDE: HelpView.xsi

INCLUDE: HighlightButton.xsi

INCLUDE: Image.xsi

INCLUDE: Input.xsi

INCLUDE: InputBrowser.xsi

INCLUDE: IntInput.xsi

INCLUDE: InvisibleBox.xsi

INCLUDE: Item.xsi

INCLUDE: ItemGroup.xsi

INCLUDE: LabelType.xsi

INCLUDE: LightButton.xsi

INCLUDE: MenuSection.xsi

INCLUDE: MultiImage.xsi

INCLUDE: MultiLineOutput.xsi

INCLUDE: Plugin.xsi

INCLUDE: Rectangle.xsi

#INCLUDE: Slider.xsi

INCLUDE: Style.xsi

#INCLUDE: Valuator.xsi
#INCLUDE: ValueInput.xsi
#INCLUDE: ValueOutput.xsi

INCLUDE: Widget.xsi

INCLUDE: Window.xsi

MODULE = FLTK               PACKAGE = FLTK
