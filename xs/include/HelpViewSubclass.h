#ifndef fltk_HelpViewSubclass_h
#define fltk_HelpViewSubclass_h

/*

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Cheap (as in 'shoddy') HelpView subclassing

=for seealso xs/Subclass.xsi

=for frak's sake... who defined HelpView::handle(int) and HelpView::draw()
private? It's the only widget where they are defined as such.

=for git $Id$

=cut

*/

#ifndef fltk_HelpView_h
#include <fltk/HelpView.h> // Minimum.
#endif

class FL_API HelpViewSubclass : public fltk::HelpView {
public:
    HelpViewSubclass( char * cls, int x, int y, int w, int h, const char * lbl )
            : fltk::HelpView( x, y, w, h, lbl ) { // Just about everything
        _class = cls;
    };
    ~HelpViewSubclass( ) {
        delete _class;
        this->~HelpView( );
    }
private:
    int handle( int event ) {
        int handled = 1; /* safe to assume for now */
        AV * args = newAV();
        av_push( args, sv_2mortal( newSViv( event ) ) );
        handled = _call_method( "handle", args );
        return handled;
    };
    void draw ( ) { // Just about everything supports this one
        int handled = 1; /* safe to assume for now */
        AV * args = newAV();
        handled = _call_method( "draw", args );
    };
    char * _class;
protected:
    int _call_method ( const char * method, AV * args ) {
        int retval;
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
#endif // #ifndef fltk_HelpViewSubclass_h
