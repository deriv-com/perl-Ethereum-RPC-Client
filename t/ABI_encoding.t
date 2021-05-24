#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use JSON::MaybeXS;

use Ethereum::RPC::Client;

my $rpc_client = Ethereum::RPC::Client->new;

my $test_address = '0xd1aa52637fdc1d2b7f0c8b33c0fc954ef3e71f72';
my $abi = [
	{
		"inputs" => [
			{
				"internalType" => "address",
				"name" => "_address",
				"type" => "address"
			},
			{
				"internalType" => "uint256",
				"name" => "_dynamic_uint",
				"type" => "uint256"
			},
			{
				"internalType" => "string",
				"name" => "_string",
				"type" => "string"
			},
			{
				"internalType" => "bytes[]",
				"name" => "_dynamic_array",
				"type" => "bytes[]"
			}
		],
		"name" => "ABIEncodeTest",
		"outputs" => [],
		"stateMutability" => "nonpayable",
		"type" => "function"
	}
];

my $remix_abi_encode = "0x4138306d000000000000000000000000d1aa52637fdc1d2b7f0c8b33c0fc954ef3e71f72000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000000b61627261636164616272610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010100000000000000000000000000000000000000000000000000000000000000";

my $contract = $rpc_client->contract({
    contract_abi    => encode_json($abi),
    from            => $test_address,
    gas             => 4000000,
    gas_price       => 10
});

use Tie::IxHash;
tie my %params, "Tie::IxHash";

%params = (
    address => '0xd1aa52637fdc1d2b7f0c8b33c0fc954ef3e71f72',
    string => 'abracadabra',
    'string[]' => ["abra", "cadabra"],
    'string[4]' => ["ab", "ra", "cada", "bra"],
    'bytes10[2]' => ["1234567890", "1234567890"],
    'bytes[]' => ["17", "17"],
);

my $offset = scalar (keys %params);
my (@static, @dynamic);
for my $param (keys %params){
    my ($static, $dynamic) = $contract->get_hex_param($offset, $param, $params{$param});
    push(@static, $static->@*);
    push(@dynamic, $dynamic->@*);
    $offset += scalar $dynamic->@*;
}

use Data::Dumper;
my @data = (@static, @dynamic);
my $data = join("", @data);

print Dumper $data;

done_testing;

