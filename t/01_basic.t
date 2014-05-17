use strict;
use warnings;
use utf8;
use Test::More;
use Test::MockObject;
use Capture::Tiny qw/:all/;

use Ukigumo::Constants;
use Ukigumo::Client::Notify::Sendmail;
use Email::Sender::Simple;

BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' }

subtest 'sendmail ok ?' => sub {
    my $notify = Ukigumo::Client::Notify::Sendmail->new(
        to   => 'hirobanex@tester.net',
        from => 'ukigumo@tester.net',
    );

    my $c = Test::MockObject->new();
    $c->set_always('project','hoge-project');
    $c->set_always('branch','hoge-branch');
    my $mock_logger = Test::MockObject->new();
    $mock_logger->mock('infof',sub { warn $_[1] });
    $c->mock('logger', sub {$mock_logger});

    my $report_url       = 'http://hogehoget.net';
    my $status           = STATUS_FAIL;
    my $last_status      = STATUS_FAIL;
    my $current_revision = '0.11';

    my ($stdout, $stderr, $res) = capture {
        $notify->send($c, $status, $last_status, $report_url, $current_revision,);
    };

    like $stderr, qr/Sending message to/,'log catch';

    my @deliveries = Email::Sender::Simple->default_transport->deliveries;

    is scalar @deliveries, 1, 'is there sendmail trace ?';
};

done_testing;

