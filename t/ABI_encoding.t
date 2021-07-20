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

my $coinbase = $rpc_client->eth_coinbase();

my $contract = $rpc_client->contract({
    contract_abi => $abi,
    from         => $coinbase,
    gas          => 4000000,
});

my $deploy_transaction = $contract->_prepare_transaction($bytecode, "constructor", [[10, 15]]);

my $remix_deploy_data_input = path("./t/resources/abi_encoding/remix_deploy.bin")->slurp_utf8;
$remix_deploy_data_input =~ s/^\s+|\s+$//g;

is $deploy_transaction->data, $remix_deploy_data_input, "correct deploy encoding";

my $function_id = substr($contract->get_function_id("testString", 3), 0, 10);

my @dynamic_array = ("ha", "ta", "tu");
my @static_array = ("double", "string");
my $test_string_transaction = $contract->_prepare_transaction($function_id, "testString", ["ha", \@dynamic_array, \@static_array]);

my $remix_string_test_data = path("./t/resources/abi_encoding/remix_testString.bin")->slurp_utf8;
$remix_string_test_data =~ s/^\s+|\s+$//g;


is $test_string_transaction->data, $remix_string_test_data, "correct deploy encoding";

done_testing;

