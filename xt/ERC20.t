use strict;
use warnings;

use Test::More;
use Math::BigInt;

use Ethereum::RPC::Client;
use Ethereum::RPC::Contract::Helper::ImportHelper;

my $rpc_client = Ethereum::RPC::Client->new;

my $coinbase = $rpc_client->eth_coinbase;

my $truffle_project = Ethereum::RPC::Contract::Helper::ImportHelper::from_truffle_build("./xt/builds/SimpleToken.json");

die "can't read json" unless $truffle_project;

my $contract = $rpc_client->contract({
    contract_abi    => $truffle_project->{abi},
    from            => $coinbase,
    gas             => 4000000,
});
    
my ($message, $error) = $contract->invoke_deploy($truffle_project->{bytecode})->get_contract_address(35);
die $error if $error;

$contract->contract_address($message->response);
    
my @account_list = @{$rpc_client->eth_accounts()};

($message, $error) = $contract->invoke("name")->call_transaction();
ok !$error;
is $message->to_string, "SimpleToken";

($message, $error) = $contract->invoke("symbol")->call_transaction();
ok !$error;
is $message->to_string, "SIM";

($message, $error) = $contract->invoke("decimals")->call_transaction();
ok !$error;
is $message->to_big_int, 18;

($message, $error) = $contract->invoke("balanceOf", $coinbase)->call_transaction();
ok !$error;
my $coinbase_balance = $message->to_big_int;

($message, $error) = $contract->invoke("balanceOf", $account_list[1])->call_transaction();
ok !$error;
my $account_one_balance = $message->to_big_int;

($_, $error) = $contract->invoke("approve", $account_list[1], 1000)->send_transaction();
ok !$error;

($message, $error) = $contract->invoke("allowance", $coinbase, $account_list[1])->call_transaction();
ok !$error;
is $message->to_big_int, 1000;

($_, $error) = $contract->invoke("transfer", $account_list[1], 1000)->send_transaction();
ok !$error;

($message, $error) = $contract->invoke("balanceOf", $coinbase)->call_transaction();
ok !$error;
is $message->to_big_int, Math::BigInt->new($coinbase_balance - 1000);

($message, $error) = $contract->invoke("balanceOf", $account_list[1])->call_transaction();
ok !$error;
is $message->to_big_int, Math::BigInt->new($account_one_balance + 1000);

done_testing();
