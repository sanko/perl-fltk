
=pod

=for abstract Basic FLTK::MenuBar Example

=for license Artistic License 2.0 | Copyright (C) 2009 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for git $Id$

=cut
use strict;
use warnings;
use FLTK;
$|++;

#
my $win = new FLTK::Window(100, 100, 400, 350);
$win->begin;
my $m = FLTK::MenuBar->new(0, 0, 660, 21, 'Test');
build_menus($m, $win);
$win->end();
$win->show();
run;

sub build_menus {
    my ($menu) = @_;
    my $g = FLTK::ItemGroup->new();
    $menu->begin();
    $g = FLTK::ItemGroup->new("&File");
    $g->begin();
    FLTK::Item->new("&New File", 0, sub { warn 'New File'; });
    FLTK::Item->new("&Open File...",
                    FLTK::COMMAND() + ord 'o',
                    sub { warn 'Open File...' });
    FLTK::Item->new("&Insert File...",
                    FLTK::COMMAND + ord 'i',
                    sub { warn 'insert_cb' }
    );
    FLTK::Divider->new();
    FLTK::Item->new("&Save File",
                    FLTK::COMMAND + ord 's',
                    sub { warn 'save_cb' });
    FLTK::Item->new("Save File &As...",
                    FLTK::COMMAND + FLTK::SHIFT + ord 's',
                    sub { warn 'saveas_cb' });
    new FLTK::Divider();
    FLTK::Item->new("New &View",
                    FLTK::ACCELERATOR + ord 'v',
                    sub { warn 'view_cb' }, 0);
    FLTK::Item->new("&Close View",
                    FLTK::COMMAND + ord 'w',
                    sub { warn 'close_cb' }
    );
    new FLTK::Divider();
    {
        my $x = FLTK::ItemGroup->new('Submenu');
        $x->begin();
        my $btn = FLTK::Button->new(0, 0, 250, 20, 'Button');
        $btn->callback(sub { warn 'button'; });
        $btn->labelfont(HELVETICA_BOLD);
        $x->end();
    }
    new FLTK::Divider();
    FLTK::Item->new("E&xit", FLTK::COMMAND + ord 'X', sub {exit}, 0);
    $g->end();
    $g = FLTK::ItemGroup->new("&Edit");
    $g->begin();
    FLTK::Item->new("Cu&t",  FLTK::COMMAND + ord 'x', sub { warn 'cut_cb' });
    FLTK::Item->new("&Copy", FLTK::COMMAND + ord 'c', sub { warn 'copy_cb' });
    FLTK::Item->new("&Paste",
                    FLTK::COMMAND + ord 'v',
                    sub { warn 'paste_cb' });
    FLTK::Item->new("&Delete", 0, sub { warn 'delete_cb' });
    $g->end();
    $g = FLTK::ItemGroup->new("&Search");
    $g->begin();
    FLTK::Item->new("&Find...",
                    FLTK::COMMAND + ord 'f',
                    sub { warn 'find_cb' });
    FLTK::Item->new("F&ind Again",
                    FLTK::COMMAND + ord 'g',
                    sub { warn 'find2_cb' }
    );
    FLTK::Item->new("&Replace...",
                    FLTK::COMMAND + ord 'r',
                    sub { warn 'replace_cb' });
    FLTK::Item->new("Re&place Again",
                    FLTK::COMMAND + ord 't',
                    sub { warn 'replace2_cb' });
    $g->end();
    $menu->end();
}
