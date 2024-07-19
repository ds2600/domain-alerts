```bash
sudo cpan Net::Whois::Raw Date::Parse Date::Format Date::Calc LWP::UserAgent MIME::Lite Term::ReadKey
```
```bash
sudo chmod +x domain-alerts.pl
```
```bash
cp config.example.pl config.pl
```

Make a file called *domains.txt* and put your domains you want to check on a new line.

You can run `./domain-alerts.pl --test` to make sure it works before automating it.
