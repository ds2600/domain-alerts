## domain-alerts

Script to check for domain expirations, sends an email and webhook for 45 day, 15 day and 7 day reminders.

```bash
sudo cpan Net::Whois::Raw Date::Parse Date::Format Date::Calc LWP::UserAgent MIME::Lite Term::ReadKey JSON Data::Dumper
```
```bash
sudo chmod +x domain-alerts.pl
```
```bash
cp config.example.pl config.pl
```

Make a file called *domains.txt* and put your domains you want to check on a new line.

### Testing/Debugging

You can run `./domain-alerts.pl --test` to make sure it works before automating it.

You can use the `--debug-webhook` or `--debug-email` parameters to troubleshoot that.

### Crontab

```bash
1 0 * * * /path/to/domain-alerts.pl >> /var/log/domain-alerts.log 2>&1
```

