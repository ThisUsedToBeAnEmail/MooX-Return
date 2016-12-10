package MooX::Return::Base;

use Moo::Role;

sub return_validate {
    my ($self, $args) = @_;

    return $args;
}

1;
