#!/usr/bin/perl
package config;

our $alert_emails = 'alerts@example.com';
our $webhook_url = 'https://example.com/webhook';
our $smtp_server = 'smtp.example.com';
our $smtp_port = 25;
our $smtp_user = 'username';
our $smtp_password = 'password';
our $smtp_from = 'monitor@example.com';
our $domain_file = './domains.txt';
1;
