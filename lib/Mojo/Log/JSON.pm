package Mojo::Log::JSON;

use Mojo::Base 'Mojo::Log';

use JSON;

our $VERSION = '0.02';

has codec => sub { JSON->new->indent(0)->utf8->canonical };

has default_fields => sub {
    {   datetime => sub {

            my ( $sec, $min, $hour, $mday, $mon, $year ) = gmtime();
            sprintf(
                "%04d-%02d-%02d %02d:%02d:%02d",
                $year + 1900,
                $mon + 1, $mday, $hour, $min, $sec
            );
        },
    };
};

has format => sub {
    my $self = shift;

    return sub {
        my ( $time, $level, @lines ) = @_;

        my %msg = (
            (   map {

                    my $value = $self->default_fields->{$_};

                    $_ => ref $value eq 'CODE' ? $value->() : $value;

                } keys %{ $self->default_fields }
            ),

            level => $level,

            ref $lines[0]       # data structure?
            ? %{ $lines[0] }    #  multiple keys
            : ( message => join( "\n", @lines ) ),    # single 'message' key

        );

        return $self->codec->encode( \%msg ) . "\n";
    };
};

1;

__END__

=encoding utf-8

=head1 NAME

Mojo::Log::JSON - Simple JSON logger

=head1 SYNOPSIS

    use Mojo::Log::JSON;

    # Log to STDERR
    my $logger = Mojo::Log::JSON->new;

    # Customize log file location, minimum log level and default fields
    my $logger = Mojo::Log::JSON->new(    #
        path           => '/var/log/mojo.log',
        level          => 'warn',
        default_fields => {                      #
            datetime => sub { time2iso() },      # default added to log
        },
    );

    # To add extra default field
    $logger->default_fields->{foo} = "bar";

    # Log messages - debug, info, warn, error, fatal (same as Mojo::Log)

    $log->debug( "A simple string" );
    $log->debug( "A", "message", "over", "multiple", "lines" );
    $log->debug( { message => "A data structure", foo => "bar" } );

    # The above examples would generate something like the following:
    {"datetime":"2014-03-13 13:15:44","level":"debug","message":"A simple string"}
    {"datetime":"2014-03-13 13:15:45","level":"debug","message":"A\nmessage\nover\nmultiple\nlines"}
    {"datetime":"2014-03-13 13:15:46","foo":"bar","level":"debug","message":"A data structure"}

=head1 DESCRIPTION

L<Mojo::Log::JSON> is a simple JSON logger for L<Mojo> projects. It logs a
JSON object (hashref) per log message. Each object occupies a single line to
allow easy parsing of the log output.

The key C<level> is always added to the data structure, with the value set to
the level of the log message being emitted.

By default the key C<datetime> is also added to the data structure with a value
of the current time in ISO 8601 format. This can be removed or other fields can
be added via the C<default_fields> attribute.

=head1 ATTRIBUTES

All of the attributes of L<Mojo::Log> are present, plus the following additional
attributes.

=head2 codec

Pass in a L<JSON> object to override the default JSON formatting settings.

=head2 default_fields

Hashref of key/value pairs to add to the data structure. Can be overwritten by
values in the log message

=head1 METHODS

L<Mojo::Log::JSON> inherits all methods from L<Mojo::Log>.

=head1 SEE ALSO

=over

=item L<Mojo::Log>

=back

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/mjemmeson/mojo-log-json/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/mjemmeson/mojo-log-json>

    git clone git://github.com/mjemmeson/mojo-log-json.git

=head1 AUTHOR

Michael Jemmeson E<lt>mjemmeson@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2014- Michael Jemmeson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
