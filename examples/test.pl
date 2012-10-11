#!/usr/bin/env perl
use strict;
use warnings;
use AnyEvent;
use AnyEvent::Campfire::Client;
use Data::Printer;

my $cv = AnyEvent->condvar;

my $client = AnyEvent::Campfire::Client->new(
    token   => '', # your token here
    rooms   => '', # room number
    account => '', # uh?
);

$client->on(
    'join',
    sub {
        my ( $self, $room ) = @_;
        warn "-- join\n";
        $client->speak( $room, "hi" );
    }
);

$client->on(
    'message',
    sub {
        my ( $e, $data ) = @_;
        warn "-- message\n";
        p $data;
        return unless defined $data->{body};
        if ( $data->{body} eq 'leave' ) {
            $client->exit;
        }

        if ( $data->{body} eq 'say hello' ) {
            $client->speak( $data->{room_id}, "hello" );
        }
    }
);

$client->on(
    'leave',
    sub {
        my ( $e, $data ) = @_;
        warn "-- leave\n";
        p $data;
        $cv->send;
    }
);

$client->on(
    'error',
    sub {
        my ( $self, $error ) = @_;
        warn "-- error\n";
    }
);

$cv->recv;

__END__

=pod

=head1 SYNOPSIS

    you> say hello
    bot> hello
    you> leave
    bot> has left the room.

=cut
