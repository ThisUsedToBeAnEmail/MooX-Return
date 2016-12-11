#!perl
use Test::More;

BEGIN {
    use_ok('MooX::Return::Type');
}

my $something = MooX::Return::Type->new();

warn Dumper $something;

=pod
my $hash1 = {
    hash    => 'hash',
    hashing => 'hashing',
    hashed  => 'hashed',
};

warn Dumper $something->hash($hash1);

my $hash2 = (
    hash    =>  'hash',
    hashing =>  'hashing',
    hashed  =>  'hashed',
);

warn Dumper $something->hash($hash2);

my %hash3 = (
    hash    =>  'hash',
    hashing =>  'hashing',
    hashed  =>  'hashed',
);

warn Dumper $something->hash(%hash3);

my %hash4 = {
    hash    =>  'hash',
    hashing =>  'hashing',
    hashed  =>  'hashed',
};

warn Dumper $something->hash(%hash4);
=cut

done_testing();

1;
