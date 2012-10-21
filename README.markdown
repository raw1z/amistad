# amistad #

Amistad adds friendships management into a rails 3.0 application. it supports ActiveRecord 3.0.x and Mongoid 2.0.x.

## Installation ##

Add the following line in your Gemfile:

    gem 'amistad'

Then run:

    bundle install

## Usage ##

Refer to the wiki pages for usage and friendships management.

## Testing ##

There are rake tasks available which allow you to run the activerecord tests for three rdbms:

    rake spec:activerecord:sqlite
    rake spec:activerecord:mysql
    rake spec:activerecord:postgresql

In order to run these tasks you need to create a confiuration file for the databases connections:

    spec/support/activerecord/database.yml

    sqlite:
      adapter: "sqlite3"
      database: ":memory:"

    mysql:
      adapter: mysql2
      encoding: utf8
      database: <name of mysql database>
      username: <username>
      password: <password>

    postgresql:
      adapter: postgresql
      encoding: unicode
      database: <name of postgresql database>
      username: <username>
      password: <password>

Of course there is one rake task for running mongoid tests:

    rake spec:mongoid

The default rake tasks runs the ActiveRecord tests for the three rdbms followed by the Mongoid tests.

## Contributors ##

* David Czarnecki : block friendships (and many other improvements)
* Adrian Dulić : unblock friendships (and many other improvements)

## Note on Patches/Pull Requests ##

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright ##

Copyright © 2010 Rawane ZOSSOU. See LICENSE for details.
