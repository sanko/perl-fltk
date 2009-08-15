#!perl
package FLTK;

=pod

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for abstract Perl interface to the Fast Light Toolkit

=for git $Id$

=cut

use strict;
use warnings;
our $VERSION_BASE = 530; our $UNSTABLE_RELEASE = 1; our $VERSION = sprintf(($UNSTABLE_RELEASE ? '%.3f_%03d' : '%.3f'), $VERSION_BASE / 1000, $UNSTABLE_RELEASE);
use XSLoader;
use vars qw[@EXPORT_OK @EXPORT %EXPORT_TAGS];
use Exporter qw[import];
%EXPORT_TAGS = (
    ask => [
        qw[ BEEP_DEFAULT BEEP_MESSAGE BEEP_ERROR BEEP_QUESTION BEEP_PASSWORD
            BEEP_NOTIFICATION
            alert ask beep beep_on_dialog choice choice_alert input message
            password
            icon_style message_style
            message_window_label message_window_timeout
            message_window_scrollable ]
    ],
    box => [
        qw[ drawframe drawframe2
            NO_BOX
            UP_BOX DOWN_BOX THIN_UP_BOX THIN_DOWN_BOX ENGRAVED_BOX
            EMBOSSED_BOX BORDER_BOX FLAT_BOX HIGHLIGHT_UP_BOX
            HIGHLIGHT_DOWN_BOX ROUND_UP_BOX ROUND_DOWN_BOX DIAMOND_UP_BOX
            DIAMOND_DOWN_BOX SHADOW_BOX ROUNDED_BOX RSHADOW_BOX RFLAT_BOX
            OVAL_BOX OSHADOW_BOX OFLAT_BOX BORDER_FRAME PLASTIC_UP_BOX
            PLASTIC_DOWN_BOX ]
    ],
    clock => [qw[SQUARE ANALOG ROUND DIGITAL]],
    color => [
        qw[ NO_COLOR    FREE_COLOR  NUM_FREE_COLOR  GRAY00  GRAY05  GRAY10
            GRAY15      GRAY20      GRAY25          GRAY30  GRAY33  GRAY35
            GRAY40      GRAY45      GRAY50          GRAY55  GRAY60  GRAY65
            GRAY66      GRAY70      GRAY75          GRAY80  GRAY85  GRAY90
            GRAY95      GRAY99      BLACK           RED     GREEN   YELLOW
            BLUE        MAGENTA     CYAN            WHITE   DARK_RED
            DARK_GREEN  DARK_YELLOW DARK_BLUE       DARK_MAGENTA    DARK_CYAN
            WINDOWS_BLUE
            color   parsecolor  lerp    inactive    contrast split_color
            set_color_index get_color_index set_background nearest_index
            color_chooser ]
    ],
    cursor => [
        qw[ CURSOR_DEFAULT  CURSOR_ARROW    CURSOR_CROSS    CURSOR_WAIT
            CURSOR_INSERT   CURSOR_HAND     CURSOR_HELP     CURSOR_MOVE
            CURSOR_NS       CURSOR_WE       CURSOR_NWSE     CURSOR_NESW
            CURSOR_NO       CURSOR_NONE
            cursor ]
    ],
    damage => [
        qw[ DAMAGE_CHILD DAMAGE_CHILD_LABEL DAMAGE_EXPOSE DAMAGE_ALL
            DAMAGE_VALUE DAMAGE_PUSHED      DAMAGE_SCROLL DAMAGE_OVERLAY
            DAMAGE_HIGHLIGHT                DAMAGE_CONTENTS ]
    ],
    default => [qw[run message alert ask input password %FLTK]],
    dial    => [qw[NORMAL LINE FILL]],
    draw    => [
        qw[ push_matrix pop_matrix scale translate rotate concat load_identity
            transform push_clip clipout pop_clip push_no_clip not_clipped
            intersect_with_clip setcolor setcolor_alpha getcolor drawstyle
            setdrawflags drawflags line_style line_width line_dashes SOLID
            DASH DOT DASHDOT DASHDOTDOT CAP_FLAT CAP_ROUND CAP_SQUARE
            JOIN_MITER JOIN_ROUND JOIN_BEVEL newpath addvertex addvertices
            addvertices_transformed addcurve addarc addpie addchord closepath
            strokepath fillpath fillstrokepath fillrect strokerect drawline
            drowpoint setfont getfont getsize getwidth getdescent
            drawtext_transformed drawtext measure column_widths drawimage
            readimage scrollrect ]
    ],
    events => [
        qw[ NO_EVENT PUSH RELEASE ENTER LEAVE DRAG FOCUS UNFOCUS KEY KEYUP
            FOCUS_CHANGE MOVE SHORTCUT DEACTIVATE ACTIVATE HIDE SHOW PASTE
            TIMEOUT MOUSEWHEEL DND_ENTER DND_DRAG DND_LEAVE DND_RELEASE
            TOOLTIP
            LeftButton MiddleButton RightButton SpaceKey BackSpaceKey TabKey
            ClearKey ReturnKey PauseKey ScrollLockKey EscapeKey HomeKey
            LeftKey UpKey RightKey DownKey PageUpKey PageDownKey EndKey
            PrintKey InsertKey MenuKey HelpKey NumLockKey Keypad KeypadEnter
            MultiplyKey AddKey SubtractKey DecimalKey DivideKey Keypad0
            Keypad1 Keypad2 Keypad3 Keypad4 Keypad5 Keypad6 Keypad7 Keypad8
            Keypad9 KeypadLast F0Key F1Key F2Key F3Key F4Key F5Key F6Key F7Key
            F8Key F9Key F10Key F11Key F12Key LastFunctionKey LeftShiftKey
            RightShiftKey LeftCtrlKey RightCtrlKey CapsLockKey LeftMetaKey
            RightMetaKey LeftAltKey RightAltKey DeleteKey LeftAccKey
            RightAccKey LeftCmdKey RightCmdKey
            SHIFT CAPSLOCK CTRL ALT NUMLOCK META SCROLLLOCK BUTTON1 BUTTON2
            BUTTON3 ANY_BUTTON ACCELERATOR OPTION COMMAND
            BUTTON
            DEVICE_MOUSE DEVICE_STYLUS DEVICE_ERASER DEVICE_CURSOR
            DEVICE_AIRBRUSH DEVICE_TOUCH
            event_x event_y event_dx event_dy event_x_root event_y_root
            event_clicks event_is_click event_state event_key event_button
            event_key_state event_text event_length event_key_repeated
            event_pressure event_x_tilt event_y_tilt event_device event_inside
            compose compose_reset try_shortcut key_name key foreachShortcut
            get_key_state get_mouse warp_mouse handle belowmouse pushed focus
            copy paste dnd modal grab exit_modal exit_modal_flag ]
    ],
    flags => [
        qw[ NO_FLAGS
            ALIGN_TOP ALIGN_BOTTOM ALIGN_LEFT ALIGN_RIGHT ALIGN_CENTER
            ALIGN_INSIDE ALIGN_CLIP ALIGN_WRAP ALIGN_MASK
            ALIGN_POSITIONMASK
            ALIGN_TOPLEFT ALIGN_BOTTOMLEFT ALIGN_TOPRIGHT
            ALIGN_BOTTOMRIGHT ALIGN_CENTERLEFT ALIGN_CENTERRIGHT
            ALIGN_INSIDE_TOP ALIGN_INSIDE_BOTTOM ALIGN_INSIDE_LEFT
            ALIGN_INSIDE_TOPLEFT ALIGN_INSIDE_BOTTOMLEFT
            ALIGN_INSIDE_RIGHT ALIGN_INSIDE_TOPRIGHT
            ALIGN_INSIDE_BOTTOMRIGHT ALIGN_MENU ALIGN_BROWSER
            INACTIVE OUTPUT STATE SELECTED INVISIBLE HIGHLIGHT CHANGED
            COPIED_LABEL RAW_LABEL LAYOUT_VERTICAL TAB_TO_FOCUS
            CLICK_TO_FOCUS INACTIVE_R FOCUSED PUSHED RESIZE_NONE
            RESIZE_FIT RESIZE_FILL OPENED ]
    ],
    font => [
        qw[ HELVETICA HELVETICA_BOLD HELVETICA_ITALIC HELVETICA_BOLD_ITALIC
            COURIER   COURIER_BOLD   COURIER_ITALIC   COURIER_BOLD_ITALIC
            TIMES     TIMES_BOLD     TIMES_ITALIC     TIMES_BOLD_ITALIC
            SYMBOL_FONT
            SCREEN_FONT SCREEN_BOLD_FONT
            ZAPF_DINGBATS
            BOLD ITALIC BOLD_ITALIC font list_fonts ]
    ],
    gl => [
        qw[ glstart glfinish glsetcolor glstrokerect glfillrect glsetfont
            glgetascent glgetdescent glgetwidth gldrawtext gldrawimage ]
    ],
    gsave => [qw[push_matrix pop_matrix]],
    image => [qw[drawimage]],
    label => [
        qw[ NO_LABEL NORMAL_LABEL SYMBOL_LABEL SHADOW_LABEL ENGRAVED_LABEL
            EMBOSSED_LABEL ]
    ],
    run => [
        qw[ READ WRITE EXCEPT
            awake
            ready
            flush
            run wait
            add_timeout repeat_timeout
            get_time_secs ]
    ],
    version => [
        qw[ FL_MAJOR_VERSION FL_MINOR_VERSION FL_PATCH_VERSION
            FL_VERSION version]
    ],
    visual => [
        qw[ RGB_COLOR INDEXED_COLOR SINGLE_BUFFER DOUBLE_BUFFER ACCUM_BUFFER
            ALPHA_BUFFER DEPTH_BUFFER STENCIL_BUFFER RGB24_COLOR MULTISAMPLE
            STEREO
            glVisual own_colormap visual ]
    ],
    widget => [qw[ RESERVED_TYPE TOGGLE RADIO GROUP_TYPE WINDOW_TYPE ]],
    when   => [
        qw[ WHEN_CHANGED WHEN_RELEASE WHEN_RELEASE_ALWAYS WHEN_ENTER_KEY
            WHEN_ENTER_KEY_ALWAYS WHEN_ENTER_KEY_CHANGED WHEN_NOT_CHANGED ]
    ]
);
@EXPORT_OK = sort map {@$_} values %EXPORT_TAGS;
$EXPORT_TAGS{'all'} = \@EXPORT_OK;
@{$EXPORT_TAGS{'style'}}
    = sort map { @{$EXPORT_TAGS{$_}} } qw[box font label];
@EXPORT    # Export these tags (if prepended w/ ':') or functions by default
    = sort map { m[^:(.+)] ? @{$EXPORT_TAGS{$1}} : $_ } qw[:style :default];

#
our $NOXS ||= $0 eq __FILE__;    # for testing
XSLoader::load 'FLTK', $VERSION if !$FLTK::NOXS;
1;
