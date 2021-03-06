#include "include/FLTK_pm.h"

MODULE = FLTK::ask               PACKAGE = FLTK::ask

#ifndef DISABLE_ASK

=pod

=for license Artistic License 2.0 | Copyright (C) 2009-2011 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.532006

=for git $Id$

=head1 NAME

FLTK::ask - Implementation of message, ask, choice, and input functions

=head1 Description

Implementation of L<C<FLTK::message()>|FLTK::ask/"message">,
L<C<FLTK::ask(...)>|FLTK::ask/"ask">,
L<C<FLTK::choice(...)>|FLTK::ask/"choice">,
L<C<FLTK::input()>|FLTK::ask/"input">.

=begin apidoc

=cut

#include <fltk/ask.h>

=for apidoc T[dialog]E||int beep|BEEP_DEFAULT|



=for apidoc T[dialog]E||int beep|BEEP_MESSAGE|



=for apidoc T[dialog]E||int beep|BEEP_ERROR|



=for apidoc T[dialog]E||int beep|BEEP_QUESTION|



=for apidoc T[dialog]E||int beep|BEEP_PASSWORD|



=for apidoc T[dialog]E||int beep|BEEP_NOTIFICATION|



=cut

BOOT:
    register_constant("BEEP_DEFAULT", newSViv( fltk::BEEP_DEFAULT ));
    export_tag("BEEP_DEFAULT", "dialog");
    register_constant("BEEP_MESSAGE", newSViv( fltk::BEEP_MESSAGE ));
    export_tag("BEEP_MESSAGE", "dialog");
    register_constant("BEEP_ERROR", newSViv( fltk::BEEP_ERROR ));
    export_tag("BEEP_ERROR", "dialog");
    register_constant("BEEP_QUESTION", newSViv( fltk::BEEP_QUESTION ));
    export_tag("BEEP_QUESTION", "dialog");
    register_constant("BEEP_PASSWORD", newSViv( fltk::BEEP_PASSWORD ));
    export_tag("BEEP_PASSWORD", "dialog");
    register_constant("BEEP_NOTIFICATION", newSViv( fltk::BEEP_NOTIFICATION ));
    export_tag("BEEP_NOTIFICATION", "dialog");

=for apidoc T[dialog,default]F|||message|char * string|

Displays a message in a pop-up box with an "OK" button, waits for the user to
hit the button. The message will wrap to fit the window, or may be many lines
by putting C<\n> characters into it. The enter key is a shortcut for the OK
button.

=for apidoc T[dialog,default]F|||alert|char * string|

Same as L<C<FLTK::message()>|/"message"> except for the "!" symbol.

=cut

MODULE = FLTK::ask               PACKAGE = FLTK

void
message( char * string )
    CODE:
        fltk::alert( string );

BOOT:
    export_tag("message", "dialog");
    export_tag("message", "default");

void
alert( char * string )
    CODE:
        fltk::alert( string );

BOOT:
    export_tag("alert", "dialog");
    export_tag("alert", "default");

MODULE = FLTK::ask               PACKAGE = FLTK::ask

=for apidoc T[dialog]F||int choice|ask|char * question|

Displays a message in a pop-up box with a "Yes" and "No" button and waits for
the user to hit a button. The return value is C<1> if the user hits "Yes",
C<0> if they pick "No". The C<Enter> key is a shortcut for "Yes" and C<ESC> is
a shortcut for "No".

If L<C<message_window_timeout>|/"message_window_timeout"> is used, then C<-1>
will be returned if the timeout expires.

=cut

MODULE = FLTK::ask               PACKAGE = FLTK

int
ask( char * question )
    CODE:
        RETVAL = fltk::ask( question );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("ask", "dialog");
    export_tag("ask", "default");

MODULE = FLTK::ask               PACKAGE = FLTK::ask

=for apidoc T[dialog,default]F||int choice|choice|char * question|char * answer_1|char * answer_2|char * answer_3|

