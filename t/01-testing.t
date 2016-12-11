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

use Data::Dumper;

subtest 'Test Type Hashes' => sub {
    my $class = MyTest::Something->new();

    run_validate_test({
        class       => $class,
        args        => { hello  => 'one', way => 'needs' },
        spec        => { spec   => { hello => { type => 'SCALAR' }, way => { type => 'SCALAR' } } }, 
        expected    => { hello  => 'one', way => 'needs' },
    });

    run_validate_test({
        class       => $class,
        args        => { hello  => 'one', way => { goodbye => 'needs' }, },
        spec        => { 
            spec   => { 
                hello => { 
                    type => 'SCALAR',
                    validate => sub { $_ =~ m{^one|two|three$}ix },
                }, 
                way => { 
                    type => 'HASH', 
                    spec => {
                        goobye  =>  {
                            type    => 'SCALAR',
                        }
                    }
                } 
            } 
        }, 
        expected    => { hello  => 'one', way => { goodbye => 'needs' } },
    });

    run_validate_test({
        class       => $class,
        args        => { hello  => 'one', goodbye => 'needs' },
        spec        => { 
            spec   => { 
                hello => { 
                    type => 'SCALAR',
                    validate => sub { $_ =~ m{^one|two|three$}ix },
                }, 
                way => { 
                    type => 'HASH',
                    default => { },
                    count   => 1,
                    spec => {
                        goobye  =>  {
                            type    => 'SCALAR',
                        }
                    }
                } 
            } 
        }, 
        expected    => { hello  => 'one', way => { goodbye => 'needs' } },
    });


    run_validate_test({
        class       => $class,
        args        => { hello  => 'one', way => [ 'goodbye', 'needs' ], },
        spec        => { 
            spec   => { 
                hello => { 
                    type => 'SCALAR' 
                }, 
                way => { 
                    type => 'ARRAY',
                    count => 2,
                } 
            } 
        }, 
        expected    => { hello  => 'one', way => [ 'goodbye', 'needs' ], },
    }); 

    run_validate_test({
        class       => $class,
        args        => hello  => 'one', [ 'goodbye', 'needs' ],
        spec        => { 
            spec   => { 
                hello => { 
                    type => 'SCALAR' 
                }, 
                way => { 
                    type => 'ARRAY',
                    default => [ ],
                    count => 2,
                } 
            } 
        }, 
        expected    => { hello  => 'one', way => [ 'goodbye', 'needs' ], },
    }); 

    run_validate_test({
        class       => $class,
        args        => ['one', 'goodbye', 'needs'],
        spec        => { 
            spec   => [
                { 
                    hello => { 
                        type => 'SCALAR' 
                    },
                },
                {
                    way => { 
                        type => 'ARRAY',
                        default => [ ],
                        count => 2,
                    }
                }
            ]
        }, 
        expected    => { hello  => 'one', way => [ 'goodbye', 'needs' ], },
    });

};

sub run_validate_test {
    my $test = shift;

    my $valid = $test->{class}->return_validate($test->{args}, $test->{spec});
    is_deeply($valid, $test->{expected}, "deeply hash");
}

done_testing();

1;
