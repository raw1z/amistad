require 'rails/generators'
require 'rails/generators/migration'

class FriendshipGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  def self.next_migration_number
    now = DateTime.now
    "#{now.year}#{'%02d' % now.month}#{'%02d' % now.day}#{'%02d' % now.hour}#{'%02d' % now.minute}#{'%02d' % now.second}"
  end
  
  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  end
  
  desc "This generator creates a friendship model and its migration file"
  def create_friendship_model_files
    template 'friendship.rb', 'app/models/friendship.rb'
    template 'create_friendships.rb', "db/migrate/#{self.class.next_migration_number}_create_friendships.rb"
  end
end