Shows the message with three buttons below it marked with the strings
C<answer_1>, C<answer_2>, and C<answer_3>. Returns C<0>, C<1>, or C<2>
depending on which button is hit. If one of the strings begins with the
special character '*' then the associated button will be the default which is
selected when the C<Enter> key is pressed. C<ESC> is a shortcut for
C<answer_1>.

If L<C<message_window_timeout>|/"message_window_timeout"> is used, then C<-1>
will be returned if the timeout expires.

=for apidoc T[dialog,default]F||int choice|choice_alert|char * question|char * question|char * answer_1|char * answer_2|char * answer_3|

Same as L<C<choice()>|/"choice"> except a "!" icon is used instead of a "?"

=cut

MODULE = FLTK::ask               PACKAGE = FLTK

int
choice( char * question, char * answer_1, char * answer_2, char * answer_3)
    CODE:
        int a = fltk::choice(question, answer_3, answer_2, answer_1);
        RETVAL = a == 0 ? 2 : a == 2 ? 0 : a;
    OUTPUT:
        RETVAL

int
choice_alert( char * question, char * answer_1, char * answer_2, char * answer_3)
    CODE:
        int a = fltk::choice_alert(question, answer_3, answer_2, answer_1);
        RETVAL = a == 0 ? 2 : a == 2 ? 0 : a;
    OUTPUT:
        RETVAL

BOOT:
    export_tag("choice", "dialog");
    export_tag("choice", "default");
    export_tag("choice_alert", "dialog");
    export_tag("choice_alert", "default");

MODULE = FLTK::ask               PACKAGE = FLTK::ask

=for apidoc T[dialog,default]F||char * string|input|char * label|char * default_value = ''|

Pops up a window displaying a string, lets the user edit it, and return the
new value. The cancel button returns C<undef>. The returned pointer is only
valid until the next time L<C<FLTK::input()>|FLTK::ask/"input"> is called.

If L<C<message_window_timeout>|/"message_window_timeout"> is used, then C<0>
will be returned if the timeout expires.

=for apidoc T[dialog,default]Fx||char * string|password|char * label|char * default_value = ''|

Same as L<C<FLTK::input()>|FLTK::ask/"input"> except an
L<FLTK::SecretInput|FLTK::SecretInput> field is used.

=cut

MODULE = FLTK::ask               PACKAGE = FLTK

const char *
input( char * label, char * default_value = 0 )
    CODE:
        RETVAL = fltk::input( label, default_value );
    OUTPUT:
        RETVAL

const char *
password( char * label, char * default_value = 0 )
    CODE:
        RETVAL = fltk::input( label, default_value );
    OUTPUT:
        RETVAL

BOOT:
    export_tag("input", "dialog");
    export_tag("input", "default");
    export_tag("password", "dialog");
    export_tag("password", "default");

MODULE = FLTK::ask               PACKAGE = FLTK::ask

=for apidoc T[dialog,default]F|||beep|int type = FLTK::ask::BEEP_DEFAULT|

Generates a simple beep message.

=cut

MODULE = FLTK::ask               PACKAGE = FLTK

void
beep( int type = fltk::BEEP_DEFAULT )
    CODE:
        fltk::beep( type );

BOOT:
    export_tag("beep", "dialog");
    export_tag("beep", "default");

MODULE = FLTK::ask               PACKAGE = FLTK::ask

=for apidoc T[dialog]F|||beep_on_dialog|bool value

You can enable beep on default message dialog (like L<C<ask>|/"dialog">,
L<C<choice>|/"choice">, L<C<input>|/"input">, ...) by using this function with
true (default is false).

=for apidoc T[dialog]F||bool value|beep_on_dialog||

You get the state enable beep on default message dialog (like
L<C<ask>|/"dialog">, L<C<choice>|/"choice">, L<C<input>|/"input">, ...) by using
this function with true (default is false).

=cut

MODULE = FLTK::ask               PACKAGE = FLTK

bool
beep_on_dialog( bool value = NO_INIT )
    CASE: items == 1
        CODE:
            fltk::beep_on_dialog( value );
    CASE:
        CODE:
            RETVAL = fltk::beep_on_dialog( );
        OUTPUT:
            RETVAL

