require 'rubygems'
require 'active_record'
require 'logger'

require File.join(File.dirname(__FILE__), '../lib/amistad')

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "spec/db/amistad.sqlite3.db"
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
  end
end

ActiveRecord::Base.logger = Logger.new(File.open('spec/db/database.log', 'a'))

class User < ActiveRecord::Base
  acts_as_friend
end

class Friendship < ActiveRecord::Base
  acts_as_friendship
end
