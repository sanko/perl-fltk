=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for abstract Perl Interface to the Fast Light Toolkit

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=head1 Description

FLTK is-

=for html <span style="color:#F00;font-size:2em;">

B<I am actively seeking volunteers to help test and develop this project.
Please see the notes on L<joining the team|FLTK::Notes/"Join the Team">.>

=for html </span>

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

#define ENABLE_CALLBACKS  // Depends on weak refs... see FLTK::_cb_w
#define DISABLE_DEPRECATED          // Depreciated widgets, and other junk
#define DISABLE_ASSOCIATIONFUNCTOR  // Requires subclass
#define DISABLE_ASSOCIATIONTYPE     // Requires subclass
#define DISABLE_HANDLE // Disables creation of [Widget]::handle( int event ) methods

#include <fltk/config.h> // created in / during fltk2's configure stage and
                         // installed to /fltk/include/ by Alien::FLTK

#if HAVE_GL == 0
#define DISABLE_GL 1
#define DISABLE_GLWINDOW 1
#endif

#ifndef ENABLE_DEPRECATED
#define DISABLE_ADJUSTER
#endif // #ifndef ENABLE_DEPRECATED

#ifndef SvWEAKREF           // Callbacks use weak references to the widget
#undef  ENABLE_CALLBACKS    // TODO: Explain this better :)
#endif // #ifndef SvWEAKREF

// #define ENABLE_HASH_CALLBACKS // TODO - based on perlcall
#ifdef ENABLE_HASH_CALLBACKS
static HV * Mapping = (HV*)NULL;
#endif // #ifdef ENABLE_HASH_CALLBACKS

HV * FLTK_stash,  // For inserting stuff directly into FLTK's namespace
   * FLTK_export; // For inserting stuff directly into FLTK's exports

=begin apidoc

=for apidoc Hx|||_cb_w|WIDGET|(void*)CODE

This is the callback for all widgets. It expects an C<fltk::Widget> object and
the C<CODE> should be an AV* containing data that looks a little like this...

  [
    SV * coderef,
    FLTK::Widget widget,
    SV* args             # optional arguments sent along to coderef
  ]

=cut

void _cb_w (fltk::Widget * WIDGET, void * CODE) { // Callbacks for widgets
#ifdef ENABLE_CALLBACKS
#ifndef ENABLE_HASH_CALLBACKS
    dTHX;
    if (CODE == NULL) return;
    AV *cbargs = (AV *) CODE;
    if (cbargs == NULL) return;
    I32 alen = av_len(cbargs);
    SV *thecb = SvRV(*av_fetch(cbargs, 0, 0));
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK(sp);
    for(int i = 1; i <= alen; i++) { XPUSHs(*av_fetch(cbargs, i, 0)); }
            PUTBACK;
    call_sv(thecb, G_DISCARD);
        FREETMPS;
    LEAVE;
#else  // ifndef ENABLE_HASH_CALLBACKS
    warn("It's not ready!");
#endif // ifndef ENABLE_HASH_CALLBACKS
#else // ifdef ENABLE_CALLBACKS
    warn( "Callbacks have been disabled. ...how'd you get here? ¬.¬ " );
#endif // ifdef ENABLE_CALLBACKS
}

=for apidoc H|||_cb|(void*)CODE

This is the generic callback for just about everything. It expects a single
C<(void*) CODE> parameter which should be an AV* holding data that looks a
little like this...

  [
    SV * coderef,
    SV* args  # optional arguments sent along to coderef
  ]

=cut

void _cb (void * CODE) { // Callbacks for timers, etc.
#ifdef ENABLE_CALLBACKS
    dTHX;
#ifdef ENABLE_HASH_CALLBACKS
    warn("Hash based callbacks are not ready.");
#else // #ifdef ENABLE_HASH_CALLBACKS
    AV *cbargs = (AV *) CODE;
    I32 alen = av_len(cbargs);
    SV *thecb = SvRV(*av_fetch(cbargs, 0, 0));
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK(sp);
    for(int i = 1; i <= alen; i++) { XPUSHs(*av_fetch(cbargs, i, 0)); }
            PUTBACK;
    call_sv(thecb, G_DISCARD);
        FREETMPS;
    LEAVE;
#endif // ifdef ENABLE_HASH_CALLBACKS
#else  // ifdef ENABLE_CALLBACKS
    warn( "Callbacks have been disabled. ...how'd you get here? ¬.¬ " );
#endif // ifdef ENABLE_CALLBACKS
}

