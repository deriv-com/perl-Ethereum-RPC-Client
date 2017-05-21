requires 'perl', '5.008005';
requires 'Moo';
requires 'MojoX::JSON::RPC', 0;

on test => sub {
    requires 'Test::More', '0.96';
};
