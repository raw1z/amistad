require "spec_helper"
require 'mongo_mapper'

MongoMapper.database = 'amistad_mongo_mapper_test'

RSpec.configure do |config|
  config.before(:each) do
  end
end