=for apidoc |||isa|package|parent|

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



// Alright, let's get things started, shall we?

MODULE = FLTK               PACKAGE = FLTK

BOOT:
    FLTK_stash  = Perl_gv_stashpv(aTHX_ "FLTK", TRUE );
    FLTK_export = Perl_get_hv(aTHX_ "FLTK::EXPORT_TAGS", TRUE );

    # Functions (Exported)

INCLUDE: ask.xsi

INCLUDE: damage.xsi

INCLUDE: events.xsi

INCLUDE: draw.xsi

INCLUDE: Flags.xsi

INCLUDE: GL.xsi

INCLUDE: layout.xsi

INCLUDE: run.xsi

INCLUDE: Version.xsi

    # Objects (Widgets, Types, etc.)

INCLUDE: Adjuster.xsi

INCLUDE: AlignGroup.xsi

INCLUDE: AnsiWidget.xsi

INCLUDE: BarGroup.xsi

INCLUDE: Box.xsi

INCLUDE: Browser.xsi

INCLUDE: Button.xsi

INCLUDE: CheckButton.xsi

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

INCLUDE: FloatInput.xsi

INCLUDE: Font.xsi

INCLUDE: GlWindow.xsi

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

INCLUDE: LineDial.xsi

INCLUDE: MultiBrowser.xsi

#INCLUDE: Rectangle.xsi
#INCLUDE: Slider.xsi

INCLUDE: Style.xsi

#INCLUDE: Valuator.xsi
#INCLUDE: ValueInput.xsi
#INCLUDE: ValueOutput.xsi

INCLUDE: Widget.xsi

INCLUDE: WidgetAssociation.xsi

INCLUDE: Window.xsi


    #INCLUDE: ~old/CheckButton.xsi
    #INCLUDE: ~old/Choice.xsi
    #INCLUDE: ~old/Clock.xsi
    #INCLUDE: ~old/ClockOutput.xsi
    #INCLUDE: ~old/CreatedWindow.xsi
    #INCLUDE: ~old/CycleButton.xsi
    #INCLUDE: ~old/Dial.xsi
    #INCLUDE: ~old/Divider.xsi
    #INCLUDE: ~old/FillDial.xsi
    #INCLUDE: ~old/FillSlider.xsi
    #INCLUDE: ~old/FlatBox.xsi
    #INCLUDE: ~old/FloatInput.xsi
    #INCLUDE: ~old/Font.xsi
    #INCLUDE: ~old/FrameBox.xsi
    #INCLUDE: ~old/gifImage.xsi
    #INCLUDE: ~old/GlutWindow.xsi
    #INCLUDE: ~old/GlWindow.xsi
    #INCLUDE: ~old/GSave.xsi
    #INCLUDE: ~old/Guard.xsi
    #INCLUDE: ~old/HighlightBox.xsi
    #INCLUDE: ~old/HighlightButton.xsi
    #INCLUDE: ~old/Image.xsi
    #INCLUDE: ~old/ImageType.xsi
    #INCLUDE: ~old/Input.xsi
    #INCLUDE: ~old/IntInput.xsi
    #INCLUDE: ~old/InvisibleBox.xsi
    #INCLUDE: ~old/Item.xsi
    #INCLUDE: ~old/ItemGroup.xsi
    #INCLUDE: ~old/LightButton.xsi
    #INCLUDE: ~old/LineDial.xsi
    #INCLUDE: ~old/List.xsi
    #INCLUDE: ~old/Menu.xsi
    #INCLUDE: ~old/MenuBar.xsi
    #INCLUDE: ~old/MenuSection.xsi
    #INCLUDE: ~old/MenuWindow.xsi
    #INCLUDE: ~old/Monitor.xsi
    #INCLUDE: ~old/MultiBrowser.xsi
    #INCLUDE: ~old/MultiImage.xsi

MODULE = FLTK               PACKAGE = FLTK

BOOT:
#ifndef ENABLE_CALLBACKS
    warn( "FLTK's callback system was disabled during build.\n" );
    // This warning should show up during compilation
#endif

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

=cut
