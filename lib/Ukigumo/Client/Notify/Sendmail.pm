package Ukigumo::Client::Notify::Sendmail;
use 5.008005;
use strict;
use warnings;
use Ukigumo::Constants;
use Email::Sender::Simple qw(sendmail);
use Email::Simple;
use Email::Simple::Creator;
use Data::Recursive::Encode;
use Mouse;

our $VERSION = "0.01";

has 'to' => (
    is  => 'ro',
    isa => 'Str',
    required => 1,
);

has 'from' => (
    is  => 'ro',
    isa => 'Str',
    required => 1,
);

has 'ignore_success' => (
    is => 'ro',
    isa => 'Bool',
    required => 0,
    default => 1,
);

has ignore_skip => (
    is => 'ro',
    isa => 'Bool',
    default => 1,
);

no Mouse;

sub send {
    my ($self, $c, $status, $last_status, $report_url, $current_revision) = @_;

    if ( $self->ignore_success && $status eq STATUS_SUCCESS && defined($last_status) && ($last_status eq STATUS_SUCCESS || $last_status eq STATUS_SKIP) ) {
        $c->logger->infof("The test was succeeded. There is no reason to notify($status, $last_status).");
        return;
    }
    if ( $self->ignore_skip && $status eq STATUS_SKIP ) {
        $c->logger->infof( "The test was skiped. There is no reason to notify.");
        return;
    }

    my $message = sprintf( "%s %s %s", $c->project, $c->branch, substr($current_revision, 0, 10) );
    $c->logger->infof("Sending message to : $self->{to}");

    my $email = Email::Simple->create(
        header => Data::Recursive::Encode->encode(
            'MIME-Header-ISO_2022_JP' => [
                To      => $self->to,
                From    => $self->from,
                Subject => "[ukigumo]$message",
            ]
        ),
        body       => $report_url,
        attributes => {
            content_type => 'text/plain',
            charset      => 'ISO-2022-JP',
            encoding     => '7bit',
        },
    );

    sendmail($email);
}





1;
__END__

=encoding utf-8

=head1 NAME

Ukigumo::Client::Notify::Sendmail - It's new $module

=head1 SYNOPSIS

    use Ukigumo::Client::Notify::Sendmail;

=head1 DESCRIPTION

Ukigumo::Client::Notify::Sendmail is ...

=head1 LICENSE

Copyright (C) Hiroyuki Akabane.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hiroyuki Akabane E<lt>hirobanex@gmail.comE<gt>

=cut

