use strict;
use warnings;
use Test::More;
use Ethereum::RPC::Client;

my $eth = Ethereum::RPC::Client->new({host => "127.0.1.1", port => "8545"});
my $web3_clientVersion = $eth->web3_clientVersion;
diag "Got $web3_clientVersion";
ok($web3_clientVersion);

done_testing();
