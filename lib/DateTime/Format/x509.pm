package DateTime::Format::x509;

# ABSTRACT: parse and format x509 type dates

use strict;
use warnings;

use DateTime;
use DateTime::TimeZone;

sub new {
    my $class = shift;
    my %opts  = @_;

    return bless \%opts, $class;
}

sub parse_datetime {
    my ($self, $string) = @_;

    $string =~ s/(...) (..) (..):(..):(..) (....) (...)// || die 'Incorrectly formatted datetime';
    my ( $b, $d, $H, $M, $S, $Y, $Z ) = ($1, $2, $3, $4, $5, $6, $7);

    my $month_by_name = {
        Jan => 1,
        Feb => 2,
        Mar => 3,
        Apr => 4,
        May => 5,
        Jun => 6,
        Jul => 7,
        Aug => 8,
        Sep => 9,
        Oct => 10,
        Nov => 11,
        Dec => 12
    };

    my $month = $month_by_name->{$b} || die 'Invalid month';

    if($Z ne 'GMT' && $Z ne 'UTC') {
        die "Invalid time zone '$Z'. RFC3161 requires times to be in UTC.";
    }

    return DateTime->new(
        year       => 0 + $Y,
        month      => $month,
        day        => 0 + $d,
        hour       => 0 + $H,
        minute     => 0 + $M,
        second     => 0 + $S,
        time_zone  => 'UTC',
        formatter  => $self
    );
}

sub format_datetime {
    my ($self, $dt) = @_;
    return $dt->strftime('%b %d %H:%M:%S %Y UTC');
}

1;

__END__

=head1 NAME

DateTime::Format::x509 - parse and format x509 type dates

=head1 VERSION

Version 1.0.2


=head1 SYNOPSIS

    use DateTime::Format::x509;

    my $f = DateTime::Format::x509->new();
    my $dt = $f->parse_datetime('Mar 11 03:05:34 2013 UTC');

    # Mar 11 03:05:34 2013 UTC
    print $f->format_datetime($dt);


=head1 DESCRIPTION

This module parses and formats x509 style datetime strings, used in certificates.

=head1 METHODS

=over

=item C<parse_datetime($string)>

Given an x509 datetime string, this method will return a new L<DateTime> object.

If given an improperly formatted string, this method will die.

=item C<format_datetime($datetime)>

Given a L<DateTime> object, this method returns an x509 timestamp string.

=back

=cut
