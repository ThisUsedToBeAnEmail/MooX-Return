package MooX::Return;

use strict;
use warnings;
use Carp qw/croak/;
use Module::Runtime;

our $VERSION = '0.16';

sub import {
    my ( $self, @import ) = @_;
    
    my $target = caller;
    
    for my $needed_method (qw/with around has/) {
        next if $target->can($needed_method);
        croak "Can't find method <$needed_method> in <$target>";
    }

    my $with = $target->can('with');
    my $around = $target->can('around');
    my $has = $target->can('has');

    my @target_isa;

    { no strict 'refs'; @target_isa = @{"${target}::ISA"} };

    if (@target_isa) {   
        eval '{
        package ' . $target . ';
            
            sub _validate {
                my ($class, @meta) = @_;
                return $class->maybe::next::method(@meta);
            }
            
        1;
        }';
    }

    my $apply_modifiers = sub {
       $with->('MooX::Return::Base');
    };

    my @element = ( );
    my $option = sub {
        my ( $name, %attributes ) = @_;
        my $element_data = { };
        $element_data->{$name} = \%attributes;
        push @element, $element_data;
        $around->(
            '_validate' => sub {
                my ( $orig, $self ) = ( shift, shift );
                return $self->$orig(@_), \@element;
            }
        );
        return;
    };

    { no strict 'refs'; *{"${target}::validate"} = $option; }

    $apply_modifiers->();

    return;
}

1;

__END__

