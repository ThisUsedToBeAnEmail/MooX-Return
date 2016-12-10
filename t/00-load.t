#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'MooX::Haze' ) || print "Bail out!\n";
}

diag( "Testing MooX::Haze $MooX::Haze::VERSION, Perl $], $^X" );
