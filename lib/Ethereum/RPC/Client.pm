package Ethereum::RPC::Client;

use strict;
use warnings;

use Moo;
use HTTP::Request;
use JSON::MaybeXS;
use LWP::UserAgent;

use Ethereum::RPC::Contract;

our $VERSION = '0.01';

has host => (
    is      => 'ro',
    default => sub { '127.0.0.1' }
);
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
        id      => $self->{id}++,
        method  => $method,
        params  => (ref $_[0] ? $_[0] : [@_]),
        jsonrpc => "2.0"
    };
    my $res = $self->_request($url, $obj);

    return $res->{result} unless $res->{error};
    return $res->{error} if $res;
    return undef;

}


sub _request {
    my ($self, $url, $json_data) = @_;

    my $req = HTTP::Request->new(POST => $url);
    $req->header('Content-Type' => 'application/json');

    my $ua = LWP::UserAgent->new;
    my $data = encode_json($json_data);
    $req->add_content_utf8($data);

    my $content = $ua->request($req)->{ _content };

    my $decoded = decode_json($content);
    return $decoded;
}

=head2 contract

Creates a new contract instance

Parameters:
    contract_address    ( Optional - only if the contract already exists ),
    contract_abi        ( Required - https://solidity.readthedocs.io/en/develop/abi-spec.html ),
    from                ( Optional - Address )
    gas                 ( Optional - Integer gas )
    gas_price           ( Optional - Integer gasPrice )

Return:
    New contract instance

=cut


sub contract {
    my $self = shift;
    my $params = shift;
    return Ethereum::RPC::Contract->new(( %{$params}, rpc_client => $self ));
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
