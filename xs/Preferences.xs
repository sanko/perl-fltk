#include "include/FLTK_pm.h"

MODULE = FLTK::Preferences               PACKAGE = FLTK::Preferences

#ifndef DISABLE_PREFERENCES

=pod

=for license Artistic License 2.0 | Copyright (C) 2009,2010 by Sanko Robinson

=for author Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

=for version 0.530

=for git $Id$

=head1 NAME

FLTK::Preferences - Application preferences

=head1 Description

Preferences are data trees containing a root, branches and leaves.

=cut

#include <fltk/Preferences.h>

fltk::Preferences::Root
SYSTEM( )
    CODE:
        RETVAL = fltk::Preferences::SYSTEM;
    OUTPUT: RETVAL

fltk::Preferences::Root
USER( )
    CODE:
        RETVAL = fltk::Preferences::USER;
    OUTPUT: RETVAL

=begin apidoc

=for apidoc ||FLTK::Preferences tree|new|FLTK::Preferences::Root root|char * vendor|char * application|

Creates a new L<preferences|FLTK::Preferences> object.

=over

=item * C<$root> is a value representing either per machine
(C<FLTK::Preferences::SYSTEM>) or per user (C<FLTK::Preferences::USER>)
settings.

=item * C<vendor> is the unique identification of the author or vendor of
C<$application>.

Note: vendor must be a valid directory name.

=item * C<$application> is a vendor unique application name, for example,
C<PreferencesTest>. Multiple preferences files can be created per application.

Note: application name must be a valid file name.

=back

=for apidoc ||FLTK::Preferences node|new|FLTK::Preferences parent|char * group|

Creates a L<Preferences|FLTK::Preferences> node in relation to a parent node
for reading and writing

=over

=item * C<$parent> is the base name for the group.

=item * C<$group> is a group name which may contain C</> separated group
names.

=back

Example:

  my $colors = FLTK::Preferences->new( $prefs, 'setup/colors' );

=for apidoc ||FLTK::Preferences prefs|new|char * path|char * vendor|char * application|

Creates a L<Preferences|FLTK::Preferences> object.

=over

=item * C<$path> is an application-supplied path.

=back

=cut

fltk::Preferences *
fltk::Preferences::new( ... )
    CODE:
        if ( items == 4 && SvIOK(ST(1)) && SvPOK(ST(2)) && SvPOK(ST(3)) ) {
            /* Root root, const char * vendor, const char * application */
            fltk::Preferences::Root root = (fltk::Preferences::Root) SvIV(ST(1));
            const char * vendor          = (const char *)            SvPV_nolen(ST(2));
            const char * application     = (const char *)            SvPV_nolen(ST(3));
            RETVAL = new fltk::Preferences( root, vendor, application );
        }
        else if ( items == 4 /* && SvPOK(ST(1)) && SvPOK(ST(2)) && SvPOK(ST(3)) */ ) {
            /* const char * path, const char * vendor, const char * application */
            const char * path   = (const char *) SvPV_nolen(ST(1));
            const char * vendor = (const char *) SvPV_nolen(ST(2));
            const char * app    = (const char *) SvPV_nolen(ST(3));
            RETVAL = new fltk::Preferences( path, vendor, app );
        }
        else if ( items == 3 && sv_isobject(ST(1)) && sv_derived_from(ST(1), "FLTK::Preferences") && SvPOK(ST(2)) ) {
            /* Preferences * prefs, const char *group */
            fltk::Preferences * prefs = INT2PTR( fltk::Preferences *, SvIV( ( SV * ) SvRV( ST(1) ) ) );
            const char        * group = (const char *) SvPV_nolen(ST(2));
            RETVAL = new fltk::Preferences( prefs, group );
        }
        else
            XSRETURN_UNDEF;
    OUTPUT:
        RETVAL

=for apidoc |||destroy||

Destroy individual keys.

Destroying the base L<preferences|FLTK::Preferences> will flush changes to the
prefs file. After destroying the base, none of the depending
L<preferences|FLTK::Preferences> must be read or written.

=cut

void
fltk::Preferences::DESTROY(  )

void
fltk::Preferences::destroy( )
    CODE:
        //delete THIS;
        sv_setsv(ST(0), &PL_sv_undef);

=for apidoc ||int count|groups||

Returns the number of groups that are contained within a group.

=cut

int
fltk::Preferences::groups( )

=for apidoc ||const char * name|group|int index|

Returns the group name of the C<$index>th group. There is no guaranteed order
of group names and C<$index> must be within the range given by
L<C<groups( )>|FLTK::Preferences/"groups">.

=cut

const char *
fltk::Preferences::group( int index )

=for apidoc ||bool exists|groupExists|char * group|

Returns C<1>, if a group with this name exists.

=for apidoc ||bool removed|deleteGroup|char * group|

Delete a group.

=cut

bool
fltk::Preferences::groupExists( const char * group )

bool
fltk::Preferences::deleteGroup( const char * group )

=for apidoc ||int count|entries||

Returns the number of entries (key/value) pairs for a group.

=cut

int
fltk::Preferences::entries( )

=for apidoc ||char * key|entry|int index|

Returns the name of an entry. There is no guaranteed order of entry names and
C<$index> must be within the range given by
L<C<entries()>|FLTK::Preferences/"entries">.

=cut

const char *
fltk::Preferences::entry( int index )

=for apidoc ||bool exists|entryExists|char * entry|

Returns C<1>, if a group with this name exists.

=for apidoc ||bool gone|deleteEntry|char * entry|

Delete a group.

=cut

bool
fltk::Preferences::entryExists( const char * group )

bool
fltk::Preferences::deleteEntry( const char * group )

=for apidoc ||bool okay|set|char * entry|char * value|

Set an entry (key/value) pair.

=cut

bool
fltk::Preferences::set( const char * entry, const char * value )

=for apidoc ||char * value|get|char * key|char * value|char * defaultValue = 0|

Get an entry (key/value) pair.

=cut

void
fltk::Preferences::get( const char * entry, OUTLIST char * value, char * defaultValue = 0 )
    C_ARGS: entry, value, (const char *) defaultValue

=for apidoc ||int length|size|char * key|

Returns the size of the value part of an entry.

=cut

int
fltk::Preferences::size( const char * entry )

=for apidoc ||char * path|getUserdataPath||

Creates a path that is related to the preferences file and that is usable for
application data beyond what is covered by L<Preferences|FLTK::Preferences>.

=cut

char *
fltk::Preferences::getUserdataPath( )
    PREINIT:
        char path[MAX_PATH];
        int length = MAX_PATH;
    CODE:
        if ( ! THIS->getUserdataPath( path, length ) )
            XSRETURN_UNDEF;
        RETVAL = path;
    OUTPUT:
        RETVAL

=for apidoc |||flush||

Writes all preferences to disk. This method works only with the base
L<preference|FLTK::Preferences> group.

Note: This method is rarely used as the L<preferences|FLTK::Preferences> flush
automatically when L<C<destroy( )>|FLTK::Preferences/"destroy"> is called or
when the base L<preferences|FLTK::Preferences> go out of scope.

=cut

void
fltk::Preferences::flush( )

#endif // ifndef DISABLE_PREFERENCES
