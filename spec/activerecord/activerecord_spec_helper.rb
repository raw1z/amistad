require 'spec_helper'
require 'active_record'

Dir[File.expand_path('../../support/activerecord/*.rb', __FILE__)].each{|f| require f }

RSpec.configure do |config|
  config.before(:suite) do
    CreateSchema.suppress_messages{ CreateSchema.migrate(:up) }
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

