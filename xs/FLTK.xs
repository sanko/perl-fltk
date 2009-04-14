#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>
#include "./ppport.pl"

#define ALLOW_CALLBACKS  1
#define ALLOW_DESTROY    1 // Introduce pointless bugs :D
#define ALLOW_DEPRECATED 1 // Depreciated widgets, etc.

=for apidoc H|||cb_w|fltk::Widget|CODE

This is the function called by FLTK whenever callbacks are triggered. See
L<FLTK::Widget::callback()>.

=cut

#include <fltk/Widget.h>
void cb_w (fltk::Widget * WIDGET, void * CODE) {
#if ALLOW_CALLBACKS
    AV *cbargs = (AV *)CODE;
    I32 alen = av_len(cbargs);
    CV *thecb = (CV *)SvRV(*av_fetch(cbargs, 0, 0));
    dSP;
    ENTER;
        SAVETMPS;
            PUSHMARK(sp);
    for(int i = 1; i <= alen; i++) { XPUSHs(*av_fetch(cbargs, i, 0)); }
            PUTBACK;
    call_sv((SV*)thecb, G_DISCARD);
        FREETMPS;
    LEAVE;
#else
    warn( "Callbacks have been disabled. ¬.¬ " );
#endif
}


/* Alright, let's get things started, shall we? */
MODULE = FLTK               PACKAGE = FLTK

INCLUDE: perl ../Build define |

INCLUDE: Adjuster.xsi

INCLUDE: AssociationFunctor.xsi

INCLUDE: AssociationType.xsi

#ifdef NORMAL /* NORMAL is carelessly redefined in fltk/Browser.h */
#define PERL_NORMAL NORMAL
#undef NORMAL
#endif

INCLUDE: Browser.xsi

#ifdef PERL_NORMAL /* Reverse the hack */
#undef NORMAL
#define NORMAL PERL_NORMAL
#undef PERL_NORMAL
#endif

INCLUDE: Button.xsi

INCLUDE: CheckButton.xsi

INCLUDE: Choice.xsi

INCLUDE: Clock.xsi

INCLUDE: ClockOutput.xsi

INCLUDE: CreatedWindow.xsi

INCLUDE: CycleButton.xsi

INCLUDE: Dial.xsi

INCLUDE: Divider.xsi

INCLUDE: FillDial.xsi

INCLUDE: FillSlider.xsi

INCLUDE: FlatBox.xsi

INCLUDE: FloatInput.xsi

INCLUDE: Font.xsi

INCLUDE: FrameBox.xsi

INCLUDE: gifImage.xsi

#ifdef ENTER
#define PERL_ENTER ENTER
#undef ENTER
#endif /* ifdef ENTER */

#ifdef LEAVE
#define PERL_LEAVE LEAVE
#undef LEAVE
#endif /* ifdef LEAVE */

INCLUDE: GlutWindow.xsi

INCLUDE: GlWindow.xsi

#ifdef PERL_ENTER
#undef ENTER
#define ENTER PERL_ENTER
#undef PERL_ENTER
#endif /* ifdef PERL_ENTER */

#ifdef PERL_LEAVE
#undef LEAVE
#define LEAVE PERL_LEAVE
#undef PERL_LEAVE
#endif /* ifdef PERL_LEAVE */

INCLUDE: Group.xsi

INCLUDE: GSave.xsi

INCLUDE: Guard.xsi

INCLUDE: HighlightBox.xsi

INCLUDE: HighlightButton.xsi

INCLUDE: Image.xsi

INCLUDE: ImageType.xsi

INCLUDE: Input.xsi

INCLUDE: IntInput.xsi

INCLUDE: InvisibleBox.xsi

INCLUDE: Item.xsi

INCLUDE: ItemGroup.xsi

INCLUDE: LightButton.xsi

INCLUDE: LineDial.xsi

INCLUDE: List.xsi

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

=for git $Id: FLTK.xs 9b2bc67 2009-04-14 02:18:15Z sanko@cpan.org $ for got=

=cut
