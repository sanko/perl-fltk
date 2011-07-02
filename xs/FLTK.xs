=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532007

=for git $Id$

=cut

#include "include/FLTK_pm.h"

HV * FLTK_stash,  // For inserting stuff directly into FLTK's namespace
   * FLTK_export; // For inserting stuff directly into FLTK's exports

void register_constant( const char * name, SV * value ) {
    dTHX;
    newCONSTSUB( FLTK_stash, name, value );
}

void register_constant( const char * package, const char * name, SV * value ) {
    dTHX;
    HV * _stash  = gv_stashpv( package, TRUE );
    newCONSTSUB( _stash, name, value );
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
    if ( CODE == NULL )    return;
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

=for apidoc H|||_cb_t|(void *) CODE|

This is the generic callback for just about everything. It expects a single
C<(void*) CODE> parameter which should be an AV* holding data that looks a
little like this...

  [
    SV * coderef,
    SV * args  # optional arguments sent along to coderef
  ]

=cut

void _cb_t (void * CODE) { // Callbacks for timers, idle watchers, and checks
    dTHX;
    if ( CODE == NULL )     return;
    AV  * ref = MUTABLE_AV( CODE );
    SV ** coderef = av_fetch(ref, 0, FALSE);
    if ( coderef  == ( SV ** ) NULL ) return; // Be somewhat safe
    SV ** argsref = av_fetch(ref, 1, FALSE);
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    if ( argsref != NULL ) XPUSHs( * argsref );
            PUTBACK;
    call_sv( * coderef, G_DISCARD );
        FREETMPS;
    LEAVE;
}

=for apidoc H|||_cb_u|int position|(void *) CODE|

This is the callback for FLTK::TextDisplay->highlight_data(...). It expects an
C<int> parameter which represents a buffer position and a C<(void*) CODE>
parameter which should be an AV* holding data that looks a little like this...

  [
    SV * coderef,
    SV * args  # optional arguments sent along to coderef
  ]

=cut

void _cb_u ( int position, void * CODE) { // Callback for TextDisplay->highlight_data( ... )
    dTHX;
    if ( CODE == NULL )     return;
    AV  * ref = MUTABLE_AV( CODE );
    SV ** coderef = av_fetch(ref, 0, FALSE);
    if ( coderef  == ( SV ** ) NULL ) return; // Avoid silly mistakes
    SV ** argsref = av_fetch(ref, 1, FALSE);
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    XPUSHs(sv_2mortal(newSViv(position)));
    if ( argsref != NULL ) XPUSHs( * argsref );
            PUTBACK;
    call_sv( * coderef, G_DISCARD );
        FREETMPS;
    LEAVE;
}

=for apidoc H|||_cb_f|int fd|(void *) CODE|

This is the callback for FLTK::add_fh(...). It expects an C<int> parameter
which represents a filehandle's fileno and a C<(void*) CODE> parameter which
should be an AV* holding data that looks a little like this...

  [
    SV * coderef,
    SV * filedes,     # Used in FLTK::remove_fd(...) only
    SV * events,     # "                               "
    SV * args        # Optional arguments sent along to coderef
  ]

=cut

void _cb_f ( int fd, void * CODE) { // Callback for add_fh( ... )
    dTHX;
    if ( CODE == NULL )     return;
    AV  * ref = MUTABLE_AV( CODE );
    SV ** coderef = av_fetch(ref, 0, FALSE);
    if ( coderef  == ( SV ** ) NULL ) return; // Avoid silly mistakes
    SV ** fileref = av_fetch( ref, 1, FALSE );
    SV ** moderef = av_fetch( ref, 3, FALSE );
    SV ** argsref = av_fetch( ref, 4, FALSE );
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    XPUSHs( sv_2mortal(newSVsv(SvRV(* fileref ))));
    if ( argsref != NULL ) XPUSHs( * argsref );
            PUTBACK;
    call_sv( * coderef, G_DISCARD );
        FREETMPS;
    LEAVE;
}

=for apidoc H|||isa|const char * package|const char * parent|

This pushes C<parent> onto C<package>'s C<@ISA> list for inheritance. This now
tries to create the parent package if it is not preexisting.

=cut

void isa ( const char * package, const char * parent ) {
    dTHX;
    HV * parent_stash = gv_stashpv( parent, GV_ADD | GV_ADDMULTI );
    av_push( get_av( form( "%s::ISA", package ), TRUE ),
             newSVpv( parent, 0 ) );
    // TODO: make this spider up the list and make deeper connections?
}

=for apidoc H|||export_tag|const char * what|const char * _tag|

Adds a function to a specific export tag.

=cut

void export_tag (const char * what, const char * _tag ) {
    dTHX;
    //warn("Exporting %s to %s", what, _tag);
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

void magic_ptr_init( const char * var, int * ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_int = { magic_ptr_get_int, magic_ptr_set_int, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_int, sizeof(ufuncs_int));
    return;
}

void magic_ptr_init( const char * var, float * ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_float = { magic_ptr_get_float, magic_ptr_set_float, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_float, sizeof(ufuncs_float));
    return;
}

void magic_ptr_init( const char * var, bool * ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_bool = { magic_ptr_get_bool, magic_ptr_set_bool, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_bool, sizeof(ufuncs_bool));
    return;
}

void magic_ptr_init( const char * var, const char ** ptr ) {
    dTHX;
    SV * sv;
    struct ufuncs ufuncs_char_ptr = { magic_ptr_get_char_ptr, magic_ptr_set_char_ptr, (long) ptr };
    sv = get_sv( var, GV_ADD|GV_ADDMULTI );
    sv_magic(sv, NULL, PERL_MAGIC_uvar, (char *)&ufuncs_char_ptr, sizeof(ufuncs_char_ptr));
    return;
}


int call ( const char * code, const char * args ) {
    dTHX;
    int retval;
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    XPUSHs( sv_2mortal( newSVpv( args, strlen( args ) ) ) );
            PUTBACK;
    retval = call_pv( code, G_SCALAR | G_EVAL );
        FREETMPS;
    LEAVE;
    return retval;
}


int call ( SV * code, const char * args ) {
    dTHX;
    int retval;
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK( sp );
    XPUSHs( sv_2mortal( newSVpv( args, strlen( args ) ) ) );
            PUTBACK;
    retval = call_sv( code, G_SCALAR );
        FREETMPS;
    LEAVE;
    return retval;
}

/*
int get_c_func (const char * name) {
    dTHX;
    SV *result;
    int count;
    dSP;
    PUSHMARK(sp);
    XPUSHs (sv_2mortal (newSVpv (name, 0)));
    PUTBACK;
    count = call_pv("DynaLoader::dl_find_symbol_anywhere", G_SCALAR | G_EVAL );
    SPAGAIN;
    if (count != 1)
        croak ("FLTK::get_c_func returned %d items", count);
    result = POPs;
    if (!SvOK (result))
        croak ("Could not get C function for %s", name);
    PUTBACK;
    return SvIV(result);
}

int install_xsub (const char * package, int id) {
    dTHX;
    SV *result;
    int count;
    dSP;
    PUSHMARK(sp);
    XPUSHs (sv_2mortal (newSVpv (package, 0)));
    XPUSHs (sv_2mortal (newSViv ( id )));
    PUTBACK;
    count = call_pv("DynaLoader::dl_install_xsub", G_SCALAR | G_EVAL );
    SPAGAIN;
    if (count != 1)
        croak ("FLTK::install_xsub returned %d items", count);
    result = POPs;
    if (!SvOK (result))
        croak ("Could not install function for %s", package);
    PUTBACK;
    return SvIV(result);
}

void boot_subpackage( const char * package ) {
    install_xsub( "FLTK::Window::bootstrap", get_c_func("boot_FLTK__Window") );
    call("FLTK::Window::bootstrap", "");
    call("FLTK::Window::import", "");
}
*/

SV * cvrv;

=for apidoc H|W|bool true|DllMain|HINSTANCE hInst|DWORD reason|LPVOID lpRes|

Grabs the process global instance handle.

=cut

#ifdef WIN32
#include <windows.h>
HINSTANCE _dllInstance;
HINSTANCE dllInstance( ) { return _dllInstance; }
extern "C" BOOL WINAPI DllMain (HINSTANCE hInst, DWORD reason, LPVOID lpRes) {
    switch ( reason ) {
        case DLL_PROCESS_ATTACH:
        case DLL_THREAD_ATTACH:
            _dllInstance = hInst;
            break;
    }
    return TRUE;
}
#endif // #ifdef WIN32

#include "include/FLTK_pm_boot.h"

=end apidoc

=cut

/* Alright, let's get things started, shall we? */

MODULE = FLTK               PACKAGE = FLTK

BOOT:
    FLTK_stash  = gv_stashpv( "FLTK", TRUE );
    FLTK_export = get_hv( "FLTK::EXPORT_TAGS", TRUE );
    cvrv = eval_pv(
        "sub {"
        "    require DynaLoader;"
        "    my $package = shift;"
        "    my $symbol  = $package;"
        "    $symbol =~ s[\\W][_]g;"
        "    DynaLoader::dl_install_xsub($package . '::bootstrap',"
        "                                DynaLoader::dl_find_symbol_anywhere("
        "                                                             'boot_' . $symbol"
        "                                )"
        "    );"
        "    $package->bootstrap();"
        "    $package->import();"
        "}", TRUE );
    reboot();
