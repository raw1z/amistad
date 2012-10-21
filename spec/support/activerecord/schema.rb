def db_config(type)
  YAML.load_file(File.expand_path('../database.yml', __FILE__))[type]
end

def connect_server(type)
  config = db_config type
  database = config['database']

  ActiveRecord::Base.establish_connection config.merge('database' => (type == 'postgresql' ? 'postgres' : nil))
  ActiveRecord::Base.connection.recreate_database(database)
  ActiveRecord::Base.establish_connection(config) 
end

case ENV['RDBM']
when 'mysql' then connect_server 'mysql'
when 'postgresql' then connect_server 'postgresql'
else
  ActiveRecord::Base.establish_connection db_config('sqlite')
end

class CreateSchema < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.string :name, :null => false
    end

    create_table :profiles, :force => true do |t|
      t.string :name, :null => false
    end

    create_table :friendships, :force => true do |t|
      t.integer :friendable_id
      t.integer :friend_id
      t.integer :blocker_id
      t.boolean :pending, :default => true
    end

    add_index :friendships, [:friendable_id, :friend_id], :unique => true
  end
end
