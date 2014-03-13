# NAME

Mojo::Log::JSON - Simple JSON logger

# SYNOPSIS

    use Mojo::Log::JSON;

    # Log to STDERR
    my $logger = Mojo::Log::JSON->new;

    # Customize log file location, minimum log level and default fields
    my $log = Mojo::Log::JSON->new(    #
        path           => '/var/log/mojo.log',
        level          => 'warn',
        default_fields => {                      #
            datetime => sub { time2iso() },      # default added to log
        },
    );

    # Log messages - debug, info, warn, error, fatal (same as Mojo::Log)

    $log->debug( "A simple string" );
    $log->debug( "A", "message", "over", "multiple", "lines" );
    $log->debug( { message => "A data structure", foo => "bar" } );

    # The above examples would generate something like the following:
    {"datetime":"YYYY-MM-DD HH:mm:ss","level":"debug","message":"A simple string"}
    {"datetime":"2014-03-13 13:15:45","level":"debug","message":"A\nmessage\nover\nmultiple\nlines"}
    {"datetime":"2014-03-13 13:16:32","foo":"bar","level":"debug","message":"A data structure"}

# DESCRIPTION

[Mojo::Log::JSON](https://metacpan.org/pod/Mojo::Log::JSON) is a simple JSON logger for [Mojo](https://metacpan.org/pod/Mojo) projects. It logs a
JSON object (hashref) per log message. Each object occupies a single line to
allow easy parsing of the log output.

The key `level` is always added to the data structure, with the value set to
the level of the log message being emitted.

By default the key `datetime` is also added to the data structure with a value
of the current time in ISO 8601 format. This can be removed or other fields can
be added via `default_fields`.

# ATTRIBUTES

All of the attributes of [Mojo::Log](https://metacpan.org/pod/Mojo::Log) are present, plus the following additional
attributes.

## codec

Pass in a [JSON](https://metacpan.org/pod/JSON) object to override the default JSON formatting settings.

## default\_fields

Hashref of key/value pairs to add to the data structure. Can be overwritten by
values in the log message

# METHODS

[Mojo::Log::JSON](https://metacpan.org/pod/Mojo::Log::JSON) inherits all methods from [Mojo::Log](https://metacpan.org/pod/Mojo::Log).

# SEE ALSO

- [Mojo::Log](https://metacpan.org/pod/Mojo::Log)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/mjemmeson/mojo-log-json/issues](https://github.com/mjemmeson/mojo-log-json/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/mjemmeson/mojo-log-json](https://github.com/mjemmeson/mojo-log-json)

    git clone git://github.com/mjemmeson/mojo-log-json.git

# AUTHOR

Michael Jemmeson <mjemmeson@cpan.org>

# COPYRIGHT

Copyright 2014- Michael Jemmeson

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
