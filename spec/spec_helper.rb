require 'rspec'
require 'amistad'
Dir["#{File.dirname(__FILE__)}/support/*.rb"].each {|f| require f}

def create_users
  User.delete_all
  %w(John Jane David James Peter Mary Victoria Elisabeth).each do |name|
    instance_variable_set("@#{name.downcase}".to_sym, User.create(:name => name))
  end
end
