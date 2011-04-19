#!perl -w
use strict;
use warnings;
use Module::Build qw[];
chdir '../..' if not -d '_build';
use lib 'inc';
my $build = Module::Build->current;
my $file = shift || 'xs/rc/version.rc';
exit
    if $build->up_to_date(-f __FILE__ ? __FILE__ : 'xs/rc/' . __FILE__,
                          $file);
printf 'Generating %s... ', $file;
my $version = $build->dist_version;
$version .= '_00' unless $version =~ m/_/;
$version = sprintf('%.1d,%.1d,%.1d,%.1d',
                   map {int}
                       $version =~ m[^(\d+)\.(\d\d\d)(\d\d\d)(?:_(\d+))?$]);
my $first_year      = 2008;
my $year            = 1900 + (gmtime())[5];
my $copyright_years = "$first_year";
if ($year > $first_year) { $copyright_years .= "..$year"; }
my $build_datetime = gmtime();
open(my ($fh), '>', $file) || die "Can't open '$file' for writing: $!";
print $fh <<"__EOT";
#include <windows.h>

1 VERSIONINFO
FILEVERSION    $version
PRODUCTVERSION $version
FILEOS         VOS__WINDOWS32
FILETYPE       VFT_DLL
{
  BLOCK "StringFileInfo"
  {
    BLOCK "040904E4"
    {
      VALUE "Comments"         , "FLTK built $build_datetime"
      VALUE "CompanyName"      , "Sanko Robinson"
      VALUE "FileDescription"  , "FLTK - Perl extension for The Fast Light Toolkit"
      VALUE "FileVersion"      , "$version"
      VALUE "InternalName"     , "FLTK.dll"
      VALUE "LegalCopyright"   , "Copyright © Sanko Robinson $copyright_years"
      VALUE "LegalTrademarks"  , "Artistic 2 licence"
      VALUE "OriginalFilename" , "FLTK.dll"
      VALUE "ProductName"      , "FLTK Perl extension"
      VALUE "ProductVersion"   , "$version"
    }
  }

  BLOCK "VarFileInfo"
  {
    VALUE "Translation", 0x0409, 0x04E4
  }
}
__EOT
close($fh) || die "Couldn't write '$file': $!";
print "okay\n";
$build->add_to_cleanup($file);
exit(0);
