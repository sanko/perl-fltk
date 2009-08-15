=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for abstract Perl Interface to the Fast Light Toolkit

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/
CPANID: SANKO

=for git $Id$ for got=

=cut

#include <EXTERN.h>
#include <perl.h>
#define NO_XSLOCKS // XSUB.h will otherwise override various things we need
#include <XSUB.h>
#include "./ppport.pl"

#include <fltk/Widget.h>

using namespace fltk;

#define ENABLE_CALLBACKS  // Depends on weak refs... see FLTK::_cb_w
//#define ENABLE_DESTROY    // Introduce pointless bugs :D
#define DISABLE_DEPRECATED          // Depreciated widgets, and other junk
#define DISABLE_ASSOCIATIONFUNCTOR  // Requires subclass
#define DISABLE_ASSOCIATIONTYPE     // Requires subclass
#define DISABLE_HANDLE // Disables creation of [Widget]::handle( int event ) methods

#define USE_IMAGE 0
#define USE_GL    0
#define USE_GLUT  0
#define USE_CAIRO 0
#define USE_X     0 // TODO

#ifndef ENABLE_DEPRECATED
#define DISABLE_ADJUSTER
#endif // #ifndef ENABLE_DEPRECATED

#ifndef SvWEAKREF           // Callbacks use weak references to the widget
#undef  ENABLE_CALLBACKS    // TODO: Explain this better :)
#endif // #ifndef SvWEAKREF

#include <fltk/Widget.h>

//#define ENABLE_HASH_CALLBACKS // TODO - based on perlcall
#ifdef ENABLE_HASH_CALLBACKS
static HV * Mapping = (HV*)NULL;
#endif // #ifdef ENABLE_HASH_CALLBACKS

/* For inserting stuff directly into FLTK's namespace */
HV * FLTK_stash = gv_stashpv("FLTK", TRUE);

=for apidoc Hx|||_cb_w|WIDGET|(void*)CODE

This is the callback for all widgets. It expects an C<fltk::Widget> object and
the C<CODE> should be an AV* containing data that looks a little like this...

  [
    SV * coderef,
    FLTK::Widget widget,
    SV* args             # optional arguments sent along to coderef
  ]

=back

=cut

void _cb_w (fltk::Widget * WIDGET, void * CODE) { // Callbacks for widgets
#ifdef ENABLE_CALLBACKS
#ifndef ENABLE_HASH_CALLBACKS
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
#ifdef ENABLE_CALLBACKS // XXX - ...should weaken affect this?
#ifndef ENABLE_HASH_CALLBACKS
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
#else  // ifndef ENABLE_HASH_CALLBACKS
    warn("It's not ready!");
#endif // ifndef ENABLE_HASH_CALLBACKS
#else // ifdef ENABLE_CALLBACKS
    warn( "Callbacks have been disabled. ...how'd you get here? ¬.¬ " );
#endif // ifdef ENABLE_CALLBACKS
}

void isa(char * package, char * parent) {
    av_push(perl_get_av(form("%s::ISA",package),TRUE),newSVpv(parent,0));
    /* TODO: make this spider up the list and make deeper connections? */
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

/* Alright, let's get things started, shall we? */

MODULE = FLTK               PACKAGE = FLTK

    # Functions (Exported)

INCLUDE: ask.xsi

INCLUDE: damage.xsi

INCLUDE: events.xsi

INCLUDE: draw.xsi

INCLUDE: Flags.xsi

INCLUDE: FLTK_VERSION.xsi

INCLUDE: gl.xsi

INCLUDE: run.xsi

    # Objects (Widgets, etc.)

INCLUDE: Adjuster.xsi

INCLUDE: AlignGroup.xsi

INCLUDE: AnsiWidget.xsi

INCLUDE: BarGroup.xsi

INCLUDE: Box.xsi

INCLUDE: Browser.xsi

INCLUDE: Button.xsi

INCLUDE: CheckButton.xsi

INCLUDE: Choice.xsi

INCLUDE: Clock.xsi

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

INCLUDE: MultiBrowser.xsi

#INCLUDE: Rectangle.xsi
#INCLUDE: Slider.xsi
#INCLUDE: Style.xsi
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
    warn( "FLTK's callback system has been disabled %s.\n",
#ifndef SvWEAKREF
            "because weak references are not implemented in this release of perl"
#else  // #ifndef SvWEAKREF
            "manually"
#endif // #ifndef SvWEAKREF
    );
#endif

=head1 Testing

This is all in a section called Testing.

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
