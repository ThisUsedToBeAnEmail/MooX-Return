#!perl
use Test::More;

package MyTest::Something;

use Moo;
use MooX::Return;

sub sometest {
    my $hash = {
        something   =>  'one',
        second      =>  'two',
    };
    return $hash;
}

validate sometest {
    type => 'HASH',
    spec => {
        something   => {
            type    => 'SCALAR',
        },
        second      => {
            type    => 'SCALAR',
        }
    }
};

package main;

BEGIN {
    use_ok('MyTest::Something');
}

my $something = MyTest::Something->new();

use Data::Dumper;

my $args = { hello  => 'one', way => 'needs' };
my $spec = { spec   => { hello => { type => 'SCALAR' }, way => { type => 'SCALAR' } } };

warn Dumper $something->return_validate($args, $spec);

done_testing();

1;
