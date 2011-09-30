if defined?(ActiveRecord)
  require 'amistad/active_record/friend_model'
  require 'amistad/active_record/friendship_model'
end

if defined?(Mongoid)
  require 'amistad/mongoid/friend_model'
end

require 'amistad/friend_model'
require 'amistad/friendship_model'
