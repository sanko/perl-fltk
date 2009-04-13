#ifndef _HAVE_SUBCLASS_GLWINDOW_H_
#define _HAVE_SUBCLASS_GLWINDOW_H_ 1

#include <fltk/GlWindow.h>
#include <fltk/gl.h>

class GlWindow : public fltk::GlWindow {
    public:
        GlWindow(int x,int y,int w,int h,const char *l=0)
            : fltk::GlWindow(x,y,w,h,l) { ; }
        void draw ( ) { }
    private:
};

#endif // _HAVE_SUBCLASS_GLWINDOW_H_


/*

=pod

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

CPAN ID: SANKO

=head1 License and Legal

Copyright (C) 2009 by Sanko Robinson E<lt>sanko@cpan.orgE<gt>

This program is free software; you can redistribute it and/or modify
it under the terms of The Artistic License 2.0.  See the F<LICENSE>
file included with this distribution or
http://www.perlfoundation.org/artistic_license_2_0.  For
clarification, see http://www.perlfoundation.org/artistic_2_0_notes.

When separated from the distribution, all POD documentation is covered
by the Creative Commons Attribution-Share Alike 3.0 License.  See
http://creativecommons.org/licenses/by-sa/3.0/us/legalcode.  For
clarification, see http://creativecommons.org/licenses/by-sa/3.0/us/.

=for git $Id$

*/
