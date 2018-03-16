requires 'perl', '5.008005';
requires 'Moo';
requires 'MojoX::JSON::RPC', 0;
requires 'Math::BigInt', '>= 1.999811';
requires 'Math::BigFloat', '>= 1.999811';
requires 'Dist::Zilla::Plugin';
on test => sub {
    requires 'Test::More', '0.96';
};
