ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ":memory:"
)

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