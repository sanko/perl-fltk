=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.531

=for git $Id$

=head1 NAME

FLTK - Perl bindings to the C<2.0.x> branch of the Fast Light Toolkit

=head1 Description

FLTK is a graphical user interface toolkit for X (UNIX®), Microsoft® Windows®,
OS/X, and several other platforms. FLTK provides modern GUI functionality
without the bloat and supports 3D graphics via OpenGL® and its built-in GLUT
emulation.

This module, L<FLTK|FLTK>, exposes bindings to the experimental 2.0.x branch
of the Fast Light Toolkit.

=cut

#define PERL_NO_GET_CONTEXT 1
#include <EXTERN.h>
#include <perl.h>
#define NO_XSLOCKS // XSUB.h will otherwise override various things we need
#include <XSUB.h>
#define NEED_sv_2pv_flags
#include "./include/ppport.h"
#include "./include/WidgetSubclass.h"
#include <fltk/Widget.h>

#define DISABLE_DEPRECATED          // Depreciated widgets, and other junk
#define DISABLE_ASSOCIATIONFUNCTOR  // Requires subclass
#define DISABLE_ASSOCIATIONTYPE     // Requires subclass
#define DISABLE_TEXTBUFFER          // Floating on a sea of bugs

#include <config.h>                 // created and installed by Alien::FLTK2

#if HAVE_GL == 0
#define DISABLE_GL       1
#define DISABLE_GLWINDOW 1
#endif

#ifndef ENABLE_DEPRECATED
#define DISABLE_ADJUSTER
#endif // #ifndef ENABLE_DEPRECATED

#ifndef MAX_PATH
#define MAX_PATH 1024
#endif //#ifndef MAX_PATH

HV * FLTK_stash,  // For inserting stuff directly into FLTK's namespace
   * FLTK_export; // For inserting stuff directly into FLTK's exports

SV * fltk_theme_CV;
fltk::Theme * original_theme = &fltk::theme_;

bool _fltk_theme( ) {
    dTHX;
    warn ("Here");
    if ( fltk_theme_CV && SvOK( fltk_theme_CV ) ) {
        warn ("Trying to call fltk_theme sub...");
        int count, ret_val;
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
            PUTBACK;
    count = call_sv( fltk_theme_CV, G_SCALAR );
            SPAGAIN;
    ret_val = ( bool ) ( ( count != 1 ) ? 0 : POPi );
        FREETMPS;
    LEAVE;
        return ret_val;
    }
    return (*original_theme)();
}

=begin apidoc

=for apidoc Hx|||_cb_w|WIDGET|(void*)CODE|

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

=for apidoc H|||_cb_t|(void*)CODE|

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

=for apidoc H|||_cb_f|const char * file|

This is the callback for file_chooser(...) and dir_chooser(...). It expects a
single C<const char *> parameter which should be the filename. When triggered,
the code ref handed to file_chooser_callback( CV * ) is called.

=cut

SV * file_chooser_cb;

void _cb_f (const char * file) { // Callback for file_chooser
    dTHX;
    if ( ! SvOK( file_chooser_cb ) ) return;
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    XPUSHs( newSVpv( file, strlen( file ) ) );
            PUTBACK;
    call_sv( file_chooser_cb, G_DISCARD );
        FREETMPS;
    LEAVE;
}

=for apidoc H|||isa|const char * package|const char * parent|

This pushes C<parent> onto C<package>'s C<@ISA> list for inheritance.

=cut

void isa ( const char * package, const char * parent ) {
    dTHX;
    av_push( get_av( form( "%s::ISA", package ), TRUE ),
             newSVpv( parent, 0 ) );
    // TODO: make this spider up the list and make deeper connections?
}

=for apidoc H|||export_tag|const char * what|const char * _tag|

Adds a function to a specific export tag.

=cut

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

=for apidoc H|W|bool true|DllMain|HINSTANCE hInst|DWORD reason|LPVOID lpRes|

Grabs the process global instance handle.

=cut

#ifdef WIN32
#include <windows.h>
HINSTANCE dllInstance; /* Global library instance handle. */
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

=for TODO This whole magic variable stuff screams "Refactor and rethink me!"

=for apidoc H||I32|magic_ptr_get_int|IV iv|SV * sv|

Gets the value of int-based magical variables.

=for apidoc H||I32|magic_ptr_set_int|IV iv|SV * sv|

Sets the value of int-based magical variables.

=cut

I32 magic_ptr_get_int( pTHX_ IV iv, SV * sv ) {
    int * ptr = INT2PTR( int *, iv );
    sv_setiv( sv, (int) * ptr );
    return 1;
}

I32 magic_ptr_set_int( pTHX_ IV iv, SV * sv ) {
    int * ptr = INT2PTR( int *, iv );
    * ptr = SvIV( sv );
    return 1;
}

=for apidoc H||I32|magic_ptr_get_float|IV iv|SV * sv|

