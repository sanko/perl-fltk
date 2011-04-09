#ifndef fltk_RectangleSubclass_h
#define fltk_RectangleSubclass_h

/*

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Cheap (as in 'shoddy') Rectangle subclassing

=for seealso xs/Subclass.xsi

=for git $Id$

=cut

*/

#define PERL_NO_GET_CONTEXT 1
#include <EXTERN.h>
#include <perl.h>
#define NO_XSLOCKS // XSUB.h will otherwise override various things we need
#include <XSUB.h>
#define NEED_sv_2pv_flags
#include "ppport.h"

#ifndef fltk_Rectangle_h
#include <fltk/Rectangle.h> // Minimum.
#endif

#ifndef fltk_TabGroup_h
#include "fltk/TabGroup.h" // For TabGroupPager
#endif

template< class X >
class FL_API RectangleSubclass : public X {
public:
    RectangleSubclass( char * cls, int x, int y, int w, int h, const char * lbl )
            : X( x, y, w, h, lbl ) { // Just about everything
        bless_class( cls );
    };
    RectangleSubclass( char * cls, int x, int y, int w, int h, const char * lbl,
                    uchar nbr, bool v, fltk::Flags a, uchar dw, uchar dh )
            : X( x, y, w, h, lbl, nbr, v, a, dw, dh ) { // AlignGroup
        bless_class( cls );
    };
    RectangleSubclass( char * cls, int x, int y, int w, int h, int defsize )
            : X( x, y, w, h, defsize ) { // AnsiRectangle
        bless_class( cls );
    };
    RectangleSubclass( char * cls, int x, int y, int w, int h, const char * lbl,
                    bool begin )
            : X( x, y, w, h, lbl, begin ) { // Group
        bless_class( cls );
    };
    RectangleSubclass( char * cls, char * name, int dx, int dy, int dw, int dh,
                    char * pattern, fltk::Box * down )
            : X( name, dx, dy, dw, dh, pattern, down ) { // FrameBox
        bless_class( cls );
    };
    RectangleSubclass( char * cls, fltk::Box * box, int x, int y, int w, int h,
                    const char * lbl )
            : X( box, x, y, w, h, lbl ) { // InvisibleBox
        bless_class( cls );
    };
    RectangleSubclass( char * cls, const char* label, int shortcut,
                    fltk::Callback * callback, void * user_data_,
                    fltk::Flags flags )
            : X( label, shortcut, callback, user_data_, flags ) { // Item
        bless_class( cls );
    }
    RectangleSubclass( char * cls, X original, int w, int h, int flags = 0 )
            : X( original, w, h, flags ) { // Rectangle (clone constructor)
        bless_class( cls );
    };
    RectangleSubclass( char * cls, int w, int h, char * label )
            : X( w, h, label ) { // Window
        bless_class( cls );
    }
    RectangleSubclass( char * cls, int x, int y, int w, int h )
            : X( x, y, w, h ) { // ccCellBox, ccValueBox, ccHueBox
        bless_class( cls );
    };
    RectangleSubclass( char * cls, char * label, fltk::Symbol * symbol,
                    bool begin )
            : X( label, symbol, begin ) { // ItemGroup
        bless_class( cls );
    }
    RectangleSubclass( char * cls, char * name, fltk::Box * down )
            : X( name, down ) { // HighlightBox
        bless_class( cls );
    };
    RectangleSubclass( char * cls, char * label, bool begin )
            : X( label, begin ) { // ItemGroup
        bless_class( cls );
    }
    RectangleSubclass( char * cls, int w, int h )
            : X( w, h ) { // Rectangle
        bless_class( cls );
    };
    RectangleSubclass( char * cls, char * name )
            : X( name ) { // FlatBox
        bless_class( cls );
    }
    RectangleSubclass( char * cls, X original )
            : X( original ) { // Rectangle (clone constructor)
        bless_class( cls );
    };
    RectangleSubclass( char * cls, int h )
            : X( h ) { // StatusBarGroup
        bless_class( cls );
    }
    RectangleSubclass( char * cls )
            : X( ) { // Divider, TabGroupPager
        bless_class( cls );
    }
    //~RectangleSubclass( ) {
    //    this->~X( );
    //}
    int handle( int event ) {
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        av_push( args, sv_2mortal( newSViv( event ) ) );
        handled = _call_method( "handle", args );
        if ( handled != 1 )
            handled = this->X::handle( event );
        return handled;
    };
    int handle( int event, fltk::Rectangle rect ) { // fltk::Input
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        av_push( args, sv_2mortal( newSViv( event ) ) );
        SV * sv_rect = sv_newmortal();
        sv_setref_pv( sv_rect, "FLTK::Rectangle", ( void * ) rect );
        av_push( args, sv_2mortal( newSViv( sv_rect ) ) );
        handled = _call_method( "handle", args );
        if ( handled != 1 )
            handled = this->X::handle( event );
        return handled;
    };
    void draw ( ) { // Just about everything supports this one
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "draw", args );
        if ( handled != 1 )
            this->X::draw( );
    };
    void draw ( int glyph_width ) {  // For fltk::Button
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        av_push( args, sv_2mortal( newSViv( glyph_width ) ) );
        handled = _call_method( "draw", args );
        if ( handled != 1 )
            this->X::draw( glyph_width );
    };
    void draw( fltk::Rectangle * sr ) { // fltk::Input
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        SV * sv_rect = sv_newmortal();
        sv_setref_pv( sv_rect, "FLTK::Rectangle", ( void * ) sr );
        av_push( args, sv_2mortal( newSViv( sv_rect ) ) );
        handled = _call_method( "draw", args );
        if ( handled != 1 )
            this->X::draw( sr );
    };
    void draw( fltk::Rectangle * sr, fltk::Flags flags, bool slot ) { // fltk::Slider
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        SV * sv_rect = sv_newmortal();
        sv_setref_pv( sv_rect, "FLTK::Rectangle", ( void * ) sr );
        av_push( args, sv_2mortal( newSViv( sv_rect ) ) );
        av_push( args, sv_2mortal( newSViv( flags ) ) );
        av_push( args, sv_2mortal( newSViv( slot ) ) );
        handled = _call_method( "draw", args );
        if ( handled != 1 )
            this->X::draw( sr, flags, slot );
    };
    void draw_overlay( ) { // fltk::GlWindow
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "draw_overlay", args );
        if ( handled != 1 )
            this->X::draw_overlay( );
        return;
    };
    void create( ) { // fltk::MenuWindow
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "create", args );
        if ( handled != 1 )
            this->X::create( );
        return;
    };
    void flush( ) { // fltk::MenuWindow
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "flush", args );
        if ( handled != 1 )
            this->X::flush( );
        return;
    };
    int format( const char * buffer ) { // fltk::Valuator
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        av_push( args, sv_2mortal( newSVpv( buffer, strlen( buffer ) ) ) );
        handled = _call_method( "format", args );
        if ( handled != 1 )
            handled = this->X::format( buffer );
        return handled;
    };
    void value_damage ( ) { // fltk::Valuator
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "value_damage", args );
        if ( handled != 1 )
            this->X::value_damage( );
        return;
    };
    void handle_push ( ) { // fltk::Valuator
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "handle_push", args );
        if ( handled != 1 )
            this->X::handle_push( );
        return;
    };
    void handle_drag ( double value ) { // fltk::Valuator
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        av_push( args, sv_2mortal( newSVnv( value ) ) );
        handled = _call_method( "handle_drag", args );
        if ( handled != 1 )
            this->X::handle_drag( value );
        return;
    };
    void handle_release ( ) { // fltk::Valuator
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "handle_release", args );
        if ( handled != 1 )
            this->X::handle_release( );
        return;
    };

    // TabGroupPager
    int which ( fltk::TabGroup * group, int event_x, int event_y ) { };
    const char * mode_name( ) const { };
    int id ( ) const { };
    fltk::TabGroupPager * clone( ) const { };
