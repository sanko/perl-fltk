#!perl -I../../blib/lib -I../../blib/arch -I../../blib/arch/FLTK/FLTK
use strict;
use warnings;

#
$|++;

#
use Test::More tests => 1;
BEGIN { use_ok('FLTK', qw[:all]) }

# $Id$
