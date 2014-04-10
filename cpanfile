requires 'perl', '5.008005';

requires 'JSON';
recommends 'JSON::XS';
requires 'Mojolicious';
requires 'Time::HiRes';

on test => sub {
    requires 'Test::More';
    requires 'Test::Trap';
};