Gets the value of float-based magical variables.

=for apidoc H||I32|magic_ptr_set_float|IV iv|SV * sv|

Sets the value of float-based magical variables.

=cut

I32 magic_ptr_get_float ( pTHX_ IV iv, SV * sv ) {
    float * ptr = INT2PTR( float *, iv );
    sv_setnv( sv, (float) * ptr );
    return 1;
}

I32 magic_ptr_set_float ( pTHX_ IV iv, SV * sv ) {
    float * ptr = INT2PTR( float *, iv );
    * ptr = SvNV( sv );
    return 1;
}

=for apidoc H||I32|magic_ptr_get_bool|IV iv|SV * sv|

Gets the value of int-based magical variables.

=for apidoc H||I32|magic_ptr_set_bool|IV iv|SV * sv|

Sets the value of int-based magical variables.

=cut

I32 magic_ptr_get_bool ( pTHX_ IV iv, SV * sv ) {
    bool * ptr = INT2PTR( bool *, iv );
    sv_setiv( sv, (bool) * ptr );
    return 1;
}

I32 magic_ptr_set_bool ( pTHX_ IV iv, SV * sv ) {
    bool * ptr = INT2PTR( bool *, iv );
    * ptr = SvTRUE(sv) ? true : false;
    return 1;
}

=for apidoc H||I32|magic_ptr_get_char_ptr|IV iv|SV * sv|

Gets the value of string-like magical variables.

=for apidoc H||I32|magic_ptr_set_char_ptr|IV iv|SV * sv|

Sets the value of string-like magical variables.

=cut

I32 magic_ptr_get_char_ptr ( pTHX_ IV iv, SV * sv ) {
    const char ** ptr = INT2PTR( const char **, iv );
    sv_setpv( sv, (const char *) * ptr );
    return 1;
}

I32 magic_ptr_set_char_ptr ( pTHX_ IV iv, SV * sv ) {
    const char ** ptr = INT2PTR( const char **, iv );
    * ptr = SvPV_nolen( sv );
    return 1;
}

=for apidoc H|||magic_ptr_init|const char * var|void ** ptr|

Creates truly magical variables. (This is effectively a C-level equivalent of
a tied variable).

=cut

static void magic_ptr_init( const char * var, int * ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_int = { magic_ptr_get_int, magic_ptr_set_int, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_int, sizeof(ufuncs_int));
    return;
}

static void magic_ptr_init( const char * var, float * ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_float = { magic_ptr_get_float, magic_ptr_set_float, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_float, sizeof(ufuncs_float));
    return;
}

static void magic_ptr_init( const char * var, bool * ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_bool = { magic_ptr_get_bool, magic_ptr_set_bool, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_bool, sizeof(ufuncs_bool));
    return;
}

static void magic_ptr_init( const char * var, const char ** ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_char_ptr = { magic_ptr_get_char_ptr, magic_ptr_set_char_ptr, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_char_ptr, sizeof(ufuncs_char_ptr));
    return;
}

=end apidoc

=head1 Synopsis

=for markdown {%highlight perl linenos%}

    use strict;
    use warnings;
    use FLTK qw[:style];

    my $window = FLTK::Window->new(300, 180);
    $window->begin();
    my $box = FLTK::Widget->new(20, 40, 260, 100, "Hello, World!");
    $box->box(UP_BOX);
    $box->labelfont(HELVETICA_BOLD_ITALIC);
    $box->labelsize(36);
    $box->labeltype(SHADOW_LABEL);
    $window->end();
    $window->show();
    exit FLTK::run();

=for markdown {%endhighlight%}

=head1 See Also

L<FLTK::Notes|FLTK::Notes>

=cut

/* Alright, let's get things started, shall we? */

MODULE = FLTK               PACKAGE = FLTK

PROTOTYPES: DISABLE

BOOT:
    FLTK_stash  = gv_stashpv("FLTK", TRUE );
    FLTK_export = get_hv("FLTK::EXPORT_TAGS", TRUE );

    # Functions (Exported)

INCLUDE: ask.xsi

INCLUDE: damage.xsi

INCLUDE: draw.xsi

INCLUDE: events.xsi

INCLUDE: file_chooser.xsi

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

INCLUDE: Divider.xsi

INCLUDE: FileBrowser.xsi

INCLUDE: FileIcon.xsi

INCLUDE: FileInput.xsi

INCLUDE: FillSlider.xsi

INCLUDE: Font.xsi

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

INCLUDE: PixelType.xsi

INCLUDE: Plugin.xsi

INCLUDE: pnmImage.xsi

INCLUDE: Preferences.xsi

INCLUDE: Rectangle.xsi

INCLUDE: Style.xsi

INCLUDE: Symbol.xsi

INCLUDE: TextBuffer.xsi

INCLUDE: Theme.xsi

#INCLUDE: ValueInput.xsi

MODULE = FLTK               PACKAGE = FLTK
