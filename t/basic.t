use strict;
use warnings;

use Test::More;
use Test::Trap;
use Mojo::Log::JSON;

ok my $logger = Mojo::Log::JSON->new(), "new";

trap { $logger->debug("Simple string") };
like $trap->stderr,
    qr/{"datetime":"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d","level":"debug","message":"Simple string"}/,
    "string message ok";

trap { $logger->debug(qw/ Multi line string /) };
like $trap->stderr,
    qr/{"datetime":"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d","level":"debug","message":"Multi\\nline\\nstring/,
    "multi line message ok";

trap { $logger->debug( { message => "Data structure", foo => 'bar' } ) };
like $trap->stderr,
    qr/{"datetime":"\d{4}-\d\d-\d\d \d\d:\d\d:\d\d","foo":"bar","level":"debug","message":"Data structure"}/,
    "data structure message ok";

done_testing;
