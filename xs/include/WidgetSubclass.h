#ifndef fltk_WidgetSubclass_h
#define fltk_WidgetSubclass_h

/*

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Cheap (as in 'shoddy') Widget subclassing

=for seealso xs/Subclass.xsi

=for git $Id$

=cut

*/

#ifndef fltk_Widget_h
#include "Widget.h" // Minimum.
#endif

template< class X >
class FL_API WidgetSubclass : public X {
public:
    WidgetSubclass( char * cls, int x, int y, int w, int h, const char * lbl )
            : X( x, y, w, h, lbl ) { // Just about everything
        _class = cls;
    };
    WidgetSubclass( char * cls, int x, int y, int w, int h, const char * lbl,
                    uchar nbr, bool v, fltk::Flags a, uchar dw, uchar dh )
            : X( x, y, w, h, lbl, nbr, v, a, dw, dh ) { // AlignGroup
        _class = cls;
    };
    WidgetSubclass( char * cls, int x, int y, int w, int h, int defsize )
            : X( x, y, w, h, defsize ) { // AnsiWidget
        _class = cls;
    };
    WidgetSubclass( char * cls, int x, int y, int w, int h, const char * lbl,
                    bool begin )
            : X( x, y, w, h, lbl, begin ) { // Group
        _class = cls;
    };
    WidgetSubclass( char * cls, char * name, int dx, int dy, int dw, int dh,
                    char * pattern, fltk::Box * down )
            : X( name, dx, dy, dw, dh, pattern, down ) { // FrameBox
        _class = cls;
    };
    WidgetSubclass( char * cls, fltk::Box * box, int x, int y, int w, int h,
                    const char * lbl )
            : X( box, x, y, w, h, lbl ) { // InvisibleBox
        _class = cls;
    };
    WidgetSubclass( char * cls, const char* label, int shortcut,
                    fltk::Callback * callback, void * user_data_,
                    fltk::Flags flags )
            : X( label, shortcut, callback, user_data_, flags ) { // Item
        _class = cls;
    }
    WidgetSubclass ( char * cls, int w, int h, char * label )
            : X( w, h, label ) { // Window
        _class = cls;
    }
    WidgetSubclass( char * cls, int x, int y, int w, int h )
            : X( x, y, w, h ) { // ccCellBox, ccValueBox, ccHueBox
        _class = cls;
    };
    WidgetSubclass ( char * cls, char * label, fltk::Symbol * symbol,
                     bool begin )
            : X( label, symbol, begin ) { // ItemGroup
        _class = cls;
    }
    WidgetSubclass( char * cls, char * name, fltk::Box * down )
            : X( name, down ) { // HighlightBox
        _class = cls;
    };
    WidgetSubclass ( char * cls, char * label, bool begin )
            : X( label, begin ) { // ItemGroup
        _class = cls;
    }
    WidgetSubclass ( char * cls, char * name )
            : X( name ) { // FlatBox
        _class = cls;
    }
    WidgetSubclass ( char * cls )
            : X( ) { // Divider
        _class = cls;
    }

    ~WidgetSubclass() {
        delete _class;
        this->~X( );
    }
    int handle( int event ) {
        int handled = 1; /* safe to assume for now */
        AV * args = newAV();
        av_push( args, sv_2mortal( newSViv( event ) ) );
        handled = _call_method( "handle", args );
        if ( handled != 1 )
            handled = this->X::handle( event );
        return handled;
    };
    int handle( int event, fltk::Rectangle rect ) { // fltk::Input
        int handled = 1; /* safe to assume for now */
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
        AV * args = newAV();
        handled = _call_method( "draw", args );
        if ( handled != 1 )
            this->X::draw( );
    };
    void draw ( int glyph_width ) {  // For fltk::Button
        int handled = 1; /* safe to assume for now */
        AV * args = newAV();
        av_push( args, sv_2mortal( newSViv( glyph_width ) ) );
        handled = _call_method( "draw", args );
        if ( handled != 1 )
            this->X::draw( glyph_width );
    };
    void draw( fltk::Rectangle * sr ) { // fltk::Input
        int handled = 1; /* safe to assume for now */
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
        AV * args = newAV();
        handled = _call_method( "draw_overlay", args );
        if ( handled != 1 )
            this->X::draw_overlay( );
        return;
    };
private:
    char * _class;
protected:
    int _call_method ( const char * method, AV * args ) {
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
#endif // #ifndef fltk_WidgetSubclass_h
