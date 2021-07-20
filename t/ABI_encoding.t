#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use JSON::MaybeXS;
use Path::Tiny;

use Ethereum::RPC::Client;

my $rpc_client = Ethereum::RPC::Client->new;

my $abi = path("./t/resources/abi_encoding/abi_encoding.abi")->slurp_utf8;
my $bytecode = path("./t/resources/abi_encoding/abi_encoding.bin")->slurp_utf8;

my $remix_abi_encode = path("./t/resources/abi_encoding/remix_data.bin")->slurp_utf8;
$remix_abi_encode =~ s/^\s+|\s+$//g;

my $coinbase = $rpc_client->eth_coinbase();

my $contract = $rpc_client->contract({
    contract_abi => $abi,
    from         => $coinbase,
    gas          => 4000000,
});

my $contract_address = $contract->invoke_deploy($bytecode, 10, 25)->get_contract_address(35);

$contract->contract_address($contract_address->get->response);

# my $encoded = $contract->encode(
#     "changeOwner", '0xd1aa52637fdc1d2b7f0c8b33c0fc954ef3e71f72',
#     'abracadabra',
#     ["abra",       "cadabra"],
#     ["ab",         "ra", "cada", "bra"],
#     ["1234567890", "1234567890"],
#     ["0x11",       "0x11"]);

# is $encoded, $remix_abi_encode, "correct encoded abi";

done_testing;

