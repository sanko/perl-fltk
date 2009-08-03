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
    WidgetSubclass( char * cls, int x, int y, int w, int h, const char *l = 0 )
            : X( x, y, w, h, l ) {
        _class = cls;
    };
    ~WidgetSubclass() {
        delete _class;
    }
    int handle( int event ) {
        int handled = 1; // safe to assume for now
        dSP;
        I32 ax;
        ENTER;
        SAVETMPS;
        PUSHMARK( SP );
        SV * widget = sv_newmortal();
        sv_setref_pv( widget, _class, ( void* ) this ); // XXX - scalar value won't match parent...
        XPUSHs( widget );
        XPUSHs( sv_2mortal( newSViv( event ) ) );
        PUTBACK;
        int count = call_method( "handle", G_EVAL | G_SCALAR );
        SPAGAIN;
        SP -= count;
        ax = ( SP - PL_stack_base ) + 1;
        if ( ( SvTRUE( ERRSV ) ) || ( count != 1 ) || ( !SvOK( ST( 0 ) ) ) )
            handled = 0;
        else
            handled = SvIV( ST( 0 ) );
        PUTBACK;
        FREETMPS;
        LEAVE;
        return handled ? handled : this->X::handle( event );
    };
private:
    char * _class;
};
}

#endif // #ifndef fltk_WidgetSubclass_h
