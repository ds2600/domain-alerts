#!/usr/bin/perl
use strict;
use warnings;
use Net::Whois::Raw;
use Date::Parse;
use Date::Format;
use Date::Calc qw(Today Delta_Days);
use LWP::UserAgent;
use MIME::Lite;
use Getopt::Long;
use Term::ReadKey;

no warnings 'once';

BEGIN {
    my $config_file = './config.pl';
    unless (-e $config_file) {
        die "Config file not found";
    }
    require $config_file;
}

# Command line options
my $test_mode = 0;
GetOptions("test" => \$test_mode);

# Function to send email alerts
sub send_email {
    my ($subject, $body) = @_;
    my $msg = MIME::Lite->new(
        From    => $config::smtp_from,
        To      => $config::alert_emails,
        Subject => $subject,
        Data    => $body
    );
    $msg->send('smtp', $config::smtp_server, Port => $config::smtp_port, AuthUser => $config::smtp_user, AuthPass => $config::smtp_password);
}

# Function to send webhook alerts
sub send_webhook {
    my ($message) = @_;
    my $ua = LWP::UserAgent->new;
    my $response = $ua->post($config::webhook_url, { message => $message });
    unless ($response->is_success) {
        warn "Failed to send webhook: " . $response->status_line;
    }
}

sub paginate_output {
    my @lines = @_;
    my $page_size = 20;
    my $line_count = 0;
    
    foreach my $line (@lines) {
        print "$line_count $line\n";
        $line_count++;
        if ($line_count >= $page_size) {
            print "--More--";
            ReadMode 'cbreak';
            my $key = ReadKey(0);
            ReadMode 'normal';
            last if $key eq 'q';
            $line_count = 0;
        }
    }
}

# Function to check domain expiration
sub check_domain_expiration {
    open my $fh, '<', $config::domain_file or die "Could not open '$config::domain_file': $!";
    while (my $domain = <$fh>) {
        chomp $domain;
        my $whois_info = whois($domain);
        if ($whois_info =~ /Registrar Registration Expiration Date:\s*(\d{4}-\d{2}-\d{2})/) {
            my $expiry_date = $1;
            my ($year, $month, $day) = split /-/, $expiry_date;
            my ($today_year, $today_month, $today_day) = Today();
            my $days_left = Delta_Days($today_year, $today_month, $today_day, $year, $month, $day);

            if ($test_mode) {
                print "Domain $domain expires on $expiry_date\n";
            }

            if ($days_left == 45 || $days_left == 15 || $days_left <= 7) {
                my $message = "Domain $domain will expire in $days_left days (on $expiry_date)";
                if ($test_mode) {
                    print "$message\n";
                } else {
                    my $subject = "Domain Expiration Alert: $domain";
                    send_email($subject, $message);
                    #send_webhook($message);
                }
            }
        } else {
            if ($test_mode) {
                print "Could not find expiry date for domain: $domain\nWHOIS information:\n$whois_info\n";
                paginate_output(split /\n/, $whois_info);
            } else {
                warn "Could not find expiry date for domain: $domain\nWHOIS information:\n$whois_info\n";
                paginate_output(split /\n/, $whois_info);
            }
        }
    }    
    close $fh;
}

# Main script
check_domain_expiration();

