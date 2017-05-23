package Ethereum::RPC::Client;

use strict;
use warnings;
use Moo;
use MojoX::JSON::RPC::Client;

our $VERSION = '0.01';

has jsonrpc => (
    is      => "lazy",
    default => sub { MojoX::JSON::RPC::Client->new });
has host => (
    is      => 'ro',
    default => sub { '127.0.0.1' });
has port => (
    is      => "lazy",
    default => 8545
);

## no critic (RequireArgUnpacking)
sub AUTOLOAD {
    my $self = shift;

    my $method = $Ethereum::RPC::Client::AUTOLOAD;
    $method =~ s/.*:://;

    return if ($method eq 'DESTROY');

    my $url = "http://" . $self->host . ":" . $self->port;

    $self->{id} = 1;
    my $obj = {
        id     => $self->{id}++,
        method => $method,
        params => (ref $_[0] ? $_[0] : [@_]),
    };
    my $res = $self->jsonrpc->call($url, $obj);
    if ($res) {
        if ($res->is_error) {
            return $res->error_message;
        }

        return $res->result;
    }

    return;
}

1;

=pod

=head1 NAME

Ethereum::RPC::Client - Ethereum JSON-RPC Client

=head1 SYNOPSIS

   use Ethereum::RPC::Client;

   # Create Ethereum::RPC::Client object
   my $eth = Ethereum::RPC::Client->new(
      host     => "127.0.0.1",
   );

   my $web3_clientVersion = $eth->web3_clientVersion;

   # https://github.com/ethereum/wiki/wiki/JSON-RPC

=head1 DESCRIPTION

This module implements in PERL the JSON-RPC of Ethereum L<https://github.com/ethereum/wiki/wiki/JSON-RPC>

=head1 SEE ALSO

L<Bitcoin::RPC::Client>

=head1 AUTHOR

Binary.com E<lt>fayland@binary.comE<gt>

=head1 COPYRIGHT

Copyright 2017- Binary.com

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
