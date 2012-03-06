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

It is possible to test amistad by running one of the following commands from the gem directory:

    rspec spec/activerecord # activerecord tests
    rspec spec/mongoid      # mongoid tests
    
Remember that amistad is only compatible with ActiveRecord 3.0.x and Mongoid 2.0.x.

You can also run `rake` by itself and it will run the ActiveRecord tests followed by the Mongoid tests.

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
