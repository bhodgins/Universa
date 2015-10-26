package Universa::Channel;

use Moose;
use Universa::Attribute::EntityCollection;

has '_entities' => (
    isa         => 'Universa::Attribute::EntityCollection',
    is          => 'ro',
    builder     => '_build_entities',
    lazy        => 1,
    handles     => {
	add_entity => 'add',
	count_entities => 'count',
	entity_by_uuid => 'by_uuid',
	entity_by_name => 'by_name',
	remove_entity  => 'remove',
    },
    );

has 'name'      => (
    isa         => 'Str',
    is          => 'ro',
    default     => '',
    lazy        => 1,
    );

# For indexing purposes:
has 'type'      => (
    isa         => 'Str',
    is          => 'ro',
    default     => '',
    lazy        => 1,
    );

has 'info'      => (
    isa         => 'HashRef[Any]',
    is          => 'ro',
    builder     => '_build_info',
    lazy        => 1,
    );


sub route {
    my ($self, $message) = @_;
    
    if ($message->target->[0] eq ':all') {
	# Broadcast message:

	print "TESTING\n";
	foreach my $entity ( $self->_entities->_values ) {
	    $entity->put($message);
	}
    }

    else {
	foreach my $uuid ( @{ $message->target } ) {
	    if (my $entity = $self->entity_by_uuid($uuid)) {
		$entity->put($message);
	    }
	}
    }
}

sub _build_info { {} }

sub _build_stub { Universa::Channel::Stub->new }

sub _build_entities {
    Universa::Attribute::EntityCollection->new;
}
    
__PACKAGE__->meta->make_immutable;

package Universa::Channel::Stub;

use Moose;


# Stub

__PACKAGE__->meta->make_immutable;
