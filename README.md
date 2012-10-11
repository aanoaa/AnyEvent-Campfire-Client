### install ###

    $ cpanm AnyEvent::Campfire::Client    # not yet working

### usage ###

```perl
use AnyEvent::Campfire::Client;
my $client = AnyEvent::Campfire::Client->new(
    token => 'xxxx',
    rooms => '1234',
    account => 'p5-hubot',
);

$client->on(
    'join',
    sub {
        my ($self, $data) = @_;
        $client->speak($data->{room_id}, "hi");
    }
);

$client->on(
    'message',
    sub {
        my ($self, $data) = @_;
        # ...
    }
);

## want to exit?
$client->exit;
```
