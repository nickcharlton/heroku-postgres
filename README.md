# heroku-postgres

This provides a Ruby client to [Heroku][]'s [Postgres][] service. It's been
partially extracted from the [Heroku command line client][heroku-cli] as it's
otherwise not documented.

It was primarily built to automate creating backups for usage elsewhere. It's
initially limited to just being able to do this, so if there's something
missing, open an issue.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heroku-postgres'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku-postgres

## Usage

```ruby
require 'heroku/postgres'

# login (return a client object, but you don't need that directly)
Heroku::Postgres.login(username: '', password: '')

# find the database by app name and database name
db = Heroku::Postgres.find('app-name', 'db-name')

# have a look at the current backups
db.backups
# => [<Heroku::Postgres::Backup id=abc>]

# capture a backup, waiting for completion
backup = db.capture_backup(true)

# generate a public url so you can fetch the file
backup.public_url
```

## Contributing

1. Fork it ( https://github.com/nickcharlton/heroku-postgres/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

Copyright (c) 2015 Nick Charlton <nick@nickcharlton.net>.

[Heroku]: https://www.heroku.com/home
[Postgres]: https://www.heroku.com/postgres
[heroku-cli]: https://github.com/heroku/heroku
