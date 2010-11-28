class CreateFriendships < ActiveRecord::Migration
  def self.up
    create_table :friendships do |t|
      t.integer :user_id
      t.integer :friend_id
      t.integer :blocker_id
      t.boolean :pending, :default => true
    end

    add_index :friendships, [:user_id, :friend_id], :unique => true
  end

  def self.down
    drop_table :friendships
  end
end
