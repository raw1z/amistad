require 'rails/generators'
require 'rails/generators/migration'

module Amistad
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def self.next_migration_number
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      desc "This generator creates a friendship model and its migration file"
      def create_friendship_model_files
        template 'create_friendships.rb', "db/migrate/#{self.class.next_migration_number}_create_friendships.rb"
      end
    end
  end
end
