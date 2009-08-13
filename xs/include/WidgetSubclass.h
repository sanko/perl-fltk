#ifndef fltk_WidgetSubclass_h
#define fltk_WidgetSubclass_h

/*

=pod

=for license Artistic License 2.0 |Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Cheap (as in 'shoddy') Widget subclassing

=for seealso xs/Subclass.xsi

=for git $Id$

=cut

*/

#ifndef fltk_Widget_h
#include "Widget.h" // Minimum.
#endif

namespace fltk {
template< class X >
class FL_API WidgetSubclass : public X {
public:
    WidgetSubclass( char * cls, int x, int y, int w, int h, const char * lbl )
            : X( x, y, w, h, lbl ) { // Just about everything
        _class = cls;
    };
    WidgetSubclass( char * cls, int x, int y, int w, int h, const char * lbl,
                    uchar nbr, bool v, Flags a, uchar dw, uchar dh )
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
                    char * pattern, Box * down )
            : X( name, dx, dy, dw, dh, pattern, down ) { // FrameBox
        _class = cls;
    };
    WidgetSubclass ( char * cls, int w, int h, char * label )
            : X( w, h, label ) { // Window
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
            handled = X::handle( event );
        return handled;
    };
    void draw ( ) { // Just about everything supports this one
        int handled = 1; /* safe to assume for now */
        AV * args = newAV();
        av_push( args, sv_2mortal( newSViv( 52 ) ) );
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
    void draw( fltk::Rectangle * sr, Flags flags, bool slot ) { // fltk::Slider
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
private:
    char * _class;
    int _call_method ( char * method, AV * args ) {
        int retval;
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
}
#endif // #ifndef fltk_WidgetSubclass_h