BOOT:
    export_tag("beep_on_dialog", "dialog");

MODULE = FLTK::ask               PACKAGE = FLTK::ask

=for apidoc T[dialog]F||FLTK::NamedStyle style|icon_style||

This L<Style|FLTK::Style> is used for the C<50x50> icon area on the left of
all the popup windows. You can change the colors or font used here.

=for apidoc T[dialog]F|||icon_style|FLTK::NamedStyle style|

Set the icon style.

=for apidoc T[dialog]F||FLTK::NamedStyle style|message_style||

This L<Style|FLTK::Style> is used for the label area for all the popup
windows. You can change the L<C<textfont()>|FLTK::Style/"textfont"> or
L<C<textsize()>|FLTK::Style/"textsize"> to make them print differently.

=for apidoc T[dialog]F|||message_style|FLTK::NamedStyle style|

Set the message style.

=cut

MODULE = FLTK::ask               PACKAGE = FLTK

fltk::NamedStyle *
icon_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            fltk::icon_style = style;
        OUTPUT:
    CASE:
        CODE:
            RETVAL = fltk::icon_style;
        OUTPUT:
            RETVAL

fltk::NamedStyle *
message_style( fltk::NamedStyle * style = NO_INIT )
    CASE: items == 1
        CODE:
            fltk::message_style = style;
        OUTPUT:
    CASE:
        CODE:
            RETVAL = fltk::message_style;
        OUTPUT:
            RETVAL

BOOT:
    export_tag("icon_style", "dialog");
    export_tag("message_style", "dialog");

MODULE = FLTK::ask               PACKAGE = FLTK::ask

=end apidoc

=head1 Variables

There are a few variables you my change that affect how L<FLTK|FLTK> behaves.

=over

=item * C<$FLTK::message_window_label>

The value of this is used as the title of L<C<message()>|FLTK::ask/"message">,
L<C<alert()>|FLTK::ask/"alert">, L<C<ask()>|FLTK::ask/"dialog">,
L<C<choice()>|FLTK::ask/"choice">, etc. windows.

=item * C<$FLTK::no>

You can change this string to convert L<FLTK|FLTK> to a foreign language.

=item * C<$FLTK::yes>

You can change this string to convert L<FLTK|FLTK> to a foreign language.

=item * C<$FLTK::ok>

You can change this string to convert L<FLTK|FLTK> to a foreign language.

=item * C<$FLTK::cancel>

You can change this string to convert L<FLTK|FLTK> to a foreign language.

=cut

BOOT:
    magic_ptr_init( "FLTK::message_window_label",
                                    &fltk::message_window_label );
    export_tag("$message_window_label", "vars");
    magic_ptr_init( "FLTK::yes",    &fltk::yes );
    export_tag("$yes", "vars");
    magic_ptr_init( "FLTK::no",     &fltk::no );
    export_tag("$no", "vars");
    magic_ptr_init( "FLTK::ok",     &fltk::ok );
    export_tag("$ok", "vars");
    magic_ptr_init( "FLTK::cancel", &fltk::cancel );
    export_tag("$cancel", "vars");

=item * C<$FLTK::message_window_timeout>

Set this to a positive value to cause the L<C<message()>|FLTK::ask/"message">,
L<C<alert()>|FLTK::ask/"alert">, L<C<ask()>|FLTK::ask/"dialog">,
L<C<choice()>|FLTK::ask/"choice">, etc. windows to close automatically after
this timeout. If the timeout expires, C<-1> will be returned by the functions
that return integers. The timeout value is a float in seconds.

=cut

BOOT:
    magic_ptr_init( "FLTK::message_window_timeout",
                    &fltk::message_window_timeout );
    export_tag("$message_window_timeout", "vars");

=item * C<$FLTK::message_window_scrollable>

When this is set to true, then (all) message windows will use scrollbars if
the given message is too long.

=back

=cut

BOOT:
    magic_ptr_init( "FLTK::message_window_scrollable",
                    &fltk::message_window_scrollable );
    export_tag("$message_window_scrollable", "vars");

#endif // ifndef DISABLE_ASK
