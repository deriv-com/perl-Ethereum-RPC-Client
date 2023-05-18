## contract

Creates a new contract instance

Parameters:
    contract\_address    ( Optional - only if the contract already exists ),
    contract\_abi        ( Required - https://solidity.readthedocs.io/en/develop/abi-spec.html ),
    from                ( Optional - Address )
    gas                 ( Optional - Integer gas )
    gas\_price           ( Optional - Integer gasPrice )

Return:
    New contract instance

# NAME

Ethereum::RPC::Client - Ethereum JSON-RPC Client

# SYNOPSIS

    use Ethereum::RPC::Client;

    # Create Ethereum::RPC::Client object
    my $eth = Ethereum::RPC::Client->new(
       host     => "127.0.0.1",
    );

    my $web3_clientVersion = $eth->web3_clientVersion;

    # https://github.com/ethereum/wiki/wiki/JSON-RPC

# DESCRIPTION

This module implements in PERL the JSON-RPC of Ethereum [https://github.com/ethereum/wiki/wiki/JSON-RPC](https://github.com/ethereum/wiki/wiki/JSON-RPC)

# SEE ALSO

[Bitcoin::RPC::Client](https://metacpan.org/pod/Bitcoin%3A%3ARPC%3A%3AClient)

# AUTHOR

Binary.com <fayland@binary.com>

# COPYRIGHT

Copyright 2017- Binary.com

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.



