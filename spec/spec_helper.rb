require 'rspec'
require 'active_record'
require 'mongoid'
require 'ap'
require 'database_cleaner'
Dir["#{File.dirname(__FILE__)}/support/*.rb"].each {|f| require f}

def create_users(friend_model)
  friend_model.delete_all
  %w(John Jane David James Peter Mary Victoria Elisabeth).each do |name|
    instance_variable_set("@#{name.downcase}".to_sym, friend_model.create{ |fm| fm.name = name})
  end
end

def activate_amistad(friend_model)
  friend_model.class_exec do
    include Amistad::FriendModel
  end
end

def reload_environment
  # ensure that the gem will be always required
  $".grep(/.*lib\/amistad.*/).each do |file|
    $".delete(file)
  end

  # delete all the classes
  if Object.const_defined?(:Amistad)
    Amistad.constants.each do |constant|
      Amistad.send(:remove_const, constant)
    end

    Object.send(:remove_const, :Amistad)
  end

  Object.send(:remove_const, :User) if Object.const_defined?(:User)
  Object.send(:remove_const, :Profile) if Object.const_defined?(:Profile)

  # require the gem
  require "amistad"
end
