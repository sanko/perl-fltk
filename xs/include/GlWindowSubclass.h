#ifndef fltk_GlWindowSubclass_h
#define fltk_GlWindowSubclass_h

/*

=pod

=for license Artistic License 2.0 |Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract draw() function Subclass of GlWidget

=for seealso xs/GlWindow.xsi

=for seealso xs/include/WidgetSubclass.h

=for git $Id$

=cut

*/

#ifndef fltk_GlWindow_h
#include <fltk/GlWindow.h> // Minimum.
#endif

#ifndef fltk_WidgetSubclass_h
#include <include/WidgetSubclass.h>
#endif

namespace fltk {
template<>
void WidgetSubclass<GlWindow>::draw ( ) {
    int handled = 1; /* safe to assume for now */
    AV * args = newAV();
    handled = _call_method( "draw", args );
    /* GlWindow::draw( ) is a pure virtual function */
};

}
#endif // #ifndef fltk_GlWindowSubclass_h
