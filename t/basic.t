use strict;
use warnings;

use Test::More;
use Capture::Tiny 'capture_stderr';
use Mojo::Log::JSON;

my $time_re = qr/"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d"/;

ok my $logger = Mojo::Log::JSON->new(), "new";

my $stderr;

$stderr = capture_stderr { $logger->debug("Simple string") };
like $stderr,
    qr/{"datetime":$time_re,"level":"debug","message":"Simple string"}/,
    "string message ok";

$stderr = capture_stderr { $logger->debug(qw/ Multi line string /) };
like $stderr,
    qr/{"datetime":$time_re,"level":"debug","message":"Multi\\nline\\nstring/,
    "multi line message ok";

$stderr = capture_stderr { $logger->debug( { message => "Data structure", foo => 'bar' } ) };
like $stderr,
    qr/{"datetime":$time_re,"foo":"bar","level":"debug","message":"Data structure"}/,
    "data structure message ok";

$logger->default_fields->{extra_field} = 'default extra field';

$stderr = capture_stderr { $logger->debug( { message => "Data structure", foo => 'bar' } ) };
like $stderr,
    qr/{"datetime":$time_re,"extra_field":"default extra field","foo":"bar","level":"debug","message":"Data structure"}/,
    "data structure message ok";

done_testing;
