#ifndef fltk_TabGroupPagerSubclass_h
#define fltk_TabGroupPagerSubclass_h

/*

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Cheap (as in 'shoddy') TabGroupPager subclassing

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

#ifndef fltk_TabGroup_h
#include <fltk/TabGroup.h> // Minimum.
#endif

template< class X >
class FL_API TabGroupPagerSubclass : public WidgetSubclass< X > {
public:
    TabGroupPagerSubclass( char * cls ) : X( ) { bless_class( cls ); };
    //~TabGroupPagerSubclass( ) {
    //    this->~X( );
    //}

    int which ( fltk::TabGroup * group, int event_x, int event_y ) { };
    const char * mode_name( ) const { };
    int id ( ) const {
        int handled = 1; /* safe to assume for now */
        dTHX;
        AV * args = newAV();
        handled = _call_method( "handle_release", args );
        if ( handled != 1 )
            this->X::handle_release( );
        return;
    };
    fltk::TabGroupPager * clone( ) const { };

    /*

template<>
int TabGroupPagerSubclass<fltk::TabGroupPager>::which ( fltk::TabGroup * group, int event_x, int event_y ) {
        int handled = 1; /* safe to assume for now * /
        dTHX;
        AV * args = newAV();
        SV * sv_group = sv_newmortal();
        sv_setref_pv( sv_group, "FLTK::TabGroup", ( void * ) group ); // XXX - May be a subclass
        av_push( args, sv_2mortal( newSViv( event_x ) ) );
        av_push( args, sv_2mortal( newSViv( event_y ) ) );
        handled = _call_method( "which", args );
        return handled; // XXX - Should return -1?
        /*
        int H = g->tab_height();
        if (!H) return -1;
        if (H < 0) {
          if (event_y > g->h() || event_y < g->h()+H) return -1;
        } else {
          if (event_y > H || event_y < 0) return -1;
        }
        if (event_x < 0) return -1;
        int p[128], w[128];
        int selected = g->tab_positions(p, w);
        int d = (event_y-(H>=0?0:g->h()))*slope()/H;
        for (int i=0; i<g->children(); i++) {
          if (event_x < p[i+1]+(i<selected ? slope() - d : d)) return i;
        }
        return -1;
        * /
    };

template<>
fltk::TabGroupPager * TabGroupPagerSubclass<fltk::TabGroupPager>::clone( ) const {
        return new TabGroupPagerSubclass<fltk::TabGroupPager>( * this );
    };


template<>
const char * TabGroupPagerSubclass<fltk::TabGroupPager>::mode_name ( ) const {
        return "Shrink";
    }; // TabGroupPager



template<>
int TabGroupPagerSubclass<fltk::TabGroupPager>::id ( ) const {
        return 128;
    }; // TabGroupPager
*/
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
#endif // #ifndef fltk_TabGroupPagerSubclass_h

#ifndef fltk_TabGroupPagerSubclass_h
#define fltk_TabGroupPagerSubclass_h

/*

=pod

=for license Artistic License 2.0 |Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract pure virtual function Subclass of TabGroupPager

=for seealso xs/TabGroupPager.xsi

=for seealso xs/include/TabGroupPagerSubclass.h

=for git $Id$

=cut

*/

#ifndef fltk_TabGroup_h
#include <fltk/TabGroup.h> // Minimum.
#endif

//template<>
//void TabGroupPagerSubclass<fltk::TabGroupPager>::draw ( ) {
//	int handled = 1; /* safe to assume for now */
//	dTHX;
//	AV * args = newAV();
//	handled = _call_method( "draw", args );
//	/* GlWindow::draw( ) is a pure virtual function */
//}





#endif // #ifndef fltk_TabGroupPagerSubclass_h





