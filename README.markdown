# amistad #

Amistad adds friendships management into a rails 3.0 application. it supports ActiveRecord and Mongoid.

## Installation ##

Add the following line in your Gemfile:

    gem 'amistad'

Then run:

    bundle install

## Usage ##

If you are using ActiveRecord, you need to generate a friendship model. Amistad has a generator for this task :

    rails generate amistad:install  
    
This command creates a new model called __friendship__ in *'app/models'* :

    class Friendship < ActiveRecord::Base
      include Amistad::FriendshipModel
    end

It also creates a new migration for the friendship model so don't forget to migrate your database :

    rake db:migrate

If you are using Mongoig, you don't need a friendship model. Finally, activate __amistad__ in your user model :

    class User < ActiveRecord::Base  
      include Amistad::FriendModel
    end
    
or :

    class User
      include Mongoid::Document
      include Amistad::FriendModel
    end
    
## Friendships management ##

### Creating friendships ###
To create a new friendship with another user use the method called __invite()__ :

    @john.invite @jane
    @peter.invite @john
    @peter.invite @jane
    @victoria.invite @john
    
The __invite()__ method return *true* if the friendship successfully created, otherwise it returns *false*. The friendships remain in pending state until they are approved by the user requested. To approve the friendship created above use the method called __approve()__ :

    @jane.approve @john
    @john.approve @peter
    @jane.approve @peter
    
As __invite()__, __approve()__ return *true* if the friendship was successfuly approved or *false* if not.

### Listing friends ###

There are two types of friends in __amistad__ :

- the friends who were invited by the user
- the friends who invited the user

To get the friend who where invited by __@john__, use the __invited()__ method :

    @john.invited #=> [@jane]
    
To get the friends who invited __@john__, use the __invited_by()__ method :

    @john.invited_by #=> [@peter]
    
To get all the friends of __@john__ (those he invited and those who invited him) :

    @john.friends #=> [@jane, @peter]
    
To get the pending friendships use :

    @victoria.pending_invited #=> [@john]
    @john.pending_invited_by #=> [@victoria]
    
It is also possible to check if two users are friends :

    @john.friend_with? @jane #=> true
    @victoria.friend_with? @john #=> false

You can also check if a user is somehow connected to another :

    @john.connected_with? @jane #=> true
    @victoria.connected_with? @john #=> true

You can also check if a user was invited by anoter :

    @john.invited_by? @john #=> true
    @victoria.invited_by? @john #=> false

You can also check if a user invited another :

    @john.invited? @jane #=> true

You can also find the friends that two users have in common :

    @john.common_friends_with(@peter) #=> [@jane]
    
### Removing friendships ###

The __remove()__ method allow a user to remove its friendships :

    @john.remove @jane
    @john.remove @peter
    @john.remove @victoria
    
### Blocking friendships ###

The __block()__ method allow a user to block a friendship with another user :

    @john.invite @jane
    @jane.block @john
    
To get the blocked users :

    @jane.blocked #=> [@john]

You can also check if a user is blocked :

    @jane.blocked? @john #=> true

### Unblocking friendship ###

The __unblock()__ method allow a user to unblock previously blocked friendship with another user :

    @jane.block @john
    @jane.blocked #=> [@john]

    @jane.unblock @john
    @jane.blocked #=> []

## Testing the gem ##

It is possible to test amistad by running the following command from the gem directory:

    rake spec
    
Remember that amistad is only compatible with ActiveRecord 3.x.

## Acknowledgement ##

* David Czarnecki : block friendships
* Adrian Dulić : unblock friendships (and many other improvements)

## Note on Patches/Pull Requests ##
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright ##

Copyright © 2010 Rawane ZOSSOU. See LICENSE for details.
