requires 'perl', '5.014';
requires 'Moo';
requires 'Mojo::UserAgent';
requires 'Math::BigInt', '>= 1.999811';
requires 'Math::BigFloat', '>= 1.999811';
requires 'JSON::MaybeXS', '>= 1.003008';
requires 'List::Util', '1.23';
requires 'Scalar::Util', '1.23';
requires 'Future', '>= 0.37';

on configure => sub {
    requires 'ExtUtils::MakeMaker', '>= 7.1101';
};

on test => sub {
    requires 'Test::More', '0.96';
};
