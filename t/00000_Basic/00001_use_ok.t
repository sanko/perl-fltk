#!perl -I../../blib/lib -I../../blib/arch -I../../blib/arch/FLTK/FLTK
use strict;
use warnings;

#
$|++;

#
use Test::More tests => 1;
BEGIN { use_ok('FLTK', qw[:all]) }

# $Id: 00001_use_ok.t a404412 2009-03-24 05:36:10Z sanko@cpan.org $
