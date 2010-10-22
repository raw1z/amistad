$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rspec/core'
require 'rspec/autorun'
require 'active_record'
require 'logger'
require 'amistad'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

ActiveRecord::Migration.verbose = false

ActiveRecord::Schema.define do
  create_table :users, :force => true do |t|
    t.string :name, :null => false
  end

  create_table :friendships, :force => true do |t|
    t.integer :user_id
    t.integer :friend_id
    t.boolean :pending, :default => true
    t.boolean :blocked, :default => false
  end
end

class User < ActiveRecord::Base
  include Amistad::FriendModel
end

class Friendship < ActiveRecord::Base
  include Amistad::FriendshipModel
end