public:
    char * _class;
    int    _okay;
    const char * bless_class( ) {
        return _okay == 1337 ? _class : 0;
    };
private:
    void bless_class ( char * cls ) {
        _class = cls;
        _okay = 1337;
    };
protected:
    int _call_method ( const char * method, AV * args ) {
        dTHX;
        int retval = 0;
        HV * pkg = gv_stashpv( _class, 0 );
        GV * gv  = gv_fetchmethod_autoload( pkg, method, FALSE );
        if ( !( gv && isGV( gv ) ) )
            return retval;
        dSP;
        I32 ax;
        ENTER;
        SAVETMPS;
        PUSHMARK( SP );
        SV * sv_self = sv_newmortal();
        sv_setref_pv( sv_self, _class, ( void * ) this );
        XPUSHs( sv_self );
        for ( int i = av_len( args ); i >= 0; i-- )
            XPUSHs( av_shift( args )   );
        PUTBACK;
        int count = call_method( method, G_KEEPERR | G_EVAL | G_SCALAR );
        SPAGAIN;
        SP -= count;
        ax = ( SP - PL_stack_base ) + 1;
        if ( ( SvTRUE( ERRSV ) ) || ( count != 1 ) || ( !SvOK( ST( 0 ) ) ) )
            retval = 0;
        else
            retval = SvIV( ST( 0 ) );
        PUTBACK;
        FREETMPS;
        LEAVE;
        return retval;
    };
};

#endif // #ifndef fltk_RectangleSubclass_h
