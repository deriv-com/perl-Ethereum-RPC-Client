# perl-Ethereum-RPC-Client


[![Build Status](https://travis-ci.org/binary-com/perl-Ethereum-Contract.svg?branch=master)](https://travis-ci.org/binary-com/perl-Ethereum-Contract)
[![codecov](https://codecov.io/gh/binary-com/perl-Ethereum-Contract/branch/master/graph/badge.svg)](https://codecov.io/gh/binary-com/perl-Ethereum-Contract)

# NAME

perl-Ethereum-RPC

# SYNOPSIS

    ```perl
        #!/usr/bin/perl
        use strict;
        use warnings;
        use Ethereum::RPC::Client;
        use Ethereum::Contract::Contract;
        
        my $abi = ...
        my $bytecode = ...
        my $rpc_client = Ethereum::RPC::Client->new;
        
        my $coinbase = $rpc_client->eth_coinbase;
        
        my $contract = $rpc_client->contract({
            contract_abi    => $abi,
            from            => $from,
            gas             => $gas,
        });
            
        # Deploying a Contract
        # get_contract_address ( number of seconds that will be expected to return the contract address )
        my $contract->deploy($bytecode)->get_contract_address(35);
        
        die $response->error if $response->error;
        
        print $contract->invoke("functionname", qw{param1 param2 param3})->call->to_big_int();
        
        my $hash = $contract->invoke("functionname", $param1, $param2, $param3)->send;
    ```

# DESCRIPTION

perl-Ethereum-Contract is a library to enable perl to call the contract functions using RPC calls.

# USAGE

- Loading Contract

    ```perl
        
        my $rpc_client = Ethereum::RPC::Client->new; 

        my $contract = $rpc_client->contract({
            contract_abi    => $abi,
            from            => $coinbase,
            gas             => 3000000,
        });
    ```
    
- Deploying a Contract

    ```perl
        $contract->deploy($bytecode);
    ```
    
- Calling a Contract function

    ```perl
        my ($message, $error) = $contract->invoke($function_name, param1, param2, ...)->call();
        $big_int = $message->to_big_int unless $error;
    ```

# CAVEATS

This software is in an early state.

### REQUIREMENTS
* perl 5
* [Ethereum::RPC::Client](https://github.com/binary-com/perl-Ethereum-RPC-Client)

# AUTHOR

Binary.com

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
