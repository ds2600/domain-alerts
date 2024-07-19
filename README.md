## domain-alerts

Script to check for domain expirations, sends an email and webhook for 45 day, 15 day and 7 day reminders.

### Installation

1. Ensure you have build tools installed
```bash
sudo apt update
sudo apt install build-essential libperl-dev
```

2. Clone repo

3. Install dependencies 
```bash
sudo cpan Net::Whois::Raw Date::Parse Date::Format Date::Calc LWP::UserAgent MIME::Lite Term::ReadKey JSON Data::Dumper LWP::Protocol::https MIME::Base64 Authen::SASL
```

4. Ensure file is executable
```bash
sudo chmod +x domain-alerts.pl
```

5. Copy and enter configs
```bash
cp config.example.pl config.pl
```

6. Make a file called `domains.txt` and put your domains you want to check on a new line.

### Testing/Debugging

You can run `./domain-alerts.pl --test` to make sure it works before automating it.

You can use the `--debug-webhook` or `--debug-email` parameters to troubleshoot that.

### Crontab

```bash
1 0 * * * /path/to/domain-alerts.pl >> /var/log/domain-alerts.log 2>&1
```

