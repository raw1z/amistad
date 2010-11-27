# amistad #

Amistad adds friendships management into a rails 3.0 application.

## Installation ##

Just run the following command :

    gem install amistad
  
Then in your Gemfile add the following line :

    gem 'amistad'
  
## Usage ##

First generate a friendship model :

    rails generate amistad:install  
    
This commands create a new model called __friendship__ in *'app/models'* :

    class Friendship < ActiveRecord::Base
      include Amistad::FriendshipModel
    end

It also creates a new migration for the friendship model so don't forget to migrate your database :

    db:migrate

Then activate __amistad__ in your user model :

    class User < ActiveRecord::Base  
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

    @john.is_friend_with? @jane #=> true
    @victoria.is_friend_with? @john #=> false
    
You can also check if a user invited anoter :

    @john.was_invited_by? @john #=> true
    @victoria.was_invited_by? @john #=> false
    
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
    
## Testing the gem ##

It is possible to test amistad by running the following command from the gem directory:

    rake spec
    
Remember that amistad is only compatible with ActiveRecord 3.x.


## Note on Patches/Pull Requests ##
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright ##

Copyright © 2010 Rawane ZOSSOU. See LICENSE for details.
