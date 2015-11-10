require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec'
require 'rspec/core/rake_task'

namespace :spec do
  desc "Run Rspec tests for ActiveRecord (with sqlite as RDBM)"
  RSpec::Core::RakeTask.new(:activerecord) do |t|
    t.pattern = "./spec/activerecord/**/*_spec.rb"
    t.rspec_opts = "--format Fuubar"
  end

  desc "Run Rspec tests for Mongoid"
  RSpec::Core::RakeTask.new(:mongoid) do |t|
    t.pattern = "./spec/mongoid/**/*_spec.rb"
    t.rspec_opts = "--format Fuubar"
  end

  desc "Run Rspec tests for MongoMapper"
  RSpec::Core::RakeTask.new(:mongo_mapper) do |t|
    t.pattern = "./spec/mongo_mapper/**/*_spec.rb"
    t.rspec_opts = "--format Fuubar"
  end

  namespace :activerecord do
    desc "run activerecord tests on a sqlite database"
    task :sqlite do
      ENV['RDBM'] = 'sqlite'
      Rake::Task['spec:activerecord'].reenable
      Rake::Task['spec:activerecord'].invoke
    end
    
    desc "run activerecord tests on a mysql database"
    task :mysql do
      ENV['RDBM'] = 'mysql'
      Rake::Task['spec:activerecord'].reenable
      Rake::Task['spec:activerecord'].invoke
    end

    desc "run activerecord tests on a postgresql database"
    task :postgresql do
      ENV['RDBM'] = 'postgresql'
      Rake::Task['spec:activerecord'].reenable
      Rake::Task['spec:activerecord'].invoke
    end
  end
end

task :default do
  Rake::Task['spec:activerecord:sqlite'].invoke
  Rake::Task['spec:activerecord:mysql'].invoke
  Rake::Task['spec:activerecord:postgresql'].invoke
  Rake::Task['spec:mongoid'].invoke
  Rake::Task['spec:mongo_mapper'].invoke
end
