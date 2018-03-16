package Ethereum::RPC::Contract::ContractTransaction;

use strict;
use warnings;

our $VERSION = '0.001';

=head1 NAME

   Ethereum::RPC::Contract::ContractTransaction - Centralize contract transactions

=cut


use Moo;
use Ethereum::RPC::Contract::ContractResponse;
use Ethereum::RPC::Contract::Helper::UnitConversion;

has contract_address => ( is => 'ro' );
has rpc_client       => ( is => 'ro', lazy => 1 );

sub _build_rpc_client {
    return Ethereum::RPC::Client->new;
}

has data             => ( is => 'ro', required => 1 );
has from             => ( is => 'ro');
has gas              => ( is => 'ro');
has gas_price        => ( is => 'ro');

=head2 call_transaction

Call a public functions and variables from a ethereum contract

Return:
    Ethereum::RPC::Contract::ContractResponse, error message

=cut

sub call_transaction {
    my $self = shift;

    my $res = $self->rpc_client->eth_call([{
        to    => $self->contract_address,
        data  => $self->data,
    }, "latest"]);

    return (Ethereum::RPC::Contract::ContractResponse->new({ response => $res }), undef) if $res and $res =~ /^0x/;

    return ( undef, $res );

}

=head2 send_transaction

Send a transaction to a payable functions from a ethereum contract

The parameter GAS is required to send a payable request.

Return:
    Ethereum::RPC::Contract::ContractResponse, error message

=cut

sub send_transaction {
    my $self = shift;

    return ( undef, "the transaction can't be sent without the GAS parameter" ) unless $self->gas;

    my $res = $self->rpc_client->eth_sendTransaction([{
        to          => $self->contract_address,
        from        => $self->from,
        gas         => Ethereum::RPC::Contract::Helper::UnitConversion::to_wei($self->gas),
        gasPrice    => $self->gas_price,
        data        => $self->data,
    }]);

    return (Ethereum::RPC::Contract::ContractResponse->new({ response => $res }), undef) if $res and $res =~ /^0x/;

    return ( undef, $res );

}

=head2 get_contract_address

Try to get a contract address based on a transaction hash

Parameters:
    $wait_seconds    ( Optional - max time to wait for the contract address response ),
    $send_response     ( Optional - response of the send method, if not informed send a new transaction and then try to get the address ),

Return:
    Ethereum::Contract::ContractResponse

=cut

sub get_contract_address {

    my ($self, $wait_seconds, $send_response) = @_;

    my ($transaction, $error) = undef, undef;
    ($transaction, $error) = $self->send_transaction unless $send_response;

    return ( undef, $error ) if $error;

    my $deployed = $self->rpc_client->eth_getTransactionReceipt($transaction->response);

    while ($wait_seconds and not $deployed and $wait_seconds > 0) {
        sleep(1);
        $wait_seconds--;
        $deployed = $self->rpc_client->eth_getTransactionReceipt($transaction->response);
    }

    return ( Ethereum::RPC::Contract::ContractResponse->new({ response => $deployed->{contractAddress} }), undef )
        if $deployed and ref($deployed) eq 'HASH';

    return ( undef, "Can't get the contract address for transaction: $transaction" );

}

1;
